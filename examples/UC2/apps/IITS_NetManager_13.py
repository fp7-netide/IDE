# Developed by Juan Manuel Sanchez, March 2016.

"""
An OpenFlow 1.3 L2 static switching implementation.
"""


from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.ofproto import inet
from ryu.lib.mac import haddr_to_bin
from ryu.lib.packet import packet
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types
from ryu.lib.packet import ipv4
from ryu.topology import event, switches
from ryu.topology.api import get_switch, get_link
from ipaddr import IPv4Address

################### IP Setup ##################
# Hosts
ipp1 = '10.0.1.11'
ipp2 = '10.0.1.12'
ipp3 = '10.0.1.13'
ipp4 = '10.0.1.14'
ipp5 = '10.0.1.15'

###############################################

# Switches IDs
SW1_ID  = 1
SW2_ID  = 2
SW3_ID  = 3
SW4_ID  = 4
SW1b_ID  = 5
SW2b_ID  = 6
SW3b_ID  = 7
SW4b_ID  = 8
HH1_ID = 11
HH2_ID = 12
HH3_ID = 13
HH4_ID = 14
HH5_ID = 15

#Dictionaries of Host IPs/Switches IDs : columns/rows of the out_port_table
HOST = {ipp1:0, ipp2:1, ipp3:2, ipp4:3, ipp5:4}
SWITCH = {SW1_ID:0, SW2_ID:1, SW3_ID:2, SW4_ID:3, HH1_ID:4, HH2_ID:5, HH3_ID:6, HH4_ID:7, HH5_ID:8, SW1b_ID:9, SW2b_ID:10, SW3b_ID:11, SW4b_ID:12}

#Boolean variable to determine proactive/reactive behavior
PROACTIVE = False

class IITS_NetManager_13(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    out_port_table = [[]]

    def __init__(self, *args, **kwargs):
        super(IITS_NetManager_13, self).__init__(*args, **kwargs)
        self.out_port_table_create(SWITCH, HOST)
        self.mac_to_port = {}
        self.link_down_route = {}
        self.topology_api_app = self
        self.datapath_list = {}
        self.main_branch={}
        self.main_branch_state={}
        #Initiate Switch state to down(false) for every switch
        self.switch_state = {}
        for switch in SWITCH:
            self.switch_state.setdefault(switch)
            self.switch_state[switch] = False

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # install table-miss flow entry
        #
        # We specify NO BUFFER to max_len of the output action due to
        # OVS bug. At this moment, if we specify a lesser number, e.g.,
        # 128, OVS will send Packet-In with invalid buffer_id and
        # truncated packet data. In that case, we cannot output packets
        # correctly.  The bug has been fixed in OVS v2.1.0.
        match = parser.OFPMatch()
        actions = [parser.OFPActionOutput(ofproto.OFPP_CONTROLLER, ofproto.OFPCML_NO_BUFFER)]
        self.add_flow(datapath, 0, match, actions)

    def all_switches_up(self):
        for switch in self.switch_state:
            if self.switch_state[switch] == False:
                return False
        return True

    def out_port_table_create(self, switches, hosts):
        #Create table initialized to 1s, the prot that connects HHs to hosts
        self.out_port_table = [[1 for i in range(len(hosts))] for j in range(len(switches))]

    def install_all_flows(self):
         #In case of proactive behaviour
         for switch in SWITCH:
              datapath = self.datapath_list[switch]
              for host in HOST:
                   out_port = self.out_port_table[SWITCH[switch]][HOST[host]]
                   actions = [datapath.ofproto_parser.OFPActionOutput(out_port)]
                   self.add_flow(datapath, host, actions)

    def update_system_info(self, links_list):
        #Update out_port_table alternative routes & main branch links
        for link in links_list:
            #link_down_route
            self.link_down_route.setdefault(link.src.dpid)
            #switch_state
            self.switch_state.setdefault(link.src.dpid)
            self.switch_state[link.src.dpid] = True
            #Main branch links
            self.main_branch.setdefault(link.src.dpid, {})
            self.main_branch_state.setdefault(link.src.dpid, {})
            #out_port_table
            if link.src.dpid == SW1_ID:
                if link.dst.dpid == SW2_ID:
                    self.out_port_table[SWITCH[SW1_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[SW1_ID]][HOST[ipp4]] = link.src.port_no
                    self.main_branch[SW1_ID][link.src.port_no] = SW2_ID
                    self.main_branch_state[SW1_ID][link.src.port_no] = True
                if link.dst.dpid == SW3_ID:
                    self.out_port_table[SWITCH[SW1_ID]][HOST[ipp5]] = link.src.port_no
                    self.main_branch[SW1_ID][link.src.port_no] = SW3_ID
                    self.main_branch_state[SW1_ID][link.src.port_no] = True
                if link.dst.dpid == HH1_ID:
                    self.out_port_table[SWITCH[SW1_ID]][HOST[ipp1]] = link.src.port_no
                if link.dst.dpid == HH3_ID:
                    self.out_port_table[SWITCH[SW1_ID]][HOST[ipp3]] = link.src.port_no
                if link.dst.dpid == SW3b_ID:
                    self.link_down_route[SW1_ID] = link.src.port_no
            if link.src.dpid == SW2_ID:
                if link.dst.dpid == SW1_ID:
                    self.out_port_table[SWITCH[SW2_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[SW2_ID]][HOST[ipp3]] = link.src.port_no
                    self.main_branch[SW2_ID][link.src.port_no] = SW1_ID
                    self.main_branch_state[SW2_ID][link.src.port_no] = True
                if link.dst.dpid == SW3_ID:
                    self.out_port_table[SWITCH[SW2_ID]][HOST[ipp5]] = link.src.port_no
                    self.main_branch[SW2_ID][link.src.port_no] = SW3_ID
                    self.main_branch_state[SW2_ID][link.src.port_no] = True
                if link.dst.dpid == HH2_ID:
                    self.out_port_table[SWITCH[SW2_ID]][HOST[ipp2]] = link.src.port_no
                if link.dst.dpid == HH4_ID:
                    self.out_port_table[SWITCH[SW2_ID]][HOST[ipp4]] = link.src.port_no
                if link.dst.dpid == SW3b_ID:
                    self.link_down_route[SW2_ID] = link.src.port_no
            if link.src.dpid == SW3_ID:
                if link.dst.dpid == SW1_ID:
                    self.out_port_table[SWITCH[SW3_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[SW3_ID]][HOST[ipp3]] = link.src.port_no
                    self.main_branch[SW3_ID][link.src.port_no] = SW1_ID
                    self.main_branch_state[SW3_ID][link.src.port_no] = True
                if link.dst.dpid == SW2_ID:
                    self.out_port_table[SWITCH[SW3_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[SW3_ID]][HOST[ipp4]] = link.src.port_no
                    self.main_branch[SW3_ID][link.src.port_no] = SW2_ID
                    self.main_branch_state[SW3_ID][link.src.port_no] = True
                if link.dst.dpid == SW4_ID:
                    self.out_port_table[SWITCH[SW3_ID]][HOST[ipp5]] = link.src.port_no
                    self.main_branch[SW3_ID][link.src.port_no] = SW4_ID
                    self.main_branch_state[SW3_ID][link.src.port_no] = True
                if link.dst.dpid == SW4b_ID:
                    self.link_down_route[SW3_ID] = link.src.port_no
            if link.src.dpid == SW4_ID:
                if link.dst.dpid == SW3_ID:
                    self.out_port_table[SWITCH[SW4_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[SW4_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[SW4_ID]][HOST[ipp3]] = link.src.port_no
                    self.out_port_table[SWITCH[SW4_ID]][HOST[ipp4]] = link.src.port_no
                    self.main_branch[SW4_ID][link.src.port_no] = SW3_ID
                    self.main_branch_state[SW4_ID][link.src.port_no] = True
                if link.dst.dpid == HH5_ID:
                    self.out_port_table[SWITCH[SW4_ID]][HOST[ipp5]] = link.src.port_no
                if link.dst.dpid == SW3b_ID:
                    self.link_down_route[SW4_ID] = link.src.port_no
            if link.src.dpid == HH1_ID:
                if link.dst.dpid == SW1_ID:
                    self.out_port_table[SWITCH[HH1_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[HH1_ID]][HOST[ipp3]] = link.src.port_no
                    self.out_port_table[SWITCH[HH1_ID]][HOST[ipp4]] = link.src.port_no
                    self.out_port_table[SWITCH[HH1_ID]][HOST[ipp5]] = link.src.port_no
                if link.dst.dpid == SW1b_ID:
                    self.link_down_route[HH1_ID] = link.src.port_no
                #else:
                    #self.out_port_table[SWITCH[HH1_ID]][HOST[ipp1]] = link.src.port_no
            if link.src.dpid == HH2_ID:
                if link.dst.dpid == SW2_ID:
                    self.out_port_table[SWITCH[HH2_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[HH2_ID]][HOST[ipp3]] = link.src.port_no
                    self.out_port_table[SWITCH[HH2_ID]][HOST[ipp4]] = link.src.port_no
                    self.out_port_table[SWITCH[HH2_ID]][HOST[ipp5]] = link.src.port_no
                if link.dst.dpid == SW2b_ID:
                    self.link_down_route[HH2_ID] = link.src.port_no
                #else:
                    #self.out_port_table[SWITCH[HH2_ID]][HOST[ipp2]] = link.src.port_no
            if link.src.dpid == HH3_ID:
                if link.dst.dpid == SW1_ID:
                    self.out_port_table[SWITCH[HH3_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[HH3_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[HH3_ID]][HOST[ipp4]] = link.src.port_no
                    self.out_port_table[SWITCH[HH3_ID]][HOST[ipp5]] = link.src.port_no
                if link.dst.dpid == SW1b_ID:
                    self.link_down_route[HH3_ID] = link.src.port_no
                #else:
                    #self.out_port_table[SWITCH[HH3_ID]][HOST[ipp3]] = link.src.port_no
            if link.src.dpid == HH4_ID:
                if link.dst.dpid == SW2_ID:
                    self.out_port_table[SWITCH[HH4_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[HH4_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[HH4_ID]][HOST[ipp3]] = link.src.port_no
                    self.out_port_table[SWITCH[HH4_ID]][HOST[ipp5]] = link.src.port_no
                if link.dst.dpid == SW2b_ID:
                    self.link_down_route[HH4_ID] = link.src.port_no
                #else:
                    #self.out_port_table[SWITCH[HH4_ID]][HOST[ipp4]] = link.src.port_no
            if link.src.dpid == HH5_ID:
                if link.dst.dpid == SW4_ID:
                    self.out_port_table[SWITCH[HH5_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[HH5_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[HH5_ID]][HOST[ipp3]] = link.src.port_no
                    self.out_port_table[SWITCH[HH5_ID]][HOST[ipp4]] = link.src.port_no
                if link.dst.dpid == SW4b_ID:
                    self.link_down_route[HH5_ID] = link.src.port_no
                #else:
                    #self.out_port_table[SWITCH[HH5_ID]][HOST[ipp5]] = link.src.port_no
            if link.src.dpid == SW1b_ID:
                if link.dst.dpid == SW2b_ID:
                    self.out_port_table[SWITCH[SW1b_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[SW1b_ID]][HOST[ipp4]] = link.src.port_no
                if link.dst.dpid == SW3_ID:
                    self.out_port_table[SWITCH[SW1b_ID]][HOST[ipp5]] = link.src.port_no
                if link.dst.dpid == HH1_ID:
                    self.out_port_table[SWITCH[SW1b_ID]][HOST[ipp1]] = link.src.port_no
                if link.dst.dpid == HH3_ID:
                    self.out_port_table[SWITCH[SW1b_ID]][HOST[ipp3]] = link.src.port_no
            if link.src.dpid == SW2b_ID:
                if link.dst.dpid == SW1b_ID:
                    self.out_port_table[SWITCH[SW2b_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[SW2b_ID]][HOST[ipp3]] = link.src.port_no
                if link.dst.dpid == SW3_ID:
                    self.out_port_table[SWITCH[SW2b_ID]][HOST[ipp5]] = link.src.port_no
                if link.dst.dpid == HH2_ID:
                    self.out_port_table[SWITCH[SW2b_ID]][HOST[ipp2]] = link.src.port_no
                if link.dst.dpid == HH4_ID:
                    self.out_port_table[SWITCH[SW2b_ID]][HOST[ipp4]] = link.src.port_no
            if link.src.dpid == SW3b_ID:
                if link.dst.dpid == SW1_ID:
                    self.out_port_table[SWITCH[SW3b_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[SW3b_ID]][HOST[ipp3]] = link.src.port_no
                if link.dst.dpid == SW2_ID:
                    self.out_port_table[SWITCH[SW3b_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[SW3b_ID]][HOST[ipp4]] = link.src.port_no
                if link.dst.dpid == SW4_ID:
                    self.out_port_table[SWITCH[SW3b_ID]][HOST[ipp5]] = link.src.port_no
            if link.src.dpid == SW4b_ID:
                if link.dst.dpid == SW3_ID:
                    self.out_port_table[SWITCH[SW4b_ID]][HOST[ipp1]] = link.src.port_no
                    self.out_port_table[SWITCH[SW4b_ID]][HOST[ipp2]] = link.src.port_no
                    self.out_port_table[SWITCH[SW4b_ID]][HOST[ipp3]] = link.src.port_no
                    self.out_port_table[SWITCH[SW4b_ID]][HOST[ipp4]] = link.src.port_no
                if link.dst.dpid == HH5_ID:
                    self.out_port_table[SWITCH[SW4b_ID]][HOST[ipp5]] = link.src.port_no

    def get_topology_data(self):
        switch_list = get_switch(self.topology_api_app, None)
        #switches=[switch.dp.id for switch in switch_list]
        for switch in switch_list:
             self.datapath_list.setdefault(switch.dp.id)
             self.datapath_list[switch.dp.id] = switch.dp
        links_list = get_link(self.topology_api_app, None)
        #Add ports to out_port_table
        self.update_system_info(links_list)

        #print self.out_port_table
        #print self.link_down_route

        #Install flows in case of proactive behaviour
        if PROACTIVE and self.all_switches_up():
            self.install_all_flows()

    def arp_unicast(self, msg):
        datapath = msg.datapath
        ofproto = datapath.ofproto

        pkt = packet.Packet(msg.data)
        eth = pkt.get_protocols(ethernet.ethernet)[0]
        src = eth.src
        dst = eth.dst
        dpid = datapath.id
        in_port = msg.match['in_port']
        self.mac_to_port.setdefault(dpid, {})
        # forward ARP
        if src not in self.mac_to_port[dpid]:
            self.mac_to_port[dpid][src] = in_port 
        
        out_port = self.mac_to_port[dpid][dst]
        actions = [datapath.ofproto_parser.OFPActionOutput(out_port)]
        data = None
        if msg.buffer_id == ofproto.OFP_NO_BUFFER:
            data = msg.data

        out = datapath.ofproto_parser.OFPPacketOut(datapath=datapath, buffer_id=msg.buffer_id,
                                  in_port=in_port, actions=actions, data=data)
        datapath.send_msg(out)

    def arp_multicast(self, msg):
        datapath = msg.datapath
        ofproto = datapath.ofproto

        pkt = packet.Packet(msg.data)
        eth = pkt.get_protocols(ethernet.ethernet)[0]
        src = eth.src
        dst = eth.dst
        dpid = datapath.id
        in_port = msg.match['in_port']

        self.mac_to_port.setdefault(dpid, {})
        #Check whether the mac is known or not and if it comes from a different port than before and discard
	if src in self.mac_to_port[dpid] and in_port != self.mac_to_port[dpid][src]:
            #self.logger.info("Switch %s : known host %s", dpid, src)
            return

        # learn a mac address to avoid loops.
        self.mac_to_port[dpid][src] = in_port
        #self.logger.info("Switch %s : mac learned %s port %s", dpid, src, in_port)


        # and flood ARP
        out_port = ofproto.OFPP_FLOOD
        actions = [datapath.ofproto_parser.OFPActionOutput(out_port)]
        data = None
        if msg.buffer_id == ofproto.OFP_NO_BUFFER:
            data = msg.data

        out = datapath.ofproto_parser.OFPPacketOut(datapath=datapath, buffer_id=msg.buffer_id,
                                  in_port=in_port, actions=actions, data=data)
        datapath.send_msg(out)

    def forward_arp(self, msg):
        #Send arp packets according to the tree
        pkt = packet.Packet(msg.data)
        eth = pkt.get_protocols(ethernet.ethernet)[0]
        dst = eth.dst
        datapath = msg.datapath
        dpid = datapath.id
        in_port = msg.match['in_port']

        self.logger.info("ARP in %s %s", dpid, in_port)

        if dst == 'ff:ff:ff:ff:ff:ff':
            self.arp_multicast(msg)
        else:
            self.arp_unicast(msg)

    def forward_packet(self, msg):
        datapath = msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        in_port = msg.match['in_port']

        pkt = packet.Packet(msg.data)
        pkt_ipv4 = pkt.get_protocol(ipv4.ipv4)

        dst = pkt_ipv4.dst
        src = pkt_ipv4.src

        dpid = datapath.id

        self.logger.info("packet in %s %s %s %s", dpid, src, dst, msg.match['in_port'])
        # Get out_port for packet based on dst address and dpid
        if dst in HOST:
            out_port = self.out_port_table[SWITCH[dpid]][HOST[dst]]
        else:
            out_port = ofproto.OFPP_FLOOD


        actions = [parser.OFPActionOutput(out_port)]

        # install a flow to avoid packet_in next time
        if out_port != ofproto.OFPP_FLOOD:
            match = parser.OFPMatch(in_port=in_port, ipv4_dst=dst)
            # verify if we have a valid buffer_id, if yes avoid to send both
            # flow_mod & packet_out
            if msg.buffer_id != ofproto.OFP_NO_BUFFER:
                self.add_flow(datapath, 1, match, actions, msg.buffer_id)
                return
            else:
                self.add_flow(datapath, 1, match, actions)
        data = None
        if msg.buffer_id == ofproto.OFP_NO_BUFFER:
            data = msg.data

        out = parser.OFPPacketOut(datapath=datapath, buffer_id=msg.buffer_id,
                                  in_port=in_port, actions=actions, data=data)
        datapath.send_msg(out)

    def add_flow(self, datapath, priority, match, actions, buffer_id=None):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        if buffer_id:
            mod = parser.OFPFlowMod(datapath=datapath, buffer_id=buffer_id,
                                    priority=priority, match=match,
                                    instructions=inst)
        else:
            mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                    match=match, instructions=inst)
        datapath.send_msg(mod)

    def add_priority_flow(self, datapath,  dst, out_port, buffer_id=None):
        self.logger.info("Added priority flow to %s in %s via %s", dst, datapath.id, out_port)
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        match = datapath.ofproto_parser.OFPMatch(
            eth_type=ether_types.ETH_TYPE_IP, ipv4_dst=IPv4Address(dst))
        actions = [parser.OFPActionOutput(out_port)]
        priority = ofproto.OFP_DEFAULT_PRIORITY + 1

        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        if buffer_id:
            mod = parser.OFPFlowMod(datapath=datapath, buffer_id=buffer_id,
                                    priority=priority, match=match,
                                    instructions=inst)
        else:
            mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                    match=match, instructions=inst)
        datapath.send_msg(mod)

    def del_priority_flow(self, datapath, dst, out_port, buffer_id=None):
        self.logger.info("Deleted priority flow to %s in %s via %s", dst, datapath.id, out_port)
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        match = datapath.ofproto_parser.OFPMatch(
            eth_type=ether_types.ETH_TYPE_IP, ipv4_dst=IPv4Address(dst))
        actions = [parser.OFPActionOutput(out_port)]
        priority = ofproto.OFP_DEFAULT_PRIORITY + 1

        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        if buffer_id:
            mod = parser.OFPFlowMod(datapath=datapath, buffer_id=buffer_id, priority=priority,
                                    flags=ofproto.OFPFF_SEND_FLOW_REM, match=match,
                                    instructions=inst)
        else:
            mod = parser.OFPFlowMod(datapath=datapath, priority=priority, flags=ofproto.OFPFF_SEND_FLOW_REM,
                                    match=match, instructions=inst)
        datapath.send_msg(mod)

    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):
        #self.logger.info("Packet In")
        msg = ev.msg
        datapath = msg.datapath
        ofproto = datapath.ofproto

        pkt = packet.Packet(msg.data)

        eth = pkt.get_protocol(ethernet.ethernet)
        if eth.ethertype == ether_types.ETH_TYPE_LLDP:
            self.get_topology_data()
            return
        elif eth.ethertype == ether_types.ETH_TYPE_ARP:
            # handle ARPs
            self.forward_arp(msg)
        elif eth.ethertype == ether_types.ETH_TYPE_IP:
            pkt_ipv4 = pkt.get_protocol(ipv4.ipv4)
            if pkt_ipv4.src == '0.0.0.0':
                #ignore bootp packets
                return
            else:
                self.forward_packet(msg)

    @set_ev_cls(ofp_event.EventOFPPortStatus, MAIN_DISPATCHER)
    def _port_status_handler(self, ev):
        msg = ev.msg
        reason = msg.reason
        datapath = msg.datapath
        dpid = datapath.id
        ofp = datapath.ofproto
        ofp_port = msg.desc
        port_no = msg.desc.port_no

        ofproto = msg.datapath.ofproto
        if reason == ofproto.OFPPR_ADD:
            self.logger.info("port added %s", port_no)
        elif reason == ofproto.OFPPR_DELETE:
            self.logger.info("port deleted %s", port_no)
        elif reason == ofproto.OFPPR_MODIFY:
            self.logger.info("port modified in %s port %s port_state %s", dpid, port_no, ofp_port.state)
            self.main_branch_state.setdefault(dpid, {})
            self.main_branch.setdefault(dpid, {})
            if port_no in self.main_branch_state[dpid]:
                if ofp_port.state == ofp.OFPPS_LINK_DOWN and self.main_branch_state[dpid][port_no] == True:
                    self.main_branch_state[dpid][port_no] = False
                    #Switch to link_down behaviour and add priority flows
                    if dpid == SW1_ID:
                        if self.main_branch[dpid][port_no] == SW2_ID:
                            self.add_priority_flow(self.datapath_list[HH1_ID], ipp2, self.link_down_route[HH1_ID])
                            self.add_priority_flow(self.datapath_list[HH1_ID], ipp4, self.link_down_route[HH1_ID])
                            self.add_priority_flow(self.datapath_list[HH3_ID], ipp2, self.link_down_route[HH3_ID])
                            self.add_priority_flow(self.datapath_list[HH3_ID], ipp4, self.link_down_route[HH3_ID])                       
                        if self.main_branch[dpid][port_no] == SW3_ID:
                            self.add_priority_flow(self.datapath_list[SW1_ID], ipp5, self.link_down_route[SW1_ID])
                    if dpid == SW2_ID:
                        if self.main_branch[dpid][port_no] == SW1_ID:
                            self.add_priority_flow(self.datapath_list[HH2_ID], ipp1, self.link_down_route[HH2_ID])
                            self.add_priority_flow(self.datapath_list[HH2_ID], ipp3, self.link_down_route[HH2_ID])
                            self.add_priority_flow(self.datapath_list[HH4_ID], ipp1, self.link_down_route[HH4_ID])
                            self.add_priority_flow(self.datapath_list[HH4_ID], ipp3, self.link_down_route[HH4_ID])                       
                        if self.main_branch[dpid][port_no] == SW3_ID:
                            self.add_priority_flow(self.datapath_list[SW2_ID], ipp5, self.link_down_route[SW2_ID])
                    if dpid == SW3_ID:
                        if self.main_branch[dpid][port_no] == SW1_ID:
                            self.add_priority_flow(self.datapath_list[SW4_ID], ipp1, self.link_down_route[SW4_ID])
                            self.add_priority_flow(self.datapath_list[SW4_ID], ipp3, self.link_down_route[SW4_ID])
                        if self.main_branch[dpid][port_no] == SW2_ID:
                            self.add_priority_flow(self.datapath_list[SW4_ID], ipp2, self.link_down_route[SW4_ID])
                            self.add_priority_flow(self.datapath_list[SW4_ID], ipp4, self.link_down_route[SW4_ID])
                        if self.main_branch[dpid][port_no] == SW4_ID:
                            self.add_priority_flow(self.datapath_list[SW3_ID], ipp5, self.link_down_route[SW3_ID])
                    if dpid == SW4_ID:
                        if self.main_branch[dpid][port_no] == SW3_ID:
                            self.add_priority_flow(self.datapath_list[HH5_ID], ipp1, self.link_down_route[HH5_ID])
                            self.add_priority_flow(self.datapath_list[HH5_ID], ipp2, self.link_down_route[HH5_ID])
                            self.add_priority_flow(self.datapath_list[HH5_ID], ipp3, self.link_down_route[HH5_ID])
                            self.add_priority_flow(self.datapath_list[HH5_ID], ipp4, self.link_down_route[HH5_ID])
                elif ofp_port.state != ofp.OFPPS_LINK_DOWN and self.main_branch_state[dpid][port_no] == False:
                    #OF1.0 doesn't include a LINK_DOWN equivalent so we suppose if it has ben modified and is not down, it has to be up
                    self.main_branch_state[dpid][port_no] = True
                    #Delete priority flows and return to normal behaviour
                    if dpid == SW1_ID:
                        if self.main_branch[dpid][port_no] == SW2_ID:
                            self.del_priority_flow(self.datapath_list[HH1_ID], ipp2, self.link_down_route[HH1_ID])
                            self.del_priority_flow(self.datapath_list[HH1_ID], ipp4, self.link_down_route[HH1_ID])
                            self.del_priority_flow(self.datapath_list[HH3_ID], ipp2, self.link_down_route[HH3_ID])
                            self.del_priority_flow(self.datapath_list[HH3_ID], ipp4, self.link_down_route[HH3_ID])                       
                        if self.main_branch[dpid][port_no] == SW3_ID:
                            self.del_priority_flow(self.datapath_list[SW1_ID], ipp5, self.link_down_route[SW1_ID])
                    if dpid == SW2_ID:
                        if self.main_branch[dpid][port_no] == SW1_ID:
                            self.del_priority_flow(self.datapath_list[HH2_ID], ipp1, self.link_down_route[HH2_ID])
                            self.del_priority_flow(self.datapath_list[HH2_ID], ipp3, self.link_down_route[HH2_ID])
                            self.del_priority_flow(self.datapath_list[HH4_ID], ipp1, self.link_down_route[HH4_ID])
                            self.del_priority_flow(self.datapath_list[HH4_ID], ipp3, self.link_down_route[HH4_ID])                       
                        if self.main_branch[dpid][port_no] == SW3_ID:
                            self.del_priority_flow(self.datapath_list[SW2_ID], ipp5, self.link_down_route[SW2_ID])
                    if dpid == SW3_ID:
                        if self.main_branch[dpid][port_no] == SW1_ID:
                            self.del_priority_flow(self.datapath_list[SW4_ID], ipp1, self.link_down_route[SW4_ID])
                            self.del_priority_flow(self.datapath_list[SW4_ID], ipp3, self.link_down_route[SW4_ID])
                        if self.main_branch[dpid][port_no] == SW2_ID:
                            self.del_priority_flow(self.datapath_list[SW4_ID], ipp2, self.link_down_route[SW4_ID])
                            self.del_priority_flow(self.datapath_list[SW4_ID], ipp4, self.link_down_route[SW4_ID])
                        if self.main_branch[dpid][port_no] == SW4_ID:
                            self.del_priority_flow(self.datapath_list[SW3_ID], ipp5, self.link_down_route[SW3_ID])
                    if dpid == SW4_ID:
                        if self.main_branch[dpid][port_no] == SW3_ID:
                            self.del_priority_flow(self.datapath_list[HH5_ID], ipp1, self.link_down_route[HH5_ID])
                            self.del_priority_flow(self.datapath_list[HH5_ID], ipp2, self.link_down_route[HH5_ID])
                            self.del_priority_flow(self.datapath_list[HH5_ID], ipp3, self.link_down_route[HH5_ID])
                            self.del_priority_flow(self.datapath_list[HH5_ID], ipp4, self.link_down_route[HH5_ID])
        else:
            self.logger.info("Illeagal port state %s %s", port_no, reason)

#!/usr/bin/python

""" 
 Copyright (c) 2014, NetIDE Consortium (Create-Net (CN), Telefonica Investigacion Y Desarrollo SA (TID), Fujitsu 
 Technology Solutions GmbH (FTS), Thales Communications & Security SAS (THALES), Fundacion Imdea Networks (IMDEA),
 Universitaet Paderborn (UPB), Intel Research & Innovation Ireland Ltd (IRIIL) )
 
 All rights reserved. This program and the accompanying materials
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Authors:
	Georgios Katsikas
"""

###############################################################################################
###        Name: Monitor.py
###      Author: Georgios Katsikas - katsikas@imdea.org
### Description: Module that gathers and prints useful statistics (e.g. pkt/byte counters)
###############################################################################################

import os

# Pyretic libraries
from pyretic.lib.corelib import *
from pyretic.lib.std import *
from pyretic.lib.query import *

# Pyretic modules
from Commons import *

### Monitoring Module for DC Topology ###
class Monitor(DynamicPolicy):
	# Monitor Constructor
	def __init__(self, monitoringInterval):
		super(Monitor, self).__init__()
		self.MonitoringInterval = monitoringInterval
		self.SetInitialState()
	
	# Start monitoring
	def SetInitialState(self):
		#self.ByteQuery  = self.ByteCounts()
		self.PktQuery   = self.PacketCounts()
		self.PktCapture = self.PacketInsector()
		self.UpdatePolicy()
	
	# Dynamically Update Policy
	def UpdatePolicy(self):
		self.policy = self.PktQuery + self.PktCapture # + self.ByteQuery

	# Prints counted packets
	def PacketCountPrinter(self, PktCounts):
		print("------------------------------ Packet Counts ------------------------------")
		for k, v in sorted(PktCounts.items()):
			print u'{0}: {1} pkts'.format(k, v)
		print("---------------------------------------------------------------------------")

	# Counts packets every second
	def PacketCounts(self):
		q = count_packets(self.MonitoringInterval, ['srcip', 'switch', 'protocol'])
		q.register_callback(self.PacketCountPrinter)
		return q

	# Prints counted bytes
	def ByteCountPrinter(self, ByteCounts):
		print("------------------------------- Packet Bytes ------------------------------")
		for k, v in sorted(ByteCounts.items()):
			print u'{0}: {1} bytes'.format(k, v)
		print("---------------------------------------------------------------------------")

	# Counts bytes every second
	def ByteCounts(self):
		q = count_bytes(self.MonitoringInterval, ['srcip', 'switch', 'protocol'])
		q.register_callback(self.ByteCountPrinter)
		return q

	# Packet capture
	def PacketInsector(self):
		q = packets(1, ['srcip', 'dstip', 'switch', 'protocol', 'ethtype'])
		q.register_callback(self.PacketPrinter)
		return q

	# Prints captured packet
	def PacketPrinter(self, pkt):
		print "------------------------------- Packet Content -----------------------------"

		# Capture Ethernet IP + ICMP/UDP/TCP		
		if pkt['ethtype'] == IP_TYPE:
			print "Ethernet packet"
			raw_bytes = [ord(c) for c in pkt['raw']]
			print "Ethernet payload is %d" % pkt['payload_len']    
			eth_payload_bytes = raw_bytes[pkt['header_len']:]   
			print "Ethernet payload is %d bytes" % len(eth_payload_bytes)
			ip_version = (eth_payload_bytes[0] & 0b11110000) >> 4
			ihl = (eth_payload_bytes[0] & 0b00001111)
			ip_header_len = ihl * 4
			ip_payload_bytes = eth_payload_bytes[ip_header_len:]
			ip_proto = eth_payload_bytes[9]
			print "IP Version = %d" % ip_version
			print "IP Header_len = %d" % ip_header_len
			print "IP Protocol = %d" % ip_proto
			print "IP Payload is %d bytes" % len(ip_payload_bytes)		

			# Number 6 is TCP
			if ip_proto == TCP:
				print "TCP packet"
				tcp_data_offset = (ip_payload_bytes[12] & 0b11110000) >> 4
				tcp_header_len = tcp_data_offset * 4
				print "TCP Header Length = %d" % tcp_header_len
				tcp_payload_bytes = ip_payload_bytes[tcp_header_len:]
				print "TCP Payload is %d bytes" % len(tcp_payload_bytes)
				if len(tcp_payload_bytes) > 0:
					print "Payload:\t",
					print ''.join([chr(d) for d in tcp_payload_bytes])
			# Number 17 is UDP
			elif ip_proto == UDP:
				print "UDP Packet"
				udp_header_len = 8
				print "UDP Header Length = %d" % udp_header_len
				udp_payload_bytes = ip_payload_bytes[udp_header_len:]
				print "UDP Payload is %d bytes" % len(udp_payload_bytes)
				if len(udp_payload_bytes) > 0:
					print "Payload:\t",
					print ''.join([chr(d) for d in udp_payload_bytes])
			# Number 1 is ICMP
			elif ip_proto == ICMP:
				print "ICMP packet"
				print pkt
			else:
				print "Unhandled IP packet type"
		# Capture Ethernet ARP
		elif pkt['ethtype'] == ARP_TYPE:
			print "ARP packet"
			print pkt
		else:
			print "Unhandled packet type"
		print "----------------------------------------------------------------------------"

### Main Method ###
def main():
	return Monitor(MonitoringInterval)

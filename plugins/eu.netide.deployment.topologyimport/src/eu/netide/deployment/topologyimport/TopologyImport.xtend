package eu.netide.deployment.topologyimport

import Topology.Connector
import Topology.Network
import Topology.NetworkEnvironment
import Topology.Port
import Topology.Switch
import Topology.TopologyFactory
import java.io.BufferedReader
import java.io.File
import java.io.FileNotFoundException
import java.io.FileReader
import java.io.IOException
import java.util.ArrayList
import java.util.Collections
import java.util.HashMap
import org.eclipse.core.resources.IFile
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ArrayNode

class TopologyImport {

	def createTopologyModelFromString(String switches, String hosts, String links, String filename) {
		var mapper = new ObjectMapper
		var jswitches = mapper.readTree(switches) as ArrayNode
		var jhosts = mapper.readTree(hosts) as ArrayNode
		var jlinks = mapper.readTree(links) as ArrayNode

		var ResourceSet resset = new ResourceSetImpl()
		var Resource res = resset.createResource(URI::createURI(filename))

		var ne = TopologyFactory.eINSTANCE.createNetworkEnvironment
		ne.name = "Imported"
		val network = TopologyFactory.eINSTANCE.createNetwork
		network.name = "Imported"
		network.networkenvironment = ne

		for (jswitch : jswitches) {
			var s = TopologyFactory.eINSTANCE.createSwitch
			s.topology = network
			var dpid = Integer.parseInt(jswitch.get("dpid").asText, 16)

			s.name = "s" + dpid
			s.dpid = "" + dpid

			for (jport : jswitch.get("ports") as ArrayNode) {
				var port = TopologyFactory.eINSTANCE.createPort
				port.id = jport.get("port_no").asInt
				port.hwAddr = jport.get("hw_addr").asText
				port.name = jport.get("name").asText
				port.networkelement = s
			}
		}

		for (jhost : jhosts) {
			var h = TopologyFactory.eINSTANCE.createHost
			h.topology = network
			var mac = jhost.get("mac").asText
			h.mac = mac
			h.name = "h" + mac.substring(mac.length - 2)

			var p = TopologyFactory.eINSTANCE.createPort
			p.id = jhost.get("port").get("port_no").asInt
			p.name = jhost.get("port").get("name").asText
			p.networkelement = h

		}

		for (jlink : jlinks) {
			var l = TopologyFactory.eINSTANCE.createConnector
			val dpidsrc = Integer.parseInt(jlink.get("src").get("dpid").asText, 16)
			val dpiddst = Integer.parseInt(jlink.get("dst").get("dpid").asText, 16)
			val portsrc = Integer.parseInt(jlink.get("src").get("port_no").asText)
			val portdst = Integer.parseInt(jlink.get("dst").get("port_no").asText)
			l.network = network

			var p1 = network.networkelements.filter(Switch).findFirst[dpid == "" + dpidsrc].ports.findFirst [
				id == portsrc
			]
			var p2 = network.networkelements.filter(Switch).findFirst[dpid == "" + dpiddst].ports.findFirst [
				id == portdst
			]

			p1.connector = l
			p2.connector = l
		}

		res.contents.add(ne)
		res.save(null)

	}

	def void createTopologyModelFromFile(IFile ifile) {
		var File file = ifile.getLocation().toFile()
		var BufferedReader reader = null
		var ResourceSet resset = new ResourceSetImpl()
		var Resource res = resset.createResource(
			URI::createURI(
				'''«ifile.getFullPath().removeLastSegments(1).toPortableString()»/«ifile.getName()».topology'''.
					toString))
					var TopologyFactory factory = TopologyFactory::eINSTANCE
					var NetworkEnvironment ne = factory.createNetworkEnvironment()
					ne.setName("TestNE")
					var Network net = factory.createNetwork()
					net.setNetworkenvironment(ne)
					net.setName("TestNet")
					try {
						reader = new BufferedReader(new FileReader(file))
						var String text = null
						var String base_str = "sw"
						var int nr_switches = Integer::parseInt(reader.readLine())
						var HashMap<String, Switch> sw_list = new HashMap<String, Switch>()

						for (var int i = 0; i < nr_switches; i++) {
							text = reader.readLine()
							var String name = '''«base_str»_«String::valueOf(i)»'''.toString
							var Switch sw = factory.createSwitch()
							sw.setName(name)
							sw.setTopology(net)
							sw_list.put(name, sw)
						}

						var int nr_edges = Integer::parseInt(reader.readLine())
						var HashMap<String, Connector> connector_list = new HashMap<String, Connector>()
						var HashMap<Connector, ArrayList<Port>> port_list = new HashMap<Connector, ArrayList<Port>>()
						var ArrayList<Port> all_ports = new ArrayList<Port>()

						for (var i = 0; i < nr_edges; i++) {
							text = reader.readLine()
							var ArrayList<Port> ports = new ArrayList<Port>()
							var String name = '''edge_«String::valueOf(i)»'''.toString
							var Connector con = factory.createConnector()
							con.setNetwork(net)
							connector_list.put(name, con)
							var Port port1 = factory.createPort()
							port1.setConnector(con)
							port1.setId(1)
							var Port port2 = factory.createPort()
							port2.setConnector(con)
							port2.setId(2)
							ports.add(port1)
							ports.add(port2)
							port_list.put(con, ports)
							all_ports.add(port1)
							all_ports.add(port2)
							con.getConnectedports().clear()
							con.getConnectedports().addAll(ports)
						}
						var Switch s0 = sw_list.get("sw_0")
						var Switch s1 = sw_list.get("sw_1")
						s0.getPorts().clear()
						s0.getPorts().add(all_ports.get(0))
						s1.getPorts().clear()
						s1.getPorts().add(all_ports.get(1))
					} catch (FileNotFoundException e) {
						e.printStackTrace()
					} catch (IOException e) {
						e.printStackTrace()
					}
					res.getContents().add(ne)
					try {
						res.save(Collections::EMPTY_MAP)
					} catch (IOException e) {
						e.printStackTrace()
					}
				// Read from topology file
				// create objects 
				}

			}
			
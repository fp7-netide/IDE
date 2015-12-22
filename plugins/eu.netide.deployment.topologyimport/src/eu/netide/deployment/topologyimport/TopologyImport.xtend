package eu.netide.deployment.topologyimport

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
import Topology.Connector
import Topology.Host
import Topology.Network
import Topology.NetworkEnvironment
import Topology.Port
import Topology.Switch
/*import java.lang.reflect.InvocationTargetException;
 * import org.eclipse.emf.common.notify.Adapter;
 * import org.eclipse.emf.common.notify.Notification;
 * import org.eclipse.emf.common.util.EList;
 * import org.eclipse.emf.common.util.TreeIterator;
 * import org.eclipse.emf.ecore.EAnnotation;
 * import org.eclipse.emf.ecore.EClass;
 * import org.eclipse.emf.ecore.EDataType;
 * import org.eclipse.emf.ecore.EObject;
 * import org.eclipse.emf.ecore.EOperation;
 * import org.eclipse.emf.ecore.EPackage;
 * import org.eclipse.emf.ecore.EReference;
 * import org.eclipse.emf.ecore.EStructuralFeature;
 import org.eclipse.emf.ecore.resource.Resource; */
import Topology.TopologyFactory
import eu.netide.deployment.topologyimport.json.JSONObject

class TopologyImport {

	def createTopologyModelFromString(String input, String filename) {
		var jtopo = new JSONObject(input)

		var ResourceSet resset = new ResourceSetImpl()
		var Resource res = resset.createResource(URI::createURI(filename))

		var nodes = jtopo.getJSONObject("network-topology").getJSONArray("topology").getJSONObject(0).
			getJSONArray("node")
		var links = jtopo.getJSONObject("network-topology").getJSONArray("topology").getJSONObject(0).
			getJSONArray("link")

		var ne = TopologyFactory.eINSTANCE.createNetworkEnvironment
		ne.name = "Imported"
		val network = TopologyFactory.eINSTANCE.createNetwork
		network.name = "Imported"
		network.networkenvironment = ne

		nodes.forEach [ e |
			var element = TopologyFactory.eINSTANCE.createSwitch
			element.name = '''s«(e as JSONObject).getString("node-id").split(":").get(1)»'''
			network.networkelements.add(element)
		]

		links.forEach [ e |
			val sourceName = '''s«(e as JSONObject).getJSONObject("source").getString("source-node").split(":").get(1)»'''
			val destName = '''s«(e as JSONObject).getJSONObject("destination").getString("dest-node").split(":").get(1)»'''

			val source = network.networkelements.findFirst[name == sourceName]
			val sourceport = TopologyFactory.eINSTANCE.createPort
			val dest = network.networkelements.findFirst[name == destName]
			val destport = TopologyFactory.eINSTANCE.createPort

			if (!network.connectors.exists [ l |
				l.connectedports.map[networkelement].containsAll(#[source, dest])
			]) {

				sourceport.id = source.ports.size
				sourceport.networkelement = source

				destport.id = dest.ports.size
				destport.networkelement = dest

				var link = TopologyFactory.eINSTANCE.createConnector
				link.connectedports.add(sourceport)
				link.connectedports.add(destport)

				link.network = network
			}
		]

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
			
package eu.netide.deployment.topologyvalidation.restrictiontopology

import Topology.Switch
import Topology.impl.TopologyFactoryImpl
import java.io.IOException
import java.util.Collections
import java.util.HashMap
import java.util.LinkedList
import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.xtend.lib.annotations.Accessors

import static eu.netide.deployment.topologyvalidation.matcher.VqlBuilder.*

abstract class ARootTopoModule extends ATopoModule {

	@Accessors protected LinkedList<Connection> connections = new LinkedList<Connection>()

	private LinkedList<ValSwitch> switches = null

	def public static Map<String, Class<?>> getParameterMap() {}

	new(String n) {
		super(n)
	}

	new (String name, Map<String, Object> parameterMap){
		this(name)
	}

	def private getSwitches() {
		if (switches === null) {
			switches = findSwitches
		}
		return switches
	}

	def void generateTopoRestriction() {
		this.connections = this.resolve();
	}

	/**
	 * For debugging purposes:
	 * Renders a topology from eu.netide.configuration
	 * to get a graphical representation of the generated
	 * topology
	 *
	 * @param filePath of the model which will be created
	 */
	def render(String filePath) {

		val fac = TopologyFactoryImpl.eINSTANCE

		val environment = fac.createNetworkEnvironment
		environment.name = "GenEnv"
		val network = fac.createNetwork
		network.name = "I"
		environment.networks.add(network)

		val swMap = new HashMap<ValSwitch, Switch>()

		getSwitches.forEach [
			val s = fac.createSwitch
			s.name = name
			network.networkelements.add(s)
			swMap.put(it, s)
		]

		connections.forEach [

			val leftPort = fac.createPort
			val rightPort = fac.createPort

			swMap.get(left).ports.add(leftPort)
			println('''«right.name»[«right.hashCode»]<--->«left.name»[«left.hashCode»]''')
			swMap.get(right).ports.add(rightPort)

			val con = fac.createConnector
			con.connectedports.add(leftPort)
			con.connectedports.add(rightPort)
			network.connectors.add(con)
		]

		saveGraph(filePath, environment)
	}

	def saveGraph(String fileName, EObject obj) throws IOException {
		val reg = Resource.Factory.Registry.INSTANCE;
		val Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("topology", new XMIResourceFactoryImpl());

		val resSet = new ResourceSetImpl();
		val resource = resSet.createResource(URI.createFileURI(fileName));
		(resource as XMLResource).encoding = "UTF-8"
		resource.getContents().add(obj);
		resource.save(Collections.EMPTY_MAP);
	}

	def private static LinkedList<ValSwitch> findSwitches(AModule module) {
		val result = new LinkedList<ValSwitch>()
		result.addAll(module.submodules.values.filter(ValSwitch))
		module.submodules.values.filter(AModule).forEach [
			result.addAll(findSwitches)
		]

		return result
	}

	// TODO: Move to ViatraManager (because of pattern FQN relation between the Vquery builder and Vmatcher)
	def generateViatraQuery(String fileName) {
		generateViatraQuery(fileName, getSwitches, getConnections)
	}

}

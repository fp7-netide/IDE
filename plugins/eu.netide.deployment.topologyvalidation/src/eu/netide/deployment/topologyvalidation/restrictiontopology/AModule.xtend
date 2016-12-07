package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.HashMap
import java.util.LinkedList
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

abstract class AModule implements IModule {

	@Accessors protected String name = ""
	@Accessors protected Map<String, IGate> gates = new HashMap<String, IGate>
	@Accessors protected List<GateConnector> gateConnectors = new LinkedList<GateConnector>
	@Accessors protected Map<String, IModule> submodules = new HashMap<String, IModule>
	@Accessors protected boolean resolved = false

	protected new() {
		super()
	}

	protected new(String n) {
		super()
		name = n
	}


	/**
	 * @returns GateConnectors which are not connected to Gates of this module.
	 * This GateConnectors needs to be resolved, because the are not connected to outer GateConnectors.
	 */
	def getInnerConnectedGates(IGate gate) {
		val resultList = new LinkedList<IGate>

		gateConnectors.forEach [
			if (left == gate) {
				resultList.add(right)
			} else if (right == gate) {
				resultList.add(left)
			}
		]
		return resultList
	}
}

package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.LinkedList
import java.util.List

abstract class ATopoModule extends AModule {

	new(String n) {
		super(n)
	}

	def protected void init() {
		initSubmodules()
		initGates()
		initGateConnectors()
	}

	def void initSubmodules()

	def void initGates()

	def void initGateConnectors()



	def void addGate(String key, Gate gate) {
		gates.put(key, gate)
	}

	def void addSubmodule(String key, IModule module) {
		submodules.put(key, module)
	}

	def void addGateConnector(IGate left, IGate right) {
		gateConnectors.add(new GateConnector(left, right))
	}

	def void addGateConnector(IGate left, IGate right, String restriction) {
		val gc = new GateConnector(left, right)
		gc.addRestriction(new Restriction(restriction))
		gateConnectors.add(gc)
	}

	override LinkedList<Connection> resolve() {
		// TODO: is property needed?
		if(resolved) return new LinkedList<Connection>

		val resultList = new LinkedList<Connection>

		for (GateConnector gateConnector : getInnerGateConnectors()) {
			resultList.addAll( gateConnector.resolve() )
		}

		this.submodules.values.forEach[
			resultList.addAll( resolve() )
		]

		this.resolved = true
		return resultList
	}

	def List<GateConnector> getInnerGateConnectors() {
		val resultList = new LinkedList<GateConnector>()
		resultList.addAll(
			gateConnectors
				.filter[!gates.containsValue(it.left)]
				.filter[!gates.containsValue(it.right)]
		)

		return resultList
	}
}
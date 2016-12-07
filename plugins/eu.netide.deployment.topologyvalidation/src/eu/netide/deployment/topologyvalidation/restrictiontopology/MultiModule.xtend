package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.LinkedList
import java.util.List
import java.util.Map
import java.util.function.Function

class MultiModule<T extends IModule> extends AModule{

	protected Integer arraySize

	new(Integer size, String n, Map<String, Object> parameters, Function<Map<String, Object>, T> creator) {
		super(n)

		arraySize = size

		for (var i = 0; i < arraySize; i++) {
			submodules.put(i.toString, creator.apply(parameters));
		}

		if (arraySize > 0) {
			submodules.get("0").gates.forEach[ key, gate |
				val myGate = new Gate(this)
				this.gates.put(key, myGate)
				submodules.values.forEach[
					this.gateConnectors.add(new GateConnector(myGate, it.gates.get(key)))
				]
			]
		}
	}

	def IModule get(int i) {
		submodules.get(i.toString)
	}

	override List<Connection> resolve() {
		if(resolved) return emptyList

		val resultList = new LinkedList<Connection>

		this.submodules.values.forEach[
			resultList.addAll( resolve() )
		]

		this.resolved = true
		return resultList
	}
}

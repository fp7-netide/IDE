package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.LinkedList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

class Gate implements IGate {

	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) IModule module

	new(IModule module) {
		super()
		this.module = module
	}

	override IModule getModule() {
		this.module
	}

	override List<Connection> resolve(IGate gate, LinkedList<Restriction> restrictions) {

		if (this.module instanceof ValSwitch) {

			if (gate.module instanceof ValSwitch) {

				// both are switches
				// -> add Connection
				return newLinkedList(new Connection(this.module, gate.module as ValSwitch, restrictions))
			} else {

				// this.module is a Switch and gate.module is AModule
				// -> reverse resolving
				return gate.resolve(this, restrictions)
			}
		} else {

			// this.module is a Module
			// -> resolve all inner connected gates

			val resultList = new LinkedList<Connection>()
			module.gateConnectors.filter[left==this].forEach[
				val newRestrictions = restrictions.clone as LinkedList<Restriction>
				newRestrictions.addAll(it.restrictions)
				resultList.addAll(right.resolve(gate, newRestrictions))
			]
			module.gateConnectors.filter[right==this].forEach[
				val newRestrictions = restrictions.clone as LinkedList<Restriction>
				newRestrictions.addAll(it.restrictions)
				resultList.addAll(left.resolve(gate, newRestrictions))
			]
			return resultList
		}
	}
}

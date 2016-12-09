package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.LinkedList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

class Connection extends ARestrictable{

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER) ValSwitch left

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER) ValSwitch right

	new(Restriction r) {
		super()
		addRestriction(r)
	}

	new(List<Restriction> rs) {
		super()
		restrictions.addAll(rs)
	}

	new(ValSwitch left, ValSwitch right) {
		this.left = left;
		this.right = right;
	}

	new(ValSwitch left, ValSwitch right, LinkedList<Restriction> restrictions) {
		this(left, right)
		this.restrictions = restrictions
	}

	override clone() {
		val clone = new Connection(restrictions.clone as LinkedList<Restriction>)
		clone.left = left
		clone.right = right
		return clone
	}
}

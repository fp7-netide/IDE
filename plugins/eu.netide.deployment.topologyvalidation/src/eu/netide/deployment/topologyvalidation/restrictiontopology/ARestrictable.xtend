package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.LinkedList
import org.eclipse.xtend.lib.annotations.Accessors

class ARestrictable implements IRestrictable {

	@Accessors protected LinkedList<Restriction> restrictions = new LinkedList<Restriction>


	override renderRestrictions() {
		'''«FOR r : restrictions SEPARATOR ' && '»«r.render»«ENDFOR»'''
	}

	override addRestriction(Restriction restriction) {
		restrictions.add(restriction)
	}

}
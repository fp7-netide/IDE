package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.LinkedList

interface IRestrictable {

	def LinkedList<Restriction> getRestrictions()

	def String renderRestrictions()

	def void setRestrictions(LinkedList<Restriction> restrictions)

	def void addRestriction(Restriction restriction)

}

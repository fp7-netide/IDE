package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.LinkedList
import java.util.List

interface IGate {

	def public IModule getModule()

	def public List<Connection> resolve(IGate gate, LinkedList<Restriction> restrictions)

}

package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.Map
import java.util.List

interface IModule extends IResolvable{

	def String getName()

	def Map<String, IGate> getGates()
	def List<GateConnector> getGateConnectors()
}

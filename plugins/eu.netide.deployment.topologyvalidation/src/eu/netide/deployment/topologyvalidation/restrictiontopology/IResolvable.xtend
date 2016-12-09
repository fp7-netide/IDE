package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.List

interface IResolvable {
	def List<Connection> resolve()
}

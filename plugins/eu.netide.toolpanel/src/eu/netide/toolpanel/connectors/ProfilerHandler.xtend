package eu.netide.toolpanel.connectors

import com.fasterxml.jackson.databind.node.ArrayNode
import com.fasterxml.jackson.databind.node.ObjectNode
import eu.netide.toolpanel.runtime.RuntimeModelManager
import org.eclipse.emf.transaction.RecordingCommand
import RuntimeTopology.FlowStatistics
import Topology.Switch
import RuntimeTopology.RuntimeTopologyFactory
import RuntimeTopology.PortStatistics
import RuntimeTopology.AggregatedStatistics

class ProfilerHandler {

	def handleFlowStats(ArrayNode flowStats) {
		val session = RuntimeModelManager.instance.session
		val rt = RuntimeModelManager.instance.runtimeData

		for (node : flowStats) {
			if (node.get("Type").asText.equals("Flow Stats")) {
				var updateCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {
					override doExecute() {
						val dpid = node.get("dpid").asText
						val env = RuntimeModelManager.instance.runtimeData.networkenvironment
						val sw = env.getNetworks().map[x|x.networkelements].flatten.filter(typeof(Switch)).findFirst [ x |
							x.dpid == dpid
						]
						if (sw == null)
							return
						var FlowStatistics fs = rt.flowstatistics.findFirst[x|x.^switch.equals(sw)]

						if (fs == null) {
							fs = RuntimeTopologyFactory.eINSTANCE.createFlowStatistics
							fs.^switch = sw
							fs.setRuntimedata(rt);
						}
						fs.duration_sec = node.get("duration_sec").asInt
						fs.duration_nsec = node.get("duration_nsec").asInt
						fs.priority = node.get("priority").asInt
						fs.idle_timeout = node.get("idle_timeout").asInt
						fs.hard_timeout = node.get("hard_timeout").asInt
						fs.cookie = node.get("cookie").asInt
						fs.packet_count = node.get("packet_count").asInt
						fs.byte_count = node.get("byte_count").asInt
					}
				};
				session.transactionalEditingDomain.commandStack.execute(updateCommand)
			}
		}
//				return Status.OK_STATUS
	}

// job.schedule
	def void handlePortStats(ArrayNode portStats, ArrayNode dpidLog) {
		val session = RuntimeModelManager.instance.session
		val rt = RuntimeModelManager.instance.runtimeData

		for (node : portStats) {
			if (node.get("port").asInt != 65534 && node.get("Type").asText.equals("Port Stats")) {

				var updateCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {

					override doExecute() {
						val dpid = node.get("dpid").asText
						val portno = node.get("port").asInt
						val env = RuntimeModelManager.instance.runtimeData.networkenvironment

						val sw = env.getNetworks().map[x|x.networkelements].flatten.filter [ x |
							x instanceof Switch
						].findFirst[x|x.dpid == dpid]
						if (sw == null)
							return
						val port = sw.ports.get(portno - 1)

						var PortStatistics ps = rt.portstatistics.findFirst[x|x.port.equals(port)]

						if (ps == null) {
							ps = RuntimeTopologyFactory.eINSTANCE.createPortStatistics
							ps.port = port
							ps.setRuntimedata(rt);

						}

						val size = dpidLog.size()
						ps.changed = false

						if (size >= 2) {
							val currentEntry = dpidLog.get(size - 2).findFirst [ x |
								x.get("port").asInt == portno
							]

							val currentBytes = currentEntry.get("tx_bytes").asInt
							val newBytes = node.get("tx_bytes").asInt
							ps.changed = currentBytes != newBytes
						}

						ps.tx_bytes = node.get("tx_bytes").asInt
						ps.rx_bytes = node.get("rx_bytes").asInt
						ps.tx_dropped = node.get("tx_dropped").asInt
						ps.rx_dropped = node.get("rx_dropped").asInt
						ps.tx_packets = node.get("tx_packets").asInt
						ps.rx_packets = node.get("rx_packets").asInt
						ps.tx_errors = node.get("tx_errors").asInt
						ps.rx_errors = node.get("rx_errors").asInt
						ps.rx_over_err = node.get("rx_over_err").asInt
						ps.rx_frame_err = node.get("rx_frame_err").asInt
						ps.rx_crc_err = node.get("rx_crc_err").asInt
						ps.collisions = node.get("collisions").asInt
					}

				};
				session.transactionalEditingDomain.commandStack.execute(updateCommand)
			}

		}
	// return Status.OK_STATUS
	}

	def handleAggregatedStats(ObjectNode aggregatedStats) {
		val session = RuntimeModelManager.instance.session
		val rt = RuntimeModelManager.instance.runtimeData
		val node = aggregatedStats

		if (node.get("Type").asText.equals("Aggregate Stats")) {
			var updateCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {
				override doExecute() {
					val dpid = node.get("dpid").asText
					val env = RuntimeModelManager.instance.runtimeData.networkenvironment
					val sw = env.getNetworks().map[x|x.networkelements].flatten.filter(typeof(Switch)).findFirst [ x |
						x.dpid == dpid
					]
					if(sw == null) return

					var AggregatedStatistics fs = rt.aggregatedstatistics.findFirst[x|x.^switch.equals(sw)]

					if (fs == null) {
						fs = RuntimeTopologyFactory.eINSTANCE.createAggregatedStatistics
						fs.^switch = sw
						fs.setRuntimedata(rt);
					}
					fs.byte_count = node.get("byte_count").asInt
					fs.flow_count = node.get("flow_count").asInt
					fs.packet_count = node.get("packet_count").asInt

				}
			};
			session.transactionalEditingDomain.commandStack.execute(updateCommand)
		}

//				return Status.OK_STATUS
	}

// job.schedule
}

package eu.netide.toolpanel.connectors

import RuntimeTopology.PortStatistics
import RuntimeTopology.RuntimeData
import RuntimeTopology.RuntimeTopologyFactory
import Topology.NetworkEnvironment
import Topology.Switch
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ArrayNode
import com.fasterxml.jackson.databind.node.ObjectNode
import eu.netide.configuration.utils.fsa.FSAProvider
import eu.netide.configuration.utils.fsa.FileSystemAccess
import eu.netide.lib.netip.Message
import eu.netide.toolpanel.runtime.RuntimeModelManager
import eu.netide.zmq.hub.client.IZmqNetIpListener
import eu.netide.zmq.hub.server.ZmqHubManager
import eu.netide.zmq.hub.server.ZmqPubSubHub
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.sirius.business.api.session.Session
import RuntimeTopology.FlowStatistics
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl
import org.eclipse.emf.ecore.xmi.XMIResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.ecore.EcoreFactory

class ProfilerConnector implements IZmqNetIpListener {

	private ZmqPubSubHub hub
	private ObjectMapper mapper
	private RuntimeModelManager manager
	private Session session
	private IFile file
	private Boolean recording

	private ObjectNode recordLog
	private ObjectNode log
	private FileSystemAccess fsa

	new(IFile file) {
		this.hub = ZmqHubManager.instance.getPubSubHub("Profiler", "tcp://localhost:5561")
		this.hub.running = false
		this.hub.running = true
		this.hub.register(this)
		this.mapper = new ObjectMapper
		this.file = file
		this.recordLog = mapper.nodeFactory.objectNode
		this.log = mapper.nodeFactory.objectNode
		this.log.putArray("FlowLog")
		this.log.putArray("PortLog")
		this.recording = false

		this.fsa = FSAProvider.get
		this.fsa.project = file.project
		this.fsa.outputDirectory = "./statistics"

		this.manager = RuntimeModelManager.getInstance();
		this.session = manager.getSession();

	}

	public def start() {
	}

	override update(Message msg) {
		var json = mapper.readTree(msg.payload)

		if (json.has("PortStats"))
			handlePortStats(json.get("PortStats") as ArrayNode)
		else if (json.has("FlowStats"))
			handleFlowStats(json.get("FlowStats") as ArrayNode)
	}

	def handleFlowStats(ArrayNode flowStats) {
		var job = new Job("Updating Runtime Model") {

			override protected run(IProgressMonitor monitor) {

				(log.get("FlowLog") as ArrayNode).add(flowStats)
				if (recording) {
					(recordLog.get("FlowLog") as ArrayNode).add(flowStats)
				}

				var res = session.getSemanticResources().iterator().next();

				val rt = res.getContents().get(0) as RuntimeData;
				val env = rt.networkenvironment;

				for (node : flowStats) {
					if (node.get("Type").asText.equals("Flow Stats")) {
						var updateCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {
							override doExecute() {
								val dpid = node.get("dpid").asText
								val sw = env.getNetworks().map[x|x.networkelements].flatten.filter(typeof(Switch)).
									findFirst[x|x.dpid == dpid]
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
				return Status.OK_STATUS

			}

		}
		job.schedule
	}

	private def void handlePortStats(ArrayNode portStats) {
		var job = new Job("Updating Runtime Model") {

			override protected run(IProgressMonitor monitor) {

				(log.get("PortLog") as ArrayNode).add(portStats)
				if (recording) {
					(recordLog.get("log") as ArrayNode).add(portStats)
				}

				var res = session.getSemanticResources().iterator().next();

				val rt = res.getContents().get(0) as RuntimeData;
				val env = rt.networkenvironment;

				for (node : portStats) {
					if (node.get("port").asInt != 65534 && node.get("Type").asText.equals("Port Stats")) {

						var updateCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {

							override doExecute() {

								val dpid = node.get("dpid").asText
								val portno = node.get("port").asInt

								val sw = env.getNetworks().map[x|x.networkelements].flatten.filter [ x |
									x instanceof Switch
								].findFirst[x|x.dpid == dpid]
								val port = sw.ports.get(portno - 1)

								var PortStatistics ps = rt.portstatistics.findFirst[x|x.port.equals(port)]

								if (ps == null) {
									ps = RuntimeTopologyFactory.eINSTANCE.createPortStatistics
									ps.port = port
									ps.setRuntimedata(rt);

								}

								val size = (log.get("PortLog") as ArrayNode).size()

								if (size > 2) {
									val currentBytes = (log.get("PortLog") as ArrayNode).get(size - 2).findFirst[x | x.get("port").asInt == portno].get("tx_bytes").asInt
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
				return Status.OK_STATUS

			}

		}
		job.schedule
	}

	public def clearPortStatistics() {

		var clearCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {

			override protected doExecute() {
				var res = session.getSemanticResources().iterator().next()
//				val env = res.getContents().get(0) as NetworkEnvironment
				val rt = res.getContents().get(1) as RuntimeData

				rt.portstatistics.clear
			}

		}

		this.session.transactionalEditingDomain.commandStack.execute(clearCommand)

	}

	public def setRecording(Boolean recording) {
		this.recording = recording
		if (recording) {
			this.recordLog.putArray("FlowLog")
			this.recordLog.putArray("PortLog")
		} else {
			this.fsa.generateFile(System.currentTimeMillis.toString() + ".json",
				mapper.writerWithDefaultPrettyPrinter.writeValueAsString(recordLog))
			this.recordLog.remove("FlowLog")
			this.recordLog.remove("PortLog")
		}

	}
}

package eu.netide.toolpanel.connectors

import RuntimeTopology.PortStatistics
import RuntimeTopology.RuntimeData
import RuntimeTopology.RuntimeTopologyFactory
import Topology.NetworkEnvironment
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ArrayNode
import com.fasterxml.jackson.databind.node.ObjectNode
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
import eu.netide.configuration.utils.fsa.FileSystemAccess
import eu.netide.configuration.utils.fsa.FSAProvider

class ProfilerConnector implements IZmqNetIpListener {

	private ZmqPubSubHub hub
	private ObjectMapper mapper
	private RuntimeModelManager manager
	private Session session
	private IFile file
	private Boolean recording

	private ObjectNode log
	private FileSystemAccess fsa

	new(IFile file) {
		this.hub = ZmqHubManager.instance.getPubSubHub("Profiler", "tcp://localhost:5561")
		this.hub.running = true
		this.hub.register(this)
		this.mapper = new ObjectMapper
		this.file = file
		this.log = mapper.nodeFactory.objectNode
		
		this.fsa = FSAProvider.get
		this.fsa.project = file.project
		this.fsa.outputDirectory = "./statistics"

		this.manager = RuntimeModelManager.getInstance();
		this.session = manager.getSession();

	}

	override update(Message msg) {

		if (this.recording) {
			var stats = mapper.readTree(msg.payload).get("stats") as ArrayNode
			(this.log.get("log") as ArrayNode).add(stats)
		}

		var job = new Job("Updating Runtime Model") {

			override protected run(IProgressMonitor monitor) {

				var res = session.getSemanticResources().iterator().next();

				val env = res.getContents().get(0) as NetworkEnvironment;
				val rt = res.getContents().get(1) as RuntimeData;

				mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
				var stats = mapper.readTree(msg.payload).get("stats") as ArrayNode

				for (node : stats) {

					var updateCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {

						override doExecute() {

							val port = env.getNetworks().get(0).getNetworkelements().get(0).getPorts().get(0)
							var PortStatistics ps = rt.portstatistics.findFirst[x|x.port.equals(port)]

							if (ps == null) {
								ps = RuntimeTopologyFactory.eINSTANCE.createPortStatistics
								ps.port = port
								ps.setRuntimedata(rt);

							}

							ps.tx_bytes = node.get("tx_bytes").asInt
							ps.rx_bytes = node.get("rx_bytes").asInt

						}
					};
					session.getTransactionalEditingDomain().getCommandStack().execute(updateCommand);

					return Status.OK_STATUS
				}
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
		if(recording) {
			this.log.putArray("log")
		} else {
			this.fsa.generateFile(System.currentTimeMillis.toString()+".json", mapper.writerWithDefaultPrettyPrinter.writeValueAsString(log))
			this.log.remove("log")
		}

	}
}

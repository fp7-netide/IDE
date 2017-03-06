package eu.netide.toolpanel.connectors

import RuntimeTopology.RuntimeData
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ArrayNode
import com.fasterxml.jackson.databind.node.ObjectNode
import eu.netide.configuration.utils.fsa.FSAProvider
import eu.netide.configuration.utils.fsa.FileSystemAccess
import eu.netide.lib.netip.Message
import eu.netide.toolpanel.providers.LogProvider
import eu.netide.toolpanel.runtime.RuntimeModelManager
import eu.netide.zmq.hub.client.IZmqNetIpListener
import eu.netide.zmq.hub.server.ZmqHubManager
import eu.netide.zmq.hub.server.ZmqPubSubHub
import eu.netide.zmq.hub.server.ZmqSendReceiveHub
import java.util.Timer
import java.util.TimerTask
import org.eclipse.core.resources.IFile
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.sirius.business.api.session.Session
import org.eclipse.ui.PlatformUI
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import java.util.concurrent.ScheduledFuture

class ProfilerConnector implements IZmqNetIpListener {

	private ZmqPubSubHub hub
	private ZmqSendReceiveHub commandHub
	private ObjectMapper mapper
	private RuntimeModelManager manager
	private Session session
	private IFile file
	private Boolean recording

	private ObjectNode recordLog
	private ObjectNode log
	private FileSystemAccess fsa

	//private String address

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	private double pollInterval = -1

	private ScheduledExecutorService pollJob
	private PollTask pollTask
	
	private ProfilerHandler profilerHandler
	
	private ScheduledFuture future

	new(IFile file, String address) {
		this.hub = ZmqHubManager.instance.getPubSubHub("Profiler", String.format("tcp://%s:5561", address))
		this.hub.running = false
		this.hub.running = true
		this.hub.register(this)
		this.commandHub = ZmqHubManager.instance.getSendReceiveHub("Profiler Commands",
			String.format("tcp://%s:30557", address))

		this.mapper = new ObjectMapper
		this.file = file
		this.recordLog = mapper.nodeFactory.objectNode
		this.log = LogProvider.instance.log
		if (this.log.has("FlowLog") && this.log.has("PortLog")) {
			this.log.remove("FlowLog")
			this.log.remove("PortLog")
			this.log.remove("AggregatedLog")
		}
		this.log.putObject("FlowLog")
		this.log.putObject("PortLog")
		this.log.putObject("AggregatedLog")

		this.recording = false

		this.fsa = FSAProvider.get
		this.fsa.project = file.project
		this.fsa.outputDirectory = "./statistics"

		this.manager = RuntimeModelManager.getInstance();
		this.session = manager.getSession();

		this.pollTask = new PollTask(this)
		
		this.profilerHandler = new ProfilerHandler
	}

	private static class PollTask implements Runnable {
		private ProfilerConnector connector

		new(ProfilerConnector connector) {
			this.connector = connector
		}

		override run() {
			try{
				connector.poll()
			}
			catch(Exception e){
				e.printStackTrace
			}
		}
	}

	override update(Message msg) {
		LogProvider.instance.deactivateReplayLog
		this.log = LogProvider.instance.log
		var json = mapper.readTree(msg.payload)

		if (json.has("PortStats"))
			handlePortStats(json.get("PortStats") as ArrayNode)
		else if (json.has("FlowStats"))
			handleFlowStats(json.get("FlowStats") as ArrayNode)
		else if (json.has("AggregatedStats"))
			handleAggregatedStats(json.get("AggregatedStats") as ObjectNode)
	}

	def handleFlowStats(ArrayNode flowStats) {
		var job = new Thread("Updating Runtime Model") {

			override run() {
				session = manager.session
				if (!log.has("FlowLog")) log.putObject("FlowLog")

				val flowLog = log.get("FlowLog") as ObjectNode
				if(flowLog == null || flowStats.size == 0) return
				val dpid = flowStats.get(0).get("dpid").asText()

				if (!flowLog.has(dpid))
					flowLog.putArray(dpid)

				val dpidLog = flowLog.get(dpid) as ArrayNode
				dpidLog.add(flowStats)

				if (recording) {
					if (!recordLog.get("FlowLog").has(dpid))
						(recordLog.get("FlowLog") as ObjectNode).putArray(dpid)
					((recordLog.get("FlowLog") as ObjectNode).get(dpid) as ArrayNode).add(flowStats)
				}

				var res = session.getSemanticResources().iterator().next();

				val rt = res.getContents().get(0) as RuntimeData;
				val env = rt.networkenvironment;
				
				profilerHandler.handleFlowStats(flowStats)

			}

		}
		PlatformUI.workbench.display.asyncExec(job)
	}

	private def void handlePortStats(ArrayNode portStats) {
		var job = new Thread("Updating Runtime Model") {

			override run() {
				if (!log.has("PortLog")) log.putObject("PortLog")
				
				val portLog = log.get("PortLog") as ObjectNode
				val dpid = portStats.get(0).get("dpid").asText()
				
				

				if (portLog == null) return;
				
				session = manager.session

				if (!portLog.has(dpid))
					portLog.putArray(dpid)

				val dpidLog = portLog.get(dpid) as ArrayNode
				dpidLog.add(portStats)

				if (recording) {
					if (!recordLog.get("PortLog").has(dpid))
						(recordLog.get("PortLog") as ObjectNode).putArray(dpid)
					((recordLog.get("PortLog") as ObjectNode).get(dpid) as ArrayNode).add(portStats)
				}

				if(manager.session == null) return

				val rt = RuntimeModelManager.instance.runtimeData;

				profilerHandler.handlePortStats(portStats, dpidLog)

			}

		}
		PlatformUI.workbench.display.asyncExec(job)
	}

	def handleAggregatedStats(ObjectNode aggregatedStats) {
		var job = new Thread("Updating Runtime Model") {

			override run() {
				session = manager.session
				if (!log.has("AggregatedLog")) log.putObject("AggregatedLog")

				val flowLog = log.get("AggregatedLog") as ObjectNode
				if(aggregatedStats.size == 0) return

				val dpid = aggregatedStats.get("dpid").asText()

				if (!flowLog.has(dpid))
					flowLog.putArray(dpid)

				val dpidLog = flowLog.get(dpid) as ArrayNode
				dpidLog.add(aggregatedStats)

				if (recording) {
					if (!recordLog.get("AggregatedLog").has(dpid))
						(recordLog.get("AggregatedLog") as ObjectNode).putArray(dpid)
					((recordLog.get("AggregatedLog") as ObjectNode).get(dpid) as ArrayNode).add(aggregatedStats)
				}

				if(manager.session == null) return

				var res = session.getSemanticResources().iterator().next();

//				//val rt = res.getContents().get(0) as RuntimeData;
//				val env = rt.networkenvironment;
//				val node = aggregatedStats
				
				profilerHandler.handleAggregatedStats(aggregatedStats)

			}

		}
		PlatformUI.workbench.display.asyncExec(job)
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
			this.recordLog.putObject("FlowLog")
			this.recordLog.putObject("PortLog")
			this.recordLog.putObject("AggregatedLog")
		} else {
			this.fsa.generateFile(System.currentTimeMillis.toString() + ".json",
				mapper.writerWithDefaultPrettyPrinter.writeValueAsString(recordLog))
			this.recordLog.remove("FlowLog")
			this.recordLog.remove("PortLog")
			this.recordLog.remove("AggregatedLog")
		}

	}

	public def startPolling(double interval) {
		this.pollInterval = interval
		this.pollTask = new PollTask(this)
		this.pollJob = Executors.newSingleThreadScheduledExecutor
		this.future = this.pollJob.scheduleAtFixedRate(pollTask, 0, (1000 * interval) as int, TimeUnit.MILLISECONDS)
	}

	public def stopPolling() {
		pollJob.shutdown()
	}

	public def poll() {
		commandHub.send("2")
		commandHub.send("1")
		commandHub.send("3")
		commandHub.send("1")
		commandHub.send("4")
		commandHub.send("1")
		
	}

	public def activatePortStatistics() {
		commandHub.send("2")
	}

	public def activateFlowStatistics() {
		commandHub.send("3")
	}

	public def activateAggregatedStatistics() {
		commandHub.send("4")
	}
	
	public def destroy() {
		hub.remove(this)
	}

}

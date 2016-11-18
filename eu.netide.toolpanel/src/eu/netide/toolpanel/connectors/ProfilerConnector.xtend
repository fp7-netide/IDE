package eu.netide.toolpanel.connectors

import RuntimeTopology.RuntimeData
import RuntimeTopology.RuntimeTopologyFactory
import Topology.NetworkEnvironment
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ArrayNode
import eu.netide.lib.netip.Message
import eu.netide.toolpanel.runtime.RuntimeModelManager
import eu.netide.zmq.hub.client.IZmqNetIpListener
import eu.netide.zmq.hub.server.ZmqHubManager
import eu.netide.zmq.hub.server.ZmqPubSubHub
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.sirius.business.api.session.Session

class ProfilerConnector implements IZmqNetIpListener {

	private ZmqPubSubHub hub
	private ObjectMapper mapper
	private RuntimeModelManager manager
	private Session session
	
	new() {
		this.hub = ZmqHubManager.instance.getPubSubHub("Profiler", "tcp://localhost:5561")
		this.hub.running = true
		this.hub.register(this)
		this.mapper = new ObjectMapper

		this.manager = RuntimeModelManager.getInstance();
		this.session = manager.getSession();

		var res = session.getSemanticResources().iterator().next();

		val env = res.getContents().get(0) as NetworkEnvironment;
		val rt = res.getContents().get(1) as RuntimeData;

		var updateCommand = new RecordingCommand(session.getTransactionalEditingDomain()) {

			override doExecute() {
				var ps = RuntimeTopologyFactory.eINSTANCE.createPortStatistics();
				ps.setPort(env.getNetworks().get(0).getNetworkelements().get(0).getPorts().get(0));
				ps.setRx_bytes(5);
				ps.setTx_bytes(10);
				ps.setRuntimedata(rt);

			}
		};

		session.getTransactionalEditingDomain().getCommandStack().execute(updateCommand);
	}

	override update(Message msg) {

		var stats = mapper.readTree(msg.payload).get("stats") as ArrayNode
		for (node : stats) {
			println(node)
		}
	}
}

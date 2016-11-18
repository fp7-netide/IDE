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
import RuntimeTopology.PortStatistics
import RuntimeTopology.impl.PortStatisticsImpl
import com.fasterxml.jackson.databind.DeserializationFeature
import Topology.TopologyFactory

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
						ps.setRuntimedata(rt);

					}

					ps.tx_bytes = node.get("tx_bytes").asInt
					ps.rx_bytes = node.get("rx_bytes").asInt

				}
			};
			session.getTransactionalEditingDomain().getCommandStack().execute(updateCommand);

		}

	}
}

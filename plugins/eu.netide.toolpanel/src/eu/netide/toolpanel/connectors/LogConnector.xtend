package eu.netide.toolpanel.connectors

import com.fasterxml.jackson.databind.JsonNode
import org.eclipse.emf.common.util.URI
import java.beans.PropertyChangeSupport
import java.io.File
import com.fasterxml.jackson.databind.ObjectMapper
import java.beans.PropertyChangeListener
import eu.netide.toolpanel.connectors.ProfilerConnector
import eu.netide.toolpanel.connectors.ProfilerHandler
import org.eclipse.core.resources.IFile
import com.fasterxml.jackson.databind.node.ArrayNode
import com.fasterxml.jackson.databind.node.ObjectNode

class LogConnector {

	private PropertyChangeSupport changes;

	private JsonNode root
	private int size = 4

	private ProfilerHandler handler
	private ObjectMapper mapper

	new() {
		this.changes = new PropertyChangeSupport(this)

	}

	def fromFile(IFile file) {
		this.mapper = new ObjectMapper
		this.root = mapper.readTree(file.location.toFile)

		var s = root.get("AggregatedLog").findFirst[true].size

		changes.firePropertyChange(
			"size",
			size,
			this.size = s
		)

		this.handler = new ProfilerHandler
	}

	def handle(int i) {
		val aggregatedLog = root.get("AggregatedLog") as ObjectNode
		val portLog = root.get("PortLog")
		val flowLog = root.get("FlowLog")

		for (node : aggregatedLog) {
			this.handler.handleAggregatedStats(node.get(i - 1) as ObjectNode)
		}

		for (node : flowLog) {
			this.handler.handleFlowStats(node.get(i - 1) as ArrayNode)
		}

		for (node : portLog) {
			val dpidLog = this.mapper.createArrayNode;
			for (var j = 0; j < i; j++)
				dpidLog.add(node.get(j))
				
			this.handler.handlePortStats(node.get(i - 1) as ArrayNode, dpidLog as ArrayNode)

		}
	}

	def getSize() {
		return this.size
	}

	def addPropertyChangeListener(PropertyChangeListener l) {
		changes.addPropertyChangeListener(l);
	}

	def addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
		changes.addPropertyChangeListener(propertyName, listener);
	}

	def removePropertyChangeListener(PropertyChangeListener l) {
		changes.removePropertyChangeListener(l);
	}
}

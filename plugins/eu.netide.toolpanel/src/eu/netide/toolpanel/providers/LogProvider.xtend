package eu.netide.toolpanel.providers

import com.fasterxml.jackson.databind.node.ObjectNode
import com.fasterxml.jackson.databind.ObjectMapper

class LogProvider {
	
	private ObjectNode log
	
	private static LogProvider logProvider
	
	new() {
		var mapper = new ObjectMapper()
		log = mapper.nodeFactory.objectNode
	}
	
	public static def getInstance() {
		if (logProvider == null)
			logProvider = new LogProvider
		return logProvider
	}
	
	public def ObjectNode getLog() {
		return log
	}
	
}
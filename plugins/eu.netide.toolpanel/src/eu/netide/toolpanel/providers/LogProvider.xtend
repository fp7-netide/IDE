package eu.netide.toolpanel.providers

import com.fasterxml.jackson.databind.node.ObjectNode
import com.fasterxml.jackson.databind.ObjectMapper

class LogProvider {
	
	private ObjectNode log
	private ObjectNode replayLog
	
	private static LogProvider logProvider
	
	
	new() {
		var mapper = new ObjectMapper()
		log = mapper.nodeFactory.objectNode
		replayLog = mapper.nodeFactory.objectNode
	}
	
	public static def getInstance() {
		if (logProvider == null)
			logProvider = new LogProvider
		return logProvider
	}
	
	public def ObjectNode getLog() {
		if (replayLog != null)
			return replayLog
		return log
	}
	
	public def deactivateReplayLog () {
		replayLog = null
	}
	
	def setRecordLog(ObjectNode replayLog) {
		 this.replayLog = replayLog
	}
	
	
	
}
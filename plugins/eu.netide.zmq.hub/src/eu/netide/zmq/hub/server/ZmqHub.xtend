package eu.netide.zmq.hub.server

import org.zeromq.ZMQ
import eu.netide.zmq.hub.client.IZmqHubListener
import java.util.List

class ZmqHub implements Runnable, IZmqHub {
	
	List<IZmqHubListener> listeners = newArrayList
	
	override void run() {
		var ctx = ZMQ.context(1)
		var sub = ctx.socket(ZMQ.SUB)
		sub.subscribe("".bytes)
		
		while(!Thread.interrupted) {
			val received = sub.recv
			listeners.forEach[update(received)]
		}
	}
	
	override register(IZmqHubListener listener) {
		listeners.add(listener)
	}
	
	override remove(IZmqHubListener listener) {
		listeners.remove(listener)
	}
	
}

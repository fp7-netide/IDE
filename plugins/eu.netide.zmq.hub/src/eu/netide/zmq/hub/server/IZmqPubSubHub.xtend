package eu.netide.zmq.hub.server

import eu.netide.zmq.hub.client.IZmqNetIpListener
import eu.netide.zmq.hub.client.IZmqRawListener

interface IZmqPubSubHub extends IZmqHub {
		
	public def void register(IZmqNetIpListener listener)
	public def void remove(IZmqNetIpListener listener)
	
	public def void setRunning(Boolean running)
	public def Boolean getRunning()
	
	public def void register(IZmqRawListener listener)
	public def void remove(IZmqRawListener listener)
}

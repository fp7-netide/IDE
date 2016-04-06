package eu.netide.zmq.hub.server

import eu.netide.zmq.hub.client.IZmqHubListener

interface IZmqHub extends Runnable{
		
	public def void register(IZmqHubListener listener)
	public def void remove(IZmqHubListener listener)
	

}

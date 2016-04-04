package eu.netide.zmq.hub.server

import eu.netide.zmq.hub.client.IZmqHubListener

interface IZmqHub {
	
	public static IZmqHub INSTANCE = new ZmqHub
	
	public def void register(IZmqHubListener listener)
	public def void remove(IZmqHubListener listener)

}

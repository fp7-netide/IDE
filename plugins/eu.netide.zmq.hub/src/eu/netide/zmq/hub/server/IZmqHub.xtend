package eu.netide.zmq.hub.server

import eu.netide.zmq.hub.client.IZmqHubListener

interface IZmqHub extends Runnable{
		
	public def void register(IZmqHubListener listener)
	public def void remove(IZmqHubListener listener)
	
	public def void setRunning(Boolean running)
	public def Boolean getRunning()
	
	public def void setAddress(String address)
	public def String getAddress()
	
	public def void setName(String name)
	public def String getName()
}

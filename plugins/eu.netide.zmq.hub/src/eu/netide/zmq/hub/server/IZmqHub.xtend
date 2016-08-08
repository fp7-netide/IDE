package eu.netide.zmq.hub.server

import eu.netide.zmq.hub.client.IZmqNetIpListener
import eu.netide.zmq.hub.client.IZmqRawListener

interface IZmqHub extends Runnable{
		
	public def void register(IZmqRawListener listener)
	public def void remove(IZmqRawListener listener)
	
	public def void register(IZmqNetIpListener listener)
	public def void remove(IZmqNetIpListener listener)
	
	public def void setRunning(Boolean running)
	public def Boolean getRunning()
	
	public def void setAddress(String address)
	public def String getAddress()
	
	public def void setName(String name)
	public def String getName()
}

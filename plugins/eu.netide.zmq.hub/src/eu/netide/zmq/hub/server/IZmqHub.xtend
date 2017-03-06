package eu.netide.zmq.hub.server

import eu.netide.zmq.hub.client.IZmqRawListener

interface IZmqHub {
		
	
	public def void setAddress(String address)
	public def String getAddress()
	
	public def void setName(String name)
	public def String getName()
}

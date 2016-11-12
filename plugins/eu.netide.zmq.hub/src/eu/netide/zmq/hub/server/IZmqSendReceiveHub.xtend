package eu.netide.zmq.hub.server


interface IZmqSendReceiveHub extends IZmqHub{
		
	public def void send(String msg, (String) => void success)
	
	
}

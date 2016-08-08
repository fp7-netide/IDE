package eu.netide.zmq.hub.client

@Deprecated
interface IZmqHubListener {
	
	/**
	 * Can be called by a ZMQ hub to send a ZMQ byte array to a listener
	 * 
	 * @param message 
	 * The byte array of the received message 
	 */
	def void update(byte[] message)
	
}
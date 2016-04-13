package eu.netide.zmq.hub.client

interface IZmqHubListener {
	
	def void update(byte[] message)
	public def void setChannels(String... channel)
	
}
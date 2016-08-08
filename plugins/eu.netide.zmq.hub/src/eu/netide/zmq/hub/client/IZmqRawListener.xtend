package eu.netide.zmq.hub.client

interface IZmqRawListener {
	def void update(byte[] msg)
}
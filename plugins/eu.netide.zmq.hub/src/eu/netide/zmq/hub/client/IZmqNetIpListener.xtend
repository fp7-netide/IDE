package eu.netide.zmq.hub.client

import eu.netide.zmq.hub.client.IZmqHubListener
import eu.netide.lib.netip.Message

interface IZmqNetIpListener extends IZmqHubListener {
	def void update(Message msg)
}
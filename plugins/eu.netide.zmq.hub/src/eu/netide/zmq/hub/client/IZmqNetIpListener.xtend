package eu.netide.zmq.hub.client

import eu.netide.lib.netip.Message

interface IZmqNetIpListener {
	def void update(Message msg)
}
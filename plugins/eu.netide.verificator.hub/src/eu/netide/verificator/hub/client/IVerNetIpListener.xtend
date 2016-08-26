package eu.netide.verificator.hub.client

import eu.netide.verificator.hub.client.IVerHubListener
import eu.netide.lib.netip.Message

interface IVerNetIpListener extends IVerHubListener {
	def void update(Message msg)
}
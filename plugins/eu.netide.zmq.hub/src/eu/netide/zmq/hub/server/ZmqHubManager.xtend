package eu.netide.zmq.hub.server

import org.eclipse.core.databinding.observable.list.WritableList

class ZmqHubManager {

	public static val instance = new ZmqHubManager

	var WritableList pubSubReg
	var WritableList sendReceiveReg


	new() {
		pubSubReg = WritableList.withElementType(typeof(ZmqPubSubHub))
		sendReceiveReg = WritableList.withElementType(typeof(ZmqSendReceiveHub))
	}

	public def getPubSubHub(String address) {
		return getPubSubHub("", address)
	}

	public def ZmqPubSubHub getPubSubHub(String name, String address) {
		var hub = pubSubReg.findFirst[h|(h as ZmqPubSubHub).address.equals(address) && (h as ZmqPubSubHub).name.equals(name)] as ZmqPubSubHub
		if (hub == null) {
			hub = new ZmqPubSubHub(name, address)
			pubSubReg.add(hub)
			return hub
		}
		return hub
	}
	
	public def ZmqSendReceiveHub getSendReceiveHub(String address) {
		return getSendReceiveHub("", address)
	}
	
	public def ZmqSendReceiveHub getSendReceiveHub(String name, String address) {
		var hub = sendReceiveReg.findFirst[h|(h as ZmqSendReceiveHub).address.equals(address) && (h as ZmqSendReceiveHub).name.equals(name)] as ZmqSendReceiveHub
		if (hub == null) {
			hub = new ZmqSendReceiveHub(name, address)
			sendReceiveReg.add(hub)
			return hub
		}
		return hub
	}

	public def getPubSubHubs() {
		return pubSubReg
	}
	
	public def getSendReceiveHubs() {
		return sendReceiveReg
	}	

	public def removePubSubHub(ZmqPubSubHub hub) {
		pubSubReg.remove(hub)
	}

	public def removeSendReceiveHub(ZmqSendReceiveHub hub) {
		sendReceiveReg.remove(hub)
	}

}

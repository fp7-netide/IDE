package eu.netide.zmq.hub.server

import org.eclipse.core.databinding.observable.list.WritableList

class ZmqHubManager {

	public static val instance = new ZmqHubManager

	var WritableList reg
	
	new() {
		reg = WritableList.withElementType(typeof(ZmqHub))
	}
	
	public def getHub(String address) {
		getHub("", address)
	}
	
	public def ZmqHub getHub(String name, String address) {
		if (reg.exists[h|(h as ZmqHub).address.equals(address) && (h as ZmqHub).name.equals(address)]) {
			return reg.findFirst[h|(h as ZmqHub).address.equals(address) && (h as ZmqHub).name.equals(address)] as ZmqHub
		} else {
			var hub = new ZmqHub(name, address)
			reg.add(hub)
			return hub
		}
	}

	public def getHubs() {
		return reg
	}

	public def removeHub(ZmqHub hub) {
		reg.remove(hub)
	}

}

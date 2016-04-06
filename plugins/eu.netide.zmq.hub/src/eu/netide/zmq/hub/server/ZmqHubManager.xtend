package eu.netide.zmq.hub.server

import org.eclipse.core.databinding.observable.list.WritableList

class ZmqHubManager {

	public static val instance = new ZmqHubManager

	var WritableList reg
	
	new() {
		reg = WritableList.withElementType(typeof(ZmqHub))
	}
	
	public def getHub(String address) {
		if (reg.exists[h|(h as ZmqHub).address.equals(address)]) {
			return reg.findFirst[h|(h as ZmqHub).address.equals(address)]
		} else {
			var hub = new ZmqHub(address)
			reg.add(hub)
			// changes.firePropertyChange("hubs", reg.values.toList, reg.values.toList)
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

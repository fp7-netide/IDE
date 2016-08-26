package eu.netide.verificator.hub.server

import org.eclipse.core.databinding.observable.list.WritableList

class VerHubManager {

	public static val instance = new VerHubManager

	var WritableList reg
	
	
	
	new() {
		reg = WritableList.withElementType(typeof(VerHub))
	}
	
	public def getHub(String address) {
		getHub("", address )
	}
	
	public def VerHub getHub(String name, String address) {
		if (reg.exists[h|(h as VerHub).address.equals(address) && (h as VerHub).name.equals(address)]) {
			return reg.findFirst[h|(h as VerHub).address.equals(address) && (h as VerHub).name.equals(address)] as VerHub
		} else {
			var hub = new VerHub(name, address)
			reg.add(hub)
			return hub
		}
	}

	public def getHubs() {
		return reg
	}

	public def removeHub(VerHub hub) {
		reg.remove(hub)
	}

}

package eu.netide.zmq.hub.server

import java.beans.PropertyChangeSupport
import java.beans.PropertyChangeListener

class LogMsg {
	private String msg
	private PropertyChangeSupport changes

	new() {
		this("")
	}

	new(String msg) {
		this.msg = msg
		changes = new PropertyChangeSupport(this)
	}

	public def getMsg() { msg }

	public def void addPropertyChangeListener(PropertyChangeListener l) {
		changes.addPropertyChangeListener(l);
	}

	public def void addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
		changes.addPropertyChangeListener(propertyName, listener);
	}

	public def void removePropertyChangeListener(PropertyChangeListener l) {
		changes.removePropertyChangeListener(l);
	}
}

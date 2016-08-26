package eu.netide.verificator.hub.server

import java.beans.PropertyChangeSupport
import java.beans.PropertyChangeListener

class LogMsg {
	private String msg
	private String date
	private PropertyChangeSupport changes

	new() {
		this("", "")
	}

	new(String date, String msg) {
		this.date = date
		this.msg = msg
		changes = new PropertyChangeSupport(this)
	}

	public def getMsg() { msg }
	public def getDate() { date }

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

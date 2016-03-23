package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.UUID;

import eu.netide.workbenchconfigurationeditor.util.Constants;

public class ShimModel {
	private String id;
	private String shim;

	private PropertyChangeSupport changes;

	public ShimModel() {
		changes = new PropertyChangeSupport(this);
		id = "" + UUID.randomUUID();
	}

	public String getID() {
		return this.id;
	}

	public void setID(String id) {
		this.id = id;
	}

	public void setShim(String shim) {
		changes.firePropertyChange(Constants.COMPOSITION_MODEL_PATH, this.shim, this.shim = shim);
	}

	public String getShim() {
		return this.shim;
	}
	
	public void addPropertyChangeListener(PropertyChangeListener l) {
		changes.addPropertyChangeListener(l);
	}

	public void addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
		changes.addPropertyChangeListener(propertyName, listener);
	}

	public void removePropertyChangeListener(PropertyChangeListener l) {
		changes.removePropertyChangeListener(l);
	}
}

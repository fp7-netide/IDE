package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.UUID;

import eu.netide.workbenchconfigurationeditor.util.Constants;

public class TopologyModel {
	private String id;
	private String topologyPath;

	private PropertyChangeSupport changes;

	public TopologyModel() {
		changes = new PropertyChangeSupport(this);
		id = "" + UUID.randomUUID();
	}

	public String getID() {
		return this.id;
	}

	public void setID(String id) {
		this.id = id;
	}

	public void setTopologyPath(String path) {
		changes.firePropertyChange(Constants.TOPOLOGY_MODEL_PATH, this.topologyPath, this.topologyPath = path);
	}

	public String getTopologyPath() {
		return this.topologyPath;
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

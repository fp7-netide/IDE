package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeSupport;
import java.util.UUID;

import eu.netide.workbenchconfigurationeditor.util.Constants;

public class CompositionModel {
	private String id;
	private String compositionPath;

	private PropertyChangeSupport changes;

	public CompositionModel() {
		changes = new PropertyChangeSupport(this);
		id = "" + UUID.randomUUID();
	}

	public String getID() {
		return this.id;
	}

	public void setID(String id) {
		this.id = id;
	}

	public void setCompositionPath(String path) {
		changes.firePropertyChange(Constants.COMPOSITION_MODEL_PATH, this.compositionPath, this.compositionPath = path);
	}

	public String getCompositionPath() {
		return this.compositionPath;
	}
}

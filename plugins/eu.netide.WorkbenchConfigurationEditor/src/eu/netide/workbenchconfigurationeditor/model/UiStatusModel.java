package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

public class UiStatusModel {
	private Boolean vagrantRunning;
	private Boolean mininetRunning;
	private Boolean sshRunning;
	private Boolean serverControllerRunning;

	private int sshComboSelectionIndex;

	private PropertyChangeSupport changes;

	public UiStatusModel() {
		this.changes = new PropertyChangeSupport(this);
	}

	public Boolean getVagrantRunning() {
		return vagrantRunning;
	}

	public int getSshComboSelectionIndex() {
		return this.sshComboSelectionIndex;
	}

	public void setSshComboSelectionIndex(int sshComboSelectionIndex) {
		changes.firePropertyChange(Constants.SSH_COMBO_SELECTION_INDEX, this.sshComboSelectionIndex,
				this.sshComboSelectionIndex = sshComboSelectionIndex);
	}

	public void setVagrantRunning(Boolean vagrantRunning) {
		changes.firePropertyChange(Constants.VAGRANT_RUNNING_MODEL, this.vagrantRunning,
				this.vagrantRunning = vagrantRunning);
	}

	public Boolean getMininetRunning() {
		return mininetRunning;
	}

	public void setMininetRunning(Boolean mininetRunning) {
		changes.firePropertyChange(Constants.MININET_RUNNING_MODEL, this.mininetRunning,
				this.mininetRunning = mininetRunning);
	}

	public Boolean getSshRunning() {
		return sshRunning;
	}

	public void setSshRunning(Boolean sshRunning) {
		changes.firePropertyChange(Constants.SSH_RUNNING_MODEL, this.sshRunning, this.sshRunning = sshRunning);
	}

	public Boolean getServerControllerRunning() {
		return serverControllerRunning;
	}

	public void setServerControllerRunning(Boolean serverControllerRunning) {
		changes.firePropertyChange(Constants.SERVER_CONTROLLER_RUNNING_MODEL, this.serverControllerRunning,
				this.serverControllerRunning = serverControllerRunning);
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

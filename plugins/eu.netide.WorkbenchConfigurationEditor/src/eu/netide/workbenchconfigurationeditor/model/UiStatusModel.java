package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.ArrayList;

import org.eclipse.core.databinding.observable.list.WritableList;

import eu.netide.workbenchconfigurationeditor.util.Constants;

public class UiStatusModel {
	private Boolean vagrantRunning;
	private Boolean mininetRunning;
	private Boolean debuggerRunning;
	private Boolean sshRunning;
	private Boolean serverControllerRunning;
	private Boolean coreRunning;

	private int sshComboSelectionIndex;
	private int launchTableIndex;
	private int compositionSelectionIndex;

	private String serverControllerSelection;
	private CompositionModel compositionModel;
	private TopologyModel topologyModel;

	private WritableList profileWritableList;
	private WritableList modelWritableList;
	private WritableList compositionWritableList;

	// list corresponding to doc
	private ArrayList<LaunchConfigurationModel> modelList;
	// list corresponding to doc
	private ArrayList<SshProfileModel> profileList;

	// private ArrayList<CompositionModel> compositionList;

	private PropertyChangeSupport changes;

	public UiStatusModel() {
		this.changes = new PropertyChangeSupport(this);
	}

	// public CompositionModel getCompositionAtSelectedIndex() {
	// return this.compositionList.get(this.compositionSelectionIndex);
	// }
	//
	// public void addCompositionToList(CompositionModel m) {
	// compositionWritableList.add(m);
	// }

	public void setCompositionSelectionIndex(int index) {
		changes.firePropertyChange(Constants.COMPOSITION_SELECTION_INDEX, this.compositionSelectionIndex,
				this.compositionSelectionIndex = index);
	}

	public int getCompositionSelectionIndex() {
		return this.compositionSelectionIndex;
	}

	public void setCoreRunning(boolean running) {
		changes.firePropertyChange(Constants.CORE_RUNNING_MODEL, this.coreRunning, this.coreRunning = running);
	}

	public boolean getCoreRunning() {
		return this.coreRunning;
	}

	public void setWritableCompositionList(WritableList input) {
		this.compositionWritableList = input;
	}

	public WritableList getWritableCompositionList() {
		return this.compositionWritableList;
	}

	// public void setCompositionList(ArrayList<CompositionModel> compoList) {
	// this.compositionList = compoList;
	// }
	//
	// public ArrayList<CompositionModel> getCompositionList() {
	// return this.compositionList;
	// }

	public void setWritableModelList(WritableList input) {
		this.modelWritableList = input;
	}

	public WritableList getWritableModelList() {
		return this.modelWritableList;
	}

	public void setWritableProfileList(WritableList input) {
		this.profileWritableList = input;
	}

	public WritableList getWritableProfileList() {
		return this.profileWritableList;
	}

	public int getLaunchTableIndex() {
		return this.launchTableIndex;
	}

	public void setServerControllerSelection(String serverControllerSelection) {
		changes.firePropertyChange(Constants.SERVER_CONTROLLER_SELECTION, this.serverControllerSelection,
				this.serverControllerSelection = serverControllerSelection);
	}

	public String getServerControllerSelection() {
		return this.serverControllerSelection;
	}

	public void setLaunchTableIndex(int launchTableIndex) {
		changes.firePropertyChange(Constants.LAUNCH_TABLE_INDEX, this.launchTableIndex,
				this.launchTableIndex = launchTableIndex);
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

	public Boolean getDebuggerRunning() {
		return debuggerRunning;
	}

	public void setDebuggerRunning(Boolean debuggerRunning) {
		changes.firePropertyChange(Constants.DEBUGGER_RUNNING_MODEL, this.debuggerRunning,
				this.debuggerRunning = debuggerRunning);
	}

	public void setCompositionModel(CompositionModel model) {
		changes.firePropertyChange(Constants.COMPOSITION_MODEL_PATH, this.compositionModel,
				this.compositionModel = model);
	}

	public void setTopologyModel(TopologyModel model) {
		changes.firePropertyChange(Constants.TOPOLOGY_MODEL, this.topologyModel, this.topologyModel = model);
	}

	public TopologyModel getTopologyModel() {
		return this.topologyModel;
	}

	public void addEntryToModelList(LaunchConfigurationModel model) {
		if (this.modelWritableList != null) {
			this.modelWritableList.add(model);
		} else {
			this.modelList.add(model);
		}
	}

	public void addEntryToSSHList(SshProfileModel model) {
		if (this.profileWritableList != null) {
			this.profileWritableList.add(model);
		} else {
			this.profileList.add(model);
		}

	}

	public void removeEntryFromModelList(LaunchConfigurationModel model) {

		if (this.modelWritableList != null) {
			this.modelWritableList.remove(model);
		} else {
			this.modelList.remove(model);
		}
	}

	public void removeEntryFromSSHList(SshProfileModel model) {

		if (this.profileWritableList != null) {
			this.profileWritableList.remove(model);
		} else {
			this.profileList.remove(model);
		}
	}

	public void removeEntryFromSSHList() {

		if (this.profileWritableList != null) {
			this.profileWritableList.remove(sshComboSelectionIndex);
		} else {
			this.profileList.remove(sshComboSelectionIndex);
		}
	}

	public void removeEntryFromModelList() {

		if (this.modelWritableList != null) {
			this.modelWritableList.remove(launchTableIndex);
		} else {
			this.modelList.remove(launchTableIndex);
		}
	}

	public void setModelList(ArrayList<LaunchConfigurationModel> modelList) {
		this.modelList = modelList;
	}

	public void setProfileList(ArrayList<SshProfileModel> profileList) {
		this.profileList = profileList;
	}

	public ArrayList<LaunchConfigurationModel> getModelList() {
		return this.modelList;
	}

	public ArrayList<SshProfileModel> getProfileList() {
		return this.profileList;
	}

	public LaunchConfigurationModel getModelAtIndex(int index) {
		return this.modelList.get(index);
	}

	public LaunchConfigurationModel getModelAtIndex() {
		return this.modelList.get(this.launchTableIndex);
	}

	public SshProfileModel getSshModelAtIndex(int index) {
		return this.profileList.get(index);
	}

	public SshProfileModel getSshModelAtIndex() {
		return this.profileList.get(this.sshComboSelectionIndex);
	}

	public CompositionModel getCompositionModel() {
		return compositionModel;
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

package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.ArrayList;

import eu.netide.workbenchconfigurationeditor.util.Constants;

public class UiStatusModel {
	private Boolean vagrantRunning;
	private Boolean mininetRunning;
	private Boolean sshRunning;
	private Boolean serverControllerRunning;

	private int sshComboSelectionIndex;
	private int launchTableIndex;

	private String serverControllerSelection;

	// list corresponding to doc
	private ArrayList<LaunchConfigurationModel> modelList;
	// list corresponding to doc
	private ArrayList<SshProfileModel> profileList;

	private PropertyChangeSupport changes;

	public UiStatusModel() {
		this.changes = new PropertyChangeSupport(this);

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

	public void addEntryToModelList(LaunchConfigurationModel model) {
		this.modelList.add(model);
	}

	public void addEntryToSSHList(SshProfileModel model) {
		this.profileList.add(model);
	}

	public void removeEntryFromModelList(LaunchConfigurationModel model) {
		this.modelList.remove(model);
	}

	public void removeEntryFromSSHList(SshProfileModel model) {
		this.profileList.remove(model);
	}
	
	public void removeEntryFromSSHList(){
		this.profileList.remove(sshComboSelectionIndex);
	}
	
	public void removeEntryFromModelList(){
		this.modelList.remove(launchTableIndex);
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

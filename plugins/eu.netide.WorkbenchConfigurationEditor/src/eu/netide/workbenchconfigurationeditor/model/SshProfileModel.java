package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.UUID;

import eu.netide.workbenchconfigurationeditor.util.Constants;

public class SshProfileModel {

	private String host;
	private String port;
	private String sshIdFile;
	private String username;
	private String profileName;
	private String id;

	private PropertyChangeSupport changes;

	public SshProfileModel() {
		changes = new PropertyChangeSupport(this);
		this.id = "" + UUID.randomUUID();
	}

	public String getID() {
		return this.id;
	}

	public void setHost(String host) {
		this.changes.firePropertyChange(Constants.HOST_MODEL, this.host, this.host = host);
	}

	public void setPort(String port) {
		this.changes.firePropertyChange(Constants.SSH_PORT_MODEL, this.port, this.port = port);
	}

	public void setSshIdFile(String sshIdFile) {
		this.changes.firePropertyChange(Constants.SSH_ID_FILE_MODEL, this.sshIdFile, this.sshIdFile = sshIdFile);
	}

	public void setUsername(String username) {
		this.changes.firePropertyChange(Constants.USERNAME_MODEL, this.username, this.username = username);
	}

	public void setProfileName(String profileName) {
		this.changes.firePropertyChange(Constants.PROFILE_NAME_MODEL, this.profileName, this.profileName = profileName);
	}

	public String getHost() {
		return this.host;
	}

	public String getPort() {
		return this.port;
	}

	public String getSshIdFile() {
		return this.sshIdFile;
	}

	public String getUsername() {
		return this.username;
	}

	public String getProfileName() {
		return this.profileName;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SshProfileModel other = (SshProfileModel) obj;
		if (id != other.id)
			return false;
		return true;
	}

	@Override
	public String toString() {
		// TODO: parse to xml format here
		return "Configuration [id=" + id + ", for App =" + "" + "]";
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

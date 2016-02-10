package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeSupport;
import java.util.UUID;

public class SshProfileModel {
	
	private String host;
	private String port;
	private String sshIdFile;
	private String username;
	private String profileName;
	private String id;
	
	private PropertyChangeSupport changes;
	
	public SshProfileModel(){
		changes = new PropertyChangeSupport(this);
		host = "";
		port = "";
		sshIdFile = "";
		username = "";
		profileName = "";
		this.id = "" +UUID.randomUUID();
	}
	
	public String getID(){
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
		return host;
	}

	public String getPort() {
		return port;
	}

	public String getSshIdFile() {
		return sshIdFile;
	}

	public String getUsername() {
		return username;
	}

	public String getProfileName(){
		return profileName;
	}
	
	@Override
	public String toString() {
		//TODO: parse to xml format here
		return "Configuration [id=" + id + ", for App =" + "" + "]";
	}
	
}

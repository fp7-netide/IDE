package eu.netide.workbenchconfigurationeditor.model;

import java.util.UUID;

public class SshProfileModel {
	
	private String host;
	private String port;
	private String sshIdFile;
	private String username;
	private String profileName;
	private String id;
	
	public SshProfileModel(String host, String port, String sshIdFile, String username, String profileName){
		this.host = host;
		this.port = port;
		this.profileName = profileName;
		this.sshIdFile = sshIdFile;
		this.username = username;
		this.id = "" + UUID.randomUUID();
	}
	
	public SshProfileModel(){
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
		this.host = host;
	}

	public void setPort(String port) {
		this.port = port;
	}

	public void setSshIdFile(String sshIdFile) {
		this.sshIdFile = sshIdFile;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setProfileName(String profileName) {
		this.profileName = profileName;
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
	
}

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
	private String secondPort;
	private String secondHost;
	private String secondUsername;
	
	private String vagrantBox;
	private String odl;
	private String engine;
	private String core;
	private String topology;
	private String tools;
	private String appFolder;
	private String composite;

	private String id;

	private PropertyChangeSupport changes;

	public SshProfileModel() {
		changes = new PropertyChangeSupport(this);
		this.id = "" + UUID.randomUUID();
	}
	
	public boolean getIsDoubleTunnel(){
		return (!getSecondHost().equals("") && !getSecondPort().equals("") && !getSecondUsername().equals(""));
	}

	public String getID() {
		return this.id;
	}
	
	public void setSecondUsername(String username){
		this.changes.firePropertyChange(Constants.SECOND_USERNAME, this.secondUsername, this.secondUsername = username);
	}
	
	public String getSecondUsername(){
		return this.secondUsername;
	}

	public void setSecondHost(String host){
		this.changes.firePropertyChange(Constants.SECOND_HOST, this.secondHost, this.secondHost = host);
	}
	
	public String getSecondHost(){
		return this.secondHost;
	}
	public void setSecondPort(String port){
		this.changes.firePropertyChange(Constants.SECOND_PORT, this.secondPort, this.secondPort = port);
	}
	
	public String getSecondPort(){
		return this.secondPort;
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
	
	public String getVagrantBox() {
		return vagrantBox;
	}

	public void setVagrantBox(String vagrantBox) {
		this.changes.firePropertyChange(Constants.VAGRANT_BOX, this.vagrantBox, this.vagrantBox = vagrantBox);
	}

	public String getOdl() {
		return odl;
	}

	public void setOdl(String odl) {
		this.changes.firePropertyChange(Constants.ODL_SHIM, this.odl, this.odl = odl);
	}

	public String getEngine() {
		return engine;
	}

	public void setEngine(String engine) {
		this.changes.firePropertyChange(Constants.ENGINE, this.engine, this.engine = engine);
	}

	public String getCore() {
		return core;
	}

	public void setCore(String core) {
		this.changes.firePropertyChange(Constants.CORE, this.core, this.core = core);
	}

	public String getTopology() {
		return topology;
	}

	public void setTopology(String topology) {
		this.changes.firePropertyChange(Constants.TOPOLOGY, this.topology, this.topology = topology);
	}

	public String getTools() {
		return tools;
	}

	public void setTools(String tools) {
		this.changes.firePropertyChange(Constants.TOOLS, this.tools, this.tools = tools);
	}

	public String getAppFolder() {
		return appFolder;
	}

	public void setAppFolder(String appFolder) {
		this.changes.firePropertyChange(Constants.APP_FOLDER, this.appFolder, this.appFolder = appFolder);
	}

	public String getComposite() {
		return composite;
	}

	public void setComposite(String composite) {
		this.changes.firePropertyChange(Constants.COMPOSITE_FILE, this.composite, this.composite = composite);
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

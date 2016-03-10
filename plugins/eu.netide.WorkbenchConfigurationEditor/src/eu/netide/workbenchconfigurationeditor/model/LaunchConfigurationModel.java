package eu.netide.workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

import eu.netide.workbenchconfigurationeditor.util.Constants;

public class LaunchConfigurationModel {

	private PropertyChangeSupport changes;

	private String appPath;
	private String platform;
	private String id;
	private String clientController;

	private String appName;
	private String appPort;
	private boolean running;

	public LaunchConfigurationModel() {
		changes = new PropertyChangeSupport(this);
	}

	public void setRunning(boolean newRunning) {
		changes.firePropertyChange(Constants.APP_RUNNING_MODEL, running, this.running = newRunning);
	}

	public boolean getRunning() {
		return this.running;
	}

	public String getPlatform() {
		return this.platform;
	}

	public void setPlatform(String platform) {
		changes.firePropertyChange(Constants.PLATFORM_MODEL, this.platform, this.platform = platform);
	}

	public String getAppPort() {
		return this.appPort;
	}

	public void setAppPort(String appPort) {
		changes.firePropertyChange(Constants.PORT_MODEL, this.appPort, this.appPort = appPort);
	}

	public String getAppName() {
		return appName;
	}

	public void setAppName(String name) {
		changes.firePropertyChange(Constants.APP_NAME_MODEL, this.appName, this.appName = name);
	}

	public void setID(String id) {
		changes.firePropertyChange(Constants.ID_MODEL, this.id, this.id = id);
	}

	public String getID() {
		return this.id;
	}

	public String getAppPath() {
		return appPath;
	}

	public void setAppPath(String appPath) {
		changes.firePropertyChange(Constants.APP_PATH_MODEL, this.appPath, this.appPath = appPath);
	}

	public String getClientController() {
		if (clientController == null)
			clientController = "";
		return clientController;
	}

	public void setClientController(String clientController) {
		changes.firePropertyChange(Constants.CLIENT_CONTROLLER_MODEL, this.clientController,
				this.clientController = clientController);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		LaunchConfigurationModel other = (LaunchConfigurationModel) obj;
		if (id != other.id)
			return false;
		return true;
	}

	@Override
	public String toString() {
		// TODO: parse to xml format here
		return "Configuration [id=" + id + ", for App =" + appPath + "]";
	}

	public LaunchConfigurationModel copy() {
		// TODO: add all setter
		return new LaunchConfigurationModel();
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

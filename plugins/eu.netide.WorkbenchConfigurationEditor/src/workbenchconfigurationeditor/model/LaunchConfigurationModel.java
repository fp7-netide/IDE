package workbenchconfigurationeditor.model;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

public class LaunchConfigurationModel {

	private PropertyChangeSupport changes = new PropertyChangeSupport(this);
	public static final String APP_PATH = "appPath";
	public static final String CLIENT_CONTROLLER = "clientController";
	public static final String SERVER_CONTROLLER = "serverController";
	public static final String TOPOLOGY = "topology";
	public static final String ID = "id";
	public static final String PLATFORM = "platform";

	private String appPath;
	private String platform;
	private String id;
	private String clientController;
	private String serverController;
	private static String topology;
	private String appName;

	public LaunchConfigurationModel(String id, String appPath, String clientController, String serverController,
			String topology) {
		this.appPath = appPath;
		this.id = id;
		this.clientController = clientController;
		this.serverController = serverController;
		LaunchConfigurationModel.topology = topology;
	}

	public String getPlatform() {
		return this.platform;
	}

	public void setPlatform(String platform) {
		this.platform = platform;
	}

	public LaunchConfigurationModel() {

	}

	public String getAppName() {
		return appName;
	}

	public void setAppName(String name) {
		this.appName = name;
	}

	public void setID(String id) {
		this.id = id;
	}

	public String getID() {
		return this.id;
	}

	public String getAppPath() {
		return appPath;
	}

	public void setAppPath(String appPath) {
		changes.firePropertyChange(APP_PATH, this.appPath, this.appPath = appPath);
	}

	public String getClientController() {
		if(clientController == null)
			clientController = "";
		return clientController;
	}

	public void setClientController(String clientController) {
		changes.firePropertyChange(CLIENT_CONTROLLER, this.clientController, this.clientController = clientController);
	}

	public String getServerController() {
		if(serverController == null)
			serverController = "";
		return serverController;
	}

	public void setServerController(String serverController) {
		changes.firePropertyChange(SERVER_CONTROLLER, this.serverController, this.serverController = serverController);
	}

	public static String getTopology() {
		return topology;
	}

	public static void setTopology(String topology) {
		LaunchConfigurationModel.topology = topology;
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
		return "Configuration [id=" + id + ", for App =" + appPath + "]";
	}

	public LaunchConfigurationModel copy() {
		return new LaunchConfigurationModel(id, appPath, clientController, serverController, topology);
	}

	public void addPropertyChangeListener(PropertyChangeListener l) {
		changes.addPropertyChangeListener(l);
	}

	public void removePropertyChangeListener(PropertyChangeListener l) {
		changes.removePropertyChangeListener(l);
	}

}

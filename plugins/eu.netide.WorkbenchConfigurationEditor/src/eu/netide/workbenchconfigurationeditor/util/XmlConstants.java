package eu.netide.workbenchconfigurationeditor.util;

public class XmlConstants {
	public static final String NODE_SSH = "ssh";
	public static final String SSH_HOST = "host";
	public static final String SSH_USERNAME = "username";
	public static final String SSH_PORT = "port";
	public static final String SSH_ID_FILE = "idFile";
	public static final String SSH_PROFILE_NAME = "name";
	public static final String ATTRIBUTE_SSH_ID = "id";
	public static final String SSH_SECOND_USERNAME = "secondUsername";
	public static final String SSH_SECOND_HOST = "secondHost";
	public static final String SSH_SECOND_PORT = "secondPort";
	
	public static final String NODE_APP = "app";
	public static final String ATTRIBUTE_APP_NAME = "name";
	public static final String ATTRIBUTE_APP_ID = "id";
	public static final String ELEMENT_APP_PATH = "appPath";
	public static final String ELEMENT_TOPOLOGY_PATH = "topologyPath";
	public static final String ELEMENT_PLATFORM = "Platform";
	public static final String ELEMENT_CLIENT_CONTROLLER = "ClientController";
	public static final String ELEMENT_SERVER_CONTROLLER = "ServerController";
	public static final String WORKBENCH = "workbench";
	
	public static final String COMPOSITION = "compositionPath";
	public static final String COMPOSITION_PATH = "compositionPath";
	
	
	public static final String[] CONSTANT_ARRAY = new String[]{NODE_APP, ATTRIBUTE_APP_NAME, ATTRIBUTE_APP_ID, ELEMENT_APP_PATH,  ELEMENT_PLATFORM, ELEMENT_CLIENT_CONTROLLER, ELEMENT_SERVER_CONTROLLER };
	public static final String ELEMENT_APP_PORT = "appPort";
}

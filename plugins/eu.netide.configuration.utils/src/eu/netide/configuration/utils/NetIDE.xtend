package eu.netide.configuration.utils

/**
 * Some useful constants
 * 
 * @author Christian Stritzke
 */
class NetIDE {

	public static val VAGRANTFILE_PATH = "/vagrant/trusty/"

	public static val MININET_CONFIGURATION_FILES = "/mininet/"

	public static val LAUNCHER_PLUGIN = "eu.netide.configuration.launcher"

	public static val GENERATOR_PLUGIN = "eu.netide.configuration.generator"

	public static val ENGINE_PATH = "~/netide/Engine/"
	public static val CORE_KARAF = "~/netide/core-karaf/bin/"
	public static val APP_FOLDER = "~/netide/apps/"
	public static val ODL_PATH = "~/netide/odl-karaf/bin/"
	public static val TOOL_PATH = "~/netide/Tools/"
	public static val COMPOSITION_PATH = "/home/vagrant/netide/composition/"
	public static val APP_TARGET_LOCATION = "netide/apps"
	public static val MN_CONFIG_TARGET_LOCATION = "netide/mn-configs"

	public static val CONTROLLER_POX = "POX"
	public static val CONTROLLER_RYU = "Ryu"
	public static val CONTROLLER_RYU_REST = "Ryu REST"
	public static val CONTROLLER_FLOODLIGHT = "Floodlight"
	public static val CONTROLLER_ODL = "OpenDaylight"
	public static val CONTROLLER_PYRETIC = "Pyretic"
	public static val CONTROLLER_ENGINE = "Network Engine"
	public static val CONTROLLER_CORE = "Core"
	public static val CONTROLLER_ONOS = "ONOS"
	public static val CONTROLLER_SHIM = "Shim"
	public static val CONTROLLER_DEBUGGER = "Debugger"
	public static val CONTROLLER_APP_BACKEND = "Backend"
	public static val CONTROLLER_MININET = "Mininet"


	public static val CONTROLLERS = newArrayList(CONTROLLER_POX, CONTROLLER_RYU, CONTROLLER_FLOODLIGHT, CONTROLLER_ODL,
		CONTROLLER_PYRETIC, CONTROLLER_ONOS)
}

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

	public static val CONTROLLER_POX = "POX"
	public static val CONTROLLER_RYU = "Ryu"
	public static val CONTROLLER_FLOODLIGHT = "Floodlight"
	public static val CONTROLLER_ODL = "OpenDaylight"
	public static val CONTROLLER_PYRETIC = "Pyretic"
	public static val CONTROLLER_ENGINE = "Network Engine"
	public static val CONTROLLER_CORE = "Core"

	public static val CONTROLLERS = newArrayList(CONTROLLER_POX, CONTROLLER_RYU, CONTROLLER_FLOODLIGHT, CONTROLLER_ODL,
		CONTROLLER_PYRETIC, CONTROLLER_ENGINE, CONTROLLER_CORE)
}

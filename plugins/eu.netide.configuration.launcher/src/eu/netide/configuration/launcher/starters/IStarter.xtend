package eu.netide.configuration.launcher.starters

import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.launcher.starters.backends.Backend

interface IStarter {

	/**
	 * Return the commandline here
	 * 
	 * @returns A unix command line to start via SSH
	 */
	def String getCommandLine()

	/**
	 * Environment variable declarations such as "PYTHONPATH=xy" have to be declared separately
	 * 
	 * @returns A string with declared environment variables separated by a " "
	 */
	def String getEnvironmentVariables()

	/**
	 * Returns the name of the starter session
	 * 
	 * @returns The Name of the starter
	 */
	def String getName()

	/**
	 * Returns a unique and Unix-Safe name of the starter session
	 * 
	 * @returns Safe Name of the starter
	 */
	def String getSafeName()

	/**
	 * Sets the launch configuration to configure the starter
	 * 
	 * @params A launch configuration
	 */
	def void setLaunchConfiguration(ILaunchConfiguration configuration)

	/**
	 * Synchronously starts a controller, tool, etc.
	 */
	def void syncStart()

	/**
	 * Asynchronously starts a controller, tool, etc.
	 */
	def void asyncStart()

	/**
	 * Kills a started process
	 */
	def void stop()

	/**
	 * Reattaches a screen session
	 */
	def void reattach()

	/**
	 * Sets a backend
	 */
	def void setBackend(Backend backend)

}
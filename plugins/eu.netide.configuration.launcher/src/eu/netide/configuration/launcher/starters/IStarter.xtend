package eu.netide.configuration.launcher.starters

import Topology.Controller
import java.util.ArrayList
import org.eclipse.core.runtime.IPath
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunch

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
	
	def String getName()
	def void setLaunchConfiguration(ILaunchConfiguration configuration)
	def void syncStart()
	def void asyncStart()
	def void stop()
	
}
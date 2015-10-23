package eu.netide.configuration.launcher.starters

import Topology.Controller
import java.util.ArrayList
import org.eclipse.core.runtime.IPath
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunch

interface IStarter {
	def ArrayList<String> getCommandLine()
	def void setLaunchConfiguration(ILaunchConfiguration configuration)
	def void syncStart()
	def void asyncStart()
	def void stop()
	
}
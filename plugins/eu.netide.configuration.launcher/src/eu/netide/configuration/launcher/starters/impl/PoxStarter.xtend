package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PoxStarter extends ControllerStarter {

	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("POX", configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}
	
	override getEnvironmentVariables() {
		return String.format("PYTHONPATH=$PYTHONPATH:controllers/%s", getAppPath.removeFileExtension.lastSegment)
	}
	
	override getCommandLine() {
		var poxline = String.format("pox/pox.py openflow.of_01 --port=%s %s ", controller.portNo, getAppPath.removeFileExtension.lastSegment)
		return poxline
	}
	



	
}
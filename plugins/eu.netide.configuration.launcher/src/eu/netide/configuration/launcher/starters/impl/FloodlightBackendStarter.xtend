package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class FloodlightBackendStarter extends ControllerStarter {

	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Floodlight Backend", configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}
	
	new(int port, String appPath, IProgressMonitor monitor) {
		super("Floodlight Backend", port, appPath, monitor)
		name = String.format("%s (%s)", name, appPath.IFile.location.lastSegment)
	}

	override getCommandLine() {
		return String.format("bash $HOME/netide/floodlight/floodlight.sh")
	}
}
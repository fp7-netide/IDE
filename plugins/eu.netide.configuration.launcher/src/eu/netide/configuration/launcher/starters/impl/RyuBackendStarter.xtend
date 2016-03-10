package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.core.resources.ResourcesPlugin

class RyuBackendStarter extends ControllerStarter {

	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu Backend", configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}
	
	new (int port, String appPath, IProgressMonitor monitor) {
		super("Ryu Backend", port, appPath, monitor)
		name = String.format("%s (%s)", name, this.appPath.lastSegment)
	}

	override getEnvironmentVariables() {
		"PYTHONPATH=$PYTHONPATH:netide/Engine/ryu-backend:netide/Engine/libraries/netip/python"
	}
	
	override getCommandLine() {
		
		return String.format(
			"sudo ryu-manager --ofp-tcp-listen-port %s ~/netide/Engine/ryu-backend/ryu-backend.py ~/netide/apps/%s",
			port, appPath.removeFirstSegments(1))
	}

}
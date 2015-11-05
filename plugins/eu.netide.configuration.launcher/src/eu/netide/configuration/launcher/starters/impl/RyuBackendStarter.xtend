package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.ControllerStarter
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor

class RyuBackendStarter extends ControllerStarter {

	new(ILaunch launch, ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu Backend", launch, configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	override getEnvironmentVariables() {
		"PYTHONPATH=$PYTHONPATH:Engine/ryu-backend"
	}
	
	override getCommandLine() {
		return String.format(
			"sudo ryu-manager --ofp-tcp-listen-port 7733 Engine/ryu-backend/backend.py controllers/%s/%s",
			appPath.removeFileExtension.lastSegment, appPath.lastSegment)
	}

}
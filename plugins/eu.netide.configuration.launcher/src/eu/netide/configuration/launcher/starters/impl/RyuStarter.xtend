package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration

class RyuStarter extends ControllerStarter {

	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu", configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	override getCommandLine() {
		var ryuline = String.format("ryu-manager --ofp-tcp-listen-port=%d controllers/%s/%s", controller.portNo,
			getAppPath.removeFileExtension.lastSegment, getAppPath.lastSegment)

		return ryuline
	}

}
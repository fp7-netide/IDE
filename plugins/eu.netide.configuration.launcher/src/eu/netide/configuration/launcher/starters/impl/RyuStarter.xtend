package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class RyuStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu", configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	new(int port, String appPath, IProgressMonitor monitor) {
		super("Ryu", port, appPath, monitor)
		name = String.format("%s (%s)", name, this.appPath.lastSegment)
	}

	override getCommandLine() {
		var ryuline = String.format("ryu-manager --ofp-tcp-listen-port=%d ~/netide/apps/%s", port,
			getAppPath.removeFirstSegments(1))

		return ryuline
	}

}

package eu.netide.configuration.launcher.starters.impl

import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor

class RyuStarter extends ControllerStarter {

	new(ILaunch launch, ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu", launch, configuration, controller, monitor)
	}

	override getCommandLine() {
		var ryuline = String.format("ryu-manager --ofp-tcp-listen-port=%d controllers/%s/%s", controller.portNo,
			controllerpath.removeFileExtension.lastSegment, controllerpath.lastSegment)

		return ryuline.cmdLineArray
	}

}
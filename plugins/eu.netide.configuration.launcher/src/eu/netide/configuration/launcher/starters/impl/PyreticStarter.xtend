package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PyreticStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Pyretic", configuration, controller, monitor)
	}

	new(int port, String appPath, IProgressMonitor monitor) {
		super("Pyretic", port, appPath, monitor)
		name = String.format("%s (%s)", name, this.appPath.lastSegment)
	}

	override getCommandLine() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}

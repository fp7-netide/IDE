package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PyreticStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_PYRETIC, configuration, controller, monitor)
	}

	new(int port, String appPath, IProgressMonitor monitor) {
		this(port, appPath, monitor, -1)
	}

	new(int port, String appPath, IProgressMonitor monitor, int id) {
		super(NetIDE.CONTROLLER_PYRETIC, port, appPath, monitor)
		name = String.format("%s (%s)", name, this.appPath.lastSegment, id)
	}

	override getCommandLine() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}

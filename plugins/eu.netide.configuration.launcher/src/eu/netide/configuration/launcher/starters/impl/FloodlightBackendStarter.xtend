package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class FloodlightBackendStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_FLOODLIGHT + " " + NetIDE.CONTROLLER_APP_BACKEND, configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	new(int port, String appPath, IProgressMonitor monitor, int id) {
		this("", port, appPath, monitor, id)
	}

	new(String appName, int port, String appPath, IProgressMonitor monitor, int id) {
		super(NetIDE.CONTROLLER_FLOODLIGHT + " " + NetIDE.CONTROLLER_APP_BACKEND, port, appPath, monitor, id)
		name = String.format("%s %s (%s)", appName, name, appPath.IFile.location.lastSegment)
	}

	new(int port, String appPath, IProgressMonitor monitor) {
		this(port, appPath, monitor, -1)
	}

	override getCommandLine() {
		return String.format("bash $HOME/netide/floodlight/floodlight.sh")
	}
}

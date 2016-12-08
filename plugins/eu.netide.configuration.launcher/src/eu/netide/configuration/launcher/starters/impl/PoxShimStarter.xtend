package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PoxShimStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_POX + " " + NetIDE.CONTROLLER_SHIM, configuration, controller, monitor)
	}

	new(String appPath, int port, IProgressMonitor monitor, int id) {
		super(NetIDE.CONTROLLER_POX + " " + NetIDE.CONTROLLER_SHIM, port, appPath, monitor, id)
	}

	new(String appPath, int port, IProgressMonitor monitor) {
		this(appPath, port, monitor, -1)
	}

	override getEnvironmentVariables() {
		return "PYTHONPATH=$PYTHONPATH:netide/Engine/ryu-backend/tests"
	}

	override getCommandLine() {
		return String.format("netide/pox/pox.py openflow.of_01 --port=%s pox_client", port)
	}

}

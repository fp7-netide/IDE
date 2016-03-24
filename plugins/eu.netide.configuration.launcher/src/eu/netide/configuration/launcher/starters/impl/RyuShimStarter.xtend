package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class RyuShimStarter extends ControllerStarter {

	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu Shim", configuration, controller, monitor)
	}
	
	new(String appPath, int port, IProgressMonitor monitor) {
		super("Ryu Shim", port, appPath, monitor)
	}

	override getEnvironmentVariables() {
		return "PYTHONPATH=$PYTHONPATH:netide/Engine/ryu-shim"
	}

	override getCommandLine() {
		return String.format(
			"sudo ryu-manager --ofp-tcp-listen-port=%s netide/Engine/ryu-shim/ryu_shim.py", controller.portNo)
	}

}
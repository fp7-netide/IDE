package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.ControllerStarter
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor

class RyuShimStarter extends ControllerStarter {

	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu Shim", configuration, controller, monitor)
	}

	override getEnvironmentVariables() {
		return "PYTHONPATH=$PYTHONPATH:Engine/ryu-shim"
	}

	override getCommandLine() {
		return String.format(
			"sudo ryu-manager --ofp-tcp-listen-port=%s Engine/ryu-shim/ryu_shim.py", controller.portNo)
	}

}
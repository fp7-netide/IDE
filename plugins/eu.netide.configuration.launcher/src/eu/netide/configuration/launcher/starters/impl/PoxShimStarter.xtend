package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PoxShimStarter extends ControllerStarter {

	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("POX Shim", configuration, controller, monitor)
	}
	
	override getEnvironmentVariables() {
		return "PYTHONPATH=$PYTHONPATH:Engine/ryu-backend/tests"
	}

	override getCommandLine() {
		return String.format(
			"pox/pox.py openflow.of_01 --port=%s pox_client",
			controller.portNo)
	}

}
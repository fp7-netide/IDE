package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.ControllerStarter
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor

class PoxShimStarter extends ControllerStarter {

	new(ILaunch launch, ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("POX Shim", launch, configuration, controller, monitor)
	}

	override getCommandLine() {
		return String.format(
			"PYTHONPATH=$PYTHONPATH:Engine/ryu-backend/tests pox/pox.py openflow.of_01 --port=%s pox_client",
			controller.portNo)
	}

}
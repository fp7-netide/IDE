package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PyreticStarter extends ControllerStarter {
	
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Pyretic", configuration, controller, monitor)
	}
	
	override getCommandLine() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
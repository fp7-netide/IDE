package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.ControllerStarter
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor

class PyreticStarter extends ControllerStarter {
	
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Pyretic", configuration, controller, monitor)
	}
	
	override getCommandLine() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.ControllerStarter
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor

class FloodlightBackendStarter extends ControllerStarter {

	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Floodlight Backend", configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	override getCommandLine() {
		return String.format("java -jar $HOME/floodlight/target/floodlight.jar")
	}
}
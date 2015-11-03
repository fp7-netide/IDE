package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.ControllerStarter
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor

class OdlShimStarter extends ControllerStarter {
	
	new(ILaunch launch, ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("OpenDaylight Shim", launch, configuration, controller, monitor)
	}
	
	override getCommandLine() {
		var str = String.format("./openflowplugin/distribution/karaf/target/assembly/bin/karaf")
		return str.cmdLineArray	
	}
}
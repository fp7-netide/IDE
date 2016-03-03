package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class OdlShimStarter extends ControllerStarter {
	
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("OpenDaylight Shim",  configuration, controller, monitor)
	}
	
	override getCommandLine() {
		//var str = String.format("~/netide/Engine/odl-shim/karaf/target/assembly/bin/karaf")
		var str = String.format("~/netide/netide/distribution-karaf-0.4.0-Beryllium/bin/karaf")
		return str	
	}
}
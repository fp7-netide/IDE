package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class OnosShimStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("ONOS Shim",  configuration, controller, monitor)
	}
	
	new (String appPath, int port, IProgressMonitor monitor) {
		super("ONOS Shim", port, appPath, monitor)
	}
	
	override getCommandLine() {
		//var str = String.format("~/netide/Engine/odl-shim/karaf/target/assembly/bin/karaf")
		var str = String.format("~/netide/distribution-karaf-0.4.0-Beryllium/bin/karaf")
		return str	
	}
}
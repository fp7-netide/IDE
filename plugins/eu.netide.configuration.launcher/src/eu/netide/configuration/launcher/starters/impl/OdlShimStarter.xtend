package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.utils.NetIDE

class OdlShimStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("OpenDaylight Shim",  configuration, controller, monitor)
	}
	
	new (String appPath, int port, IProgressMonitor monitor) {
		this(appPath, port, monitor, null)
	}
	
	new (String appPath, int port, IProgressMonitor monitor, String odlKarafPath) {
		super("OpenDaylight Shim", port, appPath, monitor)
		if(odlKarafPath != null && odlKarafPath != ""){
			this.odlKarafPath = odlKarafPath
		}
	}
	String odlKarafPath = NetIDE.ODL_PATH
	override getCommandLine() {
		//var str = String.format("~/netide/Engine/odl-shim/karaf/target/assembly/bin/karaf")
		var str = String.format(odlKarafPath)
		return str	
	}
}
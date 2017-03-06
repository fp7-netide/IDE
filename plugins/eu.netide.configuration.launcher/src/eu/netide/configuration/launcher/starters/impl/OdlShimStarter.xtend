package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class OdlShimStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_ODL + " " + NetIDE.CONTROLLER_SHIM, configuration, controller, monitor)
	}

	new(String appPath, int port, IProgressMonitor monitor) {
		this(appPath, port, monitor, null)
	}

	new(String appPath, int port, IProgressMonitor monitor, String odlKarafPath) {
		this(appPath, port, monitor, odlKarafPath, -1)
	}

	new(String appPath, int port, IProgressMonitor monitor, String odlKarafPath, int id) {
		super(NetIDE.CONTROLLER_ODL + " " + NetIDE.CONTROLLER_SHIM, port, appPath, monitor)
		if (odlKarafPath != null && odlKarafPath != "") {
			this.odlKarafPath = super.getValidPath(odlKarafPath)
		}
	}

	String odlKarafPath = NetIDE.ODL_PATH

	override getCommandLine() {
		// var str = String.format("~/netide/Engine/odl-shim/karaf/target/assembly/bin/karaf")
		var str = String.format("bash -c \'cd %s && ./karaf\'", odlKarafPath)
		return str
	}
}

package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class RyuShimTopologyStarter extends ControllerStarter {

	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_RYU_REST + " " + NetIDE.CONTROLLER_SHIM, configuration, controller, monitor)
	}

	new(String appPath, int port, IProgressMonitor monitor) {
		this(appPath, port, monitor, null)
	}

	new(String appPath, int port, IProgressMonitor monitor, String enginePath, int id) {
		super(NetIDE.CONTROLLER_RYU + " " + NetIDE.CONTROLLER_SHIM, port, appPath, monitor, id)
		if (enginePath != null && enginePath != "") {
			this.enginePath = super.getValidPath(enginePath)
		}
	}

	new(String appPath, int port, IProgressMonitor monitor, String enginePath) {
		this(appPath, port, monitor, enginePath, -1)
	}

	override getEnvironmentVariables() {
		return String.format("PYTHONPATH=$PYTHONPATH:%sryu-shim", this.enginePath)
	}

	String enginePath = NetIDE.ENGINE_PATH;

	override getCommandLine() {
		return String.format(
			"sudo ryu-manager --observe-links --ofp-tcp-listen-port %s %s../ryu/ryu/app/rest_topology.py %sryu-shim/ryu-shim.py",
			port, this.enginePath, this.enginePath)
	}

}

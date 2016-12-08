package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.utils.NetIDE

class RyuBackendStarter extends ControllerStarter {

	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_RYU + " " + NetIDE.CONTROLLER_APP_BACKEND, configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	new(int port, String appPath, IProgressMonitor monitor) {
		this(port, appPath, monitor, null, null)
	}

	new(int port, String appPath, IProgressMonitor monitor, String enginePath, String flag, int id) {
		this("", port, appPath, monitor, enginePath, flag, id)
	}

	new(String appName, int port, String appPath, IProgressMonitor monitor, String enginePath, String flag, int id) {
		super(NetIDE.CONTROLLER_RYU + " " + NetIDE.CONTROLLER_APP_BACKEND, port, appPath, monitor, id)
		name = String.format("%s %s (%s)", appName, name, this.appPath.lastSegment.replace("\\.", "_"))
		if (enginePath != null && enginePath != "") {
			this.enginePath = super.getValidPath(enginePath);
		}
		if (flag != null && flag != "") {
			this.flags = flag;
		}
	}

	new(int port, String appPath, IProgressMonitor monitor, String enginePath, String flag) {
		this(port, appPath, monitor, enginePath, flag, -1)
	}

	override getEnvironmentVariables() {

		String.format("PYTHONPATH=$PYTHONPATH:%sryu-backend:%slibraries/netip/python", this.enginePath, this.enginePath)
	}

	private String enginePath = NetIDE.ENGINE_PATH;
	private String flags = ""

	override getCommandLine() {

		var cmd = String.format(
			"sudo ryu-manager --ofp-tcp-listen-port %s %s %sryu-backend/ryu-backend.py ~/netide/apps/%s", port, flags,
			this.enginePath, appPath.removeFirstSegments(1))
		println(cmd);
		return cmd;
	}

}

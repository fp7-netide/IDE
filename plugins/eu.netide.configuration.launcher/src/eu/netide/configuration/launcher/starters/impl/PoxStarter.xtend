package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PoxStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_POX, configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	new(int port, String appPath, IProgressMonitor monitor) {
		this(port, appPath, monitor, -1)
	}

	new(int port, String appPath, IProgressMonitor monitor, int id) {
		this("", port, appPath, monitor, id)
	}

	new(String appName, int port, String appPath, IProgressMonitor monitor, int id) {
		super(NetIDE.CONTROLLER_POX, port, appPath, monitor)
		name = String.format("%s %s (%s)", appName, name, this.appPath.lastSegment, id)
	}

	override getEnvironmentVariables() {
		return String.format("PYTHONPATH=$PYTHONPATH:netide/controllers/%s", getAppPath.removeFileExtension.lastSegment)
	}

	override getCommandLine() {
		var poxline = String.format("netide/pox/pox.py openflow.of_01 --port=%s %s ", controller.portNo,
			getAppPath.removeFileExtension.lastSegment)
		return poxline
	}

}

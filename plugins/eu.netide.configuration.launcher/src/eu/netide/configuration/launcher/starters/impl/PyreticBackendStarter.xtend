package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PyreticBackendStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_PYRETIC + " " + NetIDE.CONTROLLER_APP_BACKEND, configuration, controller, monitor)
	}

	new(int port, String appPath, IProgressMonitor monitor, int id) {
		this("", port, appPath, monitor, id)
	}

	new(String appName, int port, String appPath, IProgressMonitor monitor, int id) {
		super(NetIDE.CONTROLLER_PYRETIC + " " + NetIDE.CONTROLLER_APP_BACKEND, port, appPath, monitor, id)
		if (appName != "")
			name = appName + "_" + name
	}

	new(int port, String appPath, IProgressMonitor monitor) {
		this(port, appPath, monitor, -1)
	}

	override getCommandLine() {
		return String.format(
			"PYTHONPATH=$PYTHONPATH:netide/pyretic netide/pyretic/pyretic.py -v high -f -m i pyretic.modules.%s",
			appPath.removeFileExtension.lastSegment)
	}

}

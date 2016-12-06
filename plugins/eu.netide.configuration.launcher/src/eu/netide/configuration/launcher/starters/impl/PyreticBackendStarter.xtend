package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class PyreticBackendStarter extends ControllerStarter {
	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Pyretic Backend", configuration, controller, monitor)
	}

	new(int port, String appPath, IProgressMonitor monitor, int id) {
		super("Pyretic Backend", port, appPath, monitor, id)
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

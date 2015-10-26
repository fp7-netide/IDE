package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.ControllerStarter
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor

class PyreticBackendStarter extends ControllerStarter {

	new(ILaunch launch, ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Pyretic Backend", launch, configuration, controller, monitor)
	}

	override getCommandLine() {
		return String.format("PYTHONPATH=$PYTHONPATH:pyretic pyretic/pyretic.py -v high -f -m i pyretic.modules.%s",
			appPath.removeFileExtension.lastSegment).cmdLineArray
	}

}
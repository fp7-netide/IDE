package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import java.util.ArrayList
import org.eclipse.core.runtime.IPath
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.core.runtime.IProgressMonitor

class PoxStarter extends ControllerStarter {

	new(ILaunch launch, ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("POX", launch, configuration, controller, monitor)
	}
	
	override ArrayList<String> getCommandLine() {
		var poxline = String.format("PYTHONPATH=$PYTHONPATH:controllers/%s pox/pox.py openflow.of_01 --port=%s %s ",
			controllerpath.removeFileExtension.lastSegment, controller.portNo, controllerpath.removeFileExtension.lastSegment)
		
		return poxline.cmdLineArray
	}
	



	
}
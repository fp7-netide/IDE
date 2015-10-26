package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import java.util.ArrayList
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration

class PoxStarter extends ControllerStarter {

	new(ILaunch launch, ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("POX", launch, configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}
	
	override ArrayList<String> getCommandLine() {
		var poxline = String.format("PYTHONPATH=$PYTHONPATH:controllers/%s pox/pox.py openflow.of_01 --port=%s %s ",
			getAppPath.removeFileExtension.lastSegment, controller.portNo, getAppPath.removeFileExtension.lastSegment)
		
		return poxline.cmdLineArray
	}
	



	
}
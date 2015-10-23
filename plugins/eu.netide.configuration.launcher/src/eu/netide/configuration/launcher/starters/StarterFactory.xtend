package eu.netide.configuration.launcher.starters

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.launcher.starters.impl.PoxStarter
import eu.netide.configuration.launcher.starters.impl.RyuStarter
import eu.netide.configuration.launcher.starters.impl.MininetStarter
import org.eclipse.core.runtime.IProgressMonitor

class StarterFactory {
	public def IStarter createControllerStarter(ILaunchConfiguration configuration, ILaunch launch, Controller controller, IProgressMonitor monitor) {
		var controllerplatform = configuration.attributes.get("controller_platform_" + controller.name) as String
		switch controllerplatform {
			case NetIDE.CONTROLLER_POX:
				return new PoxStarter(launch, configuration, controller, monitor)
			case NetIDE.CONTROLLER_RYU:
				return new RyuStarter(launch, configuration, controller, monitor)
		}
	}
	
	public def IStarter createMininetStarter(ILaunchConfiguration configuration, ILaunch launch, IProgressMonitor monitor) {
		return new MininetStarter(launch, configuration, monitor)
	}
}
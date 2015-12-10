package eu.netide.configuration.launcher.starters

import Topology.Controller
import eu.netide.configuration.launcher.starters.impl.DebuggerStarter
import eu.netide.configuration.launcher.starters.impl.FloodlightBackendStarter
import eu.netide.configuration.launcher.starters.impl.MininetStarter
import eu.netide.configuration.launcher.starters.impl.OdlShimStarter
import eu.netide.configuration.launcher.starters.impl.PoxShimStarter
import eu.netide.configuration.launcher.starters.impl.PoxStarter
import eu.netide.configuration.launcher.starters.impl.PyreticBackendStarter
import eu.netide.configuration.launcher.starters.impl.PyreticStarter
import eu.netide.configuration.launcher.starters.impl.RyuBackendStarter
import eu.netide.configuration.launcher.starters.impl.RyuShimStarter
import eu.netide.configuration.launcher.starters.impl.RyuStarter
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration

class StarterFactory {

	public def IStarter createSingleControllerStarter(ILaunchConfiguration configuration,
		Controller controller, IProgressMonitor monitor) {
		var controllerplatform = configuration.attributes.get("controller_platform_" + controller.name) as String

		if (controllerplatform.equals(NetIDE.CONTROLLER_ENGINE)) {
		} else {
			switch controllerplatform {
				case NetIDE.CONTROLLER_POX:
					return new PoxStarter(configuration, controller, monitor)
				case NetIDE.CONTROLLER_RYU:
					return new RyuStarter(configuration, controller, monitor)
				case NetIDE.CONTROLLER_PYRETIC:
					return new PyreticStarter(configuration, controller, monitor)
			}
		}
	}

	public def IStarter createShimStarter(ILaunchConfiguration configuration, Controller controller,
		IProgressMonitor monitor) {

		var serverplatform = configuration.attributes.get("controller_platform_target_" + controller.name) as String

		switch serverplatform {
			case NetIDE.CONTROLLER_POX:
				return new PoxShimStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_RYU:
				return new RyuShimStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_ODL:
				return new OdlShimStarter(configuration, controller, monitor)
		}

	}

	public def IStarter createBackendStarter(ILaunchConfiguration configuration, Controller controller,
		IProgressMonitor monitor) {

		var clientplatform = configuration.attributes.get("controller_platform_source_" + controller.name) as String

		switch clientplatform {
			case NetIDE.CONTROLLER_FLOODLIGHT:
				return new FloodlightBackendStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_RYU:
				return new RyuBackendStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_PYRETIC:
				return new PyreticBackendStarter(configuration, controller, monitor)
		}

	}

	public def IStarter createMininetStarter(ILaunchConfiguration configuration,
		IProgressMonitor monitor) {
		return new MininetStarter(configuration, monitor)
	}
	
	public def createDebuggerStarter(ILaunchConfiguration configuration,
		IProgressMonitor monitor) {
		return new DebuggerStarter(configuration, monitor)
	}
	
}
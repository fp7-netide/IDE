package eu.netide.configuration.launcher.starters

import Topology.Controller
import eu.netide.configuration.launcher.starters.backends.Backend
import eu.netide.configuration.launcher.starters.backends.VagrantBackend
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
import eu.netide.configuration.launcher.starters.impl.CoreStarter
import eu.netide.configuration.launcher.starters.impl.EmulatorStarter
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class StarterFactory {

	private Backend backend

	new() {
		this(new VagrantBackend)
	}

	new(Backend backend) {
		this.backend = backend
	}

	@Deprecated
	public def IStarter createSingleControllerStarter(ILaunchConfiguration configuration, Controller controller,
		IProgressMonitor monitor) {
		var controllerplatform = configuration.attributes.get("controller_platform_" + controller.name) as String

		if (controllerplatform.equals(NetIDE.CONTROLLER_ENGINE)) {
		} else {
			var IStarter starter
			switch controllerplatform {
				case NetIDE.CONTROLLER_POX:
					starter = new PoxStarter(configuration, controller, monitor)
				case NetIDE.CONTROLLER_RYU:
					starter = new RyuStarter(configuration, controller, monitor)
				case NetIDE.CONTROLLER_PYRETIC:
					starter = new PyreticStarter(configuration, controller, monitor)
				case NetIDE.CONTROLLER_FLOODLIGHT:
					starter = new FloodlightBackendStarter(configuration, controller, monitor)
			}
			starter.setBackend(backend)
			return starter
		}
	}

	public def IStarter createSingleControllerStarter(String platform, String appPath, int port,
		IProgressMonitor monitor) {
		createSingleControllerStarter(platform, appPath, port, monitor, null)
	}

	public def IStarter createSingleControllerStarter(String platform, String appPath, int port,
		IProgressMonitor monitor, String appFolderPath) {
		var controllerplatform = platform

		if (controllerplatform.equals(NetIDE.CONTROLLER_ENGINE)) {
		} else {
			var IStarter starter
			switch controllerplatform {
				case NetIDE.CONTROLLER_POX:
					starter = new PoxStarter(port, appPath, monitor)
				case NetIDE.CONTROLLER_RYU:
					starter = new RyuStarter(port, appPath, monitor, appFolderPath)
				case NetIDE.CONTROLLER_PYRETIC:
					starter = new PyreticStarter(port, appPath, monitor)
			}
			starter.setBackend(backend)
			return starter
		}
	}

//	public def IStarter createSingleControllerStarter(String platform, Controller controller,
//		IProgressMonitor monitor) {
//		var controllerplatform = platform
//
//		if (controllerplatform.equals(NetIDE.CONTROLLER_ENGINE)) {
//		} else {
//			var IStarter starter
//			switch controllerplatform {
//				case NetIDE.CONTROLLER_POX:
//					starter = new PoxStarter(configuration, controller, monitor)
//				case NetIDE.CONTROLLER_RYU:
//					starter = new RyuStarter(configuration, controller, monitor)
//				case NetIDE.CONTROLLER_PYRETIC:
//					starter = new PyreticStarter(configuration, controller, monitor)
//				case NetIDE.CONTROLLER_FLOODLIGHT:
//					starter = new FloodlightBackendStarter(configuration, controller, monitor)
//			}
//			starter.setBackend(backend)
//			return starter
//		}
//	}
	@Deprecated
	public def IStarter createShimStarter(ILaunchConfiguration configuration, Controller controller,
		IProgressMonitor monitor) {

		var serverplatform = configuration.attributes.get("controller_platform_target_" + controller.name) as String
		var IStarter starter
		switch serverplatform {
			case NetIDE.CONTROLLER_POX:
				starter = new PoxShimStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_RYU:
				starter = new RyuShimStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_ODL:
				starter = new OdlShimStarter(configuration, controller, monitor)
		}
		starter.setBackend(backend)
		return starter

	}

	public def IStarter createShimStarter(String platform, String appPath, int port, IProgressMonitor monitor) {
		createShimStarter(platform, appPath, port, monitor, null, null)
	}

	public def IStarter createShimStarter(String platform, String appPath, int port, IProgressMonitor monitor,
		String engine, String odlKaraf) {

		var serverplatform = platform
		var IStarter starter
		switch serverplatform {
			case NetIDE.CONTROLLER_POX:
				starter = new PoxShimStarter(appPath, port, monitor)
			case NetIDE.CONTROLLER_RYU:
				starter = new RyuShimStarter(appPath, port, monitor, engine)
			case NetIDE.CONTROLLER_ODL:
				starter = new OdlShimStarter(appPath, port, monitor, odlKaraf)
		}
		starter.setBackend(backend)
		return starter

	}

	@Deprecated
	public def IStarter createBackendStarter(ILaunchConfiguration configuration, Controller controller,
		IProgressMonitor monitor) {

		var clientplatform = configuration.attributes.get("controller_platform_source_" + controller.name) as String
		var IStarter starter
		switch clientplatform {
			case NetIDE.CONTROLLER_FLOODLIGHT:
				starter = new FloodlightBackendStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_RYU:
				starter = new RyuBackendStarter(configuration, controller, monitor)
			case NetIDE.CONTROLLER_PYRETIC:
				starter = new PyreticBackendStarter(configuration, controller, monitor)
		}
		starter.backend = backend
		return starter
	}

	public def IStarter createBackendStarter(String platform, String appPath, int port, IProgressMonitor monitor) {
		createBackendStarter(platform, appPath, port, monitor, null)
	}

	public def IStarter createBackendStarter(String platform, String appPath, int port, IProgressMonitor monitor,
		String engine) {

		var clientplatform = platform
		var IStarter starter
		switch clientplatform {
			case NetIDE.CONTROLLER_FLOODLIGHT:
				starter = new FloodlightBackendStarter(port, appPath, monitor)
			case NetIDE.CONTROLLER_RYU:
				starter = new RyuBackendStarter(port, appPath, monitor, engine)
			case NetIDE.CONTROLLER_PYRETIC:
				starter = new PyreticBackendStarter(port, appPath, monitor)
		}
		starter.backend = backend
		return starter
	}

	@Deprecated
	public def IStarter createMininetStarter(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		var starter = new MininetStarter(configuration, monitor)
		starter.backend = backend
		return starter
	}

	@Deprecated
	public def createDebuggerStarter(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		createDebuggerStarter(configuration, null, monitor, null)
	}

	@Deprecated
	public def createDebuggerStarter(ILaunchConfiguration configuration, String engine, IProgressMonitor monitor,
		String tools) {
		var starter = new DebuggerStarter(configuration, engine, monitor, tools)
		starter.backend = backend
		return starter
	}

	@Deprecated
	public def createCoreStarter(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		createCoreStarter(configuration, monitor, null)
	}

	@Deprecated
	public def createCoreStarter(ILaunchConfiguration configuration, IProgressMonitor monitor, String karafPath) {
		var starter = new CoreStarter(configuration, monitor, karafPath)
		starter.backend = backend
		return starter
	}

	@Deprecated
	public def createEmulatorStarter(ILaunchConfiguration configuration, IProgressMonitor monitor, String composition) {
		var starter = new EmulatorStarter(configuration, monitor, composition)
		starter.backend = backend
		return starter
	}

	@Deprecated
	public def createEmulatorStarter(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		createEmulatorStarter(configuration, monitor, null)
	}

}

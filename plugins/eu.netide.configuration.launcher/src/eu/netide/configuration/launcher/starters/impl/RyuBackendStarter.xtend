package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.utils.NetIDE

class RyuBackendStarter extends ControllerStarter {

	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu Backend", configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}
	
	new (int port, String appPath, IProgressMonitor monitor) {
		this(port, appPath, monitor, null)
	}
	
	new (int port, String appPath, IProgressMonitor monitor, String enginePath) {
		super("Ryu Backend", port, appPath, monitor)
		name = String.format("%s (%s)", name, this.appPath.lastSegment)
		if(enginePath != null && enginePath != ""){
			this.enginePath = super.getValidPath(enginePath);
		}
	}

	override getEnvironmentVariables() {
		
		String.format("PYTHONPATH=$PYTHONPATH:%sryu-backend:%slibraries/netip/python", this.enginePath, this.enginePath)
	}
	private String enginePath = NetIDE.ENGINE_PATH;
	override getCommandLine() {
		
		return String.format(
			"sudo ryu-manager --ofp-tcp-listen-port %s %sryu-backend/ryu-backend.py ~/netide/apps/%s",
			port, this.enginePath, appPath.removeFirstSegments(1))
	}

}
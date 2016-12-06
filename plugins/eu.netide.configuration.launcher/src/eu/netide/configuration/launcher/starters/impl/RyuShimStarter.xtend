package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.utils.NetIDE

class RyuShimStarter extends ControllerStarter {

	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super("Ryu Shim", configuration, controller, monitor)
	}
	
	new(String appPath, int port, IProgressMonitor monitor) {
		this(appPath, port, monitor, null)
	}
	new(String appPath, int port, IProgressMonitor monitor, String enginePath, int id){
				super("Ryu Shim", port, appPath, monitor, id)
		if(enginePath != null && enginePath != ""){
			this.enginePath = super.getValidPath(enginePath)
		}
	}
	new(String appPath, int port, IProgressMonitor monitor, String enginePath) {
		this(appPath, port, monitor, enginePath, -1)
	}

	override getEnvironmentVariables() {
		return String.format("PYTHONPATH=$PYTHONPATH:%sryu-shim", this.enginePath)
	}
	
	String enginePath = NetIDE.ENGINE_PATH;
	
	override getCommandLine() {
		return String.format(
			"sudo ryu-manager --ofp-tcp-listen-port %s %sryu-shim/ryu-shim.py", port, this.enginePath)
	}

}
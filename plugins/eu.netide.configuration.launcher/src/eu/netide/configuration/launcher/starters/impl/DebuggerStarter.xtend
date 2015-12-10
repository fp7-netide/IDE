package eu.netide.configuration.launcher.starters.impl

import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.core.runtime.IProgressMonitor

class DebuggerStarter extends Starter {
	
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Debugger", configuration, monitor)
	}
	
	override getCommandLine() {
		String.format("sudo python ~/Tools/debugger/Ryu_shim/debugger.py")
	}
	
}
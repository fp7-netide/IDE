package eu.netide.configuration.launcher.starters.impl

import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.launcher.starters.backends.Backend

class DebuggerStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Debugger", configuration, monitor)
	}
	
	new(Backend backend, String path, IProgressMonitor monitor) {
		super("Debugger", path, backend, monitor)
	}
	
	override getEnvironmentVariables() {
		return String.format("PYTHONPATH=$PYTHONPATH:netide/Engine/libraries/netip/python:netide/ryu/ryu/")
	}
	
	override getCommandLine() {
		String.format("bash -c \'cd ~/netide/Tools/debugger/Core/ && python ./debugger.py -o ~/netide/debug_results\'")
	}
	
}
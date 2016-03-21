package eu.netide.configuration.launcher.starters.impl

import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class DebuggerStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Debugger", configuration, monitor)
	}
	
	override getCommandLine() {
		String.format("python ~/netide/Tools/debugger/Core/debugger.py -o ~/netide/debug_results")
	}
	
}
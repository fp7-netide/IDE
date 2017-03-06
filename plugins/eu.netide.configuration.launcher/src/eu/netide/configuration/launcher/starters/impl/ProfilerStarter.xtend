package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor
import eu.netide.configuration.utils.NetIDE

class ProfilerStarter extends Starter {
	private String toolpath
	
	new(String name, String path, Backend backend, String toolpath, IProgressMonitor monitor) {
		super("Profiler", path, backend, monitor)
		if (toolpath != null)
			this.toolpath = this.getValidPath(toolpath)
		else
			this.toolpath = NetIDE.TOOL_PATH
	}
	
	override getCommandLine() {
		
		var cmd = String.format("bash -c \'cd %sprofiler/Network_Profiler && python network_profiler.py \'", this.toolpath)
		return cmd
	}
	
	def checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}
	
}
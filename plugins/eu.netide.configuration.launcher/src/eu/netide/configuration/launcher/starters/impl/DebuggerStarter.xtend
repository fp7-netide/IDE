package eu.netide.configuration.launcher.starters.impl

import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.launcher.starters.backends.Backend
import eu.netide.configuration.utils.NetIDE

class DebuggerStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Debugger", configuration, monitor)
	}

	new(Backend backend, String path, IProgressMonitor monitor) {
		this(backend, path, null, monitor, null)
	}

	new(Backend backend, String path, IProgressMonitor monitor, String tools) {
		this(backend, path, null, monitor, tools)
	}

	new(Backend backend, String path, String engine, IProgressMonitor monitor) {
		this(backend, path, engine, monitor, null)
	}

	new(Backend backend, String path, String engine, IProgressMonitor monitor, String tools) {
		super("Debugger", path, backend, monitor)
		if(engine != null && enginePath != ""){
			this.enginePath = super.getValidPath(engine)
		}
		if(tools != null && tools != ""){
			this.toolPath = super.getValidPath(tools)
		}
	}
	
	String enginePath = NetIDE.ENGINE_PATH;
	String toolPath = NetIDE.TOOL_PATH
	
	override getEnvironmentVariables() {
		return String.format("PYTHONPATH=$PYTHONPATH:%slibraries/netip/python:netide/ryu/ryu/", this.enginePath)
	}

	override getCommandLine() {
		String.format("python %sdebugger/Core/debugger.py -o ~/netide/debug_results", this.toolPath)
	}

}

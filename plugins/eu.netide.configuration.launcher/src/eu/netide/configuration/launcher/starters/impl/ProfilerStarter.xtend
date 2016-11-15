package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor

class ProfilerStarter extends Starter {
	
	new(String name, String path, Backend backend, IProgressMonitor monitor) {
		super("Profiler", path, backend, monitor)
	}
	
	override getCommandLine() {
		String.format("bash -c \'cd ~/netide/Tools/profiler/Network_Profiler && python network_profiler.py \'" )
	}
	
}
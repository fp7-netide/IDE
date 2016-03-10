package eu.netide.configuration.launcher.starters.impl

import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.launcher.starters.backends.Backend

class CoreStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Core", configuration, monitor)
	}
	
	new (Backend backend, IProgressMonitor monitor) {
		super("Core", "", backend, monitor)
	}
	
	override getCommandLine() {
		String.format("~/apache-karaf-3.0.6/bin/karaf")
	}
	
}
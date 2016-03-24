package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class CoreStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Core", configuration, monitor)
	}
	
	new (Backend backend, String project, IProgressMonitor monitor) {
		super("Core", project, backend, monitor)
	}
	
	override getCommandLine() {
		String.format("~/apache-karaf-3.0.6/bin/karaf")
	}
	
}
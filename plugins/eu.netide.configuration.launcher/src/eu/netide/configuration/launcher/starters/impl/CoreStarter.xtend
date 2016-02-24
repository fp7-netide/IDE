package eu.netide.configuration.launcher.starters.impl

import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class CoreStarter extends Starter {
	
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Core", configuration, monitor)
	}
	
	override getCommandLine() {
		String.format("~/karaf/assemblies/apache-karaf/target/apache-karaf-3.0.6-SNAPSHOT/bin/karaf")
	}
	
}
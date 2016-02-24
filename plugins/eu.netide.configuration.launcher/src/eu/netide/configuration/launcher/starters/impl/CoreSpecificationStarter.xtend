package eu.netide.configuration.launcher.starters.impl

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.core.runtime.IProgressMonitor

class CoreSpecificationStarter extends Starter{
	
	private String compositionPath
	
	new(ILaunchConfiguration configuration, String compositionPath, IProgressMonitor monitor) {
		super("Core", configuration, monitor)
		this.compositionPath = compositionPath
	}
	
	override getCommandLine() {
		String.format("~/apache-karaf-3.0.6/bin/client netide:loadcomposition %s", compositionPath)
	}
	
}
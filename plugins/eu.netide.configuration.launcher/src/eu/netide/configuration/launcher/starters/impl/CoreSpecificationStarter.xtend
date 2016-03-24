package eu.netide.configuration.launcher.starters.impl

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.resources.ResourcesPlugin
import eu.netide.configuration.launcher.starters.backends.Backend

class CoreSpecificationStarter extends Starter{
	
	private String compositionPath
	@Deprecated
	new(ILaunchConfiguration configuration, String compositionPath, IProgressMonitor monitor) {
		super("Core Loader", configuration, monitor)
		this.compositionPath = compositionPath
	}
	
	new(String compositionPath, Backend backend, IProgressMonitor monitor) {
		super("Core Loader", compositionPath, backend, monitor)
		this.compositionPath = compositionPath
	}
	
	override getCommandLine() {
		var file = ResourcesPlugin.workspace.root.findMember(compositionPath.IFile.fullPath)
		var fullpath = file.fullPath
		var guestPath = "$HOME/netide/" + fullpath.removeFirstSegments(1)
		
		String.format("~/apache-karaf-3.0.6/bin/client netide:loadcomposition %s", guestPath)
	}
	
}
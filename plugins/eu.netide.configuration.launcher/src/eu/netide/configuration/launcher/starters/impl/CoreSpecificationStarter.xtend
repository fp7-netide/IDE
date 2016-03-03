package eu.netide.configuration.launcher.starters.impl

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.resources.ResourcesPlugin

class CoreSpecificationStarter extends Starter{
	
	private String compositionPath
	
	new(ILaunchConfiguration configuration, String compositionPath, IProgressMonitor monitor) {
		super("Core", configuration, monitor)
		this.compositionPath = compositionPath
	}
	
	override getCommandLine() {
		var file = ResourcesPlugin.workspace.root.findMember(compositionPath)
		var fullpath = file.fullPath
		var guestPath = "$HOME/netide/" + fullpath.removeFirstSegments(1)
		
		String.format("~/apache-karaf-3.0.5/bin/client netide:loadcomposition %s", guestPath)
	}
	
}
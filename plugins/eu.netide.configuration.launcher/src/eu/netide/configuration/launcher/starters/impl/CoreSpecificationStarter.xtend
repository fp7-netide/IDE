package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

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
		var file = compositionPath.IFile
		var fullpath = file.fullPath
		var guestPath = "$HOME/netide/" + fullpath.removeFirstSegments(1)

		var cmd = String.format("bash -c \'cd ~/netide/core-karaf/bin && ./client netide:loadcomposition %s\'", guestPath)

		return cmd
	}
	
}
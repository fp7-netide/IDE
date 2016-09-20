package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.utils.NetIDE

class CoreStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Core", configuration, monitor)
	}
	
	new (Backend backend, String project, IProgressMonitor monitor) {
		super("Core", project, backend, monitor)
	}
	
	new (Backend backend, String project, IProgressMonitor monitor, String coreKarafPath){
		super("Core", project, backend, monitor)
		//TODO: validate coreKarafPath format
		if(coreKarafPath != null && coreKarafPath != "")
			this.coreKarafPath = coreKarafPath
	}
	
	private String coreKarafPath = NetIDE.CORE_KARAF;
	override getCommandLine() {
		String.format("bash -c \'cd %s && ./karaf\'", coreKarafPath)
	}
	
}
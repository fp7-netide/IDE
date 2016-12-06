package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.utils.NetIDE

class CoreStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		this(configuration, monitor, null)
	}

	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor, String coreKarafPath) {
		super("Core", configuration, monitor)
		if (coreKarafPath != null && coreKarafPath != "")
			this.coreKarafPath = super.getValidPath(coreKarafPath)
	}

	new(Backend backend, String project, IProgressMonitor monitor) {
		this(backend, project, monitor, null)
	}

	new(Backend backend, String project, IProgressMonitor monitor, String coreKarafPath, int id) {
		super("Core", project, backend, monitor, id)

		if (coreKarafPath != null && coreKarafPath != "")
			this.coreKarafPath = super.getValidPath(coreKarafPath)
	}

	new(Backend backend, String project, IProgressMonitor monitor, String coreKarafPath) {
		this(backend, project, monitor, coreKarafPath, -1)
	}

	private String coreKarafPath = NetIDE.CORE_KARAF;

	override getCommandLine() {

		var cmd = String.format("bash -c \'cd %s && ./karaf\'", coreKarafPath)

		return cmd
	}

}

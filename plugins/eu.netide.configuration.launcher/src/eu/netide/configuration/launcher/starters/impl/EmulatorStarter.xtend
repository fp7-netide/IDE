package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class EmulatorStarter extends Starter {
	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		this(configuration, monitor, null)
	}

	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor, String compositionPath) {
		super("Emulator", configuration, monitor)
		if (compositionPath != null && compositionPath != "") {
			this.compositionPath = super.getValidPath(compositionPath)
		}
	}

	String compositionPath = NetIDE.COMPOSITION_PATH

	override getCommandLine() {
		String.format("sudo java -jar %semulator-1.0-jar-with-dependencies.jar", this.compositionPath)
	}

}

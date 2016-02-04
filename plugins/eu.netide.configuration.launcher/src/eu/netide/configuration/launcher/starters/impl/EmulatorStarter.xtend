package eu.netide.configuration.launcher.starters.impl

import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration

class EmulatorStarter extends Starter {
	
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Emulator", configuration, monitor)
	}
	
	override getCommandLine() {
		String.format("sudo java -jar /home/vagrant/composition/emulator-1.0-jar-with-dependencies.jar")
	}
	
}
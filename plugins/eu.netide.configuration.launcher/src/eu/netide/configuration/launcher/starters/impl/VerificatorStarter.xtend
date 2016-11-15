package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.Starter
import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor

class VerificatorStarter extends Starter {
	
	new(String path, Backend backend, IProgressMonitor monitor) {
		super("Verificator", path, backend, monitor)
	}
	

	override getCommandLine() {
		String.format("bash -c \'cd ~/netide/Tools/debugger/Core && python verificator_runtime_ide.py \'" )
	}
	
}
package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.impl.Starter
import eu.netide.configuration.launcher.starters.backends.Backend
import org.eclipse.core.runtime.IProgressMonitor
import eu.netide.configuration.utils.NetIDE

class VerificatorStarter extends Starter {
	private String toolpath
	
	new(String path, Backend backend, String toolpath, IProgressMonitor monitor) {
		super("Verificator", path, backend, monitor)
		if (toolpath != null)
			this.toolpath = toolpath
		else
			this.toolpath = NetIDE.TOOL_PATH
	}
	

	override getCommandLine() {
		String.format("bash -c \'cd ~/netide/Tools/debugger/Core && python verificator_runtime_ide.py \'" )
	}
	
}
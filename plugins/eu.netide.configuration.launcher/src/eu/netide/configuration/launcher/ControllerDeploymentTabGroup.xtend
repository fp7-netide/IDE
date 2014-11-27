package eu.netide.configuration.launcher

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.ILaunchConfigurationDialog

class ControllerDeploymentTabGroup extends AbstractLaunchConfigurationTabGroup{
	
	override createTabs(ILaunchConfigurationDialog dialog, String mode) {
		var tab = new ControllerDeploymentTab1
		tabs = newArrayList(tab)
		
		
	}

}
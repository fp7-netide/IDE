package eu.netide.configuration.launcher

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.ILaunchConfigurationDialog

/**
 * Sets up a tab group in the launch Configuration
 * 
 * @author Christian Stritzke
 */
class ControllerDeploymentTabGroup extends AbstractLaunchConfigurationTabGroup {

	override createTabs(ILaunchConfigurationDialog dialog, String mode) {
		var tab1 = new ControllerDeploymentTab1
		var tab2 = new ControllerDeploymentTab2
		tabs = newArrayList(tab1, tab2)
	}
}
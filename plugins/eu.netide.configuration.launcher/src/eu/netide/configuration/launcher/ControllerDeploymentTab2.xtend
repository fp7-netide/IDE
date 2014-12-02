package eu.netide.configuration.launcher

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label

class ControllerDeploymentTab2 extends AbstractLaunchConfigurationTab {
	
	private Label label
	private Button checkbox
	
	override createControl(Composite parent) {
		var comp = SWTFactory.createComposite(parent, 1, 1, GridData.FILL_HORIZONTAL)
		control = comp
		var group = SWTFactory.createGroup(comp, "Miscellaneous Options", 2, 1, GridData.FILL_HORIZONTAL)
		
		group.createMiscOptions	
	}
	
	def createMiscOptions(Group group) {
		label = SWTFactory.createLabel(group, "Force new provision", 1)
		checkbox = SWTFactory.createCheckButton(group, "", null, false, 1)
		
		checkbox.addSelectionListener(new SelectionAdapter(){
			
			override widgetSelected(SelectionEvent e) {
				super.widgetSelected(e) 
				scheduleUpdateJob
			}
			
		})
	}
		
	override getName() {
		return "Misc"
	}
	
	override initializeFrom(ILaunchConfiguration configuration) {
		if (configuration.attributes.containsKey("reprovision"))
			checkbox.selection = configuration.attributes.get("reprovision") as Boolean
		else
			checkbox.selection = false

	}
	
	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute("reprovision", checkbox.selection)
	}
	
	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute("reprovision", false);
	}
	
}
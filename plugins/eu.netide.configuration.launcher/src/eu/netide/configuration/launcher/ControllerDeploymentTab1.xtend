package eu.netide.configuration.launcher

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.emf.common.ui.dialogs.ResourceDialog
import org.eclipse.swt.SWT
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.MouseAdapter
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Text
import org.eclipse.debug.internal.ui.SWTFactory

class ControllerDeploymentTab1 extends AbstractLaunchConfigurationTab {

	private Composite comp

	private Text textfield

	override createControl(Composite parent) {
		comp = SWTFactory.createComposite(parent, 1, 1, GridData.FILL_HORIZONTAL)
		control = comp
		val g = SWTFactory.createGroup(comp, "Configuration Selection", 3, 1, GridData.FILL_HORIZONTAL) //new Group(comp, SWT.NONE)
		g.createConfigurationChooser
	}

	def createConfigurationChooser(Composite c) {

		c.layout = new GridLayout(3, false)
		SWTFactory.createLabel(c, "Topology Model:", 1)

		textfield = SWTFactory.createSingleText(c, 1)
		textfield.addModifyListener(
			new ModifyListener() {
				override modifyText(ModifyEvent event) {
					updateLaunchConfigurationDialog
					scheduleUpdateJob
				}
			})

		val chooserbutton = createPushButton(c, "Choose Model", null)
		chooserbutton.addMouseListener(
			new MouseAdapter() {
				override mouseUp(MouseEvent e) {
					super.mouseUp(e)
					var dialog = new ResourceDialog(Display.getDefault().getActiveShell(), "Title", SWT.SINGLE)
					dialog.open();
					textfield.text = dialog.URIText
				}
			})

	}

	override getName() {
		"Controller Deployment"
	}

	override initializeFrom(ILaunchConfiguration configuration) {
		if (configuration.attributes.containsKey("topologymodel"))
			textfield.text = configuration.attributes.get("topologymodel") as String
		else
			textfield.text = ""
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.attributes.put("topologymodel", textfield.text)

	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
	}

}

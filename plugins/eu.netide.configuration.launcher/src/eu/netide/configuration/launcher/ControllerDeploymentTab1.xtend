package eu.netide.configuration.launcher

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.graphics.Point

class ControllerDeploymentTab1 extends AbstractLaunchConfigurationTab {

	private Label guestlabel
	private Combo guestcombo

	private Label hostlabel
	private Combo hostcombo

	override createControl(Composite parent) {

		var c = new Composite(parent, SWT.NONE)
		control = c
		c.layout = new GridLayout(2, true)

		guestlabel = new Label(c, SWT.NONE)
		guestlabel.text = "Guest Platform"

		guestcombo = new Combo(c, SWT.READ_ONLY)
		guestcombo.size = new Point(100, guestcombo.size.y)
		guestcombo.add("Pyretic")

		hostlabel = new Label(c, SWT.NONE)
		hostlabel.text = "Host Platform"

		hostcombo = new Combo(c, SWT.READ_ONLY)
		hostcombo.size = new Point(100, hostcombo.size.y)
		hostcombo.add("Ryu")

		c.createSeparator(2)
	}

	override getName() {
		"Controller Deployment"
	}

	override initializeFrom(ILaunchConfiguration configuration) {
		//hostcombo.text = configuration.attributes.get("host").toString
		//guestcombo.text = configuration.attributes.get("guest").toString
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.attributes = newHashMap("host" -> "ryu", "guest" -> "pyretic")
	}

}

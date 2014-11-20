package eu.netide.configuration.launcher

import java.util.ArrayList
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Label
import org.eclipse.ui.dialogs.ElementTreeSelectionDialog

class ControllerDeploymentTab1 extends AbstractLaunchConfigurationTab {

	private Label guestlabel
	private Combo guestcombo

	private Label hostlabel
	private Combo hostcombo

	private Composite platformcomposite

	private Composite pyreticcomposite

	private Composite ryucomposite

	private ArrayList<Composite> guestchoosers
	
	private ArrayList<Composite> hostchoosers

	override createControl(Composite parent) {

		var c = new Composite(parent, SWT.NONE)
		control = c
		c.layout = new GridLayout(1, true)

		platformcomposite = new Composite(c, SWT.NONE)
		platformcomposite.layout = new GridLayout(2, true)

		guestlabel = new Label(platformcomposite, SWT.NONE)
		guestlabel.text = "Guest Platform"

		guestcombo = new Combo(platformcomposite, SWT.READ_ONLY)

		//		guestcombo.size = new Point(100, guestcombo.size.y)
		guestcombo.items = newArrayList("Pyretic", "POX", "Floodlight")
		guestcombo.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					super.widgetSelected(e)
					displayguestchooser()
				}
			})

		hostlabel = new Label(platformcomposite, SWT.NONE)
		hostlabel.text = "Host Platform"

		hostcombo = new Combo(platformcomposite, SWT.READ_ONLY)

		hostcombo.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					super.widgetSelected(e)
					displayhostchooser()
				}
			})

		//		hostcombo.size = new Point(100, hostcombo.size.y)
		hostcombo.items = newArrayList("Ryu", "ODL")

		c.createSeparator(2)

		pyreticcomposite = new Composite(c, SWT.NONE)
		pyreticcomposite.createPyreticChooser
		pyreticcomposite.visible = false

		ryucomposite = new Composite(c, SWT.NONE)
		ryucomposite.createRyuChooser
		ryucomposite.visible = false

		guestchoosers = newArrayList(pyreticcomposite)
		hostchoosers = newArrayList(ryucomposite)

	}

	def displayguestchooser() {
		guestchoosers.forEach[visible = false]
		if (guestcombo.text.equals("Pyretic")) {
			pyreticcomposite.visible = true
		} else if (guestcombo.text.equals("Ryu")) {
			ryucomposite.visible = true
		}
	}

	def displayhostchooser() {
		hostchoosers.forEach[visible = false]
		if (hostcombo.text.equals("Ryu")) {
			ryucomposite.visible = true
		}
	}

	def createPyreticChooser(Composite c) {
		c.layout = new GridLayout(2, true)
		
		var pyreticpathlabel = new Label(c, SWT.NONE)
		pyreticpathlabel.text = "Path to Pyretic App"
//		
//		var dialog = new ElementTreeSelectionDialog(shell, );
//		dialog.open();
	}

	def createRyuChooser(Composite c) {
		c.layout = new GridLayout(2, true)
		var ryupathlabel = new Label(c, SWT.NONE)
		ryupathlabel.text = "Path to Ryu App"

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

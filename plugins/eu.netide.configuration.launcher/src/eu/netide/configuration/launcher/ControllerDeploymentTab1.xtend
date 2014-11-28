package eu.netide.configuration.launcher

import Topology.NetworkEnvironment
import java.util.ArrayList
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.emf.common.ui.dialogs.ResourceDialog
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.swt.SWT
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.MouseAdapter
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text

class ControllerDeploymentTab1 extends AbstractLaunchConfigurationTab {

	private Composite comp

	private Text textfield

	private ArrayList<Group> groups = newArrayList()

	//	private Group 
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

					groups.forEach[dispose]
					groups.removeAll
					if (textfield.text.isTopologyModelPath)
						textfield.text.handleNewTopologyModel

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

	def isTopologyModelPath(String path) {
		try {
			var resSet = new ResourceSetImpl
			var resource = resSet.getResource(URI.createURI(path), true);

			return resource.contents.get(0) instanceof NetworkEnvironment
		} catch (Exception e) {
			return false
		}
	}

	def handleNewTopologyModel(String path) {
		var resSet = new ResourceSetImpl
		var resource = resSet.getResource(URI.createURI(path), true);

		var env = resource.contents.get(0) as NetworkEnvironment

		env.controllers.forEach [ c |
			var group = SWTFactory.createGroup(comp, "Controller " + c.name, 3, 1, GridData.FILL_HORIZONTAL)
			groups.add(group)
			group.buildControllerConfigurator
		]
	}

	def buildControllerConfigurator(Group c) {
		var label = SWTFactory.createLabel(c, "Select Platform:", 1)
		var platformselector = SWTFactory.createCombo(c, SWT.READ_ONLY, 1,
			newArrayList("Ryu", "POX", "Pyretic", "OpenDaylight"))

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
		configuration.setAttribute("topologymodel", textfield.text)
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
	}

}

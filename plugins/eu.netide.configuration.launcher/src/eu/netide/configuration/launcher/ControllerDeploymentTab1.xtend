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
import java.util.Map
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.widgets.Combo
import java.util.Collection
import org.eclipse.swt.events.DisposeListener
import org.eclipse.swt.events.DisposeEvent

class ControllerDeploymentTab1 extends AbstractLaunchConfigurationTab {

	private Composite comp

	private Text textfield

	private ArrayList<Group> groups = newArrayList()

	private Map<String, String> controllermap = newHashMap()

	//	private Group 
	override createControl(Composite parent) {
		comp = SWTFactory.createComposite(parent, 1, 1, GridData.FILL_HORIZONTAL)
		
		comp.addDisposeListener(new DisposeListener {
			
			override widgetDisposed(DisposeEvent e) {
				groups.clear
				controllermap.clear
			}
			
		})
		
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
					groups.clear

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
			var group = SWTFactory.createGroup(comp, c.name, 3, 1, GridData.FILL_HORIZONTAL)
			groups.add(group)
			group.buildControllerConfigurator
		]
	}

	def buildControllerConfigurator(Group c) {
		val label = SWTFactory.createLabel(c, "Select Platform:", 1)
		val platformselector = SWTFactory.createCombo(c, SWT.READ_ONLY, 1,
			newArrayList("Ryu", "POX", "Pyretic", "OpenDaylight"))

		platformselector.select(0)
		c.buildConfigurator(platformselector.text)

		platformselector.setData("type", "platformselector")
		platformselector.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					super.widgetSelected(e)
					controllermap.put(String.format("controller_platform_%s", c.text), platformselector.text)
					c.buildConfigurator(platformselector.text)
					scheduleUpdateJob
				}
			})

	}

	def buildConfigurator(Group c, String text) {
		c.children.filter[s|s instanceof Composite && s.getData("type") == "configurator"].forEach[dispose]
		if (text == "Ryu") {
			c.buildAppConfigurator("Ryu App")
		} else if (text == "POX") {
			c.buildAppConfigurator("POX App")
		} else if (text == "Pyretic") {
			c.buildAppConfigurator(("Pyretic App"))
		} else if (text == "OpenDaylight") {
		}
	}

	def buildAppConfigurator(Group c, String labeltext) {
		val comp = SWTFactory.createComposite(c, 3, 3, GridData.FILL_HORIZONTAL)
		comp.setData("type", "configurator")
		val label = SWTFactory.createLabel(comp, labeltext, 1)
		val text = SWTFactory.createSingleText(comp, 1)

		text.setData("type", "data")

		val platform = controllermap.get(String.format("controller_platform_%s", c.text))
		text.text = if (controllermap.get(String.format("controller_data_%s_%s", c.text, platform)) != null)
			controllermap.get(String.format("controller_data_%s_%s", c.text, platform))
		else
			""
		text.addModifyListener(
			new ModifyListener {
				override modifyText(ModifyEvent e) {
					controllermap.put(String.format("controller_data_%s_%s", c.text, platform), text.text)
					scheduleUpdateJob
				}
			})

		val chooserbutton = createPushButton(comp, "Choose App", null)
		chooserbutton.addMouseListener(
			new MouseAdapter() {
				override mouseUp(MouseEvent e) {
					super.mouseUp(e)
					var dialog = new ResourceDialog(Display.getDefault().getActiveShell(), "Title", SWT.SINGLE)
					dialog.open();
					text.text = dialog.URIText ?: text.text

				}
			})

	}

	override getName() {
		"Controller Deployment"
	}

	override initializeFrom(ILaunchConfiguration configuration) {
		
		textfield.text = configuration.attributes.get("topologymodel") as String ?: ""

		configuration.attributes.keySet.forEach[k|
			if(k.startsWith("controller")) controllermap.put(k, configuration.attributes.get(k) as String)]

		groups.filter[!disposed].forEach [ g |
			var platform = configuration.attributes.get(String.format("controller_platform_%s", g.text))
			for (t : g.children.filter(typeof(Composite)).filter(x|x.getData("type").equals("configurator")).map[
				children.filter(typeof(Text))].flatten.filter(x|x.getData("type").equals("data"))) {
				var text = configuration.attributes.get(String.format("controller_data_%s_%s", g.text, platform)) as String
				t.text = if(text != null) text else ""
			}
			for (d : g.children.filter(typeof(Combo)).filter(x|x.getData("type").equals("platformselector"))) {
				d.select(
					switch (configuration.attributes.get(String.format("controller_platform_%s", g.text)) as String) {
						case "Ryu": 0
						case "POX": 1
						case "Pyretic": 2
						case "Floodlight": 3
						default: 0
					})
			}
		]

		groups.filter[!disposed].forEach [ g |
			g.children.filter(typeof(Text)).forEach [
				var platform = configuration.attributes.get("controller_platform_" + g.text)
				text = configuration.attributes.get("controller_data_" + g.text + "_" + platform) as String
			]
		]

	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute("topologymodel", textfield.text)
		controllermap.keySet.forEach[k|configuration.setAttribute(k, controllermap.get(k))]

	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
	}

}

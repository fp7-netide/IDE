package eu.netide.configuration.launcher

import Topology.NetworkEnvironment
import java.util.ArrayList
import java.util.Map
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.emf.common.ui.dialogs.ResourceDialog
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.swt.SWT
import org.eclipse.swt.events.DisposeEvent
import org.eclipse.swt.events.DisposeListener
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.MouseAdapter
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.widgets.Event
import eu.netide.configuration.utils.NetIDE

/**
 * Creates a tab to link topology models and network applications
 * 
 * @author Christian Stritzke
 */
class ControllerDeploymentTab1 extends AbstractLaunchConfigurationTab {

	private Composite comp

	private Text textfield

	private ArrayList<Group> groups = newArrayList()

	private Map<String, String> controllermap = newHashMap()

	//	private Group 
	override createControl(Composite parent) {
		comp = SWTFactory.createComposite(parent, 1, 1, GridData.FILL_HORIZONTAL)

		comp.addDisposeListener(
			new DisposeListener {

				override widgetDisposed(DisposeEvent e) {
					groups.clear
					controllermap.clear
				}

			})

		control = comp
		val g = SWTFactory.createGroup(comp, "Topology Selection", 3, 1, GridData.FILL_HORIZONTAL) //new Group(comp, SWT.NONE)
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
			newArrayList(NetIDE.CONTROLLER_RYU, NetIDE.CONTROLLER_POX, NetIDE.CONTROLLER_PYRETIC,
				NetIDE.CONTROLLER_FLOODLIGHT, NetIDE.CONTROLLER_ODL, NetIDE.CONTROLLER_ENGINE))

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
		c.children.filter[s|s instanceof Composite && (s.getData("type") == "configurator")].forEach[dispose]
		if (text == "Ryu") {
			c.buildAppConfigurator("Ryu App")
		} else if (text == NetIDE.CONTROLLER_POX) {
			c.buildAppConfigurator("POX App")
		} else if (text == NetIDE.CONTROLLER_PYRETIC) {
			c.buildAppConfigurator("Pyretic App")
		} else if (text == "OpenDaylight") {
		} else if (text == NetIDE.CONTROLLER_ENGINE) {
			c.buildCrossControllerConfigurator()
		}
		scheduleUpdateJob
	}

	def buildCrossControllerConfigurator(Group c) {
		val comp = SWTFactory.createComposite(c, 3, 3, GridData.FILL_HORIZONTAL)
		comp.setData("type", "configurator")

		var targetlabel = SWTFactory.createLabel(comp, "Server Controller", 1)
		val targetplatformselector = SWTFactory.createCombo(comp, SWT.READ_ONLY, 2,
			newArrayList(NetIDE.CONTROLLER_RYU, NetIDE.CONTROLLER_POX, NetIDE.CONTROLLER_PYRETIC,
				NetIDE.CONTROLLER_FLOODLIGHT, NetIDE.CONTROLLER_ODL))
		targetplatformselector.setData("type", "crossselector_target")
		targetplatformselector.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					super.widgetSelected(e)
					controllermap.put(String.format("controller_platform_target_%s", c.text),
						targetplatformselector.text)
					scheduleUpdateJob
				}
			})

		val sourcelabel = SWTFactory.createLabel(comp, "Client Controller", 1)

		val sourceplatformselector = SWTFactory.createCombo(comp, SWT.READ_ONLY, 2,
			newArrayList(NetIDE.CONTROLLER_RYU, NetIDE.CONTROLLER_POX, NetIDE.CONTROLLER_PYRETIC,
				NetIDE.CONTROLLER_FLOODLIGHT, NetIDE.CONTROLLER_ODL))
		sourceplatformselector.setData("type", "crossselector_source")

		val subcomp = SWTFactory.createGroup(comp, c.text, 2, 2, GridData.FILL_HORIZONTAL)
		subcomp.setData("type", "configurator")

		sourceplatformselector.setData("type", "platformselector")
		subcomp.buildConfigurator(sourceplatformselector.text)
		sourceplatformselector.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					super.widgetSelected(e)
					controllermap.put(String.format("controller_platform_source_%s", c.text),
						sourceplatformselector.text)
					subcomp.buildConfigurator(sourceplatformselector.text)
					scheduleUpdateJob
				}
			})

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
						case NetIDE.CONTROLLER_RYU: 0
						case NetIDE.CONTROLLER_POX: 1
						case NetIDE.CONTROLLER_PYRETIC: 2
						case NetIDE.CONTROLLER_FLOODLIGHT: 3
						case NetIDE.CONTROLLER_ODL: 4
						case NetIDE.CONTROLLER_ENGINE: 5
						default: 0
					})
				d.notifyListeners(SWT.Selection, new Event())
			}
			if (configuration.attributes.get(String.format("controller_platform_%s", g.text)) as String ==
				"Cross-Controller") {
				for (d : g.children.filter[!disposed].filter(typeof(Composite)).map[children].filter(typeof(Combo)).
					filter(x|x.getData("type").equals("crossselector_target"))) {
					d.select(
						switch (configuration.attributes.get(String.format("controller_platform_target_%s", g.text)) as String) {
							case NetIDE.CONTROLLER_RYU: 0
							case NetIDE.CONTROLLER_POX: 1
							case NetIDE.CONTROLLER_PYRETIC: 2
							case NetIDE.CONTROLLER_FLOODLIGHT: 3
							case NetIDE.CONTROLLER_ODL: 4
							default: 0
						})
					d.notifyListeners(SWT.Selection, new Event())
				}
				for (d : g.children.filter[!disposed].filter(typeof(Composite)).map[children].filter(typeof(Combo)).
					filter(x|x.getData("type").equals("crossselector_source"))) {
					d.select(
						switch (configuration.attributes.get(String.format("controller_platform_source_%s", g.text)) as String) {
							case NetIDE.CONTROLLER_RYU: 0
							case NetIDE.CONTROLLER_POX: 1
							case NetIDE.CONTROLLER_PYRETIC: 2
							case NetIDE.CONTROLLER_FLOODLIGHT: 3
							case NetIDE.CONTROLLER_ODL: 4
							default: 0
						})
					d.notifyListeners(SWT.Selection, new Event())
				}
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

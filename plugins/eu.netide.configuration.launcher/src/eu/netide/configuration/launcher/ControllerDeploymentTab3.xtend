package eu.netide.configuration.launcher

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.emf.common.ui.dialogs.ResourceDialog
import org.eclipse.swt.SWT
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.MouseAdapter
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text

class ControllerDeploymentTab3 extends AbstractLaunchConfigurationTab {

	Text sshHostname

	Text sshPort

	Text vagrantFolder

	Button vagrantRadio

	Button sshRadio

	Group vagrantGroup

	Group sshGroup

	Text sshIdFile

	Text userName

	override createControl(Composite parent) {

		var comp = SWTFactory.createComposite(parent, 1, 1, GridData.FILL_HORIZONTAL)
		control = comp

		this.vagrantRadio = SWTFactory.createRadioButton(comp, "Vagrant")
		this.vagrantRadio.addSelectionListener(new SelectionListener() {
			override widgetDefaultSelected(SelectionEvent e) {
				vagrantGroup.enabled = true
				vagrantGroup.children.forEach[enabled = true]
				sshGroup.enabled = false
				sshGroup.children.forEach[enabled = false]
				scheduleUpdateJob
			}

			override widgetSelected(SelectionEvent e) {
				vagrantGroup.enabled = true
				vagrantGroup.children.forEach[enabled = true]
				sshGroup.enabled = false
				sshGroup.children.forEach[enabled = false]
				scheduleUpdateJob
			}
		})

		this.vagrantGroup = SWTFactory.createGroup(comp, "Vagrant", 3, 1, GridData.FILL_HORIZONTAL)
		this.vagrantGroup.createVagrantSettings

		this.sshRadio = SWTFactory.createRadioButton(comp, "SSH")
		this.sshRadio.addSelectionListener(new SelectionListener() {
			override widgetDefaultSelected(SelectionEvent e) {
				vagrantGroup.enabled = false
				vagrantGroup.children.forEach[enabled = false]
				sshGroup.enabled = true
				sshGroup.children.forEach[enabled = true]
				scheduleUpdateJob
			}

			override widgetSelected(SelectionEvent e) {
				vagrantGroup.enabled = false
				vagrantGroup.children.forEach[enabled = false]
				sshGroup.enabled = true
				sshGroup.children.forEach[enabled = true]
				scheduleUpdateJob
			}
		})

		this.sshGroup = SWTFactory.createGroup(comp, "SSH", 3, 1, GridData.FILL_HORIZONTAL)
		this.sshGroup.createSshSettings

	}

	def createVagrantSettings(Group group) {
		var vfLabel = SWTFactory.createLabel(group, "Vagrantfile folder:", 1)
		this.vagrantFolder = SWTFactory.createSingleText(group, 2)
		this.vagrantFolder.addModifyListener(new ModifyListener() {
			override modifyText(ModifyEvent e) {
				scheduleUpdateJob
			}
		})
	}

	def createSshSettings(Group group) {
		var hostnameLabel = SWTFactory.createLabel(group, "Host Name:", 1)
		this.sshHostname = SWTFactory.createSingleText(group, 2)
		this.sshHostname.addModifyListener(new ModifyListener() {
			override modifyText(ModifyEvent e) {
				scheduleUpdateJob
			}
		})

		var portLabel = SWTFactory.createLabel(group, "Port:", 1)
		this.sshPort = SWTFactory.createSingleText(group, 2)
		this.sshPort.addModifyListener(new ModifyListener() {
			override modifyText(ModifyEvent e) {
				scheduleUpdateJob
			}
		})

		var userLabel = SWTFactory.createLabel(group, "User:", 1)
		this.userName = SWTFactory.createSingleText(group, 2)
		this.userName.addModifyListener(new ModifyListener() {
			override modifyText(ModifyEvent e) {
				scheduleUpdateJob
			}
		})

		var idfileLabel = SWTFactory.createLabel(group, "ID File:", 1)
		this.sshIdFile = SWTFactory.createSingleText(group, 1)
		this.sshIdFile.addModifyListener(new ModifyListener() {
			override modifyText(ModifyEvent e) {
				scheduleUpdateJob
			}
		})

		val chooserbutton = createPushButton(group, "Choose Model", null)
		chooserbutton.addMouseListener(new MouseAdapter() {
			override mouseUp(MouseEvent e) {
				super.mouseUp(e)
				var dialog = new ResourceDialog(Display.getDefault().getActiveShell(), "Title", SWT.SINGLE)
				dialog.open();
				sshIdFile.text = dialog.URIText
			}
		})
	}

	override getName() {
		return "Target"
	}

	override initializeFrom(ILaunchConfiguration configuration) {
		sshRadio.selection = configuration.getAttribute("target.ssh", false)
		sshHostname.text = configuration.getAttribute("target.ssh.hostname", "localhost")
		sshPort.text = configuration.getAttribute("target.ssh.port", "22")
		userName.text = configuration.getAttribute("target.ssh.username", "")
		sshIdFile.text = configuration.getAttribute("target.ssh.idfile", "")

		vagrantRadio.selection = configuration.getAttribute("target.vagrant", true)
		vagrantFolder.text = configuration.getAttribute("target.vagrant.folder", "")
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute("target.ssh", this.sshRadio.selection)
		configuration.setAttribute("target.ssh.hostname", this.sshHostname.text)
		configuration.setAttribute("target.ssh.port", this.sshPort.text)
		configuration.setAttribute("target.ssh.username", this.userName.text)
		configuration.setAttribute("target.ssh.idfile", this.sshIdFile.text)

		configuration.setAttribute("target.vagrant", this.vagrantRadio.selection)
		configuration.setAttribute("target.vagrant.folder", this.vagrantFolder.text)
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute("target.ssh", false)
		configuration.setAttribute("target.ssh.hostname", "localhost")
		configuration.setAttribute("target.ssh.port", "22")
		configuration.setAttribute("target.ssh.username", "")
		configuration.setAttribute("target.ssh.idfile", "")

		configuration.setAttribute("target.vagrant", true)
		configuration.setAttribute("target.vagrant.folder", "")
	}

}
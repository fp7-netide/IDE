package eu.netide.configuration.launcher

import Topology.NetworkEnvironment
import eu.netide.configuration.generator.GenerateActionDelegate
import eu.netide.configuration.generator.vagrantfile.VagrantfileGenerateAction
import eu.netide.configuration.launcher.dummygui.DummyGUI
import eu.netide.configuration.launcher.starters.IStarterRegistry
import eu.netide.configuration.launcher.managers.SshManager
import eu.netide.configuration.launcher.starters.StarterFactory
import eu.netide.configuration.launcher.managers.VagrantManager
import eu.netide.configuration.launcher.starters.backends.Backend
import eu.netide.configuration.launcher.starters.backends.SshBackend
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.PlatformUI

/**
 * Triggers the automatic creation of virtual machines and execution of 
 * controllers on them
 * 
 * @author Christian Stritzke
 */
class ControllerDeploymentDelegate extends LaunchConfigurationDelegate {

	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch,
		IProgressMonitor monitor) throws CoreException {

		if (monitor.isCanceled()) {
			return
		}

		val Boolean isVagrant = configuration.getAttribute("target.vagrant", true)
		val Boolean isSsh = configuration.getAttribute("target.ssh", false)
		val String sshHostname = configuration.getAttribute("target.hostname", "localhost")
		val String sshPort = configuration.getAttribute("target.ssh.port", "22")
		val String sshUsername = configuration.getAttribute("target.ssh.username", "")
		val String sshIdFile = configuration.getAttribute("target.ssh.idfile", "")
		
		var Backend backend
		
		if (isSsh)
			backend = new SshBackend(sshHostname, Integer.parseInt(sshPort), sshUsername, sshIdFile)
		

		var NetIDE_server = ""

		var path = configuration.attributes.get("topologymodel") as String
		generateConfiguration(path)

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(path), true)
		var ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)

		var file = path.IFile

		var vgen = new VagrantfileGenerateAction(file, configuration)
		vgen.run

		if (monitor.isCanceled()) {
			return
		}

		var factory = if (isVagrant) new StarterFactory  else new StarterFactory(backend)
		
		val reg = IStarterRegistry.instance

		if (monitor.isCanceled()) {
			return;
		}
		
		val vagrantManager = new VagrantManager(configuration, monitor)
		val sshManager = new SshManager(configuration, monitor)

		if (isVagrant) {
			vagrantManager.init
			vagrantManager.up
			if(configuration.attributes.get("reprovision") as Boolean) vagrantManager.provision
		}
		
		if (isSsh) {
			sshManager.copyApps
			sshManager.copyTopo
			sshManager.provision
			
		}
		


		// Iterate controllers in the network model and start apps for them 
		for (c : ne.controllers) {
			var controllerplatform = configuration.attributes.get("controller_platform_" + c.name) as String

			if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {
				var backendStarter = factory.createBackendStarter(configuration, c, monitor)
				NetIDE_server = configuration.attributes.get("controller_platform_target_" + c.name) as String // to know if server_platform is ODL #AB
				var shimStarter = factory.createShimStarter(configuration, c, monitor)

				reg.register(backendStarter.safeName, backendStarter)
				backendStarter.asyncStart

				Thread.sleep(2000)

				reg.register(shimStarter.safeName, shimStarter)
				shimStarter.asyncStart

			} else {

				var starter = factory.createSingleControllerStarter(configuration, c, monitor)
				reg.register(starter.safeName, starter)
				starter.asyncStart()

			}

		}

		// Start the debugger if the Apps are started in Debug mode
		if (launch.launchMode.equals("debug")) {
			var debuggerStarter = factory.createDebuggerStarter(configuration, monitor)
			reg.register(debuggerStarter.safeName, debuggerStarter)
			debuggerStarter.asyncStart
		}

		// ODL needs some more time...
//		if (NetIDE_server == NetIDE.CONTROLLER_ODL) {
//			Thread.sleep(30000)
//		} else {
//			Thread.sleep(2000)
//		}
		Thread.sleep(2000)

		// Start Mininet. 
		val mnstarter = factory.createMininetStarter(configuration, monitor)
		reg.register(mnstarter.safeName, mnstarter)
//		mnstarter.syncStart

		Display.getDefault().asyncExec(
			new Runnable() {
				@Override
				override run() {
					var dummygui = PlatformUI.getWorkbench().activeWorkbenchWindow.activePage.showView(
						DummyGUI.ID) as DummyGUI
					if (isVagrant) dummygui.manager = vagrantManager
					if (isSsh) dummygui.manager = sshManager
					dummygui.mininet = mnstarter
				}
			})

	}

	private def generateConfiguration(String path) {

		var resSet = new ResourceSetImpl
		var resource = resSet.getResource(URI.createURI(path), true)

		var env = resource.contents.get(0) as NetworkEnvironment

		var ga = new GenerateActionDelegate
		ga.networkEnvironment = env
		ga.run(null)
	}

	def getIFile(String s) {

		var resSet = new ResourceSetImpl
		var res = resSet.getResource(URI.createURI(s), true)

		var eUri = res.getURI()
		if (eUri.isPlatformResource()) {
			var platformString = eUri.toPlatformString(true)
			return ResourcesPlugin.getWorkspace().getRoot().findMember(platformString)
		}
		return null
	}

}

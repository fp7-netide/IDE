package eu.netide.workbenchconfigurationeditor.editors

import Topology.NetworkEnvironment
import eu.netide.configuration.generator.GenerateActionDelegate
import eu.netide.configuration.generator.vagrantfile.VagrantfileGenerateAction
import eu.netide.configuration.launcher.starters.IStarterRegistry
import eu.netide.configuration.launcher.starters.StarterFactory
import eu.netide.configuration.launcher.starters.VagrantManager
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.Launch
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.core.runtime.IProgressMonitor

class StarterStarter {

	private NetworkEnvironment ne;
	private IResource file;

/**
 * maybe use singleton
 */
	new(String topologyPath) {
		generateConfiguration(topologyPath)

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(topologyPath), true)
		ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)

		file = topologyPath.IFile

	}

	private StarterFactory factory
	private IStarterRegistry reg

	public def startVagrantFromConfig(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		var vgen = new VagrantfileGenerateAction(file, configuration)
		vgen.run

		var launch = new Launch(configuration, "run", null);

		factory = new StarterFactory
		val vagrantManager = new VagrantManager(launch, monitor)
		reg = IStarterRegistry.instance

		vagrantManager.init

		vagrantManager.up

		if(configuration.attributes.get("reprovision") as Boolean) vagrantManager.provision

	}

	public def registerControllerFromConfig(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		// Iterate controllers in the network model and start apps for them 
		for (c : ne.controllers) {
			var controllerplatform = configuration.attributes.get("controller_platform_" + c.name) as String

			if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {
				var backendStarter = factory.createBackendStarter(configuration, c, monitor)
				var NetIDE_server = configuration.attributes.get("controller_platform_target_" + c.name) as String // to know if server_platform is ODL #AB
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

		Thread.sleep(2000)

		// Start Mininet. 
		val mnstarter = factory.createMininetStarter(configuration, monitor)
		reg.register(mnstarter.safeName, mnstarter)
		mnstarter.syncStart
	}

	private def generateConfiguration(String path) {

		var resSet = new ResourceSetImpl
		var resource = resSet.getResource(URI.createURI(path), true)

		var env = resource.contents.get(0) as NetworkEnvironment

		var ga = new GenerateActionDelegate
		ga.networkEnvironment = env
		ga.run(null)
	}

	private def getIFile(String s) {

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
package eu.netide.configuration.launcher

import Topology.NetworkEnvironment
import eu.netide.configuration.generator.GenerateActionDelegate
import eu.netide.configuration.generator.vagrantfile.VagrantfileGenerateAction
import eu.netide.configuration.launcher.starters.StarterFactory
import eu.netide.configuration.preferences.NetIDEPreferenceConstants
import eu.netide.configuration.utils.NetIDE
import java.io.File
import java.util.ArrayList
import java.util.HashMap
import java.util.Map
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.Status
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.RefreshUtil
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

/**
 * Triggers the automatic creation of virtual machines and execution of 
 * controllers on them
 * 
 * @author Christian Stritzke
 */
class ControllerDeploymentDelegate extends LaunchConfigurationDelegate {

	Path location = null

	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch,
		IProgressMonitor monitor) throws CoreException {

		if (monitor.isCanceled()) {
			return
		}

		var NetIDE_server = ""

		val vagrantpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.VAGRANT_PATH, "", null)

		val env = null

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

		var factory = new StarterFactory

		location = new Path(vagrantpath)

		var cmdline = newArrayList(location.toOSString, "init", "ubuntu/trusty32")

		var workingDirectory = file.project.location

		workingDirectory = workingDirectory.append("/gen" + NetIDE.VAGRANTFILE_PATH)

		var File workingDir = null;
		if (workingDirectory != null) {
			workingDir = workingDirectory.toFile()
		}

		if (monitor.isCanceled()) {
			return;
		}

		startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)

		cmdline = newArrayList(location.toOSString, "up")

		var starters = newArrayList()

		if(configuration.attributes.get("reprovision") as Boolean) cmdline.add("--provision")

		startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)

		// Iterate controllers in the network model and start apps for them 
		for (c : ne.controllers) {
			var controllerplatform = configuration.attributes.get("controller_platform_" + c.name) as String

			if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {
				var backendStarter = factory.createBackendStarter(configuration, launch, c, monitor)
				NetIDE_server = configuration.attributes.get("controller_platform_target_" + c.name) as String // to know if server_platform is ODL #AB
				var shimStarter = factory.createShimStarter(configuration, launch, c, monitor)

				backendStarter.asyncStart

				Thread.sleep(2000)

				shimStarter.asyncStart

			} else {

				var starter = factory.createSingleControllerStarter(configuration, launch, c, monitor)
				starters.add(starter)
				starter.asyncStart()

			}

		}

		// Start the debugger if the Apps are started in Debug mode
		if (launch.launchMode.equals("debug")) {
			var debuggerStarter = factory.createDebuggerStarter(configuration, launch, monitor)
			debuggerStarter.asyncStart
		}

		// ODL needs some more time...
		if (NetIDE_server == NetIDE.CONTROLLER_ODL) {
			Thread.sleep(30000)
		} else {
			Thread.sleep(2000)
		}

		// Start Mininet synchronously. 
		// After Mininet is stopped, all other processes are stopped too and the VM halts.
		var mnstarter = factory.createMininetStarter(configuration, launch, monitor)
		mnstarter.syncStart

		starters.forEach[stop]

		if (configuration.attributes.get("shutdown") as Boolean) {
			cmdline = newArrayList(location.toOSString, "halt")
			startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
		}

	}

	def startProcess(ArrayList<String> cmdline, File workingDir, Path location, IProgressMonitor monitor,
		ILaunch launch, ILaunchConfiguration configuration, String[] env) {
		var p = DebugPlugin.exec(cmdline, workingDir, env)

		var IProcess process = null;

		// add process type to process attributes
		var Map<String, String> processAttributes = new HashMap<String, String>();
		var programName = location.lastSegment();
		var ext = location.getFileExtension();
		if (ext != null) {
			programName = programName.substring(0, programName.length() - (ext.length() + 1));
		}
		programName = programName.toLowerCase();
		processAttributes.put(IProcess.ATTR_PROCESS_TYPE, programName)

		if (p != null) {
			monitor.beginTask("Vagrant up", 0);
			process = DebugPlugin.newProcess(launch, p, location.toOSString(), processAttributes);
		}
		if (p == null || process == null) {
			if (p != null) {
				p.destroy();
			}
			throw new CoreException(new Status(IStatus.ERROR, "Bla", "Blub"))
		}

		process.setAttribute(IProcess.ATTR_CMDLINE, generateCommandLine(cmdline))

		while (!process.isTerminated()) {
			try {
				if (monitor.isCanceled()) {
					process.launch.terminate();
				}
				Thread.sleep(50);
			} catch (InterruptedException e) {
			}

			// refresh resources
			RefreshUtil.refreshResources(configuration, monitor)
		}
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

	def generateCommandLine(String[] commandLine) {
		if (commandLine.length < 1) {
			return ""
		}

		val buf = new StringBuffer()

		commandLine.forEach [ a |
			buf.append(' ')
			var characters = a.toCharArray
			val command = new StringBuffer()
			var containsSpace = false
			for (c : characters) {
				if (c == '\"') {
					command.append('\\');
				} else if (c == ' ') {
					containsSpace = true;
				}
				command.append(c)
			}
			if (containsSpace) {
				buf.append('\"');
				buf.append(command);
				buf.append('\"');
			} else {
				buf.append(command);
			}
		]

		return buf.toString
	}
}

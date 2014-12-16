package eu.netide.configuration.launcher

import Topology.NetworkEnvironment
import eu.netide.configuration.generator.GenerateActionDelegate
import eu.netide.configuration.generator.vagrantfile.VagrantfileGenerateAction
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
import org.eclipse.core.runtime.Status
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.RefreshUtil
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.core.runtime.Platform
import static extension eu.netide.configuration.utils.NetIDEUtil.absolutePath
import Topology.Controller
import org.eclipse.core.runtime.IPath

class ControllerDeploymentDelegate extends LaunchConfigurationDelegate {

	Path location = null

	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {

		if (monitor.isCanceled()) {
			return
		}

		val vagrantpath = Platform.getPreferencesService.getString("eu.netide.configuration.preferences", "vagrantPath",
			"", null)

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

		location = new Path(vagrantpath)

		var cmdline = newArrayList(location.toOSString, "init", "ubuntu/trusty64")

		var workingDirectory = file.project.location

		workingDirectory = workingDirectory.append("/gen" + NetIDE.VAGRANTFILE_PATH)

		var File workingDir = null;
		if (workingDirectory != null) {
			workingDir = workingDirectory.toFile()
		}

		if (monitor.isCanceled()) {
			return;
		}

		startProcess(cmdline, workingDir, location, monitor, launch, configuration)

		cmdline = newArrayList(location.toOSString, "up")

		if(configuration.attributes.get("reprovision") as Boolean) cmdline.add("--provision")

		startProcess(cmdline, workingDir, location, monitor, launch, configuration)

		for (c : ne.controllers) {

			var controllerplatform = (configuration.attributes.get("controller_platform_" + c.name) as String)
			var controllerpath = (configuration.attributes.get("controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath

			cmdline = getCommandLine(controllerplatform, controllerpath, c)

			var controllerthread = new Thread() {
				var File workingDir
				var ArrayList<String> cmdline

				def setParameters(File wd, ArrayList<String> cl) {
					this.workingDir = wd
					this.cmdline = cl
				}

				override run() {
					super.run()
					startProcess(cmdline, workingDir, location, monitor, launch, configuration)
				}
			}

			controllerthread.setParameters(workingDir, cmdline)
			controllerthread.start

		}

		cmdline = newArrayList(location.toOSString, "ssh", "-c",
			"sudo python ~/mn-configs/" + if(ne.name != null) ne.name + "_run.py" else "NetworkEnvironment" + "_run.py")

		startProcess(cmdline, workingDir, location, monitor, launch, configuration)

		if (configuration.attributes.get("shutdown") as Boolean) {
			cmdline = newArrayList(location.toOSString, "halt")
			startProcess(cmdline, workingDir, location, monitor, launch, configuration)
		}

	}

	def getCommandLine(String platform, IPath path, Controller c) {

		var cline = switch (platform) {
			case "Ryu": String.format("sudo ryu-manager --ofp-tcp-listen-port=%d controllers/%s/%s", c.portNo, path.removeFileExtension.lastSegment, path.lastSegment)
			case "POX": String.format("PYTHONPATH=$PYTHONPATH:controllers/%s pox/pox.py %s --port=%d", path.removeFileExtension.lastSegment, path.removeFileExtension.lastSegment, c.portNo)
			default: "echo No valid platform specified" 
		}

		newArrayList(location.toOSString, "ssh", "-c", cline)
	}

	def startProcess(ArrayList<String> cmdline, File workingDir, Path location, IProgressMonitor monitor, ILaunch launch,
		ILaunchConfiguration configuration) {
		var p = DebugPlugin.exec(cmdline, workingDir, null as String[])

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
					process.terminate();
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

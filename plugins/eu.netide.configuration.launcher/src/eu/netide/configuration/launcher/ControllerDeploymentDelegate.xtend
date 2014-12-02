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

class ControllerDeploymentDelegate extends LaunchConfigurationDelegate {

	val VAGRANTPATH_LINUX = "/usr/bin/vagrant"

	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {

		if (monitor.isCanceled()) {
			return
		}

		var path = configuration.attributes.get("topologymodel") as String
		generateConfiguration(path)
		
		var controllerPlatformKeys = configuration.attributes.keySet.filter[startsWith("controller_platform_")]
		
		var requiredPlatforms = controllerPlatformKeys.map[k | configuration.attributes.get(k) as String].toList		
		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(path), true)
		var ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)

		var file = path.IFile

		var vgen = new VagrantfileGenerateAction(file, requiredPlatforms)
		vgen.run

		if (monitor.isCanceled()) {
			return
		}

		var location = new Path(VAGRANTPATH_LINUX)

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
		
		if (configuration.attributes.get("reprovision") as Boolean) cmdline.add("--provision")
		
		startProcess(cmdline, workingDir, location, monitor, launch, configuration)
		
		cmdline = newArrayList(location.toOSString, "ssh", "-c", "sudo python ~/mn-configs/" + if (ne.name != null) ne.name else "NetworkEnvironment" + "_run.py")
		
		startProcess(cmdline, workingDir, location, monitor, launch, configuration)
		
		cmdline = newArrayList(location.toOSString, "halt")
		
		startProcess(cmdline, workingDir, location, monitor, launch, configuration)

		
		

	}
	
	def startProcess(ArrayList<String> cmdline, File workingDir, Path location, IProgressMonitor monitor, ILaunch launch, ILaunchConfiguration configuration) {
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

package eu.netide.configuration.launcher.managers

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
import org.eclipse.debug.core.RefreshUtil
import org.eclipse.debug.core.model.IProcess
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.core.runtime.jobs.Job
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.regex.Pattern
import org.eclipse.debug.core.Launch
import org.eclipse.debug.core.ILaunchConfiguration
import java.util.Date
import org.eclipse.ui.internal.console.ConsoleManager
import org.eclipse.debug.internal.core.LaunchManager

class VagrantManager implements IManager {

	private ILaunch launch

	private String vagrantpath

	private File workingDirectory

	private IProgressMonitor monitor

	new(ILaunchConfiguration launchConfiguration, IProgressMonitor monitor) {
		
		this.launch = new Launch(launchConfiguration, "debug", null)
		this.launch.setAttribute("org.eclipse.debug.core.capture_output", "true")
		this.launch.setAttribute("org.eclipse.debug.ui.ATTR_CONSOLE_ENCODING", "UTF-8")
		this.launch.setAttribute("org.eclipse.debug.core.launch.timestamp", new Date().time+"")
		DebugPlugin.getDefault().getLaunchManager().addLaunch(this.launch)
		

		this.monitor = monitor

		this.vagrantpath = new Path(
			Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
				NetIDEPreferenceConstants.VAGRANT_PATH, "", null)).toOSString

		var path = launch.launchConfiguration.attributes.get("topologymodel") as String

		this.workingDirectory = path.getIFile.project.location.append("/gen" + NetIDE.VAGRANTFILE_PATH).toFile
	}

	def up() {
		var cmd = newArrayList(vagrantpath, "up")
		startProcess(cmd)
	}

	def asyncUp() {
		var job = new Job("Vagrant Up") {
			override run(IProgressMonitor monitor) {
				up()
				Status.OK_STATUS
			}
		}
		job.schedule()
	}

	def halt() {
		var cmd = newArrayList(vagrantpath, "halt")
		startProcess(cmd)
	}

	override asyncHalt() {
		var command = new Job("Vagrant Halt") {
			override run(IProgressMonitor monitor) {
				halt()
				Status.OK_STATUS
			}
		}
		command.schedule
	}

	def provision() {
		var cmd = newArrayList(vagrantpath, "provision")
		startProcess(cmd)
	}

	def asyncProvision() {
		var command = new Job("Vagrant Provision") {
			override run(IProgressMonitor monitor) {
				provision()
				Status.OK_STATUS
			}
		}
		command.schedule
	}

	def init() {
		
		var cmd = newArrayList(vagrantpath, "init", "ubuntu/trusty32")
		startProcess(cmd)
	}

	def asyncInit() {
		var command = new Job("Vagrant Init") {
			override run(IProgressMonitor monitor) {
				init()
				Status.OK_STATUS
			}
		}
		command.schedule
	}

	override getRunningSessions() {

		var p = DebugPlugin.exec(newArrayList(vagrantpath, "ssh", "-c", "screen -list"), workingDirectory, null)
		var br = new BufferedReader(new InputStreamReader(p.getInputStream()))
		p.waitFor
		var output = newArrayList()
		var pattern = Pattern.compile("\\d+\\.[\\w\\.]+\\.\\d+")

		var l = br.readLine
		while (l != null) {
			var matcher = pattern.matcher(l)
			if (matcher.find())
				output.add(matcher.group)
			l = br.readLine

		}
		p.waitFor
		return output

	}

	def startProcess(ArrayList<String> cmdline) {

		var workingDir = this.workingDirectory
		var location = new Path(vagrantpath)
		var env = null

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
		processAttributes.put(IProcess.ATTR_PROCESS_LABEL, "Vagrant " + cmdline.get(1))
		
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
			RefreshUtil.refreshResources(launch.launchConfiguration, monitor)
		}
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
package eu.netide.configuration.launcher.managers

import eu.netide.configuration.preferences.NetIDEPreferenceConstants
import eu.netide.configuration.utils.NetIDE
import java.util.ArrayList
import java.util.Date
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
import org.eclipse.debug.core.Launch
import org.eclipse.debug.core.RefreshUtil
import org.eclipse.debug.core.model.IProcess
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.regex.Pattern
import static extension eu.netide.configuration.utils.NetIDEUtil.absolutePath
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.tm.terminal.view.core.TerminalServiceFactory
import org.eclipse.tm.terminal.view.core.interfaces.constants.ITerminalsConnectorConstants
import java.net.URL
import org.eclipse.core.runtime.FileLocator
import org.eclipse.tm.terminal.view.core.interfaces.ITerminalService.Done

class SshManager implements IManager {

	File workingDirectory
	String sshPath
	ILaunch launch
	IProgressMonitor monitor
	String sshHostname
	String sshPort
	String sshUsername
	String sshIdFile

	new(ILaunchConfiguration launchConfiguration, IProgressMonitor monitor) {

		this.launch = new Launch(launchConfiguration, "debug", null)
		this.launch.setAttribute("org.eclipse.debug.core.capture_output", "true")
		this.launch.setAttribute("org.eclipse.debug.ui.ATTR_CONSOLE_ENCODING", "UTF-8")
		this.launch.setAttribute("org.eclipse.debug.core.launch.timestamp", new Date().time + "")
		DebugPlugin.getDefault().getLaunchManager().addLaunch(this.launch)

		this.sshHostname = launchConfiguration.getAttribute("target.hostname", "localhost")
		this.sshPort = launchConfiguration.getAttribute("target.ssh.port", "22")
		this.sshUsername = launchConfiguration.getAttribute("target.ssh.username", "")
		this.sshIdFile = launchConfiguration.getAttribute("target.ssh.idfile", "").absolutePath.toOSString

		this.monitor = monitor

		this.sshPath = new Path(
			Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
				NetIDEPreferenceConstants.SSH_PATH, "", null)).toOSString

		var path = launch.launchConfiguration.attributes.get("topologymodel") as String

		this.workingDirectory = path.getIFile.project.location.append("/gen" + NetIDE.VAGRANTFILE_PATH).toFile
	}

	override getRunningSessions() {
		var cmdline = newArrayList(sshPath, "-i", sshIdFile, "-p", sshPort, sshUsername + "@" + sshHostname,
			"screen -list")
		var p = DebugPlugin.exec(cmdline, workingDirectory, null)
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

	override asyncHalt() {
		val cmdline = newArrayList(sshPath, "-i", sshIdFile, "-p", sshPort, sshUsername + "@" + sshHostname,
			"sudo poweroff")
		var job = new Job("Halt") {
			override protected run(IProgressMonitor monitor) {
				startProcess(cmdline)
				return Status.OK_STATUS
			}
		}
		job.schedule
	}

	def provision() {
		val bundle = Platform.getBundle(NetIDE.LAUNCHER_PLUGIN)
		
		val scriptsfolder = bundle.getEntry("scripts/").scriptpath

		val localScripts = newArrayList(
			"scripts/install_prereq.sh",
			"scripts/install_mininet.sh",
			"scripts/install_ryu.sh",
			"scripts/install_pyretic.sh",
			"scripts/install_pox.sh",
			"scripts/install_odl.sh",
			"scripts/install_engine.sh",
			"scripts/install_logger_debugger.sh",
			"scripts/install_floodlight.sh"
		)

		val fullScripts = newArrayList()

//		var url = bundle.getEntry("scripts/install_prereq.sh")
//		scripts.add(url.scriptpath)
//		url = bundle.getEntry("scripts/install_mininet.sh")
//		val mininetscriptpath = scriptpath(url)
//		url = bundle.getEntry("scripts/install_ryu.sh")
//		val ryuscriptpath = scriptpath(url)
//		url = bundle.getEntry("scripts/install_pyretic.sh")
//		val pyreticscriptpath = scriptpath(url)
//		url = bundle.getEntry("scripts/install_pox.sh")
//		val poxscriptpath = scriptpath(url)
//		url = bundle.getEntry("scripts/install_odl.sh")
//		val odlscriptpath = scriptpath(url)
//		url = bundle.getEntry("scripts/install_engine.sh")
//		val netideenginescriptpath = scriptpath(url)
//		url = bundle.getEntry("scripts/install_logger_debugger.sh")
//		val logger_debuggerscriptpath = scriptpath(url)
//		url = bundle.getEntry("scripts/install_floodlight.sh")
//		val floodlightscriptpath = scriptpath(url)

		startProcess(newArrayList(
			"/usr/bin/scp",
			"-i", sshIdFile,
			"-P", sshPort,
			"-r", scriptsfolder,
			sshUsername+"@"+sshHostname+":"+"."
		))

		localScripts.forEach [ e |
			var url = bundle.getEntry(e)
			startProcess(newArrayList(
				sshPath,
				"-tt",
				"-i", sshIdFile,
				"-p", sshPort,
				sshUsername+"@"+sshHostname,
				"sh ./"+e 
			))
		]

	}

	def startProcess(ArrayList<String> cmdline) {

		var workingDir = this.workingDirectory
		var location = new Path(sshPath)
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
		processAttributes.put(IProcess.ATTR_PROCESS_LABEL, cmdline.last + cmdline.get(1))

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

	private def args() {
		String.format("-i %s -p %s %s@%s", sshIdFile, sshPort, sshUsername, sshHostname)
	}

	private def startTmProcess(String command, Done done) {

		var ts = TerminalServiceFactory.service

		var options = newHashMap(
			ITerminalsConnectorConstants.PROP_TITLE -> "" as Object,
			ITerminalsConnectorConstants.PROP_FORCE_NEW -> true as Object,
			ITerminalsConnectorConstants.PROP_DELEGATE_ID ->
				"org.eclipse.tm.terminal.connector.local.launcher.local" as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_PATH -> sshPath as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_MERGE_ENVIRONMENT -> true as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_ARGS -> args + " " + command as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_WORKING_DIR -> workingDirectory.absolutePath as Object
		)

		ts.openConsole(options, done)

	}

	def scriptpath(URL url) {

		if (Platform.getOS == Platform.OS_LINUX || Platform.getOS == Platform.OS_MACOSX)
			FileLocator.resolve(url).path
		else if (Platform.getOS == Platform.OS_WIN32)
			FileLocator.resolve(url).path.substring(1)
	}

}
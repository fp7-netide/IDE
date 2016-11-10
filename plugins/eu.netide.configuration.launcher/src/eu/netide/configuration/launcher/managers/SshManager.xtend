package eu.netide.configuration.launcher.managers

import eu.netide.configuration.preferences.NetIDEPreferenceConstants
import eu.netide.configuration.utils.NetIDE
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.net.URL
import java.util.ArrayList
import java.util.Date
import java.util.HashMap
import java.util.Map
import java.util.regex.Pattern
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationType
import org.eclipse.debug.core.Launch
import org.eclipse.debug.core.RefreshUtil
import org.eclipse.debug.core.model.IProcess
import org.eclipse.emf.common.util.URI
import org.eclipse.tm.terminal.view.core.TerminalServiceFactory
import org.eclipse.tm.terminal.view.core.interfaces.ITerminalService.Done
import org.eclipse.tm.terminal.view.core.interfaces.constants.ITerminalsConnectorConstants
import org.eclipse.xtend.lib.annotations.Accessors

import static extension eu.netide.configuration.utils.NetIDEUtil.absolutePath

class SshManager implements IManager {

	File workingDirectory
	String sshPath
	String scpPath
	ILaunch launch
	IProgressMonitor monitor
	String sshHostname
	String sshPort
	String sshUsername
	String sshIdFile
	@Accessors(PUBLIC_GETTER)
	IProject project

	@Deprecated
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

		var topofile = launchConfiguration.getAttribute("topologymodel", "").IFile

//		var resset = new ResourceSetImpl
//		var res = resset.getResource(URI.createURI(topofile.fullPath.toString), true)
		this.project = topofile.project

//		var ne = res.allContents.filter(typeof(NetworkEnvironment)).next
//		this.appPaths = ne.controllers.map [
//			var platform = launchConfiguration.attributes.get("controller_platform_" + name)
//			launchConfiguration.attributes.get(String.format("controller_data_%s_%s", name, platform)) as String
//		].toSet.map[e|NetIDEUtil.absolutePath(e)]
		this.monitor = monitor

		this.sshPath = new Path(
			Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
				NetIDEPreferenceConstants.SSH_PATH, "", null)).toOSString

		this.scpPath = new Path(
			Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
				NetIDEPreferenceConstants.SCP_PATH, "", null)).toOSString

		var path = launch.launchConfiguration.attributes.get("topologymodel") as String

		this.workingDirectory = path.getIFile.project.location.toFile
	}

	new(IProject project, IProgressMonitor monitor, String username, String hostname, String port, String idfile) {
		var conf = launchConfigType.newInstance(null, "SSH Session")
		this.launch = new Launch(conf, "debug", null)
		this.launch.setAttribute("org.eclipse.debug.core.capture_output", "true")
		this.launch.setAttribute("org.eclipse.debug.ui.ATTR_CONSOLE_ENCODING", "UTF-8")
		this.launch.setAttribute("org.eclipse.debug.core.launch.timestamp", new Date().time + "")
		DebugPlugin.getDefault().getLaunchManager().addLaunch(this.launch)

		this.sshHostname = hostname
		this.sshPort = port
		this.sshUsername = username
		this.sshIdFile = idfile.absolutePath.toOSString

		// var topofile = launchConfiguration.getAttribute("topologymodel", "").IFile
		this.project = project

		this.monitor = monitor

		this.sshPath = new Path(
			Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
				NetIDEPreferenceConstants.SSH_PATH, "", null)).toOSString

		this.scpPath = new Path(
			Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
				NetIDEPreferenceConstants.SCP_PATH, "", null)).toOSString

		this.workingDirectory = project.location.toFile

	}

	private def getLaunchConfigType() {
		var m = DebugPlugin.getDefault().getLaunchManager();

		for (ILaunchConfigurationType l : m.getLaunchConfigurationTypes()) {

			if (l.getName().equals("NetIDE Controller Deployment")) {

				return l;
			}

		}
		return null;
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

	override execWithReturn(String cmd) {
		var cmdline = newArrayList(sshPath, "-i", sshIdFile, "-p", sshPort, sshUsername + "@" + sshHostname, cmd)
		var p = DebugPlugin.exec(cmdline, workingDirectory, null)
		var br = new BufferedReader(new InputStreamReader(p.getInputStream()))
		p.waitFor
		var output = ""

		var l = br.readLine
		while (l != null) {
			output = output + l + "\n"
			l = br.readLine
		}

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

	override provision() {
		val bundle = Platform.getBundle(NetIDE.LAUNCHER_PLUGIN)

		val scriptsfolder = bundle.getEntry("scripts/").scriptpath

		val localScripts = newArrayList(
			"scripts/install_prereq.sh",
			"scripts/install_engine.sh",
			"scripts/install_mininet.sh",
			"scripts/install_ryu.sh",
			"scripts/install_pyretic.sh",
			"scripts/install_pox.sh",
			"scripts/install_odl.sh",
			"scripts/install_logger_debugger.sh",
			"scripts/install_floodlight.sh"
		)

		val fullScripts = newArrayList()

		startProcess(newArrayList(
			"/usr/bin/scp",
			"-i",
			sshIdFile,
			"-P",
			sshPort,
			"-r",
			scriptsfolder,
			sshUsername + "@" + sshHostname + ":" + "."
		))

		localScripts.forEach [ e |
			var url = bundle.getEntry(e)
			startProcess(newArrayList(
				sshPath,
				"-tt",
				"-i",
				sshIdFile,
				"-p",
				sshPort,
				sshUsername + "@" + sshHostname,
				"bash ./" + e
			))
		]

	}

	override exec(String cmd) {
		startProcess(newArrayList(
			sshPath,
			"-tt",
			"-i",
			sshIdFile,
			"-p",
			sshPort,
			String.format("%s@%s", sshUsername, sshHostname),
			cmd
		))
	}

	def copyApps() {
		copyApps("", "")
	}

	def copyComposition(String source) {
		copyComposition(source, "")
	}

	def copyComposition(String source, String target) {
		exec("rm -rf netide/composition")
		exec("mkdir netide/composition")
		var targetP = target
		if (targetP == null || targetP == ""){
			targetP = NetIDE.COMPOSITION_PATH
			println(targetP)
		}
		scp(source, targetP)

	}

	def copyApps(String source, String target) {
		exec("rm -rf netide/apps")
		var sourceLocation = this.project.location + "/apps"
		if (source != null && source != "")
			sourceLocation = source
		var targetLocation = NetIDE.APP_TARGET_LOCATION

		if (target != null && target != "")
			targetLocation = target

		scp(
			sourceLocation,
			targetLocation
		)
	}

	def copyTopo() {
		copyTopo("", "")
	}

	def copyTopo(String topoPathSource, String topoPathTarget) {
		exec("rm -rf netide/mn-configs")

		var topoPathLocationSource = this.project.location + "/gen/mininet"

		if (topoPathSource != null && topoPathSource != "")
			topoPathLocationSource = topoPathSource

		var topoPathLocationTarget = NetIDE.MN_CONFIG_TARGET_LOCATION

		if (topoPathTarget != null && topoPathTarget != "")
			topoPathLocationTarget = topoPathTarget

		scp(
			topoPathLocationSource,
			topoPathLocationTarget
		)
	}

	def execTM(String cmd) {
		startTmProcess(cmd, null)
	}

	private def scp(String source, String target) {
		startProcess(newArrayList(
			scpPath,
			"-i",
			sshIdFile,
			"-P",
			sshPort,
			"-r",
			source,
			String.format("%s@%s:%s", sshUsername, sshHostname, target)
		))
	}

	def startProcess(ArrayList<String> cmdline) {
		println(cmdline)

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
		var uri = URI.createURI(s)
		var path = new Path(uri.path)
		var file = ResourcesPlugin.getWorkspace().getRoot().findMember(path.removeFirstSegments(1));
		return file
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

	override asyncProvision() {
		provision()
	}

	override asyncUp() {
	}

}

package eu.netide.configuration.launcher.starters.impl

import eu.netide.configuration.launcher.starters.IStarter
import eu.netide.configuration.launcher.starters.backends.Backend
import eu.netide.configuration.launcher.starters.backends.VagrantBackend
import eu.netide.configuration.utils.NetIDE
import java.io.File
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.model.IProcess
import org.eclipse.jface.dialogs.MessageDialog
import org.eclipse.swt.widgets.Display
import org.eclipse.tm.terminal.view.core.TerminalServiceFactory
import org.eclipse.tm.terminal.view.core.interfaces.constants.ITerminalsConnectorConstants
import org.eclipse.xtend.lib.annotations.Accessors

abstract class Starter implements IStarter {

	@Accessors(#[PROTECTED_GETTER, PROTECTED_SETTER])
	private IProcess process

	@Accessors(PROTECTED_GETTER)
	private ILaunchConfiguration configuration

	@Accessors(PROTECTED_GETTER)
	private File workingDir

//	@Accessors(PROTECTED_GETTER)
//	private String vagrantpath
	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER)
	private String name

	@Accessors(PROTECTED_GETTER)
	private String id

	@Accessors(PUBLIC_SETTER)
	private Backend backend

	protected IProgressMonitor monitor

	@Deprecated
	new(String name, ILaunchConfiguration configuration, IProgressMonitor monitor) {
		this(name, configuration, new VagrantBackend, monitor)
	}

	@Deprecated
	new(String name, ILaunchConfiguration configuration, Backend backend, IProgressMonitor monitor) {
		this.name = name
		this.configuration = configuration
		this.monitor = monitor

//		this.vagrantpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
//			NetIDEPreferenceConstants.VAGRANT_PATH, "", null)
		var path = configuration.attributes.get("topologymodel") as String

		var file = path.IFile

		this.workingDir = path.getIFile.project.location.append("/gen" + NetIDE.VAGRANTFILE_PATH).toFile

		this.id = "" + (Math.random * 10000) as int

		this.backend = backend
	}

	new(String name, String path, Backend backend, IProgressMonitor monitor) {
		this.name = name
		// this.configuration = configuration
		this.monitor = monitor

//		this.vagrantpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
//			NetIDEPreferenceConstants.VAGRANT_PATH, "", null)
		// configuration.attributes.get("topologymodel") as String
		this.workingDir = path.getIFile.project.location.append("/gen" + NetIDE.VAGRANTFILE_PATH).toFile

		this.id = "" + (Math.random * 10000) as int

		this.backend = backend
	}

	override void setLaunchConfiguration(ILaunchConfiguration configuration) {
		this.configuration = configuration
	}

	public override syncStart() {
		startProcess(fullCommandLine)
	}

	public override asyncStart() {

		var cmdline = getCommandLine()

		var controllerthread = new Job(name) {
			var File workingDir
			var String cmdline

			def setParameters(File wd, String cl) {
				this.workingDir = wd
				this.cmdline = cl
			}

			override run(IProgressMonitor monitor) {
				// super.run()
				startProcess(fullCommandLine)
				return Status.OK_STATUS
			}
		}

		controllerthread.setParameters(workingDir, cmdline)
		Thread.sleep(2000)
		controllerthread.schedule
	}

	override void stop() {
		var job = new Job("Stop" + name) {
			override protected run(IProgressMonitor monitor) {
				startProcess(
					String.format("\'sudo kill $(ps h --ppid $(screen -ls | grep %s | cut -d. -f1) -o pid)\'",
						safeName))
					return Status.OK_STATUS
				}

			}
			job.schedule
		}

		override void reattach() {
			var job = new Job(name) {
				override protected run(IProgressMonitor monitor) {
					startProcess(String.format("\"screen -r %s\"", safeName))
					return Status.OK_STATUS
				}
			}
			job.schedule
		}

		override getSafeName() {
			return name.replaceAll("[ ()]", "_") + "." + id
		}

		def getIFile(String s) {
			var path = new Path(s)
			var file = ResourcesPlugin.getWorkspace().getRoot().findMember(path.removeFirstSegments(2));
			return file
		}

		private def getFullCommandLine() {
			var cmdline = String.format("\"%s screen -S %s %s\"", environmentVariables, safeName, commandLine)

			return cmdline
		}

		protected def startProcess(String command) {
			if (this.backend == null) {
				noBackendMessage
				return
			}

			var ts = TerminalServiceFactory.service

			var options = newHashMap(
				ITerminalsConnectorConstants.PROP_TITLE -> name as Object,
				ITerminalsConnectorConstants.PROP_FORCE_NEW -> true as Object,
				ITerminalsConnectorConstants.PROP_DELEGATE_ID ->
					"org.eclipse.tm.terminal.connector.local.launcher.local" as Object,
				ITerminalsConnectorConstants.PROP_PROCESS_PATH -> backend.cmdprefix as Object,
				ITerminalsConnectorConstants.PROP_PROCESS_MERGE_ENVIRONMENT -> true as Object,
				ITerminalsConnectorConstants.PROP_PROCESS_ARGS -> backend.args + " " + command as Object,
				ITerminalsConnectorConstants.PROP_PROCESS_WORKING_DIR -> workingDir.absolutePath as Object
			)

			ts.openConsole(options, null)

		}

		override getEnvironmentVariables() {
			return ""
		}

		private def noBackendMessage() {
			MessageDialog.openError(Display.getDefault().activeShell, "Workbench Error",
				"Please set an SSH or Vagrant connection.")

		}

//	def startProcess(ArrayList<String> cmdline) {
//
//		//var workingDir = this.workingDirectory
//		var location = new Path(vagrantpath)
//		var env = null
//
//		var p = DebugPlugin.exec(cmdline, workingDir, env)
//
//		var IProcess process = null;
//
//		// add process type to process attributes
//		var Map<String, String> processAttributes = new HashMap<String, String>();
//		var programName = location.lastSegment();
//		var ext = location.getFileExtension();
//		if (ext != null) {
//			programName = programName.substring(0, programName.length() - (ext.length() + 1));
//		}
//		programName = programName.toLowerCase();
//		processAttributes.put(IProcess.ATTR_PROCESS_TYPE, programName)
//		processAttributes.put(IProcess.ATTR_PROCESS_LABEL, "Vagrant " + cmdline.get(1))
//
//		if (p != null) {
//			monitor.beginTask("Vagrant up", 0);
//			process = DebugPlugin.newProcess(launch, p, location.toOSString(), processAttributes);
//		}
//		if (p == null || process == null) {
//			if (p != null) {
//				p.destroy();
//			}
//			throw new CoreException(new Status(IStatus.ERROR, "Bla", "Blub"))
//		}
//
//		process.setAttribute(IProcess.ATTR_CMDLINE, generateCommandLine(cmdline))
//
//		while (!process.isTerminated()) {
//			try {
//				if (monitor.isCanceled()) {
//					process.launch.terminate();
//				}
//				Thread.sleep(50);
//			} catch (InterruptedException e) {
//			}
//
//			// refresh resources
//			RefreshUtil.refreshResources(launch.launchConfiguration, monitor)
//		}
//	}
//	def generateCommandLine(String[] commandLine) {
//		if (commandLine.length < 1) {
//			return ""
//		}
//
//		val buf = new StringBuffer()
//
//		commandLine.forEach [ a |
//			buf.append(' ')
//			var characters = a.toCharArray
//			val command = new StringBuffer()
//			var containsSpace = false
//			for (c : characters) {
//				if (c == '\"') {
//					command.append('\\');
//				} else if (c == ' ') {
//					containsSpace = true;
//				}
//				command.append(c)
//			}
//			if (containsSpace) {
//				buf.append('\"');
//				buf.append(command);
//				buf.append('\"');
//			} else {
//				buf.append(command);
//			}
//		]
//
//		return buf.toString
//	}
	}
	
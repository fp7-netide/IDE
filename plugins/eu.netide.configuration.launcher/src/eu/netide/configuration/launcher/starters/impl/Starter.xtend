package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.launcher.starters.IStarter
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
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.tm.terminal.view.core.TerminalServiceFactory
import org.eclipse.tm.terminal.view.core.interfaces.constants.ITerminalsConnectorConstants
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.core.runtime.jobs.Job

abstract class Starter implements IStarter {

	@Accessors(#[PROTECTED_GETTER, PROTECTED_SETTER])
	private IProcess process

	@Accessors(PROTECTED_GETTER)
	private ILaunchConfiguration configuration

	@Accessors(PROTECTED_GETTER)
	private ILaunch launch

	@Accessors(PROTECTED_GETTER)
	private Controller controller

	@Accessors(PROTECTED_GETTER)
	private File workingDir

	@Accessors(PROTECTED_GETTER)
	private String vagrantpath

	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER)
	private String name
	
	@Accessors(PROTECTED_GETTER)
	private String id

	protected IProgressMonitor monitor

	new(String name, ILaunch launch, ILaunchConfiguration configuration, IProgressMonitor monitor) {
		this.name = name
		this.launch = launch
		this.configuration = configuration
		this.controller = controller
		this.monitor = monitor

		this.vagrantpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.VAGRANT_PATH, "", null)

		var path = configuration.attributes.get("topologymodel") as String

		this.workingDir = path.getIFile.project.location.append("/gen" + NetIDE.VAGRANTFILE_PATH).toFile
		
		this.id = "" + (Math.random*10000) as int
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
				//super.run()
				startProcess(fullCommandLine)
				return Status.OK_STATUS
			}
			

			
		}

		controllerthread.setParameters(workingDir, cmdline)
		Thread.sleep(2000)
		controllerthread.schedule
	}

	override void stop() {
		startProcess(String.format("ssh -c \"sudo kill $(ps h --ppid $(screen -ls | grep %s | cut -d. -f1) -o pid)\"", safeName))
	}

	
	def safeName() {
		return name.replaceAll("[ ()]", "_") + "." + id
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
	
	private def getFullCommandLine() {
		var cmdline = String.format("ssh -c \"%s screen -S %s %s\" -- -t", environmentVariables,
			safeName, commandLine)
			
		return cmdline
	}

	private def startProcess(String command) {

		var ts = TerminalServiceFactory.service

		var options = newHashMap(
			ITerminalsConnectorConstants.PROP_TITLE -> name as Object,
			ITerminalsConnectorConstants.PROP_FORCE_NEW -> true as Object,
			ITerminalsConnectorConstants.PROP_DELEGATE_ID ->
				"org.eclipse.tm.terminal.connector.local.launcher.local" as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_PATH -> vagrantpath as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_MERGE_ENVIRONMENT -> true as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_ARGS -> command as Object,
			ITerminalsConnectorConstants.PROP_PROCESS_WORKING_DIR -> workingDir.absolutePath as Object
		)

		ts.openConsole(options, null)
	}

	override getEnvironmentVariables() {
		return ""
	}

}
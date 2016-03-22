package eu.netide.workbenchconfigurationeditor.controller

import Topology.NetworkEnvironment
import eu.netide.configuration.generator.GenerateActionDelegate
import eu.netide.configuration.generator.vagrantfile.VagrantfileGenerateAction
import eu.netide.configuration.launcher.managers.SshManager
import eu.netide.configuration.launcher.managers.VagrantManager
import eu.netide.configuration.launcher.starters.IStarter
import eu.netide.configuration.launcher.starters.IStarterRegistry
import eu.netide.configuration.launcher.starters.StarterFactory
import eu.netide.configuration.launcher.starters.backends.Backend
import eu.netide.configuration.launcher.starters.backends.SshBackend
import eu.netide.configuration.launcher.starters.backends.SshDoubleTunnelBackend
import eu.netide.configuration.launcher.starters.backends.VagrantBackend
import eu.netide.configuration.launcher.starters.impl.CoreSpecificationStarter
import eu.netide.configuration.launcher.starters.impl.CoreStarter
import eu.netide.configuration.launcher.starters.impl.DebuggerStarter
import eu.netide.configuration.launcher.starters.impl.MininetStarter
import eu.netide.configuration.launcher.starters.impl.OdlShimStarter
import eu.netide.configuration.utils.NetIDE
import eu.netide.configuration.utils.NetIDEUtil
import eu.netide.configuration.utils.fsa.FSAProvider
import eu.netide.deployment.topologyimport.TopologyImportFactory
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel
import eu.netide.workbenchconfigurationeditor.model.UiStatusModel
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.IJobChangeListener
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtend.lib.annotations.Accessors

class ControllerManager {

	private NetworkEnvironment ne;
	private IResource file;
	private IResource wbFile;
	private UiStatusModel statusModel;
	private DebuggerStarter debuggerStarter;

	private static ControllerManager instance = null;

	/**
	 * @param topologyPath may be empty if starter has been initiated 
	 */
	public def static ControllerManager getStarter() {
		if (instance == null) {
			System.err.println("Starter has not been initiated with a topology.");
		}

		return instance;
	}

	public def static void initControllerManager(UiStatusModel statusModel, IFile file) {
		if (instance == null) {
			instance = new ControllerManager(statusModel, file);
		}
	}

	public def createVagrantFile() {
		var fsa2 = FSAProvider.get
		fsa2.project = wbFile.project
		fsa2.generateFolder("gen")

		var vgen = new VagrantfileGenerateAction(wbFile)
		vgen.run
	}

	// private ArrayList<String> controllerName;
//	private ConfigurationHelper configHelper;
	private new(UiStatusModel statusModel, IFile file) {
		this.statusModel = statusModel

		wbFile = file

//		controllerName = new ArrayList<String>
//		configHelper = new ConfigurationHelper(controllerName, statusModel, wbFile)
		configToStarter = new HashMap
		reg = IStarterRegistry.instance
		factory = new StarterFactory()
		this.statusModel.setSshRunning(new Boolean(false));
		this.statusModel.setVagrantRunning(new Boolean(false));
	}

	public def initTopo() {
		generateConfiguration(this.statusModel.topologyModel.topologyPath)
	}

	private StarterFactory factory

	private IStarterRegistry reg

	private VagrantManager vagrantManager;

	private Job vagrantJob

	private SshManager sshManager

	private Job sshJob

	private Backend backend;

	/**
	 * listener may be null
	 */
	private def boolean startVagrantFromConfig(IJobChangeListener listener) {

		if (!this.statusModel.vagrantRunning) {
			backend = new VagrantBackend

			vagrantJob = new Job("VagrantManager") {

				override protected run(IProgressMonitor monitor) {
					vagrantManager = new VagrantManager(wbFile.project, monitor)
					vagrantManager.init

					vagrantManager.up

					statusModel.vagrantRunning = true
					return Status.OK_STATUS;
				}

			};
			vagrantJob.addJobChangeListener(listener);
			vagrantJob.schedule

		// Thread.sleep(2000)
		}

		return this.statusModel.vagrantRunning
	}

	public def startSSH(ArrayList<LaunchConfigurationModel> modelList, SshProfileModel model) {
		startSshWithConfig(null, model)
	}

	public def startSSH(ArrayList<LaunchConfigurationModel> modelList, IJobChangeListener listener,
		SshProfileModel model) {
		startSshWithConfig(listener, model)
	}

	public def copyApps() {
		if (sshManager != null) {
			sshManager.copyApps
			sshManager.copyTopo
		}
	}

	public def importTopology() {
		var topo = execWithReturn(
			"curl -s -u admin:admin http://localhost:8181/restconf/operational/network-topology:network-topology/");
		var topoImport = TopologyImportFactory.instance.createTopologyImport();

		var manager = if(sshManager != null) sshManager else if(vagrantManager != null) vagrantManager
		topoImport.createTopologyModelFromString(topo,
			manager.getProject().getFile("import.topology").getFullPath().toPortableString());
	}

	public def execWithReturn(String cmd) {
		var topo = ""
		if (sshManager != null) {
			topo = sshManager.execWithReturn(cmd)
		} else if (vagrantManager != null) {
			topo = vagrantManager.execWithReturn(cmd)
		}
		return topo
	}

	private def startSshWithConfig(IJobChangeListener listener, SshProfileModel model) {
		if (!this.statusModel.sshRunning) {

			sshJob = new Job("SshManager") {
				override protected run(IProgressMonitor monitor) {

					if (!model.isDoubleTunnel) {
						backend = new SshBackend(model.host, Integer.parseInt(model.port), model.username,
							model.sshIdFile)
					} else {
						backend = new SshDoubleTunnelBackend(model.host, Integer.parseInt(model.port), model.secondHost,
							Integer.parseInt(model.secondPort), model.username, model.secondUsername, model.sshIdFile);
					}
					sshManager = new SshManager(wbFile.project, monitor, model.username, model.host, model.port,
						model.sshIdFile)

					// TODO: extra button 
					// sshManager.provision
					// TODO: add are u sure option
					statusModel.sshRunning = true
					return Status.OK_STATUS
				}
			}
			sshJob.addJobChangeListener(listener)
			sshJob.schedule

			this.statusModel.sshRunning

		}

	}

	public def stopSSH() {
		if (this.statusModel.sshRunning) {
			// if (sshManager != null)
			// sshManager.asyncHalt
			this.statusModel.sshRunning = false
			this.backend = null
			val starter = configToStarter.values

			for (starterList : starter) {
				for (s : starterList) {
					s.backend = this.backend
				}
			}
			mnstarter.backend = this.backend
			serverControllerStarter.backend = this.backend

		}
	}

	public def boolean startVagrant() {
		return startVagrantFromConfig(null)
	}

	public def boolean startVagrant(IJobChangeListener listener) {
		return startVagrantFromConfig(listener)
	}

	public def haltVagrant() {
		this.statusModel.vagrantRunning = false;
		stopMininet
		vagrantManager.asyncHalt()
		this.statusModel.vagrantRunning = false;
		this.statusModel.mininetRunning = false;

	}

	public def stopMininet() {
		this.statusModel.mininetRunning = false
		if (mnstarter != null)
			mnstarter.stop
	}

	public def reattachMininet() {
		if (mnstarter != null)
			mnstarter.reattach
	}

	def reattachStarter() {
		val config = this.statusModel.getModelAtIndex();
		var re = configToStarter.get(config)
		for (r : re)
			r.reattach
	}

	public def reprovision() {
		if (vagrantManager != null) {
			vagrantManager.asyncProvision
		} else if (sshManager != null) {
			sshManager.asyncProvision
		}
	}

	public def stopStarter() {
		val config = this.statusModel.getModelAtIndex();
		config.running = false
		var toStopList = configToStarter.get(config)
		for (toStop : toStopList)
			toStop.stop
	}

	public def stopServerController() {
		if (serverControllerStarter != null) {
			serverControllerStarter.stop
		}
	}

	public def reattachServerController() {

		if (serverControllerStarter != null) {
			serverControllerStarter.reattach
		}
	}

	public def startMininet() {
		if (!this.statusModel.mininetRunning) {
			this.statusModel.mininetRunning = true
			if (mnstarter != null) {
				mnstarter.setBackend(backend)
				mnstarter.asyncStart
			} else {

				//val configuration = configHelper.topoConfiguration

				var jobMin = new Job("min Starter") {

					override protected run(IProgressMonitor monitor) {
						mnstarter = new MininetStarter(statusModel.topologyModel.topologyPath, backend, monitor)
						mnstarter.setBackend(backend)
						// Start Mininet. 
						reg.register(mnstarter.safeName, mnstarter)
						mnstarter.syncStart
						return Status.OK_STATUS
					}

				};
				jobMin.schedule();
			}
		}
	}

	private IStarter serverControllerStarter;

	public def startServerController(String serverController) {
		// create shim starter		
//		for (c : ne.controllers) {
		var job = new Job("Shim Server") {
			override protected run(IProgressMonitor monitor) {

				serverControllerStarter = new OdlShimStarter(
					NetIDEUtil.toPlatformUri(wbFile),
					7733,
					monitor
				)
				serverControllerStarter.backend = backend
				serverControllerStarter.asyncStart

				return Status.OK_STATUS
			}
		}
		job.schedule
//		Thread.sleep(2000)
//		}
	}

	private HashMap<LaunchConfigurationModel, ArrayList<IStarter>> configToStarter;

	private IStarter backendStarter;

	private IStarter starter;

	private IStarter mnstarter;

	public def startApp() {

		val launchConfigurationModel = this.statusModel.modelAtIndex;
		launchConfigurationModel.running = true

		var tmpstarterList = configToStarter.get(launchConfigurationModel)

		if (tmpstarterList == null) {
			tmpstarterList = new ArrayList<IStarter>
		} else {

			for (starter : tmpstarterList) {

				starter.setBackend(backend)
				starter.asyncStart;
			}
			return;
		}
		val starterList = tmpstarterList

		val controllerplatform = launchConfigurationModel.platform
		val path = launchConfigurationModel.appPath
		val port = Integer.parseInt(launchConfigurationModel.appPort)

		if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {
			var job = new Job("BackendStarter") {
				override run(IProgressMonitor monitor) {
					backendStarter = factory.createBackendStarter(launchConfigurationModel.clientController, path, port,
						monitor)
					starterList.add(backendStarter)
					backendStarter.backend = backend
					configToStarter.put(launchConfigurationModel, starterList)
					reg.register(backendStarter.safeName, backendStarter)
					backendStarter.syncStart
					return Status.OK_STATUS
				}
			}
			job.schedule

		} else {

			var jobSingle = new Job("single Starter") {

				override protected run(IProgressMonitor monitor) {
					starter = factory.createSingleControllerStarter(controllerplatform, path, port, monitor)
					starter.setBackend(backend)
					reg.register(starter.safeName, starter)
					starterList.add(starter)
					configToStarter.put(launchConfigurationModel, starterList)
					starter.syncStart
					return Status.OK_STATUS
				}

			};
			jobSingle.schedule();
		// Thread.sleep(2000)
		}

		Thread.sleep(2000)

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

	private Job startDebuggerJob;

	public def startDebugger() {
		val debuggerJob = new Job("Debugger") {
			override protected run(IProgressMonitor monitor) {
				if (debuggerStarter == null) {
					debuggerStarter = new DebuggerStarter(backend, NetIDEUtil.toPlatformUri(wbFile), monitor)
				}
				if (!statusModel.debuggerRunning) {
					startDebuggerJob.schedule
				}
				return Status.OK_STATUS
			}
		}

		startDebuggerJob = new Job("Start Debugger") {
			override protected run(IProgressMonitor monitor) {
				debuggerStarter.backend = backend
				debuggerStarter.syncStart
				statusModel.debuggerRunning = true
				return Status.OK_STATUS
			}
		}

		debuggerJob.schedule
	}

	public def stopDebugger() {
		if (debuggerStarter != null && statusModel.debuggerRunning) {
			debuggerStarter.stop
			statusModel.debuggerRunning = false
		}
	}

	public def reattachDebugger() {
		if (debuggerStarter != null && statusModel.debuggerRunning) {
			debuggerStarter.reattach
		}
	}

	@Accessors(PUBLIC_GETTER)
	private IStarter coreStarter;

	private Job startCoreJob;

	public def startCore() {

		val coreJob = new Job("CoreManager") {

			override protected run(IProgressMonitor monitor) {

				if (coreStarter == null) {
//					coreStarter = factory.createCoreStarter(configHelper.getTopoConfiguration, monitor)
					coreStarter = new CoreStarter(backend,
						URI.createPlatformResourceURI(wbFile.fullPath.toString, false).toString, monitor)
				}
				if (!statusModel.coreRunning)
					startCoreJob.schedule
				return Status.OK_STATUS;
			}

		};

		startCoreJob = new Job("StartCoreManager") {

			override protected run(IProgressMonitor monitor) {
				coreStarter.backend = backend
				coreStarter.syncStart
				statusModel.coreRunning = true
				return Status.OK_STATUS;
			}

		};

		coreJob.schedule

	}

	public def stopCore() {

		if (coreStarter != null && statusModel.coreRunning) {
			coreStarter.stop
			statusModel.coreRunning = false
		}
	}

	public def reattachCore() {
		if (coreStarter != null && statusModel.coreRunning) {
			coreStarter.reattach
		}
	}

	private CoreSpecificationStarter compositionStarter;

	public def loadComposition() {
		val compositionJob = new Job("CompositionJob") {
			override protected run(IProgressMonitor monitor) {
				// configuration needs to contain topology path !
				compositionStarter = new CoreSpecificationStarter(statusModel.compositionModel.compositionPath,
					backend, monitor);
				compositionStarter.backend = backend;
				compositionStarter.syncStart
				return Status.OK_STATUS
			}
		}

		compositionJob.schedule
	}

}

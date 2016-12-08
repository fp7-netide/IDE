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
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.IJobChangeListener
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtend.lib.annotations.Accessors

class ControllerManager {

	private IResource wbFile;
	private UiStatusModel statusModel;
	private DebuggerStarter debuggerStarter;

	private IStarter serverControllerStarter;

	private HashMap<LaunchConfigurationModel, IStarter> configToStarter;

	private IStarter backendStarter;

	private IStarter starter;

	private IStarter mnstarter;

	private StarterFactory factory

	private IStarterRegistry reg

	private VagrantManager vagrantManager;

	private Job vagrantJob

	private SshManager sshManager

	private Job sshJob

	@Accessors(PUBLIC_GETTER)
	private Backend backend;

	private CoreSpecificationStarter compositionStarter;

	@Accessors(PUBLIC_GETTER)
	private IStarter coreStarter;

	public def createVagrantFile() {
		var fsa2 = FSAProvider.get
		fsa2.project = wbFile.project
		fsa2.generateFolder("gen")

		var vgen = new VagrantfileGenerateAction(wbFile)
		vgen.run
	}

	new(UiStatusModel statusModel, IFile file) {
		this.statusModel = statusModel

		wbFile = file

		configToStarter = new HashMap
		reg = IStarterRegistry.instance
		factory = new StarterFactory()
		this.statusModel.setSshRunning(new Boolean(false));
		this.statusModel.setVagrantRunning(new Boolean(false));
	}

	public def initTopo() {
		generateConfiguration(this.statusModel.topologyModel.topologyPath)
	}

	/**
	 * listener may be null
	 */
	private def boolean startVagrantFromConfig(IJobChangeListener listener) {

		if (!this.statusModel.vagrantRunning) {
			this.updateBackend(new VagrantBackend)
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
			sshManager.copyApps(this.statusModel.sshModelAtIndex.appSource, this.statusModel.sshModelAtIndex.appTarget)

		}
	}

	public def copyTopology() {
		if (sshManager != null)
			sshManager.copyTopo(this.statusModel.sshModelAtIndex.minConfigSource,
				this.statusModel.sshModelAtIndex.minConfigTarget)
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
						updateBackend(new SshBackend(model.host, Integer.parseInt(model.port), model.username,
							model.sshIdFile));
					} else {
						updateBackend(
							new SshDoubleTunnelBackend(model.host, Integer.parseInt(model.port), model.secondHost,
								Integer.parseInt(model.secondPort), model.username, model.secondUsername,
								model.sshIdFile));
						}
						sshManager = new SshManager(wbFile.project, monitor, model.username, model.host, model.port,
							model.sshIdFile)

						statusModel.sshRunning = true
						return Status.OK_STATUS
					}
				}
				sshJob.addJobChangeListener(listener)
				sshJob.schedule
				this.statusModel.sshRunning = true

			}

		}

		public def stopSSH() {
			if (this.statusModel.sshRunning) {
				reg.keys.forEach[k|reg.get(k).stop]
				// reg.clear
				this.statusModel.coreRunning = false
				this.statusModel.mininetRunning = false
				this.statusModel.debuggerRunning = false
				this.statusModel.serverControllerRunning = false
				this.statusModel.modelList.forEach[m|m.running = false]

			}
		}

		private def updateBackend(Backend backend) {
			this.backend = backend
			if (reg != null) {
				reg.clear
				reg.keys.forEach[k|reg.get(k).backend = this.backend]
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
			this.statusModel.coreRunning = false
			this.statusModel.mininetRunning = false
			this.statusModel.debuggerRunning = false
			this.statusModel.serverControllerRunning = false
			this.statusModel.modelList.forEach[m|m.running = false]
			this.statusModel.vagrantRunning = false;
			this.statusModel.mininetRunning = false;

		}

		public def startMininet() {
			if (!this.statusModel.mininetRunning) {

				var jobMin = new Job("min Starter") {

					override protected run(IProgressMonitor monitor) {

						createMininet(-1)
						mnstarter.syncStart

						return Status.OK_STATUS
					}

				};
				jobMin.schedule();

			}
		}

		public def stopMininet() {
			this.statusModel.mininetRunning = false
			if (mnstarter != null) {
				mnstarter.stop
				reg.remove(mnstarter.safeName)
				mnstarter = null
			}
		}

		public def reattachMininet() {
			if (mnstarter == null)
				recreateStarter(NetIDE.CONTROLLER_MININET)
			if (mnstarter != null)
				mnstarter.reattach
		}

		private def createMininet(int id) {
			createMininet(id, new NullProgressMonitor)
		}

		private def createMininet(int id, IProgressMonitor monitor) {
			mnstarter = new MininetStarter(statusModel.topologyModel.topologyPath, backend, monitor, id)
			mnstarter.setBackend(backend)
			// Start Mininet. 
			reg.register(mnstarter.safeName, mnstarter)

			statusModel.mininetRunning = true

		}

		public def startApp() {

			val launchConfigurationModel = this.statusModel.modelAtIndex;
			launchConfigurationModel.running = true

			val controllerplatform = launchConfigurationModel.platform

			var job = new Job("BackendStarter") {
				override run(IProgressMonitor monitor) {
					if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {
						createStarterBackend(-1, launchConfigurationModel, monitor)

						backendStarter.syncStart
					} else {
						createStarterSingleApp(-1, launchConfigurationModel, monitor)
						starter.syncStart
					}
					return Status.OK_STATUS
				}
			}
			job.schedule
			Thread.sleep(2000)

		}

		private def createStarterSingleApp(int id, LaunchConfigurationModel launchConfigurationModel) {
			createStarterSingleApp(id, launchConfigurationModel, new NullProgressMonitor)
		}

		private def createStarterSingleApp(int id, LaunchConfigurationModel launchConfigurationModel,
			IProgressMonitor monitor) {
			val path = launchConfigurationModel.appPath
			val port = Integer.parseInt(launchConfigurationModel.appPort)
			val controllerplatform = launchConfigurationModel.platform

			var appFolderPath = ""
			if (statusModel.sshRunning)
				appFolderPath = statusModel.sshModelAtIndex.appFolder
			starter = factory.createSingleControllerStarter(controllerplatform, path, port, monitor, appFolderPath,
				launchConfigurationModel.flagApp, id)
			starter.setBackend(backend)
			reg.register(starter.safeName, starter)
			configToStarter.put(launchConfigurationModel, starter)
		}

		def reattachStarter() {

			reattachStarter(null)
		}

		private def createStarterBackend(int id, LaunchConfigurationModel launchConfigurationModel) {
			createStarterBackend(id, launchConfigurationModel, new NullProgressMonitor)
		}

		private def createStarterBackend(int id, LaunchConfigurationModel launchConfigurationModel,
			IProgressMonitor monitor) {

			val path = launchConfigurationModel.appPath
			val port = Integer.parseInt(launchConfigurationModel.appPort)

			var engine = ""

			if (statusModel.sshRunning) {
				engine = statusModel.sshModelAtIndex.engine

			}

			backendStarter = factory.createBackendStarter(launchConfigurationModel.clientController, path, port,
				monitor, engine, launchConfigurationModel.flagBackend, id)
			backendStarter.backend = backend
			configToStarter.put(launchConfigurationModel, backendStarter)

			reg.register(backendStarter.safeName, backendStarter)

			launchConfigurationModel.running = true
		}

		private def selectStarter(LaunchConfigurationModel config) {
			val controllerplatform = config.platform
			if (controllerplatform == NetIDE.CONTROLLER_ENGINE)
				recreateStarter(NetIDE.CONTROLLER_APP_BACKEND, config)
			else {
				switch (controllerplatform) {
					case NetIDE.CONTROLLER_POX: recreateStarter(NetIDE.CONTROLLER_POX, config)
					case NetIDE.CONTROLLER_RYU: recreateStarter(NetIDE.CONTROLLER_RYU, config)
					case NetIDE.CONTROLLER_PYRETIC: recreateStarter(NetIDE.CONTROLLER_PYRETIC, config)
				}
			}
		}

		private def reattachStarter(LaunchConfigurationModel m) {

			var config = m
			if (config == null)
				config = this.statusModel.getModelAtIndex();

			var re = configToStarter.get(config)
			if (re == null) {
				selectStarter(m)

			}
			re = configToStarter.get(config)
			if (re != null)
				re.reattach
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
			var starter = configToStarter.get(config)
			starter.stop
		}

		public def startServerController(
			String serverController,
			String port
		) {

			var job = new Job("Shim Server") {
				override protected run(IProgressMonitor monitor) {
					createShim(-1, monitor)
					serverControllerStarter.asyncStart
					return Status.OK_STATUS
				}
			}
			job.schedule
		}

		public def stopServerController() {
			if (serverControllerStarter != null) {
				serverControllerStarter.stop
				reg.remove(serverControllerStarter.safeName)
				serverControllerStarter = null
			}
		}

		public def reattachServerController() {
			if (serverControllerStarter == null) {
				recreateStarter(NetIDE.CONTROLLER_SHIM)
			}
			if (serverControllerStarter != null) {
				serverControllerStarter.reattach
			}

		}

		private def createShim(int id) {
			createShim(id, new NullProgressMonitor)
		}

		private def createShim(int id, IProgressMonitor monitor) {
			var platform = statusModel.shimModel.shim
			var engine = ""
			var odl = ""

			if (statusModel.sshRunning) {
				engine = statusModel.sshModelAtIndex.engine
				odl = statusModel.sshModelAtIndex.odl
			}
			var port = statusModel.getShimModel().getPort()
			var portInt = 6644;
			if (port != "")
				portInt = Integer.parseInt(port)

			serverControllerStarter = factory.createShimStarter(platform, NetIDEUtil.toPlatformUri(wbFile), portInt,
				monitor, engine, odl, id)

			serverControllerStarter.backend = backend

			reg.register(serverControllerStarter.safeName, serverControllerStarter)

			statusModel.serverControllerRunning = true
		}

		private def generateConfiguration(String path) {

			var resSet = new ResourceSetImpl
			var resource = resSet.getResource(URI.createURI(path), true)

			var env = resource.contents.get(0) as NetworkEnvironment

			var ga = new GenerateActionDelegate
			ga.networkEnvironment = env
			ga.run(null)
		}

		public def startDebugger() {
			val debuggerJob = new Job("Debugger") {
				override protected run(IProgressMonitor monitor) {
					if (debuggerStarter == null) {
						createDebugger(-1, monitor)
						debuggerStarter.syncStart
						return Status.OK_STATUS
					}
				}

			}
			debuggerJob.schedule
		}

		public def stopDebugger() {
			if (debuggerStarter != null && statusModel.debuggerRunning) {
				debuggerStarter.stop
				reg.remove(debuggerStarter.safeName)
				statusModel.debuggerRunning = false
			}
		}

		private def createDebugger(int id) {
			createDebugger(id, new NullProgressMonitor)
		}

		private def createDebugger(int id, IProgressMonitor monitor) {
			var tools = ""
			if (statusModel.sshRunning)
				tools = statusModel.sshModelAtIndex.tools

			debuggerStarter = new DebuggerStarter(backend, NetIDEUtil.toPlatformUri(wbFile), monitor, tools, id);

			reg.register(debuggerStarter.safeName, debuggerStarter)

			debuggerStarter.backend = backend

			statusModel.debuggerRunning = true

		}

		public def reattachDebugger() {
			if (debuggerStarter == null)
				recreateStarter(NetIDE.CONTROLLER_DEBUGGER)
			if (debuggerStarter != null && statusModel.debuggerRunning) {
				debuggerStarter.reattach
			}

		}

		public def startCore() {

			val coreJob = new Job("CoreManager") {
				override protected run(IProgressMonitor monitor) {
					createCore(-1, monitor)
					coreStarter.asyncStart

					return Status.OK_STATUS;
				}

			};

			coreJob.schedule

		}

		private def createCore(int id) {
			createCore(id, new NullProgressMonitor)
		}

		private def createCore(int id, IProgressMonitor monitor) {

			var core = ""
			if (statusModel.sshRunning)
				core = statusModel.sshModelAtIndex.core
			coreStarter = new CoreStarter(backend,
				URI.createPlatformResourceURI(wbFile.fullPath.toString, false).toString, monitor, core, id)

			coreStarter.backend = backend

			statusModel.coreRunning = true
			reg.register(coreStarter.safeName, coreStarter)

		}

		public def stopCore() {

			if (coreStarter != null && statusModel.coreRunning) {
				coreStarter.stop
				reg.remove(coreStarter.safeName)
				statusModel.coreRunning = false
				coreStarter = null
			}
		}

		public def recreateAll() {
			// attach all
			recreateStarter(NetIDE.CONTROLLER_CORE)
			recreateStarter(NetIDE.CONTROLLER_SHIM)
			recreateStarter(NetIDE.CONTROLLER_MININET)
			recreateStarter(NetIDE.CONTROLLER_DEBUGGER)

			for (LaunchConfigurationModel m : statusModel.getModelList()) {
				selectStarter(m)
			}
		}

		public def reattachCore() {
			if (coreStarter == null) {
				recreateStarter(NetIDE.CONTROLLER_CORE)
			}
			if (coreStarter != null && statusModel.coreRunning) {
				coreStarter.reattach
			} else {
			}

		}

		private def recreateStarter(String ident) {
			recreateStarter(ident, null)
		}

		private def recreateStarter(String ident, LaunchConfigurationModel m) {
			var manager = if (sshManager != null)
					sshManager
				else if(vagrantManager != null) vagrantManager
			if (manager != null) {
				val runningSessions = manager.runningSessions;

				for (String session : runningSessions) {
					if (session.contains(ident)) {

						val splitSession = session.split("\\.");

						val id = Integer.parseInt(splitSession.get(splitSession.size - 1))

						switch (ident) {
							case NetIDE.CONTROLLER_CORE:
								this.createCore(id)
							case NetIDE.CONTROLLER_SHIM:
								this.createShim(id)
							case NetIDE.CONTROLLER_APP_BACKEND:
								this.createStarterBackend(id, m)
							case NetIDE.CONTROLLER_RYU,
							case NetIDE.CONTROLLER_POX,
							case NetIDE.CONTROLLER_PYRETIC:
								createStarterSingleApp(id, m)
							case NetIDE.CONTROLLER_MININET:
								this.createMininet(id)
							case NetIDE.CONTROLLER_DEBUGGER:
								this.createDebugger(id)
							default:
								println("No known controller")
						}

					}
				}
			}
		}

		public def loadComposition() {
			val compositionJob = new Job("CompositionJob") {
				override protected run(IProgressMonitor monitor) {
					if (sshManager != null) {
						var file = statusModel.compositionModel.compositionPath.IFile
						var fullpath = file.location

						sshManager.copyComposition(fullpath.toString)
					}

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

		def getIFile(String s) {

			var uri = URI.createURI(s)
			var path = new Path(uri.path)

			var fileName = path.removeFirstSegments(2)

			var projectLocation = path.removeFirstSegments(1).removeLastSegments(1)

			var root = ResourcesPlugin.getWorkspace().getRoot()

			var projectLocationBase = projectLocation.segment(0)

			var myProject = root.getProject(projectLocationBase);

			if (myProject.exists() && !myProject.isOpen())
				myProject.open(null);

			var file = myProject.getFile(fileName)

			return file
		}
	}
	
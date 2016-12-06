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
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.IJobChangeListener
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.core.runtime.NullProgressMonitor

class ControllerManager {

	private IResource wbFile;
	private UiStatusModel statusModel;
	private DebuggerStarter debuggerStarter;

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

	private StarterFactory factory

	private IStarterRegistry reg

	private VagrantManager vagrantManager;

	private Job vagrantJob

	private SshManager sshManager

	private Job sshJob

	@Accessors(PUBLIC_GETTER)
	private Backend backend;

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

		public def stopMininet() {
			this.statusModel.mininetRunning = false
			if (mnstarter != null) {
				mnstarter.stop
				reg.remove(mnstarter.safeName)
				mnstarter = null
			}
		}

		public def reattachMininet() {
			if (mnstarter != null)
				mnstarter.reattach
			else {
				if (sshManager != null) {
					val runningSessions = sshManager.runningSessions;

					for (String session : runningSessions) {
						if (session.contains("Mininet")) {

							val splitSession = session.split("\\.");

							val id = Integer.parseInt(splitSession.get(splitSession.size - 1))

							mnstarter = new MininetStarter(statusModel.topologyModel.topologyPath, backend,
								new NullProgressMonitor, id)
							mnstarter.setBackend(backend)
							// Start Mininet. 
							reg.register(mnstarter.safeName, mnstarter)

							statusModel.mininetRunning = true
							mnstarter.reattach
						}
					}
				}
			}
		}

		def reattachStarter() {

			val config = this.statusModel.getModelAtIndex();
			var re = configToStarter.get(config)
			if (re != null)
				re.reattach
			else {
				// Ryu_Backend + this.appPath.lastSegment.replace("\\.", "_").replaceAll("[ ()]", "_")
				if (sshManager != null) {
					val runningSessions = sshManager.runningSessions;
					val launchConfigurationModel = this.statusModel.modelAtIndex;
					launchConfigurationModel.running = true

					val path = launchConfigurationModel.appPath
					val port = Integer.parseInt(launchConfigurationModel.appPort)

					for (String session : runningSessions) {
						val appPath = getIFile(this.statusModel.getModelAtIndex().appPath).projectRelativePath

						if (session.contains(
							("Ryu Backend  " + appPath.lastSegment.replace("\\.", "_")).replaceAll("[ ()]", "_")) ||
							session.contains(
								("Floodlight Backend" + appPath.lastSegment.replace("\\.", "_")).replaceAll("[ ()]",
									"_")) || session.contains(
									("Pyretic Backend" + appPath.lastSegment.replace("\\.", "_")).replaceAll("[ ()]",
										"_"))) {

								val splitSession = session.split("\\.");

								val id = Integer.parseInt(splitSession.get(splitSession.size - 1))
								var engine = ""

								if (statusModel.sshRunning) {
									engine = statusModel.sshModelAtIndex.engine

								}

								backendStarter = factory.createBackendStarter(launchConfigurationModel.clientController,
									path, port, new NullProgressMonitor, engine, launchConfigurationModel.flagBackend,
									id)
									backendStarter.backend = backend
									configToStarter.put(launchConfigurationModel, backendStarter)

									reg.register(backendStarter.safeName, backendStarter)

									backendStarter.reattach
								}
							}
						}
					}
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

				public def stopServerController() {
					if (serverControllerStarter != null) {
						serverControllerStarter.stop
						reg.remove(serverControllerStarter.safeName)
						serverControllerStarter = null
					}
				}

				public def reattachServerController() {

					if (serverControllerStarter != null) {
						serverControllerStarter.reattach
					} else {
						if (sshManager != null) {
							val runningSessions = sshManager.runningSessions;

							for (String session : runningSessions) {
								if (session.contains("Ryu_Shim") || session.contains("OpenDaylight_Shim") ||
									session.contains("POX_Shim")) {

									val splitSession = session.split("\\.");

									val id = Integer.parseInt(splitSession.get(splitSession.size - 1))

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

									serverControllerStarter = factory.createShimStarter(platform,
										NetIDEUtil.toPlatformUri(wbFile), portInt, new NullProgressMonitor, engine, odl,
										id)

										serverControllerStarter.backend = backend

										reg.register(serverControllerStarter.safeName, serverControllerStarter)

										serverControllerStarter.reattach
										statusModel.serverControllerRunning = true
									}
								}
							} else {
								System.err.println("Can't reattach core. No running process");
							}
						}

					}

					public def startMininet() {
						if (!this.statusModel.mininetRunning) {

//			if (mnstarter != null) {
//				mnstarter.setBackend(backend)
//				mnstarter.asyncStart
//			} else {
							// val configuration = configHelper.topoConfiguration
							var jobMin = new Job("min Starter") {

								override protected run(IProgressMonitor monitor) {

									mnstarter = new MininetStarter(statusModel.topologyModel.topologyPath, backend,
										monitor)
									mnstarter.setBackend(backend)
									// Start Mininet. 
									reg.register(mnstarter.safeName, mnstarter)
									mnstarter.syncStart
									statusModel.mininetRunning = true
									return Status.OK_STATUS
								}

							};
							jobMin.schedule();
//			}
						}
					}

					private IStarter serverControllerStarter;

					public def startServerController(
						String serverController,
						String port
					) {

						var job = new Job("Shim Server") {
							override protected run(IProgressMonitor monitor) {

								var platform = statusModel.shimModel.shim
								var engine = ""
								var odl = ""

								if (statusModel.sshRunning) {
									engine = statusModel.sshModelAtIndex.engine
									odl = statusModel.sshModelAtIndex.odl
								}
								var portInt = 6644;
								if (port != "")
									portInt = Integer.parseInt(port)

								serverControllerStarter = factory.createShimStarter(platform,
									NetIDEUtil.toPlatformUri(wbFile), portInt, monitor, engine, odl)

								serverControllerStarter.backend = backend
								serverControllerStarter.asyncStart
								reg.register(serverControllerStarter.safeName, serverControllerStarter)

								return Status.OK_STATUS
							}
						}
						job.schedule
					}

					private HashMap<LaunchConfigurationModel, IStarter> configToStarter;

					private IStarter backendStarter;

					private IStarter starter;

					private IStarter mnstarter;

					public def startApp() {

						val launchConfigurationModel = this.statusModel.modelAtIndex;
						launchConfigurationModel.running = true

						val controllerplatform = launchConfigurationModel.platform
						val path = launchConfigurationModel.appPath
						val port = Integer.parseInt(launchConfigurationModel.appPort)

						if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {
							var job = new Job("BackendStarter") {
								override run(IProgressMonitor monitor) {

									var engine = ""

									if (statusModel.sshRunning) {
										engine = statusModel.sshModelAtIndex.engine

									}

									backendStarter = factory.createBackendStarter(
										launchConfigurationModel.clientController, path, port, monitor, engine,
										launchConfigurationModel.flagBackend)
									backendStarter.backend = backend
									configToStarter.put(launchConfigurationModel, backendStarter)
									reg.register(backendStarter.safeName, backendStarter)
									backendStarter.syncStart
									return Status.OK_STATUS
								}
							}
							job.schedule

						} else {

							var jobSingle = new Job("single Starter") {

								override protected run(IProgressMonitor monitor) {

									var appFolderPath = ""
									if (statusModel.sshRunning)
										appFolderPath = statusModel.sshModelAtIndex.appFolder
									starter = factory.createSingleControllerStarter(controllerplatform, path, port,
										monitor, appFolderPath, launchConfigurationModel.flagApp)
									starter.setBackend(backend)
									reg.register(starter.safeName, starter)
									configToStarter.put(launchConfigurationModel, starter)
									starter.syncStart
									return Status.OK_STATUS
								}

							};
							jobSingle.schedule();
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

					private Job startDebuggerJob;

					public def startDebugger() {
						val debuggerJob = new Job("Debugger") {
							override protected run(IProgressMonitor monitor) {
								if (debuggerStarter == null) {
									var tools = ""
									if (statusModel.sshRunning)
										tools = statusModel.sshModelAtIndex.tools

									debuggerStarter = new DebuggerStarter(backend, NetIDEUtil.toPlatformUri(wbFile),
										monitor, tools)
									reg.register(debuggerStarter.safeName, debuggerStarter)
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
							reg.remove(debuggerStarter.safeName)
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

// private Job startCoreJob;
					public def startCore() {

						val coreJob = new Job("CoreManager") {
							override protected run(IProgressMonitor monitor) {
								var core = ""
								if (statusModel.sshRunning)
									core = statusModel.sshModelAtIndex.core
								coreStarter = new CoreStarter(backend,
									URI.createPlatformResourceURI(wbFile.fullPath.toString, false).toString, monitor,
									core)

									coreStarter.backend = backend
									coreStarter.asyncStart
									statusModel.coreRunning = true
									reg.register(coreStarter.safeName, coreStarter)

									return Status.OK_STATUS;
								}

							};

							coreJob.schedule

						}

						public def stopCore() {

							if (coreStarter != null && statusModel.coreRunning) {
								coreStarter.stop
								reg.remove(coreStarter.safeName)
								statusModel.coreRunning = false
								coreStarter = null
							}
						}

						public def reattachCore() {
							if (coreStarter != null && statusModel.coreRunning) {
								coreStarter.reattach
							} else {
								if (sshManager != null) {
									val runningSessions = sshManager.runningSessions;

									for (String session : runningSessions) {
										if (session.contains("Core")) {

											val splitSession = session.split("\\.");

											val id = Integer.parseInt(splitSession.get(splitSession.size - 1))

											var core = ""
											if (statusModel.sshRunning)
												core = statusModel.sshModelAtIndex.core
											coreStarter = new CoreStarter(backend,
												URI.createPlatformResourceURI(wbFile.fullPath.toString, false).toString,
												new NullProgressMonitor, core, id)

											coreStarter.backend = backend

											statusModel.coreRunning = true
											reg.register(coreStarter.safeName, coreStarter)

											coreStarter.reattach
										}
									}
								} else {
									System.err.println("Can't reattach core. No running process");
								}
							}
						}

						private CoreSpecificationStarter compositionStarter;

						public def loadComposition() {
							val compositionJob = new Job("CompositionJob") {
								override protected run(IProgressMonitor monitor) {
									if (sshManager != null) {
										var file = statusModel.compositionModel.compositionPath.IFile
										var fullpath = file.location

										sshManager.copyComposition(fullpath.toString)
									}

									// configuration needs to contain topology path !
									compositionStarter = new CoreSpecificationStarter(
										statusModel.compositionModel.compositionPath, backend, monitor);
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
					
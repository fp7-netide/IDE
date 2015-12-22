package eu.netide.workbenchconfigurationeditor.editors

import Topology.NetworkEnvironment
import eu.netide.configuration.generator.GenerateActionDelegate
import eu.netide.configuration.generator.vagrantfile.VagrantfileGenerateAction
import eu.netide.configuration.launcher.managers.VagrantManager
import eu.netide.configuration.launcher.starters.IStarter
import eu.netide.configuration.launcher.starters.IStarterRegistry
import eu.netide.configuration.launcher.starters.StarterFactory
import eu.netide.configuration.utils.NetIDE
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel
import java.util.HashMap
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationType
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import java.util.UUID

class StarterStarter {

	private NetworkEnvironment ne;
	private IResource file;

	private static StarterStarter instance = null;

	/**
	 * @param topologyPath may be empty if starter has been initiated 
	 */
	public def static StarterStarter getStarter(String topologyPath) {
		if (instance == null) {
			if (topologyPath != "") {
				instance = new StarterStarter(topologyPath);
			} else {
				System.err.println("Starter has not been initiated with a topology.");
			}
		}

		return instance;
	}

	private new(String topologyPath) {

		generateConfiguration(topologyPath)

		factory = new StarterFactory
		reg = IStarterRegistry.instance

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(topologyPath), true)
		ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)

		file = topologyPath.IFile
		vagrantIsRunning = false;
		configToStarter = new HashMap
		min = false;

	}

	private StarterFactory factory

	private IStarterRegistry reg

	private VagrantManager vagrantManager;

	private boolean vagrantIsRunning;

	public def boolean startVagrantFromConfig(ILaunchConfiguration configuration) {

		if (!vagrantIsRunning) {

			var job = new Job("VagrantManager") {

				override protected run(IProgressMonitor monitor) {
					vagrantManager = new VagrantManager(configuration, monitor)

					return Status.OK_STATUS;
				}

			};
			job.schedule();

			Thread.sleep(2000)
			var vgen = new VagrantfileGenerateAction(file, configuration)
			vgen.run

			vagrantManager.init

			vagrantManager.up

			vagrantIsRunning = true;
		}
// if(configuration.attributes.get("reprovision") as Boolean) vagrantManager.provision
		return vagrantIsRunning;

	}

	public def haltVagrant() {
		vagrantIsRunning = false;
		min = false;
		vagrantManager.asyncHalt()

	}

	def reattachStarter(LaunchConfigurationModel config) {
		var re = configToStarter.get(config)
		re.reattach
	}

	public def stopStarter(LaunchConfigurationModel config) {
		var toStop = configToStarter.get(config)
		toStop.stop
	}
	
	public def stopServerController(){
		if(serverControllerStarter != null){
			serverControllerStarter.stop
		}
	}

	private IStarter serverControllerStarter;

	public def startServerController(String serverController) {
		val config = createServerControllerConfiguration(serverController)

		if (!vagrantIsRunning) {
			// start vagrant
			startVagrantFromConfig(config)
		}

		// create shim starter		
		for (c : ne.controllers) {
			System.out.println(c.name)
			var job = new Job("Shim Server") {
				override protected run(IProgressMonitor monitor) {
					serverControllerStarter = factory.createShimStarter(config, c, monitor) // config controller monitor
					serverControllerStarter.syncStart

					return Status.OK_STATUS
				}
			}
			job.schedule
			Thread.sleep(2000)
		}
	}

	private HashMap<LaunchConfigurationModel, IStarter> configToStarter;

	private IStarter backendStarter;
	private IStarter shimStarter;
	private IStarter starter;
	private IStarter mnstarter;
	private boolean min;

	public def registerControllerFromConfig(LaunchConfigurationModel launchConfigurationModel) {

		val configuration = createLaunchConfiguration(launchConfigurationModel)

		if (!vagrantIsRunning) {
			// start vagrant
			startVagrantFromConfig(configuration)
		}

		// Iterate controllers in the network model and start apps for them 
		for (c : ne.controllers) {
			var controllerplatform = configuration.attributes.get("controller_platform_" + c.name) as String

			if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {

				var job = new Job("Backend Starter") {

					override protected run(IProgressMonitor monitor) {
						backendStarter = factory.createBackendStarter(configuration, c, monitor)
						reg.register(backendStarter.safeName, backendStarter)
						backendStarter.syncStart
						return Status.OK_STATUS
					}

				};
				job.schedule();
				Thread.sleep(2000)

				// var NetIDE_server = configuration.attributes.get("controller_platform_target_" + c.name) as String // to know if server_platform is ODL #AB
				var jobShim = new Job("shim Starter") {

					override protected run(IProgressMonitor monitor) {
						shimStarter = factory.createShimStarter(configuration, c, monitor)

						reg.register(shimStarter.safeName, shimStarter)
						shimStarter.syncStart

						return Status.OK_STATUS
					}

				};
				jobShim.schedule();

				Thread.sleep(2000)

			} else {

				var jobSingle = new Job("single Starter") {

					override protected run(IProgressMonitor monitor) {
						starter = factory.createSingleControllerStarter(configuration, c, monitor)
						reg.register(starter.safeName, starter)
						configToStarter.put(launchConfigurationModel, starter)
						starter.syncStart
						return Status.OK_STATUS
					}

				};
				jobSingle.schedule();
				Thread.sleep(2000)

			}

		}

		Thread.sleep(2000)

		if (!min) {
			min = true
			var jobMin = new Job("minn Starter") {

				override protected run(IProgressMonitor monitor) {
					mnstarter = factory.createMininetStarter(configuration, monitor)

					// Start Mininet. 
					reg.register(mnstarter.safeName, mnstarter)
					mnstarter.syncStart
					return Status.OK_STATUS
				}

			};
			jobMin.schedule();

			Thread.sleep(2000)

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

	private def ILaunchConfiguration createServerControllerConfiguration(String serverController) {
		var m = DebugPlugin.getDefault().getLaunchManager();

		for (ILaunchConfigurationType l : m.getLaunchConfigurationTypes()) {

			if (l.getName().equals("NetIDE Controller Deployment")) {
				try {

					var topoPath = new Path(LaunchConfigurationModel.getTopology()).toOSString();

					var c = l.newInstance(null, serverController + UUID);
					c.setAttribute("topologymodel", topoPath);

					// used by shim starter
					
					c.setAttribute("controller_platform_target_c1", serverController);

					c.setAttribute("controller_platform_c1", serverController);
					
					var appPath = "controller_data_c1_".concat(serverController)
					var appPathOS = "";
					c.setAttribute(appPath, appPathOS);

					c.setAttribute("reprovision", false);
					c.setAttribute("shutdown", true);

					return c.doSave();

				} catch (CoreException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		}
		return null;
	}

	private def ILaunchConfiguration createLaunchConfiguration(LaunchConfigurationModel toStart) {

		// format
		// launch Configuration: Network
		// Set: [controller_data_c1_Network
		// Engine=platform:/resource/UC1/app/simple_switch.py,
		// controller_platform_c1=Network Engine,
		// controller_platform_source_c1=Ryu, controller_platform_target_c1=Ryu,
		// reprovision=false, shutdown=true,
		// topologymodel=platform:/resource/UC2/UC2.topology]
		//
		// launch Configuration: New_configuration (1)
		// Set:
		// [controller_data_c1_Ryu=platform:/resource/UC1/app/simple_switch.py,
		// controller_platform_c1=Ryu, reprovision=false, shutdown=true,
		// topologymodel=platform:/resource/UC1/UC1.topology]
		var m = DebugPlugin.getDefault().getLaunchManager();

		for (ILaunchConfigurationType l : m.getLaunchConfigurationTypes()) {

			if (l.getName().equals("NetIDE Controller Deployment")) {
				try {
					if (toStart != null) {
						var topoPath = new Path(LaunchConfigurationModel.getTopology()).toOSString();

						var c = l.newInstance(null, toStart.getAppName() + toStart.getID());
						c.setAttribute("topologymodel", topoPath);
						c.setAttribute("controller_platform_c1", toStart.getPlatform());

						if (toStart.getPlatform().equals(NetIDE.CONTROLLER_ENGINE)) {
							c.setAttribute("controller_platform_source_c1", toStart.getClientController());
							c.setAttribute("controller_platform_target_c1", toStart.getServerController());
						}

						var appPath = "controller_data_c1_".concat(toStart.getPlatform());
						var appPathOS = new Path(toStart.getAppPath()).toOSString();

						c.setAttribute(appPath, appPathOS);

						c.setAttribute("reprovision", false);
						c.setAttribute("shutdown", true);

						return c.doSave();
					}

				} catch (CoreException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		}

		return null;
	}

}
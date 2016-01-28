package eu.netide.workbenchconfigurationeditor.editors

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
import eu.netide.configuration.launcher.starters.backends.VagrantBackend
import eu.netide.configuration.utils.NetIDE
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel
import java.util.ArrayList
import java.util.HashMap
import java.util.UUID
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.IJobChangeListener
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationType
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

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

	public def createVagrantFile(ArrayList<LaunchConfigurationModel> modelList) {
		val configuration = createVagrantConfiguration(modelList)
		var vgen = new VagrantfileGenerateAction(file, configuration)
		vgen.run
	}

	ILaunchConfigurationType configType;
	ArrayList<String> controllerName;

	private new(String topologyPath) {

		generateConfiguration(topologyPath)
		configType = getLaunchConfigType

		factory = new StarterFactory()
		reg = IStarterRegistry.instance

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(topologyPath), true)
		ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)
		controllerName = new ArrayList<String>

		for (c : ne.controllers)
			controllerName.add(c.name)

		file = topologyPath.IFile
		vagrantIsRunning = false;
		configToStarter = new HashMap
		min = false;

	}

	private StarterFactory factory

	private IStarterRegistry reg

	private VagrantManager vagrantManager;

	private boolean vagrantIsRunning;
	private Job vagrantJob

	private SshManager sshManager
	private Job sshJob
	private boolean sshIsRunning

	private Backend backend;

	/**
	 * listener may be null
	 */
	private def boolean startVagrantFromConfig(ILaunchConfiguration configuration, IJobChangeListener listener) {

		if (!vagrantIsRunning) {
			backend = new VagrantBackend

			vagrantJob = new Job("VagrantManager") {

				override protected run(IProgressMonitor monitor) {
					vagrantManager = new VagrantManager(configuration, monitor)
					vagrantManager.init

					vagrantManager.up
					return Status.OK_STATUS;
				}

			};
			vagrantJob.addJobChangeListener(listener);
			vagrantJob.schedule

			// Thread.sleep(2000)
			vagrantIsRunning = true;
		}
// if(configuration.attributes.get("reprovision") as Boolean) vagrantManager.provision
		return vagrantIsRunning;

	}

	public def startSSH(ArrayList<LaunchConfigurationModel> modelList, SshProfileModel model) {
		startSshWithConfig(createSshConfiguration(modelList), null, model)
	}

	public def startSSH(ArrayList<LaunchConfigurationModel> modelList, IJobChangeListener listener,
		SshProfileModel model) {
		startSshWithConfig(createSshConfiguration(modelList), listener, model)
	}

	private def startSshWithConfig(ILaunchConfiguration configuration, IJobChangeListener listener,
		SshProfileModel model) {
		if (!sshIsRunning) {

			sshJob = new Job("SshManager") {
				override protected run(IProgressMonitor monitor) {
					backend = new SshBackend(model.host, Integer.parseInt(model.port), model.username, model.sshIdFile)
					sshManager = new SshManager(configuration, monitor)
					sshManager.copyApps
					sshManager.copyTopo

					// TODO: extra button 
					// sshManager.provision
					// TODO: add are u sure option
					return Status.OK_STATUS
				}
			}
			sshJob.addJobChangeListener(listener)
			sshJob.schedule

			sshIsRunning = true

		}

	}

	public def stopSSH() {
		if (sshIsRunning) {
			sshManager.asyncHalt
		}
	}

	public def boolean startVagrant() {
		return startVagrantFromConfig(createServerControllerConfiguration(NetIDE.CONTROLLER_ENGINE), null)
	}

	public def boolean startVagrant(IJobChangeListener listener) {
		return startVagrantFromConfig(createServerControllerConfiguration(NetIDE.CONTROLLER_ENGINE), listener)
	}

	public def haltVagrant() {
		vagrantIsRunning = false;
		stopMininet
		vagrantManager.asyncHalt()

	}

	public def stopMininet() {
		min = false;
		if (mnstarter != null)
			mnstarter.stop
	}

	def reattachStarter(LaunchConfigurationModel config) {
		var re = configToStarter.get(config)
		for (r : re)
			r.reattach
	}

	public def stopStarter(LaunchConfigurationModel config) {
		var toStopList = configToStarter.get(config)
		for (toStop : toStopList)
			toStop.stop
	}

	public def stopServerController() {
		if (serverControllerStarter != null) {
			serverControllerStarter.stop
		}
	}

	public def startMininet() {
		if (!min) {
			min = true
			if (mnstarter != null) {
				mnstarter.setBackend(backend)
				mnstarter.asyncStart
			} else {
				var topoPath = new Path(LaunchConfigurationModel.getTopology()).toOSString();

				var c = configType.newInstance(null, "mininet" + UUID);
				c.setAttribute("topologymodel", topoPath);
				val configuration = c.doSave

				var jobMin = new Job("min Starter") {

					override protected run(IProgressMonitor monitor) {
						mnstarter = factory.createMininetStarter(configuration, monitor)
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
		val config = createServerControllerConfiguration(serverController)

		if (!vagrantIsRunning && !sshIsRunning) {
			// start vagrant
			startVagrantFromConfig(config, null)
		}

		// create shim starter		
		for (c : ne.controllers) {

			var job = new Job("Shim Server") {
				override protected run(IProgressMonitor monitor) {
					serverControllerStarter = factory.createShimStarter(config, c, monitor) // config controller monitor
					serverControllerStarter.asyncStart

					return Status.OK_STATUS
				}
			}
			job.schedule
			Thread.sleep(2000)
		}
	}

	private HashMap<LaunchConfigurationModel, ArrayList<IStarter>> configToStarter;

	private IStarter backendStarter;
	private IStarter shimStarter;
	private IStarter starter;
	private IStarter mnstarter;
	private boolean min;

	public def startApp(LaunchConfigurationModel launchConfigurationModel) {

		val configuration = createLaunchConfiguration(launchConfigurationModel)
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

		// Iterate controllers in the network model and start apps for them 
		for (c : ne.controllers) {
			var controllerplatform = configuration.attributes.get("controller_platform_" + c.name) as String

			if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {

				var job = new Job("Backend Starter") {

					override protected run(IProgressMonitor monitor) {
						backendStarter = factory.createBackendStarter(configuration, c, monitor)
						starterList.add(backendStarter)
						backendStarter.setBackend(backend)
						configToStarter.put(launchConfigurationModel, starterList)
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
						starterList.add(shimStarter)
						shimStarter.setBackend(backend)
						configToStarter.put(launchConfigurationModel, starterList)
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

	private def ILaunchConfiguration createServerControllerConfiguration(String serverController) {

		try {

			var topoPath = new Path(LaunchConfigurationModel.getTopology()).toOSString();

			var c = configType.newInstance(null, serverController + UUID);
			c.setAttribute("topologymodel", topoPath);

			for (name : controllerName) {
				// used by shim starter
				c.setAttribute("controller_platform_target_".concat(name), serverController);

				c.setAttribute("controller_platform_".concat(name), serverController);

				var appPath = "controller_data_".concat(name).concat("_".concat(serverController))
				var appPathOS = "";
				c.setAttribute(appPath, appPathOS);
			}
			c.setAttribute("reprovision", false);
			c.setAttribute("shutdown", true);

			return c.doSave();

		} catch (CoreException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();

		}
		return null;
	}

	private def ILaunchConfiguration createSshConfiguration(ArrayList<LaunchConfigurationModel> modelList) {

//				this.sshHostname = launchConfiguration.getAttribute("target.hostname", "localhost")
//		this.sshPort = launchConfiguration.getAttribute("target.ssh.port", "22")
//		this.sshUsername = launchConfiguration.getAttribute("target.ssh.username", "")
//		this.sshIdFile = launchConfiguration.getAttribute("target.ssh.idfile", "").absolutePath.toOSString
//
//		var topofile = launchConfiguration.getAttribute("topologymodel", "").IFile
		var topoPath = new Path(LaunchConfigurationModel.getTopology()).toOSString();

		var c = configType.newInstance(null, "sshConfig" + UUID);
		c.setAttribute("topologymodel", topoPath);
		c.setAttribute("target.ssh.port", "22");

		for (model : modelList) {

			for (name : controllerName) {
				c.setAttribute("controller_platform_".concat(name), model.getPlatform());
				// used by shim starter
				var appPath = "controller_data_".concat(name).concat("_".concat(model.getPlatform()));
				var appPathOS = new Path(model.getAppPath()).toOSString();

				c.setAttribute(appPath, appPathOS);
			}
		}
		c.setAttribute("reprovision", false);
		c.setAttribute("shutdown", true);

		return c.doSave();

	}

	private def ILaunchConfiguration createVagrantConfiguration(ArrayList<LaunchConfigurationModel> modelList) {
		var c = configType.newInstance(null, "vagrant" + UUID)
		var topoPath = new Path(LaunchConfigurationModel.getTopology()).toOSString()
		c.setAttribute("topologymodel", topoPath)
		for (model : modelList) {
			for (name : controllerName) {
				c.setAttribute("controller_platform_".concat(name), model.getPlatform());

				if (model.getPlatform().equals(NetIDE.CONTROLLER_ENGINE)) {

					c.setAttribute("controller_platform_source_".concat(name), model.getClientController());

				}

				var appPath = "controller_data_".concat(name).concat("_".concat(model.getPlatform()));
				var appPathOS = new Path(model.getAppPath()).toOSString();

				c.setAttribute(appPath, appPathOS);
			}
		}
		return c.doSave
	}

	private def ILaunchConfigurationType getLaunchConfigType() {
		var m = DebugPlugin.getDefault().getLaunchManager();

		for (ILaunchConfigurationType l : m.getLaunchConfigurationTypes()) {

			if (l.getName().equals("NetIDE Controller Deployment")) {

				return l;
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
		try {
			if (toStart != null) {
				var topoPath = new Path(LaunchConfigurationModel.getTopology()).toOSString();

				var c = configType.newInstance(null, toStart.getAppName() + toStart.getID());
				c.setAttribute("topologymodel", topoPath);

				for (name : controllerName) {
					c.setAttribute("controller_platform_".concat(name), toStart.getPlatform());

					if (toStart.getPlatform().equals(NetIDE.CONTROLLER_ENGINE)) {

						c.setAttribute("controller_platform_source_".concat(name), toStart.getClientController());

					}

					var appPath = "controller_data_".concat(name).concat("_".concat(toStart.getPlatform()));
					var appPathOS = new Path(toStart.getAppPath()).toOSString();

					c.setAttribute(appPath, appPathOS);
				}

				c.setAttribute("reprovision", false);
				c.setAttribute("shutdown", true);

				return c.doSave();
			}

		} catch (CoreException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		return null;
	}

}
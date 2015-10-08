package eu.netide.configuration.launcher

import Topology.Controller
import Topology.NetworkEnvironment
import eu.netide.configuration.generator.GenerateActionDelegate
import eu.netide.configuration.generator.vagrantfile.VagrantfileGenerateAction
import eu.netide.configuration.preferences.NetIDEPreferenceConstants
import eu.netide.configuration.utils.NetIDE
import java.io.File
import java.util.ArrayList
import java.util.HashMap
import java.util.Map
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IPath
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
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

import static extension eu.netide.configuration.utils.NetIDEUtil.absolutePath

/**
 * Triggers the automatic creation of virtual machines and execution of 
 * controllers on them
 * 
 * @author Christian Stritzke
 */
class ControllerDeploymentDelegate extends LaunchConfigurationDelegate {

	Path location = null

	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {

		if (monitor.isCanceled()) {
			return
		}
		
		var NetIDE_server = ""

		val proxyOn = Platform.getPreferencesService.getBoolean(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.PROXY_ON, false, null)

		val proxyAddress = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.PROXY_ADDRESS, "", null)

		val vagrantpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.VAGRANT_PATH, "", null)

		val env = null //if(Platform.getOS == Platform.OS_LINUX && proxyOn) newArrayList("http_proxy=" + proxyAddress,
				//"https_proxy=" + proxyAddress, "HOME=/home/piotr") as String[] else null as String[]

		var path = configuration.attributes.get("topologymodel") as String
		generateConfiguration(path)

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(path), true)
		var ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)

		var file = path.IFile

		var vgen = new VagrantfileGenerateAction(file, configuration)
		vgen.run

		if (monitor.isCanceled()) {
			return
		}

		location = new Path(vagrantpath)

		var cmdline = newArrayList(location.toOSString, "init", "ubuntu/trusty32")

		var workingDirectory = file.project.location

		workingDirectory = workingDirectory.append("/gen" + NetIDE.VAGRANTFILE_PATH)

		var File workingDir = null;
		if (workingDirectory != null) {
			workingDir = workingDirectory.toFile()
		}

		if (monitor.isCanceled()) {
			return;
		}

		startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)

		cmdline = newArrayList(location.toOSString, "up")

		if(configuration.attributes.get("reprovision") as Boolean) cmdline.add("--provision")

		startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)

		for (c : ne.controllers) {
			var controllerplatform = configuration.attributes.get("controller_platform_" + c.name) as String

			if (controllerplatform == NetIDE.CONTROLLER_ENGINE) {
				var serverplatform = configuration.attributes.get("controller_platform_target_" + c.name) as String
				var clientplatform = configuration.attributes.get("controller_platform_source_" + c.name) as String
				
				NetIDE_server = serverplatform // to know if server_platform is ODL #AB

				if (serverplatform == NetIDE.CONTROLLER_POX && clientplatform == NetIDE.CONTROLLER_RYU) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath

					cmdline = getCommandLine("Ryu_backend", clientcontrollerpath, c)

					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}

					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("POX_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
				else if (serverplatform == NetIDE.CONTROLLER_RYU && clientplatform == NetIDE.CONTROLLER_RYU) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Ryu_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("Ryu_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
				else if (serverplatform == NetIDE.CONTROLLER_POX && clientplatform == NetIDE.CONTROLLER_PYRETIC) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Pyretic_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("POX_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}

					Thread.sleep(2000)

					serverthread.setParameters(workingDir, cmdline)
					serverthread.start

				}
				else if (serverplatform == NetIDE.CONTROLLER_RYU && clientplatform == NetIDE.CONTROLLER_PYRETIC) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Pyretic_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("Ryu_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
				else if (serverplatform == NetIDE.CONTROLLER_ODL && clientplatform == NetIDE.CONTROLLER_RYU) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Ryu_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("ODL_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
				else if (serverplatform == NetIDE.CONTROLLER_ODL && clientplatform == NetIDE.CONTROLLER_PYRETIC) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Pyretic_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("ODL_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
				else if (serverplatform == NetIDE.CONTROLLER_POX && clientplatform == NetIDE.CONTROLLER_FLOODLIGHT) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Floodlight_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("POX_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
				else if (serverplatform == NetIDE.CONTROLLER_RYU && clientplatform == NetIDE.CONTROLLER_FLOODLIGHT) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Floodlight_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("Ryu_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
				else if (serverplatform == NetIDE.CONTROLLER_ODL && clientplatform == NetIDE.CONTROLLER_FLOODLIGHT) {
					var clientcontrollerpath = (configuration.attributes.get(
						"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath


					cmdline = getCommandLine("Floodlight_backend", clientcontrollerpath, c)
					
					var clientthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					clientthread.setParameters(workingDir, cmdline)
					clientthread.start

					cmdline = getCommandLine("ODL_Shim", clientcontrollerpath, c)

					var serverthread = new Thread() {
						var File workingDir
						var ArrayList<String> cmdline

						def setParameters(File wd, ArrayList<String> cl) {
							this.workingDir = wd
							this.cmdline = cl
						}

						override run() {
							super.run()
							startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
						}
					}
					
					Thread.sleep(2000)
					
					serverthread.setParameters(workingDir, cmdline)
					serverthread.start
					
					

				}
			} else {

				var controllerpath = (configuration.attributes.get(
					"controller_data_" + c.name + "_" + controllerplatform) as String).absolutePath

				cmdline = getCommandLine(controllerplatform, controllerpath, c)

				var controllerthread = new Thread() {
					var File workingDir
					var ArrayList<String> cmdline

					def setParameters(File wd, ArrayList<String> cl) {
						this.workingDir = wd
						this.cmdline = cl
					}

					override run() {
						super.run()
						startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
					}
				}

				controllerthread.setParameters(workingDir, cmdline)
				Thread.sleep(2000)
				controllerthread.start

			}

		}

		cmdline = newArrayList(location.toOSString, "ssh", "-c", "sudo python ~/Tools/debugger/Ryu_shim/debugger.py")
		var serverthread = new Thread() {
			var File workingDir
			var ArrayList<String> cmdline

			def setParameters(File wd, ArrayList<String> cl) {
				this.workingDir = wd
				this.cmdline = cl
			}

			override run() {
				super.run()
				startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
				}
		}
					
		Thread.sleep(2000)
					
		serverthread.setParameters(workingDir, cmdline)
		serverthread.start
		
		if (NetIDE_server == NetIDE.CONTROLLER_ODL){
			Thread.sleep(90000)
		}
		else{
			Thread.sleep(2000)	
		}
		
		cmdline = newArrayList(location.toOSString, "ssh", "-c",
			"sudo python ~/mn-configs/" +
				if(ne.name != null && ne.name != "") ne.name + "_run.py" else "NetworkEnvironment" + "_run.py")

		startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)

		if (configuration.attributes.get("shutdown") as Boolean) {
			cmdline = newArrayList(location.toOSString, "halt")
			startProcess(cmdline, workingDir, location, monitor, launch, configuration, env)
		}

	}

	def getCommandLine(String platform, IPath path, Controller c) {

		var cline = switch (platform) {
			case "Ryu":
				String.format("sudo ryu-manager --ofp-tcp-listen-port=%d controllers/%s/%s", c.portNo,
					path.removeFileExtension.lastSegment, path.lastSegment)
			case "POX":
				String.format("PYTHONPATH=$PYTHONPATH:controllers/%s pox/pox.py openflow.of_01 --port=%s %s ",
					path.removeFileExtension.lastSegment, c.portNo, path.removeFileExtension.lastSegment)
			case "Pyretic":
				String.format("PYTHONPATH=$PYTHONPATH:controllers/%s:$HOME/pyretic:$HOME/pox $HOME/pyretic/pyretic.py %s",
					path.removeFileExtension.lastSegment, path.removeFileExtension.lastSegment)
			case "POX_Shim":
				String.format("PYTHONPATH=$PYTHONPATH:Engine/ryu-backend/tests pox/pox.py openflow.of_01 --port=%s pox_client", c.portNo)
				//String.format("PYTHONPATH=$PYTHONPATH:Engine/ryu-backend/tests pox/pox.py pox_client") AB
			case "Ryu_Shim":
				String.format("PYTHONPATH=$PYTHONPATH:Engine/ryu-shim sudo ryu-manager --ofp-tcp-listen-port=%s Engine/ryu-shim/ryu_shim.py", c.portNo)
			case "Ryu_backend":
				String.format(
					"PYTHONPATH=$PYTHONPATH:Engine/ryu-backend sudo ryu-manager --ofp-tcp-listen-port 7733 Engine/ryu-backend/backend.py controllers/%s/%s",path.removeFileExtension.lastSegment, path.lastSegment)
					//"PYTHONPATH=$PYTHONPATH:Engine/ryu-backend sudo ryu-manager --ofp-tcp-listen-port 7733 Engine/ryu-backend/backend.py Engine/ryu-backend/tests/%s", 
					//path.removeFileExtension.lastSegment) AB
			case "Pyretic_backend":
				String.format("PYTHONPATH=$PYTHONPATH:pyretic pyretic/pyretic.py -v high -f -m i pyretic.modules.%s",path.removeFileExtension.lastSegment)
			case "ODL_Shim":
				String.format("./openflowplugin/distribution/karaf/target/assembly/bin/karaf")
			case "Floodlight_backend":
				String.format("java -jar $HOME/floodlight/target/floodlight.jar")
			default:
				"echo No valid platform specified"
		}

		newArrayList(location.toOSString, "ssh", "-c", cline)
	}

	def startProcess(ArrayList<String> cmdline, File workingDir, Path location, IProgressMonitor monitor, ILaunch launch,
		ILaunchConfiguration configuration, String[] env) {
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
					process.terminate();
				}
				Thread.sleep(50);
			} catch (InterruptedException e) {
			}

			// refresh resources
			RefreshUtil.refreshResources(configuration, monitor)
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

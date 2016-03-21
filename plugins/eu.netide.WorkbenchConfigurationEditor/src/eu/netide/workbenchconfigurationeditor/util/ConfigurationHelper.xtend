package eu.netide.workbenchconfigurationeditor.util

import eu.netide.configuration.utils.NetIDE
import eu.netide.workbenchconfigurationeditor.model.UiStatusModel
import java.util.ArrayList
import java.util.UUID
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Path
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationType
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.common.util.URI

class ConfigurationHelper {

	private ILaunchConfigurationType configType
	private ArrayList<String> controllerName
	private UiStatusModel statusModel
	private IResource wbFile

	new(ArrayList<String> controllerName, UiStatusModel statusModel, IResource wbFile) {
		configType = getLaunchConfigType
		this.controllerName = controllerName
		this.statusModel = statusModel
		this.wbFile = wbFile
	}

	public def ILaunchConfiguration getTopoConfiguration() {
		var topoPath = new Path(statusModel.getTopologyModel().topologyPath).toString();

		var c = configType.newInstance(null, "CoreConfiguration");
		c.setAttribute("topologymodel", topoPath);
		return c.doSave
	}

	public def ILaunchConfiguration createLaunchConfiguration() {
		val toStart = statusModel.modelAtIndex
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
				var topoPath = new Path(statusModel.getTopologyModel().topologyPath).toString();

				var c = configType.newInstance(null, toStart.getAppName() + toStart.getID());
				c.setAttribute("topologymodel", topoPath);

				for (name : controllerName) {
					c.setAttribute("controller_platform_".concat(name), toStart.getPlatform());

					if (toStart.getPlatform().equals(NetIDE.CONTROLLER_ENGINE)) {

						c.setAttribute("controller_platform_source_".concat(name), toStart.getClientController());

					}

					var appPath = "controller_data_".concat(name).concat("_".concat(toStart.getPlatform()));
					var appPathOS = new Path(toStart.getAppPath()).toString();

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

	public def ILaunchConfiguration createServerControllerConfiguration(String serverController) {

		try {
			var topoPath = URI.createPlatformResourceURI(wbFile.fullPath.toString, false).toString

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

	public def ILaunchConfiguration createSshConfiguration() {
		val modelList = statusModel.modelList
//				this.sshHostname = launchConfiguration.getAttribute("target.hostname", "localhost")
//		this.sshPort = launchConfiguration.getAttribute("target.ssh.port", "22")
//		this.sshUsername = launchConfiguration.getAttribute("target.ssh.username", "")
//		this.sshIdFile = launchConfiguration.getAttribute("target.ssh.idfile", "").absolutePath.toOSString
//
//		var topofile = launchConfiguration.getAttribute("topologymodel", "").IFile
//		var topoPath = new Path(statusModel.getTopologyModel().topologyPath).toString();
		var topoPath = URI.createPlatformResourceURI(wbFile.fullPath.toString, false).toString
		
		var c = configType.newInstance(null, "sshConfig" + UUID);
		c.setAttribute("topologymodel", topoPath);
		c.setAttribute("target.ssh.port", "22");

		for (model : modelList) {

			for (name : controllerName) {
				c.setAttribute("controller_platform_".concat(name), model.getPlatform());
				// used by shim starter
				var appPath = "controller_data_".concat(name).concat("_".concat(model.getPlatform()));
				var appPathOS = new Path(model.getAppPath()).toString();

				c.setAttribute(appPath, appPathOS);
			}
		}

		if (modelList == null) {
			var appPath = "controller_data_".concat("c1").concat("_".concat(NetIDE.CONTROLLER_ODL))
			var appPathOS = "";
			c.setAttribute(appPath, appPathOS);
		}

		c.setAttribute("reprovision", false);
		c.setAttribute("shutdown", true);

		return c.doSave();

	}

	public def ILaunchConfiguration createVagrantConfiguration() {

		var c = configType.newInstance(null, "vagrant" + UUID)
		var topoPath = new Path(statusModel.getTopologyModel().topologyPath).toString()
		c.setAttribute("topologymodel", topoPath)
		c.setAttribute("controller_platform_source_".concat(NetIDE.CONTROLLER_ENGINE), NetIDE.CONTROLLER_ENGINE);
		c.setAttribute("controller_platform_".concat("c1"), NetIDE.CONTROLLER_ODL);
		var appPath = "controller_data_".concat("c1").concat("_".concat(NetIDE.CONTROLLER_ODL))
		var appPathOS = "";
		c.setAttribute(appPath, appPathOS);

		return c.doSave
	}

	public def ILaunchConfigurationType getLaunchConfigType() {
		var m = DebugPlugin.getDefault().getLaunchManager();

		for (ILaunchConfigurationType l : m.getLaunchConfigurationTypes()) {

			if (l.getName().equals("NetIDE Controller Deployment")) {

				return l;
			}

		}
		return null;
	}

}
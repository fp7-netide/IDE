package eu.netide.configuration.launcher.starters.impl

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.core.runtime.IPath
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import Topology.Controller
import static extension eu.netide.configuration.utils.NetIDEUtil.absolutePath
import org.eclipse.core.runtime.IProgressMonitor

abstract class ControllerStarter extends Starter {

	@Accessors(PROTECTED_GETTER)
	private Controller controller

	@Accessors(PROTECTED_GETTER)
	private IPath appPath

	@Accessors(PROTECTED_GETTER)
	private String controllerplatform

	new(String name, ILaunch launch, ILaunchConfiguration configuration, Controller controller,
		IProgressMonitor monitor) {
		super(name, launch, configuration, monitor)

		this.controller = controller

		this.controllerplatform = if (controller != null)
			configuration.attributes.get("controller_platform_" + controller.name) as String
		else
			null

		this.appPath = if (controller != null)
			(configuration.attributes.get("controller_data_" + controller.name + "_" + controllerplatform) as String).
				absolutePath
		else
			null
	}

}
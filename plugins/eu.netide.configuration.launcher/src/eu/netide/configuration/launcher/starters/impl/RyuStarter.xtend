package eu.netide.configuration.launcher.starters.impl

import Topology.Controller
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.xtend.lib.annotations.Accessors

class RyuStarter extends ControllerStarter {

	@Accessors(PUBLIC_GETTER,PUBLIC_SETTER)
	private String appFolderPath
	private String appFlag;

	@Deprecated
	new(ILaunchConfiguration configuration, Controller controller, IProgressMonitor monitor) {
		super(NetIDE.CONTROLLER_RYU, configuration, controller, monitor)
		name = String.format("%s (%s)", name, appPath.lastSegment)
	}

	new(int port, String appPath, IProgressMonitor monitor, String appFolderPath, String appFlag) {
		this("", port, appPath, monitor, appFolderPath, appFlag, -1)
	}

	new(int port, String appPath, IProgressMonitor monitor, String appFolderPath, String appFlag, int id) {
		this("", port, appPath, monitor, appFolderPath, appFlag, id)
	}

	new(String appName, int port, String appPath, IProgressMonitor monitor, String appFolderPath, String appFlag,
		int id) {
		super(NetIDE.CONTROLLER_RYU, port, appPath, monitor, id)

		if (appName != "")
			name = appName + "_" + name;
		if (appFolderPath != null && appFolderPath != "")
			// TODO: validate appFolderPath format
			this.appFolderPath = super.getValidPath(appFolderPath)
		else
			this.appFolderPath = NetIDE.APP_FOLDER

		if (appFlag != null && appFlag != "")
			this.appFlag = appFlag
		else
			this.appFlag = ""

		name = String.format("%s (%s)", name, this.appPath.lastSegment)
	}

	override getCommandLine() {
		var ryuline = String.format("ryu-manager %s --ofp-tcp-listen-port=%d %s%s", appFlag, port, this.appFolderPath,
			getAppPath.removeFirstSegments(1))

		return ryuline
	}

}

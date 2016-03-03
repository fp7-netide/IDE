package eu.netide.configuration.launcher.starters.impl

import Topology.NetworkEnvironment
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

class MininetStarter extends Starter {

	private NetworkEnvironment ne

	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Mininet", configuration, monitor)

		var path = configuration.attributes.get("topologymodel") as String
		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(path), true)
		this.ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)
	}


	override getCommandLine() {
		var mnpath = "sudo python ~/netide/mn-configs/" +
			if(ne.name != null && ne.name != "") ne.name.replaceAll("[-/()]", "_") + "_run.py" else "NetworkEnvironment" + "_run.py"

		return mnpath
	}

}
package eu.netide.configuration.launcher.starters.impl

import Topology.NetworkEnvironment
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.core.runtime.Status
import eu.netide.configuration.launcher.starters.backends.Backend

class MininetStarter extends Starter {

	private NetworkEnvironment ne

	@Deprecated
	new(ILaunchConfiguration configuration, IProgressMonitor monitor) {
		super("Mininet", configuration, monitor)

		var path = configuration.attributes.get("topologymodel") as String
		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(path), true)
		this.ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)
	}

	new(String path, Backend backend, IProgressMonitor monitor) {
		super("Mininet", path, backend, monitor)

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(path), true)
		this.ne = res.contents.filter(typeof(NetworkEnvironment)).get(0)
	}

	override void stop() {
		var job = new Job("Stop" + name) {
			override protected run(IProgressMonitor monitor) {
				startProcess(String.format("\'screen -S %s -p 0 -X stuff \"quit\\n\"\'", safeName))
				return Status.OK_STATUS
			}

		}
		job.schedule
	}

	override getCommandLine() {

		var mnpath = "bash -c \'sudo mn -c && sudo python ~/netide/mn-configs/" + if (ne.name != null && ne.name != "")
			ne.name.replaceAll("[-/()]", "_") + "_run.py\'"
		else
			"NetworkEnvironment" + "_run.py\'"
		println("mininet command line: " + mnpath)
		
	
		return mnpath
	}

}

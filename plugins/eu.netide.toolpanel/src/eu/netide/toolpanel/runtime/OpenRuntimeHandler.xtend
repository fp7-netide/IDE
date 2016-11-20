package eu.netide.toolpanel.runtime

import Topology.NetworkEnvironment
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.handlers.HandlerUtil
import org.eclipse.ui.progress.UIJob

class OpenRuntimeHandler extends AbstractHandler {

	override Object execute(ExecutionEvent event) throws ExecutionException {

		var shell = HandlerUtil.getActiveShell(event);

		var sel = HandlerUtil.getActiveMenuSelection(event);
		var selection = sel as IStructuredSelection;

		var firstElement = selection.getFirstElement() as IFile;

		var resourceset = new ResourceSetImpl()
		var resource = resourceset.getResource(URI.createPlatformResourceURI(firstElement.fullPath.toOSString, true),
			true)
		var ne = resource.allContents.next as NetworkEnvironment

		var job = new OpenDiagramJob(shell.display, "Open Runtime Topology", ne)
		job.schedule

		return null
	}

	static class OpenDiagramJob extends UIJob {

		private NetworkEnvironment env

		new(Display jobDisplay, String name, NetworkEnvironment ne) {
			super(jobDisplay, name)
			this.env = ne
		}

		override runInUIThread(IProgressMonitor monitor) {

			var manager = RuntimeModelManager.instance
			manager.from(env)

			manager.open(monitor)

			return Status.OK_STATUS
		}

	}

}

package eu.netide.deployment.topologyimport.ui.popup.actions;

import org.eclipse.core.resources.IFile;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IObjectActionDelegate;
import org.eclipse.ui.IWorkbenchPart;

import eu.netide.deployment.topologyimport.TopologyImport;
import eu.netide.deployment.topologyimport.TopologyImportFactory;

public class TopologyImportAction implements IObjectActionDelegate {

	private Shell shell;
	private IFile file;

	/**
	 * Constructor for Action1.
	 */
	public TopologyImportAction() {
		super();
	}

	/**
	 * @see IObjectActionDelegate#setActivePart(IAction, IWorkbenchPart)
	 */
	public void setActivePart(IAction action, IWorkbenchPart targetPart) {
		shell = targetPart.getSite().getShell();
	}

	/**
	 * @see IActionDelegate#run(IAction)
	 */
	public void run(IAction action) {
		TopologyImport topologyimport = TopologyImportFactory.instance.createTopologyImport();
		topologyimport.createTopologyModelFromFile(file);
	}

	/**
	 * @see IActionDelegate#selectionChanged(IAction, ISelection)
	 */
	public void selectionChanged(IAction action, ISelection selection) {
		IStructuredSelection sel = (IStructuredSelection) selection;
		file = (IFile) sel.getFirstElement();
	}

}

package workbenchconfigurationeditor.handler;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.handlers.HandlerUtil;

import workbenchconfigurationeditor.editors.ConfigurationEditorInput;
import workbenchconfigurationeditor.editors.WbConfigurationEditor;
import workbenchconfigurationeditor.model.LaunchConfigurationModel;

public class CallEditor extends AbstractHandler {

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
	    // get the page
	    IWorkbenchWindow window = HandlerUtil.getActiveWorkbenchWindow(event);
	    IWorkbenchPage page = window.getActivePage();
	    // get the selection
	    ISelection selection = HandlerUtil.getCurrentSelection(event);
	    if (selection != null && selection instanceof IStructuredSelection) {
	      Object obj = ((IStructuredSelection) selection).getFirstElement();
	      // if we had a selection lets open the editor
	      if (obj != null) {
	        LaunchConfigurationModel config = (LaunchConfigurationModel) obj;
	        ConfigurationEditorInput input = new ConfigurationEditorInput(config.getID());
	        try {
	          page.openEditor(input, WbConfigurationEditor.ID);
	        } catch (PartInitException e) {
	          throw new RuntimeException(e);
	        }
	      }
	    }
	    return null;
	}

}

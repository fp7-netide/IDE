package eu.netide.parameters.templates.copy;

import java.io.StringWriter;

import org.apache.commons.io.IOUtils;
import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.resources.IFile;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.handlers.HandlerUtil;

import eu.netide.configuration.utils.fsa.FileSystemAccess;

public class CopyHandler extends AbstractHandler {

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		Shell shell = HandlerUtil.getActiveShell(event);

		ISelection sel = HandlerUtil.getActiveMenuSelection(event);
		IStructuredSelection selection = (IStructuredSelection) sel;

		try {
			IFile firstElement = (IFile) selection.getFirstElement();
			if (!firstElement.getProjectRelativePath().segment(0).equals("apps")) {
				noAppFile(shell);
			}
			FileSystemAccess fsa = new FileSystemAccess();
			fsa.setOutputDirectory("./templates");
			fsa.setProject(firstElement.getProject());

			StringWriter writer = new StringWriter();
			IOUtils.copy(firstElement.getContents(), writer, firstElement.getCharset());
			String theString = writer.toString();
			fsa.generateFile(firstElement.getProjectRelativePath().removeFirstSegments(1).toString() + ".hbs", 
					theString);
			// if (firstElement.location)

		} catch (Exception e) {
			noAppFile(shell);
		}

		return null;
	}

	private void noAppFile(Shell shell) {
		MessageDialog.openError(shell, "Error", "Please select an app file");
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return true;
	}

}

package eu.netide.parameters.templates;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.commands.IHandlerListener;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.handlers.HandlerUtil;

public class RenderHandler extends AbstractHandler {

	@Override
	public void addHandlerListener(IHandlerListener handlerListener) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean isEnabled() {
		return true;
	};

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		Shell shell = HandlerUtil.getActiveShell(event);
		
		ISelection sel = HandlerUtil.getActiveMenuSelection(event);
		IStructuredSelection selection = (IStructuredSelection) sel;

		Object firstElement = selection.getFirstElement();
		
		IFile file = null;
		
		if (firstElement instanceof IProject) {
			file = ((IProject) firstElement).getFile("parameters.json");
		} else if (firstElement instanceof IFile) {
			file = (IFile) firstElement;
		}
		
		//String path = firstElement.getProject().getLocationURI().getRawPath();
				
		
		BufferedReader br = null;
		try {
			InputStream is = new FileInputStream(file.getLocation().toFile());
			InputStreamReader isr = new InputStreamReader(is);
			br = new BufferedReader(isr);

			String s = "";
			String line;

			while ((line = br.readLine()) != null) {
				s += line + "\n";
			}
			
			
			
			TemplateRenderer helper = new TemplateRenderer();
			helper.renderTemplates(s, file.getProject(), shell);
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		

		return null;
	}

}

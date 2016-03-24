package eu.netide.parameters.templates.gui;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.handlers.HandlerUtil;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import eu.netide.parameters.language.paramschema.ParameterSchema;
import eu.netide.parameters.templates.TemplateRenderer;

@SuppressWarnings("unused")
public class ConfigureParametersHandler extends AbstractHandler {

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		Shell shell = HandlerUtil.getActiveShell(event);
		
		ISelection sel = HandlerUtil.getActiveMenuSelection(event);
		IStructuredSelection selection = (IStructuredSelection) sel;

		IProject firstElement = (IProject) selection.getFirstElement();
		
		ParameterSchemaParser parser = new ParameterSchemaParser();
		HashMap<String, ParameterSchema> schemas = parser.parse(firstElement);
		
		
		try {
			ObjectMapper om = new ObjectMapper();
			ObjectNode node = (ObjectNode) om.readTree(firstElement.findMember("parameters.json").getLocation().toFile());
			IFile file = firstElement.getFile("parameters.json");
			ParameterConfigurationShell confDialog = new ParameterConfigurationShell(Display.getDefault(), schemas, file, node);
			confDialog.open();
		} catch (Exception e) {
			IFile file = firstElement.getFile("parameters.json");
			ParameterConfigurationShell confDialog = new ParameterConfigurationShell(Display.getDefault(), schemas, file);
			confDialog.open();
		}
		

		
		return null;
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return true;
	}


}

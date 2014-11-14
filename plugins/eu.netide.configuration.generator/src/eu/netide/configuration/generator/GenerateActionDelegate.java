package eu.netide.configuration.generator;

import org.eclipse.jface.action.IAction;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IObjectActionDelegate;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.xtext.builder.EclipseResourceFileSystemAccess2;
import org.eclipse.xtext.generator.AbstractFileSystemAccess2;
import org.eclipse.xtext.generator.IFileSystemAccess;

import Topology.NetworkEnvironment;

import com.google.inject.Guice;
import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;

public class GenerateActionDelegate implements IObjectActionDelegate{

	@Inject
	private Provider<AbstractFileSystemAccess2> fsa;
	
	private NetworkEnvironment ne;
	
	public GenerateActionDelegate() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void run(IAction action) {
		Injector injector = Guice.createInjector(new CommonConfigurationModule());
				
		GenerateAction ga = injector.getInstance(GenerateAction.class);
		ga.run(ne);
	}

	@Override
	public void selectionChanged(IAction action, ISelection selection) {
		if (selection instanceof IStructuredSelection) {
			IStructuredSelection structuredselection = (IStructuredSelection)selection;
			if (structuredselection.getFirstElement() instanceof NetworkEnvironment)
				ne = (NetworkEnvironment) structuredselection.getFirstElement();
				
		}
		
	}

	@Override
	public void setActivePart(IAction action, IWorkbenchPart targetPart) {
		
		
	}

}

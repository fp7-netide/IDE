package eu.netide.configuration.generator;

import org.eclipse.jface.action.IAction;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IObjectActionDelegate;
import org.eclipse.ui.IWorkbenchPart;
import eu.netide.configuration.generator.CommonConfigurationModule;

import Topology.NetworkEnvironment;

import com.google.inject.Guice;
import com.google.inject.Injector;

/**
 * Invokes the generation of a mininet configuration file from the context menu.
 * 
 * @author Christian Stritzke
 *
 */
public class GenerateActionDelegate implements IObjectActionDelegate {

	private NetworkEnvironment ne;

	public GenerateActionDelegate() {
		// TODO Auto-generated constructor stub
	}

	public GenerateActionDelegate(NetworkEnvironment ne) {
		this.ne = ne;
	}

	public void run(IAction action) {
		Injector injector = Guice
				.createInjector(new CommonConfigurationModule());

		GenerateAction ga = injector.getInstance(GenerateAction.class);
		ga.run(ne);
	}

	public void selectionChanged(IAction action, ISelection selection) {
		if (selection instanceof IStructuredSelection) {
			IStructuredSelection structuredselection = (IStructuredSelection) selection;
			if (structuredselection.getFirstElement() instanceof NetworkEnvironment)
				ne = (NetworkEnvironment) structuredselection.getFirstElement();

		}

	}

	public void setActivePart(IAction action, IWorkbenchPart targetPart) {

	}

	public void setNetworkEnvironment(NetworkEnvironment ne) {
		this.ne = ne;
	}

}

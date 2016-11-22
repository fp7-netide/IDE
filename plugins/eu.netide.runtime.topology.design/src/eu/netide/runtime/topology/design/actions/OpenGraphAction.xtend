package eu.netide.runtime.topology.design.actions

import java.util.Collection
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction

class OpenGraphAction implements IExternalJavaAction {
	new() { // TODO Auto-generated constructor stub
	}

	override boolean canExecute(Collection<? extends EObject> arg0) {
		// TODO Auto-generated method stub
		return false
	}

	override void execute(Collection<? extends EObject> arg0, Map<String, Object> arg1) { // TODO Auto-generated method stub
		println(arg0)
	}
}

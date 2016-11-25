package eu.netide.runtime.topology.design.actions

import java.util.Collection
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction
import org.eclipse.sirius.diagram.business.internal.metamodel.spec.DNodeSpec
import org.eclipse.ui.PlatformUI
import eu.netide.toolpanel.providers.LogProvider
import RuntimeTopology.PortStatistics
import eu.netide.chartview.view.charts.ChartViewer
import eu.netide.chartview.view.ChartView
import com.fasterxml.jackson.databind.node.ArrayNode

class OpenGraphAction implements IExternalJavaAction {
	new() { 
	}

	override boolean canExecute(Collection<? extends EObject> arg0) {
		true
	}

	override void execute(Collection<? extends EObject> arg0, Map<String, Object> arg1) {
		var portStats = (arg0.get(0) as DNodeSpec).target as PortStatistics
		
		var view = PlatformUI.workbench.activeWorkbenchWindow.activePage.showView("eu.netide.chartview.views.ChartView") as ChartView
		
		var log = LogProvider.instance.log.get("PortLog").get(String.format("%s", portStats.port.networkelement.dpid)) as ArrayNode
		
		view.update(log, portStats.port.id)
	}
}

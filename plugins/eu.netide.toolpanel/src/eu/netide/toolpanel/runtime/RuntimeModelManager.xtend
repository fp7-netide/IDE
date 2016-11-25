package eu.netide.toolpanel.runtime

import RuntimeTopology.RuntimeData
import RuntimeTopology.RuntimeTopologyFactory
import Topology.NetworkEnvironment
import Topology.TopologyFactory
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.sirius.business.api.dialect.DialectManager
import org.eclipse.sirius.business.api.dialect.command.CreateRepresentationCommand
import org.eclipse.sirius.business.api.query.URIQuery
import org.eclipse.sirius.business.api.session.Session
import org.eclipse.sirius.business.api.session.SessionManager
import org.eclipse.sirius.tools.api.command.semantic.AddSemanticResourceCommand
import org.eclipse.sirius.ui.business.api.dialect.DialectUIManager
import org.eclipse.sirius.ui.business.api.session.UserSession
import org.eclipse.sirius.viewpoint.DRepresentation
import org.eclipse.sirius.diagram.DDiagramElement
import org.eclipse.sirius.diagram.HideFilter
import org.eclipse.sirius.diagram.GraphicalFilter
import org.eclipse.sirius.diagram.business.api.helper.graphicalfilters.HideFilterHelper
import org.eclipse.sirius.viewpoint.DView
import org.eclipse.sirius.diagram.DSemanticDiagram
import org.eclipse.sirius.tools.internal.command.builders.CommandBuilder

class RuntimeModelManager {

	private static RuntimeModelManager manager

	private Resource resource
	private Session session
	private RuntimeData root

	private DSemanticDiagram rep

	public static def getInstance() {
		if (manager == null)
			manager = new RuntimeModelManager
		return manager
	}

	private new() {
		val modelURI = URI.createGenericURI(URIQuery.INMEMORY_URI_SCHEME, "file.runtimetopology", null);
		val representationURI = URI.createGenericURI(URIQuery.INMEMORY_URI_SCHEME, "temp.aird", null);

		var resourceset = new ResourceSetImpl
		this.resource = resourceset.createResource(modelURI)
		var rm = RuntimeTopologyFactory.eINSTANCE.createRuntimeData
		var ne = TopologyFactory.eINSTANCE.createNetworkEnvironment
		rm.networkenvironment = ne
		this.resource.contents.add(rm)
		this.resource.save(newHashMap())

		var monitor = new NullProgressMonitor

		// SIRIUS Representation generation 
		this.session = SessionManager.INSTANCE.getSession(representationURI, monitor) as Session
		this.session.open(monitor)
		this.session.transactionalEditingDomain.commandStack.execute(
			new AddSemanticResourceCommand(this.session, modelURI, monitor))

		var usersession = UserSession.from(this.session)
		usersession.selectViewpoints(#["RuntimeTopology"])

		this.root = this.session.getSemanticResources().iterator.next.getContents.get(0) as RuntimeData

		usersession.save(monitor)
		this.session.open(monitor)

		var viewpoints = this.session.getSelectedViewpoints(true)
		var viewpoint = viewpoints.iterator.next()

		var desc = DialectManager.INSTANCE.getAvailableRepresentationDescriptions(viewpoints, root).iterator.next
//		DialectManager.INSTANCE.
		// DialectManager.INSTANCE.createRepresentation(projectName, ne, desc, session, monitor)
		var createViewCommand = new CreateRepresentationCommand(this.session, desc, root, "Runtime Topology", monitor)
		session.transactionalEditingDomain.getCommandStack().execute(createViewCommand)

		session.createView(viewpoint, newHashSet(root), monitor)

		this.rep = DialectManager.INSTANCE.getRepresentations(root, this.session).get(0) as DSemanticDiagram

		var setFilterCommand = new RecordingCommand(session.transactionalEditingDomain, "Set Filter") {
			override protected doExecute() {
				var filters = rep.description.filters
				rep.activatedFilters.add(filters.findFirst[x | x.name == "PortStatisticsFilter"])
				rep.activatedFilters.add(filters.findFirst[x | x.name == "ControllerFilter"])
			}
		}
		session.transactionalEditingDomain.commandStack.execute(setFilterCommand)
		

	}

	public def open(IProgressMonitor monitor) {
		DialectUIManager.INSTANCE.openEditor(session, rep, monitor)
	}

	public def getResource() {
		return this.resource
	}

	public def getSession() {
		return this.session
	}

	public def saveResource() {
		this.resource.save(newHashMap())
	}

	public def getNetworkEnvironment() {
		return this.root.networkenvironment
	}

	public def from(NetworkEnvironment res) {
		var command = new RecordingCommand(this.session.transactionalEditingDomain) {
			override protected doExecute() {
				var ne = EcoreUtil.copy(res)
				ne.name = "Runtime Topology"
				root.networkenvironment = ne
			}
		};
		this.session.transactionalEditingDomain.commandStack.execute(command)
	}

}

package eu.netide.newproject;

import Topology.NetworkEnvironment
import java.io.ByteArrayInputStream
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.emf.common.util.URI
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.wizard.Wizard
import org.eclipse.sirius.business.api.dialect.DialectManager
import org.eclipse.sirius.business.api.dialect.command.CreateRepresentationCommand
import org.eclipse.sirius.business.api.session.SessionManager
import org.eclipse.sirius.ui.business.api.session.UserSession
import org.eclipse.sirius.ui.tools.api.project.ModelingProjectManager
import org.eclipse.ui.INewWizard
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.progress.UIJob
import org.eclipse.sirius.business.api.session.Session

class NewNetIDEProjectWizard extends Wizard implements INewWizard {
	NewNetIDEProjectWizardPage1 page

	new() {
		super()
	}

	override init(IWorkbench workbench, IStructuredSelection selection) {
	}

	override addPages() {
		page = new NewNetIDEProjectWizardPage1("NetIDE Project")
		addPage(page)
	}

	override performFinish() {
		var job = new ProjectCreationJob("NetIDE Project Creation", page.projectName, page.parameters, page.sysreq,
			page.composition)

		job.schedule

		return true
	}

	static class ProjectCreationJob extends UIJob {

		String projectName

		Boolean sysreq

		Boolean parameters

		Boolean composition

		String paramstring = '''
			{
				
			}
		'''

		String sysreqstring = '''
			// Parameter specification
			hardware {
				
			}
			
			software {
				
			}
			
			network {
				
			}
		'''

		String compstring = '''
			<?xml version="1.0" encoding="utf-8"?>
			<CompositionSpecification xmlns="http://netide.eu/schemas/compositionspecification/v1">
				<Modules>
					<Module id="SimpleSwitch" loaderIdentification="simple_switch.py"/>
				</Modules>
				<Composition>
					<ModuleCall module="SimpleSwitch"/>
				</Composition>
			</CompositionSpecification>
		'''

		new(String name, String projectname, Boolean parameters, Boolean sysreq, Boolean composition) {
			super(name)
			this.projectName = projectname
			this.parameters = parameters
			this.sysreq = sysreq
			this.composition = composition
		}

		override runInUIThread(IProgressMonitor monitor) {

			var root = ResourcesPlugin.getWorkspace().getRoot()
			var project = root.getProject(projectName)
			project.create(monitor)
			project.open(monitor)
			project.setDefaultCharset("UTF-8", monitor)

			ModelingProjectManager.INSTANCE.convertToModelingProject(project, monitor)

			NewProjectUtils.newTopologyModelFile(project.fullPath, projectName) as NetworkEnvironment

			var sessionResourceURI = URI.createPlatformResourceURI(
				String.format("/%s/representations.aird", projectName), true)

			var session = SessionManager.INSTANCE.getSession(sessionResourceURI, monitor) as Session
			session.open(monitor)

			var usersession = UserSession.from(session)
			usersession.selectViewpoints(#["Topology"])

			var ne = session.getSemanticResources().iterator.next.getContents.get(0)

			usersession.save(monitor)
			session.open(monitor)

			var viewpoints = session.getSelectedViewpoints(true)
			var viewpoint = viewpoints.iterator.next()

			var desc = DialectManager.INSTANCE.getAvailableRepresentationDescriptions(viewpoints, ne).iterator.next

			// DialectManager.INSTANCE.createRepresentation(projectName, ne, desc, session, monitor)
			var createViewCommand = new CreateRepresentationCommand(session, desc, ne, projectName, monitor)
			session.getTransactionalEditingDomain().getCommandStack().execute(createViewCommand)

			session.createView(viewpoint, newHashSet(ne), monitor)

			var appsFolder = project.getFolder("apps")
			appsFolder.create(false, true, null)

			var compositionFolder = project.getFolder("composition")
			compositionFolder.create(false, true, null)

			if (composition) {
				var compfile = project.getFile("composition/composition.xml")
				compfile.create(new ByteArrayInputStream(compstring.getBytes("UTF-8")), false, monitor)
			}

			var resfolder = project.getFolder("results")
			resfolder.create(false, true, null)

			if (parameters) {
				var templateFolder = project.getFolder("templates")
				templateFolder.create(false, true, null)

//				var paramFile = project.getFile("parameters.json")
//				paramFile.create(new ByteArrayInputStream(paramstring.getBytes("UTF-8")), false, monitor)
			}

			if (sysreq) {
				var sysreqfile = project.getFile("requirements.sysreq")
				sysreqfile.create(new ByteArrayInputStream(sysreqstring.getBytes("UTF-8")), false, monitor)
			}

			return Status.OK_STATUS
		}
	}
}

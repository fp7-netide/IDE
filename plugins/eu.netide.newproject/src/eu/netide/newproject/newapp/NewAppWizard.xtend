package eu.netide.newproject.newapp

import java.io.ByteArrayInputStream
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.wizard.Wizard
import org.eclipse.ui.INewWizard
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.progress.UIJob

class NewAppWizard extends Wizard implements INewWizard {
	NewAppWizardPage1 page
	IProject project

	new() {
		super()
	}

	override init(IWorkbench workbench, IStructuredSelection selection) {
		project = selection.firstElement as IProject
	}

	override addPages() {
		page = new NewAppWizardPage1("NetIDE Project")
		addPage(page)
	}

	override performFinish() {
		var job = new AppCreationJob("NetIDE App Creation", page.appName, page.platform, project)

		job.schedule

		return true
	}

	static class AppCreationJob extends UIJob {

		String appName
		String controllerName
		IProject project

		new(String name, String appName, String controllerName, IProject project) {
			super(name)
			this.appName = appName
			this.controllerName = controllerName
			this.project = project
		}

		override runInUIThread(IProgressMonitor monitor) {

			var sysreqString = '''
				app: {
					name: "«this.appName»",
					version: "0.1",
					controller: {
						name: "«this.controllerName»",
					},
				}
			'''

			var paramString = '''
				parameters: {
					
				}
			'''

			var appFolder = project.getFolder("apps/" + appName)
			appFolder.create(false, true, monitor)

			var paramFile = project.getFile("apps/"+appName+"/"+appName+".params")
			paramFile.create(new ByteArrayInputStream(paramString.getBytes("UTF-8")), false, monitor)
			
			var sysReqFile = project.getFile("apps/"+appName+"/"+appName+".sysreq")
			sysReqFile.create(new ByteArrayInputStream(sysreqString.getBytes("UTF-8")), false, monitor)

			return Status.OK_STATUS
		}
	}
}

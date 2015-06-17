package eu.netide.newproject;

import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.core.resources.IWorkspaceRoot
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.ResourcesPlugin
import java.io.InputStream
import java.io.FileInputStream
import java.io.BufferedInputStream
import java.io.ByteArrayInputStream
import java.nio.charset.StandardCharsets
import java.io.StringReader

class NewNetIDEProjectWizard extends Wizard implements INewWizard {
	NewNetIDEProjectWizardPage1 page
	
	String paramstring = '''
	// Parameter specification
	types {
		
	}
	
	parameters {
		
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
		var projectName = page.projectName
		
		var root = ResourcesPlugin.getWorkspace().getRoot()
		var project = root.getProject(projectName)
		project.create(null)
		project.open(null)
		project.setDefaultCharset("UTF-8", null)
		
		var appsFolder = project.getFolder("apps")
		appsFolder.create(false, true, null)
		
		var templateFolder = project.getFolder("templates")
		templateFolder.create(false,true,null)
		
		
		var parameterfile = project.getFile("parameters.params")
		parameterfile.create(new ByteArrayInputStream(paramstring.getBytes("UTF-8")),false,null)
		
		var sysreqfile = project.getFile("requirements.sysreq")
		sysreqfile.create(new ByteArrayInputStream(sysreqstring.getBytes("UTF-8")),false,null)
		
		return true
	}

}

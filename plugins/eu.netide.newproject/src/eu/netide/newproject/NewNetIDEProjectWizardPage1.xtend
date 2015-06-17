package eu.netide.newproject

import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener

class NewNetIDEProjectWizardPage1 extends WizardPage {
	
	Text nametext
	
	new(String pageName) {
		super(pageName)
		setTitle("New NetIDE Project")
		setDescription("Creates a new NetIDE Project")
	}
	
	override createControl(Composite parent) {
		var container = SWTFactory.createComposite(parent,2,1,SWT.HORIZONTAL)
		SWTFactory.createLabel(container, "Name:", 1)
		nametext = SWTFactory.createText(container,SWT.BORDER, 1)
		nametext.addModifyListener(new ModifyListener() {
			override modifyText(ModifyEvent e) {
				dialogChanged()
			}
		})
		control = container
	}
	
	def dialogChanged() {
		if (nametext.text == null || nametext.text == "") {
			pageComplete = false
			errorMessage = "Please enter a valid project name"
			return
		}
		errorMessage = null
		pageComplete = true
	}
	
	def getProjectName() {
		return nametext.text
	}
	
}
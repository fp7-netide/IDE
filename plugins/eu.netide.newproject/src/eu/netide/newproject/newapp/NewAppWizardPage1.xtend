package eu.netide.newproject.newapp

import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.swt.widgets.Text
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.widgets.Button

class NewAppWizardPage1 extends WizardPage {
	
	Text nametext
	Text platformtext
	//Button sysreqcheck
	//Button paramcheck
	
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
		SWTFactory.createLabel(container, "Controller", 1)
		platformtext = SWTFactory.createText(container,SWT.BORDER, 1)
		platformtext.addModifyListener(new ModifyListener() {
			override modifyText(ModifyEvent e) {
				dialogChanged()
			}
		})
		
		
//		SWTFactory.createLabel(container, "System Requirement Specification:", 1)
//		sysreqcheck = SWTFactory.createCheckButton(container, "", null, false, 1)
		
//		SWTFactory.createLabel(container, "Parameter Specification:", 1)
//		paramcheck = SWTFactory.createCheckButton(container, "", null, false, 1)
		
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
	
	
	def getAppName() {
		return nametext.text
	}
	
	def getPlatform() {
		return platformtext.text
	}
	
}
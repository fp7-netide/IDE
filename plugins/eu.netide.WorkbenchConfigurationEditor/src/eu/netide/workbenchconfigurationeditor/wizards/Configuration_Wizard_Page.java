package eu.netide.workbenchconfigurationeditor.wizards;

import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;

public class Configuration_Wizard_Page extends WizardPage {

	/**
	 * Create the wizard.
	 */
	public Configuration_Wizard_Page() {
		super("wizardPage");
		setTitle("Wizard Page title");
		setDescription("Wizard Page description");
		this.setPageComplete(false);

		this.nameSet = false;
	}

	private boolean nameSet;
	private Composite container;

	/**
	 * Create contents of the wizard.
	 * 
	 * @param parent
	 */
	@Override
	public void createControl(Composite parent) {
		container = new Composite(parent, SWT.NULL);

		setControl(container);
		container.setLayout(new GridLayout(2, false));

		Label lblFileName = new Label(container, SWT.NONE);
		GridData gd_lblFileName = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_lblFileName.widthHint = 114;
		lblFileName.setLayoutData(gd_lblFileName);
		lblFileName.setText("File Name");

		fileName = new Text(container, SWT.BORDER);
		GridData gd_fileName = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_fileName.widthHint = 153;
		fileName.setLayoutData(gd_fileName);
		fileName.addModifyListener(new ModifyListener() {
			public void modifyText(ModifyEvent e) {
				if (!fileName.getText().equals(""))
					nameSet = true;
				else
					nameSet = false;

				checkForFinish();
			}
		});

	}

	protected void checkForFinish() {
		if (nameSet == true)
			this.setPageComplete(true);
		else
			this.setPageComplete(false);

	}

	private Text fileName;

	public String getFileName() {
		return fileName.getText();
	}

}

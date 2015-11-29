package eu.netide.workbenchconfigurationeditor.wizards;

import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;

public class Configuration_Wizard_Page extends WizardPage {
	private Text topologyPathText;

	/**
	 * Create the wizard.
	 */
	public Configuration_Wizard_Page() {
		super("wizardPage");
		setTitle("Wizard Page title");
		setDescription("Wizard Page description");
		this.setPageComplete(false);
		topologyPath = "";
		this.topoSet = false;
		this.nameSet = false;
	}
	
	private boolean topoSet;
	private boolean nameSet;

	/**
	 * Create contents of the wizard.
	 * @param parent
	 */
	@Override
	public void createControl(Composite parent) {
		Composite container = new Composite(parent, SWT.NULL);

		setControl(container);
		
		Label lblTopology = new Label(container, SWT.NONE);
		lblTopology.setBounds(10, 158, 59, 14);
		lblTopology.setText("Topology");
		
		topologyPathText = new Text(container, SWT.BORDER);
		topologyPathText.setBounds(116, 155, 291, 19);
		topologyPathText.addModifyListener(new ModifyListener() {
			public void modifyText(ModifyEvent e) {
				if(!topologyPathText.getText().equals(""))
					topoSet = true;
				else
					topoSet = false;
				
				checkForFinish();
			}
		});
		
		Button btnBrowse = new Button(container, SWT.NONE);
		btnBrowse.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				FileDialog dlg = new FileDialog(getShell(), SWT.OPEN);
				String path = dlg.open();

				if (path != null) {
					topologyPathText.setText(path);
					topologyPath = "file:".concat(path);

					topoSet = true;
					checkForFinish();
				}
			}
		});
		btnBrowse.setBounds(441, 151, 94, 28);
		btnBrowse.setText("Browse");
		
		Label lblFileName = new Label(container, SWT.NONE);
		lblFileName.setBounds(10, 113, 59, 14);
		lblFileName.setText("File Name");
		
		fileName = new Text(container, SWT.BORDER);
		fileName.addModifyListener(new ModifyListener() {
			public void modifyText(ModifyEvent e) {
				if(!fileName.getText().equals(""))
					nameSet = true;
				else
					nameSet = false;
				
				checkForFinish();
			}
		});
		fileName.setBounds(116, 110, 291, 19);
		

	}
	protected void checkForFinish() {
		if(topoSet == true && nameSet == true)
			this.setPageComplete(true);
		else
			this.setPageComplete(false);
		
	}

	private String topologyPath;

	public String getTopologyPath(){
		return topologyPath;
	}
	
	private Text fileName;
	public String getFileName(){
		return fileName.getText();
	}
}

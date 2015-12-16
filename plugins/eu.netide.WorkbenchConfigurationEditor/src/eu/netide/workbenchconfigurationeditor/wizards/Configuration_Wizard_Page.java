package eu.netide.workbenchconfigurationeditor.wizards;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.dialogs.ElementTreeSelectionDialog;
import org.eclipse.ui.model.BaseWorkbenchContentProvider;
import org.eclipse.ui.model.WorkbenchLabelProvider;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.GridData;

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
		container.setLayout(new GridLayout(3, false));
				
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
		new Label(container, SWT.NONE);

		Label lblTopology = new Label(container, SWT.NONE);
		lblTopology.setText("Topology");

		topologyPathText = new Text(container, SWT.BORDER);
		topologyPathText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		topologyPathText.addModifyListener(new ModifyListener() {
			public void modifyText(ModifyEvent e) {
				if (!topologyPathText.getText().equals(""))
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

				String path = null;

				IFile selectedFile = null;
				ElementTreeSelectionDialog dialog = new ElementTreeSelectionDialog(container.getShell(),
						new WorkbenchLabelProvider(), new BaseWorkbenchContentProvider());
				dialog.setTitle("Tree Selection");
				dialog.setMessage("Select the elements from the tree:");
				dialog.setInput(ResourcesPlugin.getWorkspace().getRoot());
				if (dialog.open() == ElementTreeSelectionDialog.OK) {
					Object[] result = dialog.getResult();
					if (result.length == 1) {
						if (result[0] instanceof IFile) {
							System.out.println("is file");
							selectedFile = (IFile) result[0];
							System.out.println(selectedFile.getFullPath());
							path = selectedFile.getFullPath().toOSString();
						} else {
							showMessage("Please select a topology.");
						}

						if (path != null) {
							topologyPathText.setText(path);
							topologyPath = "file:".concat(path);

							topoSet = true;
							checkForFinish();
						}
					}
				}
			}
		});
		btnBrowse.setText("Browse");

	}

	protected void checkForFinish() {
		if (topoSet == true && nameSet == true)
			this.setPageComplete(true);
		else
			this.setPageComplete(false);

	}

	private String topologyPath;

	public String getTopologyPath() {
		return topologyPath;
	}

	private Text fileName;

	public String getFileName() {
		return fileName.getText();
	}

	private void showMessage(String msg) {
		MessageDialog.openInformation(container.getShell(), "NetIDE Workbench View", msg);
	}
}

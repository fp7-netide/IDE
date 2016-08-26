package eu.netide.verificator.views;

import org.eclipse.jface.dialogs.IMessageProvider;
import org.eclipse.jface.dialogs.TitleAreaDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

public class VerAddressDialog extends TitleAreaDialog {

	private String name;
	private String address;
	private Text txtName;
	private Text txtAddress;

	public VerAddressDialog(Shell parentShell) {
		super(parentShell);
	}

	@Override
	public void create() {
		super.create();
		setTitle("Verificator");
		setMessage("Enter the listening address of your Verificator.", IMessageProvider.INFORMATION);
	}

	@Override
	protected Control createDialogArea(Composite parent) {
		
		Label lblName = new Label(parent, SWT.NONE);
		lblName.setText("Name: ");

		txtName = new Text(parent, SWT.BORDER);
		txtName.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label lblAddress = new Label(parent, SWT.NONE);
		lblAddress.setText("Address: ");

		txtAddress = new Text(parent, SWT.BORDER);
		txtAddress.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		setHelpAvailable(false);
		return parent;
	}

	public String getName() {
		return name;
	}
	
	public String getAddress() {
		return address;
	}
	
	@Override
	protected boolean isResizable() {
		return true;
	}

	@Override
	protected void okPressed() {
		saveInput();
		super.okPressed();
	}

	private void saveInput() {
		name = txtName.getText();
		address = txtAddress.getText();
	}

}

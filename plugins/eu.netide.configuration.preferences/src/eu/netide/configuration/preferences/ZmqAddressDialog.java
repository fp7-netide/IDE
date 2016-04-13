package eu.netide.configuration.preferences;

import org.eclipse.jface.dialogs.IMessageProvider;
import org.eclipse.jface.dialogs.TitleAreaDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

public class ZmqAddressDialog extends TitleAreaDialog {

	private String address;
	private String name;
	private Text txtAddress;
	private Text txtName;

	public ZmqAddressDialog(Shell parentShell) {
		super(parentShell);
	}

	@Override
	public void create() {
		super.create();
		setTitle("New ZMQ Listener");
		setMessage("Enter the listening address of your ZMQ hub.", IMessageProvider.INFORMATION);
	}

	@Override
	protected Control createDialogArea(Composite parent) {
		
		Label lblName = new Label(parent, SWT.NONE);
		lblName.setText("Name: ");

		txtName = new Text(parent, SWT.BORDER);
		txtName.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label lblAddress = new Label(parent, SWT.NONE);
		lblAddress.setText("ZMQ Address: ");

		txtAddress = new Text(parent, SWT.BORDER);
		txtAddress.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		setHelpAvailable(false);
		return parent;
	}

	public String getAddress() {
		return address;
	}
	
	public String getName() {
		return name;
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
		address = txtAddress.getText();
		name = txtName.getText();
	}

}

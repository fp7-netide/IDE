package eu.netide.workbenchconfigurationeditor.editors;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;

public class SShShell extends Shell {
	private Text txt_profileName;
	private Text txt_username;
	private Text txt_port;
	private Text txt_sshidfile;
	private Text txt_host;
	private SShShell shell;

	public void openShell(Display display) {
		try {
			this.open();
			this.layout();
			while (!this.isDisposed()) {
				if (!display.readAndDispatch()) {
					display.sleep();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Create the shell.
	 * 
	 * @param display
	 */
	public SShShell(Display display) {
		super(display, SWT.SHELL_TRIM);
		shell = this;
		setLayout(new GridLayout(1, false));

		Composite composite = new Composite(this, SWT.NONE);
		GridData gd_composite = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_composite.heightHint = 207;
		gd_composite.widthHint = 425;
		composite.setLayoutData(gd_composite);
		composite.setLayout(new GridLayout(2, false));

		Label lblNewLabel = new Label(composite, SWT.NONE);
		lblNewLabel.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblNewLabel.setText("Profile Name");

		txt_profileName = new Text(composite, SWT.BORDER);
		txt_profileName.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		txt_profileName.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_profileName.getText().equals("")) {
					profileNameSet = true;
				} else {
					profileNameSet = false;
				}
				checkForFinish();

			}
		});

		Label lblNewLabel_1 = new Label(composite, SWT.NONE);
		lblNewLabel_1.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblNewLabel_1.setText("Username");

		txt_username = new Text(composite, SWT.BORDER);
		txt_username.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		txt_username.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_username.getText().equals("")) {
					usernameSet = true;
				} else {
					usernameSet = false;
				}
				checkForFinish();

			}
		});

		Label lblNewLabel_2 = new Label(composite, SWT.NONE);
		lblNewLabel_2.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblNewLabel_2.setText("Port");

		txt_port = new Text(composite, SWT.BORDER);
		txt_port.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		txt_port.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_port.getText().equals("")) {
					portSet = true;
				} else {
					portSet = false;
				}
				checkForFinish();

			}
		});

		Label lblNewLabel_3 = new Label(composite, SWT.NONE);
		lblNewLabel_3.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblNewLabel_3.setText("SSH ID File");

		txt_sshidfile = new Text(composite, SWT.BORDER);
		txt_sshidfile.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		txt_sshidfile.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_sshidfile.getText().equals("")) {
					sshFileSet = true;
				} else {
					sshFileSet = false;
				}
				checkForFinish();

			}
		});

		Label lblHost = new Label(composite, SWT.NONE);
		lblHost.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblHost.setText("Host");

		txt_host = new Text(composite, SWT.BORDER);
		txt_host.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		txt_host.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_host.getText().equals("")) {
					hostSet = true;
				} else {
					hostSet = false;
				}
				checkForFinish();

			}
		});

		Composite composite_1 = new Composite(this, SWT.NONE);
		GridData gd_composite_1 = new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1);
		gd_composite_1.widthHint = 205;
		composite_1.setLayoutData(gd_composite_1);
		composite_1.setLayout(new GridLayout(2, false));

		Button cancleButton = new Button(composite_1, SWT.NONE);
		cancleButton.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1));
		cancleButton.setText("Cancle");

		saveBTN = new Button(composite_1, SWT.NONE);
		saveBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				shell.dispose();
			}
		});
		saveBTN.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		saveBTN.setText("Save Profile");
		saveBTN.setEnabled(false);
		createContents();
		
		openShell(display);
	}

	/**
	 * Create contents of the shell.
	 */
	protected void createContents() {
		setText("SWT Application");
		setSize(450, 289);

	}

	Button saveBTN;
	boolean hostSet;
	boolean portSet;
	boolean usernameSet;
	boolean sshFileSet;
	boolean profileNameSet;

	private void checkForFinish() {
		if (hostSet && portSet && usernameSet && sshFileSet && profileNameSet) {
			saveBTN.setEnabled(true);

			String[] tmpResult = { txt_host.getText(), txt_port.getText(), txt_sshidfile.getText(),
					txt_username.getText(), txt_profileName.getText() };
			result = tmpResult;
		} else {
			saveBTN.setEnabled(false);
			result = null;
		}

	}

	private String[] result;

	/**
	 * 
	 * @return host, port, sshidfile, username, profilename null if action
	 *         canceled by user
	 */
	public String[] getResult() {
		return result;
	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}
}

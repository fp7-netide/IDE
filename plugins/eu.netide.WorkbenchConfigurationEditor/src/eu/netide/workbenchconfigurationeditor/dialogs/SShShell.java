package eu.netide.workbenchconfigurationeditor.dialogs;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

import eu.netide.workbenchconfigurationeditor.model.SshProfileModel;

public class SShShell extends Shell {
	private Text txt_profileName;
	private Text txt_username;
	private Text txt_port;
	private Text txt_sshidfile;
	private Text txt_host;
	private SShShell shell;
	private Text txt_secondUsername;

	private boolean edit;
	private boolean delete;
	private boolean useDoubleTunneL;
	private SshProfileModel profile;

	/**
	 * 
	 * @param profile
	 *            may be null. if profile != null use edit view
	 */
	public void openShell(SshProfileModel profile) {
		delete = false;
		if (profile != null) {
			edit = true;
			this.profile = profile;
			btnDeleteProfile.setVisible(true);
		} else {
			edit = false;
			this.profile = null;
		}
		openShell(display);
	}

	private void openShell(Display display) {
		try {
			this.pack();
			this.open();
			this.layout();
			if (edit) {
				txt_profileName.setText(profile.getProfileName());
				txt_username.setText(profile.getUsername());
				txt_port.setText(profile.getPort());
				txt_sshidfile.setText(profile.getSshIdFile());
				txt_host.setText(profile.getHost());
				txt_sshidfile.setText(profile.getSshIdFile());

				if (profile.getSecondHost() != null && profile.getSecondPort() != null
						&& profile.getSecondUsername() != null) {
					if (!profile.getSecondHost().equals("") && !profile.getSecondPort().equals("")
							&& !profile.getSecondUsername().equals("")) {
						this.useDoubleTunneL = true;
						this.doubleTunnelComposite.setVisible(true);

						txt_secondUsername.setText(profile.getSecondUsername());
						txt_SecondPort.setText(profile.getSecondPort());
						txt_SecondHost.setText(profile.getSecondHost());
						btnCheckButton.setSelection(true);
					}
				}
			}
			while (!this.isDisposed()) {
				if (!display.readAndDispatch()) {
					display.sleep();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private Display display;
	private Button btnCheckButton;

	/**
	 * Create the shell.
	 * 
	 * @param display
	 */
	public SShShell(Display display) {
		super(display, SWT.SHELL_TRIM);
		shell = this;
		this.display = display;
		setLayout(new GridLayout(1, false));
		this.useDoubleTunneL = false;
		Composite composite = new Composite(this, SWT.NONE);
		GridData gd_composite = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
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
		new Label(composite, SWT.NONE);
		new Label(composite, SWT.NONE);
		new Label(composite, SWT.NONE);

		btnCheckButton = new Button(composite, SWT.CHECK);
		btnCheckButton.setLayoutData(new GridData(SWT.LEFT, SWT.FILL, false, false, 1, 1));

		btnCheckButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (useDoubleTunneL) {
					useDoubleTunneL = false;
					doubleTunnelComposite.setVisible(false);
				} else {
					useDoubleTunneL = true;
					doubleTunnelComposite.setVisible(true);
				}
			}
		});

		btnCheckButton.setText("Use SSH Double Tunnel");
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

		doubleTunnelComposite = new Composite(this, SWT.NONE);
		GridData gd_doubleTunnelComposite = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_doubleTunnelComposite.heightHint = 92;
		doubleTunnelComposite.setLayoutData(gd_doubleTunnelComposite);
		doubleTunnelComposite.setLayout(new GridLayout(2, false));

		Label lblSecondUserName = new Label(doubleTunnelComposite, SWT.NONE);
		lblSecondUserName.setText("Second UserName");

		txt_secondUsername = new Text(doubleTunnelComposite, SWT.BORDER);
		GridData gd_txt_secondUsername = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_txt_secondUsername.widthHint = 337;
		txt_secondUsername.setLayoutData(gd_txt_secondUsername);
		txt_secondUsername.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_secondUsername.getText().equals("")) {
					secondUsernameSet = true;
				} else {
					secondUsernameSet = false;
				}
				checkForFinish();

			}
		});

		Label lblSecondPort = new Label(doubleTunnelComposite, SWT.NONE);
		lblSecondPort.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblSecondPort.setText("Second Port");

		txt_SecondPort = new Text(doubleTunnelComposite, SWT.BORDER);
		txt_SecondPort.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		txt_SecondPort.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_SecondPort.getText().equals("")) {
					secondPortSet = true;
				} else {
					secondPortSet = false;
				}
				checkForFinish();

			}
		});

		Label lblNewLabel_4 = new Label(doubleTunnelComposite, SWT.NONE);
		lblNewLabel_4.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblNewLabel_4.setText("Second Host");

		txt_SecondHost = new Text(doubleTunnelComposite, SWT.BORDER);
		txt_SecondHost.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		txt_SecondHost.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				if (!txt_SecondHost.getText().equals("")) {
					secondHostSet = true;
				} else {
					secondHostSet = false;
				}
				checkForFinish();

			}
		});

		doubleTunnelComposite.setVisible(false);
		Composite composite_1 = new Composite(this, SWT.NONE);
		GridData gd_composite_1 = new GridData(SWT.CENTER, SWT.FILL, false, false, 1, 1);
		gd_composite_1.widthHint = 316;
		composite_1.setLayoutData(gd_composite_1);
		composite_1.setLayout(new GridLayout(3, false));

		Button cancleButton = new Button(composite_1, SWT.NONE);
		cancleButton.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1));
		cancleButton.setText("Cancel");
		cancleButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				String[] tmpResult = { profile.getHost(), profile.getPort(), profile.getSshIdFile(),
						profile.getUsername(), profile.getProfileName() };
				result = tmpResult;
				delete = false;
				shell.dispose();
			}
		});

		saveBTN = new Button(composite_1, SWT.NONE);
		saveBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (edit) {
					profile.setHost(txt_host.getText());
					profile.setPort(txt_port.getText());
					profile.setProfileName(txt_profileName.getText());
					profile.setSshIdFile(txt_sshidfile.getText());
					profile.setUsername(txt_username.getText());
					if (useDoubleTunneL) {
						profile.setSecondHost(txt_SecondHost.getText());
						profile.setSecondPort(txt_SecondPort.getText());
						profile.setSecondUsername(txt_secondUsername.getText());
					} else {
						profile.setSecondHost("");
						profile.setSecondPort("");
						profile.setSecondUsername("");
					}
				}
				shell.dispose();
			}
		});
		saveBTN.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		saveBTN.setText("Save Profile");
		saveBTN.setEnabled(false);

		btnDeleteProfile = new Button(composite_1, SWT.NONE);
		btnDeleteProfile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				delete = true;
				shell.dispose();
			}
		});
		btnDeleteProfile.setVisible(false);
		btnDeleteProfile.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		btnDeleteProfile.setText("Delete Profile");
		createContents();

	}

	private Button btnDeleteProfile;

	public boolean deleteEntry() {
		return delete;
	}

	/**
	 * Create contents of the shell.
	 */
	protected void createContents() {
		setText("SSH Profile");

	}

	Button saveBTN;
	boolean hostSet;
	boolean portSet;
	boolean usernameSet;
	boolean sshFileSet;
	boolean profileNameSet;
	boolean secondHostSet;
	boolean secondPortSet;
	boolean secondUsernameSet;

	private void checkForFinish() {
		if (hostSet && portSet && usernameSet && sshFileSet && profileNameSet) {
			if (!useDoubleTunneL) {
				saveBTN.setEnabled(true);

				String[] tmpResult = { txt_host.getText(), txt_port.getText(), txt_sshidfile.getText(),
						txt_username.getText(), txt_profileName.getText(), "", "", "" };
				result = tmpResult;
			} else if (secondHostSet && secondPortSet && secondUsernameSet) {
				saveBTN.setEnabled(true);

				String[] tmpResult = { txt_host.getText(), txt_port.getText(), txt_sshidfile.getText(),
						txt_username.getText(), txt_profileName.getText(), txt_secondUsername.getText(),
						txt_SecondHost.getText(), txt_SecondPort.getText() };
				result = tmpResult;
			} else {
				saveBTN.setEnabled(false);
				result = null;
			}
		} else {
			saveBTN.setEnabled(false);
			result = null;
		}

	}

	private String[] result;
	private Text txt_SecondPort;
	private Text txt_SecondHost;
	private Composite doubleTunnelComposite;

	/**
	 * 
	 * @return host, port, sshidfile, username, profilename, secondHop null if
	 *         action canceled by user
	 */
	public String[] getResult() {
		return result;
	}

	public boolean isDoubleTunnel() {
		return this.useDoubleTunneL;
	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}
}

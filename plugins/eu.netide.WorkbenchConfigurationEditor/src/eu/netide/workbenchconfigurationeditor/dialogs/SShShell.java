package eu.netide.workbenchconfigurationeditor.dialogs;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
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
				checkModelStringEmpty(profile.getAppFolder(), text_app, btnCheckButtonAppFolder);
				checkModelStringEmpty(profile.getComposite(), text_composite, btnCheckComposite);
				checkModelStringEmpty(profile.getCore(), text_core, btnCheckCore);
				checkModelStringEmpty(profile.getEngine(), text_engine, btnCheckEngine);
				checkModelStringEmpty(profile.getOdl(), text_odl, this.btnCheckODL);
				checkModelStringEmpty(profile.getTools(), text_tools, btnCheckTools);
				checkModelStringEmpty(profile.getTopology(), text_topology, btnCheckTopo);
				checkModelStringEmpty(profile.getVagrantBox(), this.text_vagrant, this.btnCheckBox);

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

	private void checkModelStringEmpty(String modelContent, Text text, Button button) {

		if (!modelContent.equals("")) {
			button.setSelection(true);
			text.setEnabled(true);
			text.setText(modelContent);
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
		setSize(564, 601);
		shell = this;
		this.display = display;
		setLayout(new GridLayout(1, false));
		this.useDoubleTunneL = false;
		Composite composite = new Composite(this, SWT.NONE);
		composite.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
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

		composite_2 = new Composite(this, SWT.NONE);
		composite_2.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		composite_2.setLayout(new GridLayout(3, false));

		lblNewLabel_5 = new Label(composite_2, SWT.NONE);
		lblNewLabel_5.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblNewLabel_5.setText("App Folder");

		text_app = new Text(composite_2, SWT.BORDER);
		text_app.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckButtonAppFolder = new Button(composite_2, SWT.CHECK);
		btnCheckButtonAppFolder.setText("Enable");
		btnCheckButtonAppFolder.addSelectionListener(new BrowseAdapter(text_app));

		lblCompositeFile = new Label(composite_2, SWT.NONE);
		lblCompositeFile.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblCompositeFile.setText("Composite File");

		text_composite = new Text(composite_2, SWT.BORDER);
		text_composite.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckComposite = new Button(composite_2, SWT.CHECK);
		btnCheckComposite.setText("Enable");
		btnCheckComposite.addSelectionListener(new BrowseAdapter(text_composite));

		lblKarafcore = new Label(composite_2, SWT.NONE);
		lblKarafcore.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblKarafcore.setText("Karaf (Core)");

		text_core = new Text(composite_2, SWT.BORDER);
		text_core.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckCore = new Button(composite_2, SWT.CHECK);
		btnCheckCore.setText("Enable");
		btnCheckCore.addSelectionListener(new BrowseAdapter(text_core));

		lblOdlShim = new Label(composite_2, SWT.NONE);
		lblOdlShim.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblOdlShim.setText("ODL Shim");

		text_odl = new Text(composite_2, SWT.BORDER);
		text_odl.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckODL = new Button(composite_2, SWT.CHECK);
		btnCheckODL.setText("Enable");
		btnCheckODL.addSelectionListener(new BrowseAdapter(text_odl));

		lblEngine = new Label(composite_2, SWT.NONE);
		lblEngine.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblEngine.setText("Engine");

		text_engine = new Text(composite_2, SWT.BORDER);
		text_engine.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckEngine = new Button(composite_2, SWT.CHECK);
		btnCheckEngine.setText("Enable");
		btnCheckEngine.addSelectionListener(new BrowseAdapter(text_engine));

		lblVagrantBoxRoot = new Label(composite_2, SWT.NONE);
		lblVagrantBoxRoot.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblVagrantBoxRoot.setText("Vagrant Box Root");

		text_vagrant = new Text(composite_2, SWT.BORDER);
		text_vagrant.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckBox = new Button(composite_2, SWT.CHECK);
		btnCheckBox.setText("Enable");
		btnCheckBox.addSelectionListener(new BrowseAdapter(text_vagrant));

		lblTools = new Label(composite_2, SWT.NONE);
		lblTools.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblTools.setText("Tools");

		text_tools = new Text(composite_2, SWT.BORDER);
		text_tools.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckTools = new Button(composite_2, SWT.CHECK);
		btnCheckTools.setText("Enable");
		btnCheckTools.addSelectionListener(new BrowseAdapter(text_tools));

		lblTopology = new Label(composite_2, SWT.NONE);
		lblTopology.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblTopology.setText("Topology");

		text_topology = new Text(composite_2, SWT.BORDER);
		text_topology.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		btnCheckTopo = new Button(composite_2, SWT.CHECK);
		btnCheckTopo.setText("Enable");
		btnCheckTopo.addSelectionListener(new BrowseAdapter(text_topology));

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
				finish = false;
				delete = false;
				shell.dispose();
			}
		});

		saveBTN = new Button(composite_1, SWT.NONE);
		saveBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (edit) {
					setProfileEntry(profile);
				}
				else {
					resultModel = new SshProfileModel();
					setProfileEntry(resultModel);
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

	private void setProfileEntry(SshProfileModel profile) {
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

		if (btnCheckButtonAppFolder.getSelection())
			profile.setAppFolder(text_app.getText());
		else
			profile.setAppFolder("");
		if (btnCheckComposite.getSelection())
			profile.setComposite(text_composite.getText());
		else
			profile.setComposite("");
		if (btnCheckCore.getSelection())
			profile.setCore(text_core.getText());
		else
			profile.setCore("");
		if (btnCheckEngine.getSelection())
			profile.setEngine(text_engine.getText());
		else
			profile.setEngine("");
		if (btnCheckODL.getSelection())
			profile.setOdl(text_odl.getText());
		else
			profile.setOdl("");
		if (btnCheckTools.getSelection())
			profile.setTools(text_tools.getText());
		else
			profile.setTools("");
		if (btnCheckBox.getSelection())
			profile.setVagrantBox(text_vagrant.getText());
		else
			profile.setVagrantBox("");
		if (btnCheckTopo.getSelection())
			profile.setTopology(text_topology.getText());
		else
			profile.setTopology("");
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
				this.finish = true;
			} else if (secondHostSet && secondPortSet && secondUsernameSet) {
				saveBTN.setEnabled(true);
				this.finish = true;
			} else {
				saveBTN.setEnabled(false);
				this.finish = false;
			}
		} else {
			saveBTN.setEnabled(false);
			this.finish = false;
		}

	}

	private Text txt_SecondPort;
	private Text txt_SecondHost;
	private Composite doubleTunnelComposite;
	private Composite composite_2;
	private Label lblNewLabel_5;
	private Label lblOdlShim;
	private Label lblTools;
	private Label lblTopology;
	private Label lblVagrantBoxRoot;
	private Label lblKarafcore;
	private Label lblEngine;
	private Label lblCompositeFile;
	private Text text_app;
	private Text text_composite;
	private Text text_core;
	private Text text_odl;
	private Text text_engine;
	private Text text_vagrant;
	private Text text_tools;
	private Text text_topology;
	private Button btnCheckButtonAppFolder;
	private Button btnCheckComposite;
	private Button btnCheckCore;
	private Button btnCheckODL;
	private Button btnCheckEngine;
	private Button btnCheckBox;
	private Button btnCheckTools;
	private Button btnCheckTopo;
	private boolean finish;

	private SshProfileModel resultModel;
	/**
	 * 
	 * @return SSH Profile according to entries of ssh shell
	 */
	public SshProfileModel getResult() {
		if (finish) {
			return resultModel;
		} else
			return null;
	}

	public boolean isDoubleTunnel() {
		return this.useDoubleTunneL;
	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

	protected class BrowseAdapter extends SelectionAdapter {
		private Text text;

		public BrowseAdapter(Text correspondingTextField) {
			super();
			this.text = correspondingTextField;
			this.text.setEnabled(false);
		}

		@Override
		public void widgetSelected(SelectionEvent e) {
			Button sender = (Button) e.getSource();

			if (sender.getSelection() == true) {
				this.text.setEnabled(true);
			} else {
				this.text.setEnabled(false);
			}
		}
	}

}

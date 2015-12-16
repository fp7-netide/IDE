package eu.netide.workbenchconfigurationeditor.editors;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CCombo;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.dialogs.ElementTreeSelectionDialog;
import org.eclipse.ui.model.BaseWorkbenchContentProvider;
import org.eclipse.ui.model.WorkbenchLabelProvider;

import eu.netide.configuration.utils.NetIDE;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.GridData;

/**
 * 
 * @author Jan-Niclas Struewer
 *
 */
public class ConfigurationShell extends Shell {

	/**
	 * Launch the application.
	 * 
	 * @param args
	 */
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

	private ConfigurationShell shell;
	private CCombo platformCombo;
	private Group client_server;
	private CCombo serverControllerCombo;
	private CCombo clientControllerCombo;
	private Button btnSaveConfig;

	/**
	 * Create the shell.
	 * 
	 * @param display
	 */
	public ConfigurationShell(Display display) {

		super(display, SWT.SHELL_TRIM);
		this.shell = this;
		setLayout(new GridLayout(1, false));
		
				Group appGroup = new Group(this, SWT.NONE);
				appGroup.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
						appGroup.setLayout(new GridLayout(3, false));
				
						Label lblApp = new Label(appGroup, SWT.NONE);
						lblApp.setText("App");
								
										appPathText = new Text(appGroup, SWT.BORDER);
										GridData gd_appPathText = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
										gd_appPathText.widthHint = 192;
										appPathText.setLayoutData(gd_appPathText);
										appPathText.addModifyListener(new ModifyListener() {

											@Override
											public void modifyText(ModifyEvent e) {
												if (!appPathText.getText().equals("")) {
													appPathSet = true;
												} else {
													appPathSet = false;
												}
												checkForFinish();

											}
										});
						
								Button btnBrowseApp = new Button(appGroup, SWT.NONE);
								btnBrowseApp.addSelectionListener(new SelectionAdapter() {
									@Override
									public void widgetSelected(SelectionEvent e) {
										IFile selectedFile = null;
										String path = null;
										ElementTreeSelectionDialog dialog = new ElementTreeSelectionDialog(shell, new WorkbenchLabelProvider(),
												new BaseWorkbenchContentProvider());
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
													path = selectedFile.getFullPath().toString();
													System.out.println("to os string: " + path);
												} else {
													showMessage("Please select an app.");
												}
											}
										}

										if (path != null) {
											path = "platform:/resource".concat(path);
											appPathText.setText(path);
										}
									}

								});
								
										btnBrowseApp.setText("Browse");

		Group platform = new Group(this, SWT.NONE);
		platform.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		platform.setLayout(new GridLayout(2, false));
		
				Label lblAppController = new Label(platform, SWT.NONE);
				lblAppController.setText("Platform");

		platformCombo = new CCombo(platform, SWT.BORDER);
		GridData gd_platformCombo = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_platformCombo.heightHint = 23;
		gd_platformCombo.widthHint = 175;
		platformCombo.setLayoutData(gd_platformCombo);
		platformCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				int index = platformCombo.getSelectionIndex();
				if (index != -1) {
					platformSet = true;
					if (platformCombo.getItem(index).equals(NetIDE.CONTROLLER_ENGINE)) {
						client_server.setVisible(true);
					} else {
						if (client_server.getVisible() == true) {
							client_server.setVisible(false);
						}
					}
				} else {
					platformSet = false;
				}
				checkForFinish();
			}
		});
		setComboboxContent(platformCombo);
		
				client_server = new Group(this, SWT.NONE);
				GridData gd_client_server = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
				gd_client_server.heightHint = 71;
				client_server.setLayoutData(gd_client_server);
						client_server.setLayout(new GridLayout(2, false));
						
								Label clientController = new Label(client_server, SWT.NONE);
								clientController.setText("Client Controller");
												
														clientControllerCombo = new CCombo(client_server, SWT.BORDER);
														GridData gd_clientControllerCombo = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
														gd_clientControllerCombo.heightHint = 20;
														gd_clientControllerCombo.widthHint = 131;
														clientControllerCombo.setLayoutData(gd_clientControllerCombo);
														setComboboxContent(clientControllerCombo);
										
												Label lblNewLabel = new Label(client_server, SWT.NONE);
												lblNewLabel.setText("Server Controller");
								
										serverControllerCombo = new CCombo(client_server, SWT.BORDER);
										GridData gd_serverControllerCombo = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
										gd_serverControllerCombo.heightHint = 20;
										serverControllerCombo.setLayoutData(gd_serverControllerCombo);
										setComboboxContent(serverControllerCombo);
												
														client_server.setVisible(false);

		btnSaveConfig = new Button(this, SWT.NONE);
		btnSaveConfig.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1));
		btnSaveConfig.setEnabled(false);
		btnSaveConfig.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				content = new String[5];
				if (!appPathText.getText().equals("")) {

					content[4] = appPathText.getText();

					if (platformCombo.getSelectionIndex() != -1) {

						content[1] = platformCombo.getItem(platformCombo.getSelectionIndex());

						if (client_server.getVisible() == true) {
							if (clientControllerCombo.getSelectionIndex() != -1) {

								content[2] = clientControllerCombo.getItem(clientControllerCombo.getSelectionIndex());
							}
							if (serverControllerCombo.getSelectionIndex() != -1) {

								content[3] = serverControllerCombo.getItem(serverControllerCombo.getSelectionIndex());
							}
						} else {
							content[2] = "";
							content[3] = "";
						}

					}
				}
				shell.dispose();

			}
		});
		btnSaveConfig.setText("Save Config");
		createContents();

		openShell(display);
	}

	private boolean appPathSet = false;
	private boolean platformSet = false;

	private void checkForFinish() {
		if (appPathSet && platformSet)
			btnSaveConfig.setEnabled(true);
		else
			btnSaveConfig.setEnabled(false);
	}

	private String[] content;
	private Text appPathText;

	/**
	 * 
	 * @return 0 = topology, 1 = platform, 2 = clientController, 3 =
	 *         serverController, 4 = appPath, null if content wasn't set or an
	 *         error occurred
	 */
	public String[] getSelectedContent() {
		return this.content;
	}

	private void setComboboxContent(CCombo combo) {

		combo.add(NetIDE.CONTROLLER_POX);
		combo.add(NetIDE.CONTROLLER_ENGINE);
		combo.add(NetIDE.CONTROLLER_FLOODLIGHT);
		combo.add(NetIDE.CONTROLLER_ODL);
		combo.add(NetIDE.CONTROLLER_PYRETIC);
		combo.add(NetIDE.CONTROLLER_RYU);

	}

	/**
	 * Create contents of the shell.
	 */
	protected void createContents() {
		setText("Choose App Run Configuration");
		setSize(338, 275);

	}

	private void showMessage(String msg) {
		MessageDialog.openInformation(shell, "NetIDE Workbench View", msg);
	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}
}

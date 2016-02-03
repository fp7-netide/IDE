package eu.netide.workbenchconfigurationeditor.editors;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.jobs.IJobChangeEvent;
import org.eclipse.core.runtime.jobs.IJobChangeListener;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CCombo;
import org.eclipse.swt.custom.CLabel;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.TabItem;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.IFileEditorInput;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.part.EditorPart;
import org.w3c.dom.Document;

import eu.netide.configuration.utils.NetIDE;
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel;
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel;

/**
 * 
 * @author Jan-Niclas Struewer
 *
 */
public class WbConfigurationEditor extends EditorPart implements IJobChangeListener {

	public static final String ID = "workbenchconfigurationeditor.editors.WbConfigurationEditor"; //$NON-NLS-1$
	private WbConfigurationEditor instanceWb = this;

	// parsed xml document
	private Document doc;
	private IFile file;
	private ArrayList<LaunchConfigurationModel> modelList;
	private ArrayList<SshProfileModel> profileList;
	private boolean serverControllerIsRunning;
	private ConfigurationShell tempShell;
	private LaunchConfigurationModel tmpModel;
	/**
	 * used to find the corresponding model to the selected table row
	 */
	private HashMap<TableItem, LaunchConfigurationModel> tableConfigMap;

	public WbConfigurationEditor() {

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void init(IEditorSite site, IEditorInput input) throws PartInitException {

		IFileEditorInput fileInput = (IFileEditorInput) input;
		this.tableConfigMap = new HashMap<TableItem, LaunchConfigurationModel>();
		// fills the modelList with the data from the xml file
		this.serverControllerIsRunning = false;
		file = fileInput.getFile();
		doc = XmlHelper.getDocFromFile(file);

		ArrayList[] parsed = XmlHelper.parseFileToModel(file, doc);

		modelList = parsed[0];
		profileList = parsed[1];

		StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).createVagrantFile(modelList);
		setSite(site);
		setInput(input);

		setPartName("Workbench");

	}

	/**
	 * Create contents of the editor part.
	 * 
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		createLayout(parent);

		addContentToTable();
		if (profileList != null)
			addContentToComboBox();

		addButtonListener();

	}

	private void addContentToTable() {
		for (LaunchConfigurationModel c : modelList) {
			addTableEntry(c);
		}
	}

	private void addContentToComboBox() {
		for (SshProfileModel p : profileList) {
			sshProfileCombo.add(p.getProfileName());
		}
	}

	/**
	 * 
	 * @param data
	 *            with 4 entries data[0] = pathName
	 */
	private void addTableEntry(LaunchConfigurationModel model) {
		String[] tmpS = new String[] { model.getAppName(), "offline", model.getPlatform(), model.getClientController(),
				model.getAppPort() };
		TableItem tmp = new TableItem(table, SWT.NONE);
		tableConfigMap.put(tmp, model);
		tmp.setText(tmpS);
	}

	private void addMininetButtonListener() {
		btnMininetOn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				mininetStatusLable.setText("Status: aktiv");
				StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).startMininet();
			}
		});

		btnMininetOff.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				mininetStatusLable.setText("Status: offline");
				StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).stopMininet();
			}
		});
	}

	private boolean vagrantRunning = false;

	private void addVagrantButtonListener() {
		btnVagrantUp.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				vagrantStatusLabel.setText("starting");
				noSwitch = true;

				StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).startVagrant(instanceWb);

			}
		});

		btnReattach.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0)
					StarterStarter.getStarter("").reattachStarter(tableConfigMap.get(table.getSelection()[0]));
			}
		});

		btnVagrantHalt.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				noSwitch = false;
				vagrantRunning = false;
				StarterStarter.getStarter("").haltVagrant();
				vagrantStatusLabel.setText("Status: offline");

				for (int i = 0; i < table.getItemCount(); i++) {
					table.getItem(i).setText(1, "offline");
					// TODO: check for unknown side effects
					// StarterStarter.getStarter("").stopStarter(tableConfigMap.get(table.getItem(i)));
				}

			}
		});
	}

	private void addTestButtonListener() {
		btnRemoveTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0) {
					TableItem[] toRemove = table.getSelection();
					for (TableItem i : toRemove) {
						LaunchConfigurationModel tmp = tableConfigMap.get(i);
						modelList.remove(tmp);
						XmlHelper.removeFromXml(doc, tmp, file);
					}
					int[] toRemoveIndex = table.getSelectionIndices();
					for (int i : toRemoveIndex) {
						table.remove(i);
					}

				} else {
					showMessage("Select a test to remove from the table.");
				}
			}
		});

		btnStopTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0) {
					TableItem tmpItem = table.getSelection()[0];
					StarterStarter.getStarter("").stopStarter(tableConfigMap.get(tmpItem));
					tmpItem.setText(1, "offline");
				}
			}
		});

		startBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				LaunchConfigurationModel toStart = null;
				if ((sshRunning || vagrantRunning)) {
					if (table.getSelectionCount() > 0) {
						TableItem selectedItem = table.getSelection()[0];
						toStart = tableConfigMap.get(selectedItem);
						if (toStart != null) {
							selectedItem.setText(1, "active");
							startApp(toStart);
						}
					}
					setVagrantLableReady();
				} else {
					showMessage("Make sure vagrant is running.");
				}
			}
		});

		btnAddTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				tmpModel = new LaunchConfigurationModel();

				tempShell = new ConfigurationShell(container.getDisplay());
				tempShell.openShell(null);

				String[] content = tempShell.getSelectedContent();
				if (content != null) {
					boolean complete = true;
					if (content[1].equals("") || content[4].equals(""))
						complete = false;

					if (complete) {
						tmpModel.setPlatform(content[1]);
						tmpModel.setClientController(content[2]);
						tmpModel.setAppPort(content[3]);
						tmpModel.setAppPath(content[4]);
						String[] tmp = content[4].split("/");
						String appName = tmp[tmp.length - 1];
						tmpModel.setAppName(appName);
						tmpModel.setID(UUID.randomUUID().toString());

						XmlHelper.addModelToXmlFile(doc, tmpModel, file);
						modelList.add(tmpModel);
						addTableEntry(tmpModel);
					}
				}

			}

		});

		btnEditTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				LaunchConfigurationModel toStart = null;

				if (table.getSelectionCount() > 0) {

					TableItem[] toRemove = table.getSelection();

					toStart = tableConfigMap.get(toRemove[0]);

					if (toStart != null) {

						tempShell = new ConfigurationShell(container.getDisplay());
						tempShell.openShell(toStart);

						String[] content = tempShell.getSelectedContent();
						if (content != null) {
							boolean complete = true;
							if (content[1].equals("") || content[4].equals(""))
								complete = false;

							if (complete) {
								for (TableItem i : toRemove) {
									LaunchConfigurationModel tmp = tableConfigMap.get(i);
									modelList.remove(tmp);
									XmlHelper.removeFromXml(doc, tmp, file);
								}

								int[] toRemoveIndex = table.getSelectionIndices();
								for (int i : toRemoveIndex) {
									table.remove(i);
								}
								tmpModel = new LaunchConfigurationModel();

								tmpModel.setPlatform(content[1]);
								tmpModel.setClientController(content[2]);
								tmpModel.setAppPort(content[3]);
								tmpModel.setAppPath(content[4]);
								String[] tmp = content[4].split("/");
								String appName = tmp[tmp.length - 1];
								tmpModel.setAppName(appName);
								tmpModel.setID(UUID.randomUUID().toString());

								XmlHelper.addModelToXmlFile(doc, tmpModel, file);
								modelList.add(tmpModel);
								addTableEntry(tmpModel);

							}
						}
					}

				}
			}
		});

		btnProvision.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				StarterStarter.getStarter("").reprovision();
			}
		});
	}

	private void addSshButtonListener() {
		tabFolder.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (noSwitch) {
					tabFolder.setSelection(currentPageIndex);
				} else {
					int newIndex = tabFolder.indexOf((TabItem) e.item);
					tabFolder.setSelection(newIndex);
					currentPageIndex = newIndex;
				}
			}
		});

		btnSSH_Up.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (sshProfileCombo.getSelectionIndex() != -1) {
					lblSShStatus.setText("Status: waiting");
					noSwitch = true;

					String modelName = sshProfileCombo.getItem(sshProfileCombo.getSelectionIndex());
					SshProfileModel model = getModelFromName(modelName);

					if (model != null) {
						StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).startSSH(modelList,
								instanceWb, model);
					}
				} else {
					showMessage("Please select / create a ssh Profile.");
				}

			}
		});

		btnCloseSSH.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				lblSShStatus.setText("Status: offline");
				StarterStarter.getStarter("").stopSSH();
				noSwitch = false;
				for (Control c : tabFolder.getTabList()) {
					c.setEnabled(true);

				}
			}
		});

		btnCreateProfile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				SShShell sshShell = new SShShell(container.getDisplay());
				sshShell.openShell(null);
				String[] result = sshShell.getResult();
				if (result != null) {

					SshProfileModel model = new SshProfileModel(result[0], result[1], result[2], result[3], result[4]);
					XmlHelper.addSshProfileToXmlFile(doc, model, file);
					profileList.add(model);
					sshProfileCombo.add(model.getProfileName());

				}

			}
		});

		btnEditProfile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (sshProfileCombo.getSelectionIndex() != -1) {
					String modelName = sshProfileCombo.getItem(sshProfileCombo.getSelectionIndex());
					SshProfileModel profile = getModelFromName(modelName);

					if (profile != null) {
						SShShell sshShell = new SShShell(container.getDisplay());
						sshShell.openShell(profile);

						sshProfileCombo.remove(sshProfileCombo.getSelectionIndex());
						profileList.remove(profile);
						XmlHelper.removeFromXml(doc, profile, file);
						sshProfileCombo.clearSelection();
						sshProfileCombo.deselectAll();

						if (!sshShell.deleteEntry()) {

							String[] result = sshShell.getResult();
							if (result != null) {
								XmlHelper.removeFromXml(doc, profile, file);

								SshProfileModel model = new SshProfileModel(result[0], result[1], result[2], result[3],
										result[4]);
								XmlHelper.addSshProfileToXmlFile(doc, model, file);
								profileList.add(model);
								sshProfileCombo.add(model.getProfileName());

							}
						}
					}

				} else {
					showMessage("Please select a profile to edit");
				}
			}
		});
	}

	private void addServerControllerButtonListener() {
		startServerController.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				String selection = selectServerCombo.getText();
				if (!serverControllerIsRunning && !selection.equals("")) {
					// Create starter for selected server controller
					StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).startServerController(selection);
					lblServerControllerStatus.setText("Status: running");
					serverControllerIsRunning = true;
					selectServerCombo.setEnabled(false);
				}
			}
		});

		btnStopServerController.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (serverControllerIsRunning) {
					// Stop starter
					StarterStarter.getStarter("").stopServerController();
					lblServerControllerStatus.setText("Status: offline");
					serverControllerIsRunning = false;
					selectServerCombo.setEnabled(true);
				}
			}
		});

	}

	private void addButtonListener() {
		addMininetButtonListener();
		addVagrantButtonListener();
		addTestButtonListener();
		addSshButtonListener();
		addServerControllerButtonListener();

	}

	private SshProfileModel getModelFromName(String name) {
		for (SshProfileModel m : profileList) {
			if (m.getProfileName().equals(name))
				return m;
		}
		return null;
	}

	private boolean noSwitch = false;
	private int currentPageIndex;

	private void setVagrantLableReady() {
		vagrantStatusLabel.setText("Status: running");
	}

	private void startApp(final LaunchConfigurationModel toStart) {

		final StarterStarter s = StarterStarter.getStarter(LaunchConfigurationModel.getTopology());

		s.startApp(toStart);

	}

	private void showMessage(String msg) {
		MessageDialog.openInformation(container.getShell(), "NetIDE Workbench View", msg);
	}

	public void createLayout(Composite parent) {
		container = new Composite(parent, SWT.NONE);
		container.setLayout(new GridLayout(1, false));

		Composite startAppComposite = new Composite(container, SWT.BORDER);

		GridData gd_startAppComposite = new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1);
		gd_startAppComposite.widthHint = 888;
		startAppComposite.setLayoutData(gd_startAppComposite);
		startAppComposite.setLayout(new GridLayout(2, false));

		tabFolder = new TabFolder(startAppComposite, SWT.NONE);
		GridData gd_tabFolder = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_tabFolder.widthHint = 515;
		tabFolder.setLayoutData(gd_tabFolder);

		sshTabItem = new TabItem(tabFolder, SWT.NONE);
		sshTabItem.setText("SSH");

		sshComposite = new Composite(tabFolder, SWT.NONE);
		sshTabItem.setControl(sshComposite);
		sshComposite.setLayout(new GridLayout(1, false));

		lblSShStatus = new Label(sshComposite, SWT.NONE);
		lblSShStatus.setBounds(0, 0, 59, 14);
		lblSShStatus.setText("Status: Offline");

		btnSSH_Up = new Button(sshComposite, SWT.NONE);

		btnSSH_Up.setBounds(0, 0, 94, 28);
		btnSSH_Up.setText("ssh Up");

		btnCloseSSH = new Button(sshComposite, SWT.NONE);
		btnCloseSSH.setText("ssh Close");

		composite = new Composite(sshComposite, SWT.NONE);
		GridData gd_composite = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_composite.widthHint = 400;
		composite.setLayoutData(gd_composite);
		composite.setLayout(new GridLayout(4, false));

		sshProfileCombo = new CCombo(composite, SWT.BORDER);
		sshProfileCombo.setEditable(false);
		GridData gd_sshProfileCombo = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_sshProfileCombo.widthHint = 161;
		sshProfileCombo.setLayoutData(gd_sshProfileCombo);

		btnCreateProfile = new Button(composite, SWT.NONE);

		btnCreateProfile.setText("Create Profile");

		btnEditProfile = new Button(composite, SWT.NONE);

		btnEditProfile.setBounds(0, 0, 94, 28);
		btnEditProfile.setText("Edit Profile");
		new Label(composite, SWT.NONE);

		vagrantTabItem = new TabItem(tabFolder, SWT.NONE);
		vagrantTabItem.setText("Vagrant");

		Composite vagrantButtons = new Composite(tabFolder, SWT.BORDER);
		vagrantTabItem.setControl(vagrantButtons);
		vagrantButtons.setLayout(new GridLayout(1, false));

		vagrantStatusLabel = new Label(vagrantButtons, SWT.NONE);
		vagrantStatusLabel.setText("Status: Offline");

		btnVagrantUp = new Button(vagrantButtons, SWT.NONE);

		btnVagrantUp.setText("Vagrant Up");

		btnVagrantHalt = new Button(vagrantButtons, SWT.NONE);
		btnVagrantHalt.setText("Vagrant Halt");

		currentPageIndex = tabFolder.getSelectionIndex();
		new Label(startAppComposite, SWT.NONE);

		Composite selectServerController = new Composite(startAppComposite, SWT.BORDER);
		GridData gd_selectServerController = new GridData(SWT.FILL, SWT.TOP, false, false, 1, 1);
		gd_selectServerController.heightHint = 60;
		selectServerController.setLayoutData(gd_selectServerController);
		selectServerController.setLayout(new GridLayout(3, false));

		lblServerControllerStatus = new CLabel(selectServerController, SWT.NONE);
		GridData gd_lblServerControllerStatus = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_lblServerControllerStatus.widthHint = 109;
		lblServerControllerStatus.setLayoutData(gd_lblServerControllerStatus);
		lblServerControllerStatus.setText("Status: Offline");
		new Label(selectServerController, SWT.NONE);
		new Label(selectServerController, SWT.NONE);
		selectServerCombo = new CCombo(selectServerController, SWT.BORDER);

		selectServerCombo.add(NetIDE.CONTROLLER_POX);
		selectServerCombo.add(NetIDE.CONTROLLER_ODL);

		GridData gd_selectServerCombo = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_selectServerCombo.heightHint = 22;
		gd_selectServerCombo.widthHint = 166;
		selectServerCombo.setLayoutData(gd_selectServerCombo);
		startServerController = new Button(selectServerController, SWT.BORDER);

		startServerController.setText("Start Server Controller");
		GridData gd_startServerController = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_startServerController.widthHint = 166;
		startServerController.setLayoutData(gd_startServerController);

		btnStopServerController = new Button(selectServerController, SWT.NONE);

		btnStopServerController.setText("Stop Server Controller");

		mininetComposite = new Composite(startAppComposite, SWT.NONE);
		mininetComposite.setLayout(new GridLayout(1, false));
		GridData gd_mininetComposite = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_mininetComposite.widthHint = 115;
		mininetComposite.setLayoutData(gd_mininetComposite);

		mininetStatusLable = new Label(mininetComposite, SWT.NONE);
		mininetStatusLable.setText("Status: Offline");

		btnMininetOn = new Button(mininetComposite, SWT.NONE);

		btnMininetOn.setText("Mininet On");

		btnMininetOff = new Button(mininetComposite, SWT.NONE);

		btnMininetOff.setText("Mininet Off");

		table = new Table(startAppComposite, SWT.BORDER | SWT.FULL_SELECTION);
		table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));

		TableColumn tc1 = new TableColumn(table, SWT.CENTER);
		TableColumn tc2 = new TableColumn(table, SWT.CENTER);
		TableColumn tc3 = new TableColumn(table, SWT.CENTER);
		TableColumn tc4 = new TableColumn(table, SWT.CENTER);
		TableColumn tc5 = new TableColumn(table, SWT.CENTER);
		tc1.setText("App Name");
		tc2.setText("Aktiv");
		tc3.setText("Platform");
		tc4.setText("Client");
		tc5.setText("Port");
		tc1.setWidth(120);
		tc2.setWidth(80);
		tc3.setWidth(100);
		tc4.setWidth(100);
		tc5.setWidth(100);
		table.setHeaderVisible(true);
		table.setLinesVisible(true);

		Composite buttonComposite = new Composite(startAppComposite, SWT.BORDER);
		buttonComposite.setLayout(new GridLayout(1, false));
		GridData gd_buttonComposite = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_buttonComposite.widthHint = 101;
		buttonComposite.setLayoutData(gd_buttonComposite);

		startBTN = new Button(buttonComposite, SWT.NONE);
		startBTN.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));

		startBTN.setText("Start");

		btnStopTest = new Button(buttonComposite, SWT.NONE);
		btnStopTest.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		btnStopTest.setText("Stop");

		btnReload = new Button(buttonComposite, SWT.NONE);
		btnReload.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		btnReload.setText("Reload");

		btnReattach = new Button(buttonComposite, SWT.NONE);
		btnReattach.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		btnReattach.setText("Reattach");

		btnProvision = new Button(buttonComposite, SWT.NONE);

		btnProvision.setText("Provision");

		testButtons = new Composite(startAppComposite, SWT.NONE);
		GridData gd_testButtons = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_testButtons.widthHint = 518;
		testButtons.setLayoutData(gd_testButtons);
		testButtons.setLayout(new GridLayout(3, false));

		btnAddTest = new Button(testButtons, SWT.NONE);
		btnAddTest.setText("Add Test");

		btnRemoveTest = new Button(testButtons, SWT.NONE);
		btnRemoveTest.setText("Remove Test");

		btnEditTest = new Button(testButtons, SWT.NONE);
		btnEditTest.setText("Edit Test");
		new Label(startAppComposite, SWT.NONE);
	}

	@Override
	public void setFocus() {
		// Set the focus
	}

	@Override
	public void doSave(IProgressMonitor monitor) {
		// Do the Save operation
	}

	@Override
	public void doSaveAs() {
		// Do the Save As operation
	}

	@Override
	public boolean isDirty() {
		return false;
	}

	@Override
	public boolean isSaveAsAllowed() {
		return false;
	}

	@Override
	public void aboutToRun(IJobChangeEvent event) {
		// TODO Auto-generated method stub

	}

	@Override
	public void awake(IJobChangeEvent event) {
		// TODO Auto-generated method stub

	}

	private boolean sshRunning = false;

	@Override
	public void done(IJobChangeEvent event) {
		if (event.getJob().getName().equals("VagrantManager")) {
			Display.getDefault().syncExec(new Runnable() {
				public void run() {
					setVagrantLableReady();
					vagrantRunning = true;
				}
			});
		} else if (event.getJob().getName().equals("SshManager")) {
			Display.getDefault().syncExec(new Runnable() {

				public void run() {
					lblSShStatus.setText("Status: running");
					sshRunning = true;
				}

			});
		}
	}

	@Override
	public void running(IJobChangeEvent event) {
		// TODO Auto-generated method stub

	}

	@Override
	public void scheduled(IJobChangeEvent event) {
		// TODO Auto-generated method stub

	}

	@Override
	public void sleeping(IJobChangeEvent event) {
		// TODO Auto-generated method stub

	}

	private Composite testButtons;
	private CLabel lblServerControllerStatus;
	private Button btnStopServerController;
	private Button btnVagrantUp;
	private Composite mininetComposite;
	private Button btnMininetOff;
	private Label vagrantStatusLabel;
	private Label mininetStatusLable;
	private Composite sshComposite;
	private Button startBTN;
	private Button btnVagrantHalt;
	private Button btnReload;
	private Button btnReattach;
	private Button btnAddTest;
	private Button btnRemoveTest;
	private Button btnStopTest;
	private Button btnEditProfile;
	private CCombo selectServerCombo;
	private Button startServerController;
	private Button btnMininetOn;
	private Button btnSSH_Up;
	private Button btnCloseSSH;
	private Composite container;
	private Table table;
	private Label lblSShStatus;
	private TabFolder tabFolder;
	private TabItem vagrantTabItem;
	private TabItem sshTabItem;
	private Button btnCreateProfile;
	private Composite composite;
	private CCombo sshProfileCombo;
	private Button btnEditTest;
	private Button btnProvision;
}

package eu.netide.workbenchconfigurationeditor.view;

import java.util.UUID;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.jobs.IJobChangeEvent;
import org.eclipse.core.runtime.jobs.IJobChangeListener;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ComboViewer;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.ControlAdapter;
import org.eclipse.swt.events.ControlEvent;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.TabItem;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.IFileEditorInput;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.part.EditorPart;

import eu.netide.configuration.utils.NetIDE;
import eu.netide.workbenchconfigurationeditor.controller.ControllerManager;
import eu.netide.workbenchconfigurationeditor.controller.WorkbenchConfigurationEditorEngine;
import eu.netide.workbenchconfigurationeditor.dialogs.ConfigurationShell;
import eu.netide.workbenchconfigurationeditor.dialogs.SShShell;
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel;
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel;
import eu.netide.workbenchconfigurationeditor.util.Constants;

/**
 * 
 * @author Jan-Niclas Struewer
 *
 */
public class WbConfigurationEditor extends EditorPart implements IJobChangeListener {

	public static final String ID = "workbenchconfigurationeditor.editors.WbConfigurationEditor"; //$NON-NLS-1$
	private WbConfigurationEditor instanceWb = this;
	private WorkbenchConfigurationEditorEngine engine;

	private IFile file;

	private boolean isDirty;

	private ConfigurationShell tempShell;
	private LaunchConfigurationModel tmpModel;

	public WbConfigurationEditor() {
		try {
			ResourcesPlugin.getWorkspace().getRoot().refreshLocal(IResource.DEPTH_INFINITE, null);
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void init(IEditorSite site, IEditorInput input) throws PartInitException {
		this.isDirty = false;
		IFileEditorInput fileInput = (IFileEditorInput) input;
		file = fileInput.getFile();
		//TODO: StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).createVagrantFile(modelList);
		setSite(site);
		setInput(input);

		setPartName("Workbench");

	}

	public IFile getFile() {
		return this.file;
	}

	/**
	 * Create contents of the editor part.
	 * 
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		createLayout(parent);
		engine = new WorkbenchConfigurationEditorEngine(this);
		addButtonListener();

	}

	private void addMininetButtonListener() {
		btnMininetOn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().startMininet();
			}
		});

		btnMininetOff.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().stopMininet();
			}
		});
	}

	private void addVagrantButtonListener() {
		btnVagrantUp.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				noSwitch = true;
				ControllerManager.getStarter().startVagrant(instanceWb);
			}
		});

		btnReattach.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0)
					ControllerManager.getStarter().reattachStarter();
			}
		});

		btnVagrantHalt.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				noSwitch = false;
				engine.getStatusModel().setVagrantRunning(false);
				ControllerManager.getStarter().haltVagrant();
			}
		});
	}

	private void addTestButtonListener() {
		btnRemoveTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0) {
					engine.getStatusModel().removeEntryFromModelList();
					setIsDirty(true);
				} else {
					showMessage("Select a test to remove from the table.");
				}
			}
		});

		btnStopTest.addSelectionListener(new SelectionAdapter() {

			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0) {
					ControllerManager.getStarter().stopStarter();
				}
			}
		});

		startBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if ((engine.getStatusModel().getSshRunning() || engine.getStatusModel().getVagrantRunning())) {
					if (table.getSelectionCount() > 0) {
						ControllerManager.getStarter().startApp();
					} else {
						showMessage("Make sure vagrant is running.");
					}
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
						tmpModel.setRunning(false);
						String[] tmp = content[4].split("/");
						String appName = tmp[tmp.length - 1];
						tmpModel.setAppName(appName);
						tmpModel.setID(UUID.randomUUID().toString());
						setIsDirty(true);

						engine.getStatusModel().addEntryToModelList(tmpModel);
					}
				}

			}

		});

		btnEditTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				if (table.getSelectionCount() > 0) {
					LaunchConfigurationModel model = engine.getStatusModel().getModelAtIndex();
					tempShell = new ConfigurationShell(container.getDisplay());
					tempShell.openShell(model);

					String[] content = tempShell.getSelectedContent();
					if (content != null) {
						boolean complete = true;
						if (content[1].equals("") || content[4].equals(""))
							complete = false;

						if (complete) {

							model.setPlatform(content[1]);
							model.setClientController(content[2]);
							model.setAppPort(content[3]);
							model.setAppPath(content[4]);
							String[] tmp = content[4].split("/");
							String appName = tmp[tmp.length - 1];
							model.setAppName(appName);
							model.setID(UUID.randomUUID().toString());

							setIsDirty(true);
						}

					}

				}
			}
		});

		btnProvision_1.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().reprovision();
			}
		});
		btnProvision_2.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().reprovision();
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

					SshProfileModel model = engine.getStatusModel().getSshModelAtIndex();

					if (model != null) {
						ControllerManager.getStarter().startSSH(engine.getStatusModel().getModelList(), instanceWb,
								model);
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
				ControllerManager.getStarter().stopSSH();
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

					SshProfileModel model = new SshProfileModel();
					model.setHost(result[0]);
					model.setPort(result[1]);
					model.setUsername(result[2]);
					model.setProfileName(result[3]);
					model.setProfileName(result[4]);

					engine.getStatusModel().addEntryToSSHList(model);
					setIsDirty(true);
				}

			}
		});

		btnEditProfile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (sshProfileCombo.getSelectionIndex() != -1) {

					SshProfileModel profile = engine.getStatusModel().getSshModelAtIndex();

					if (profile != null) {
						SShShell sshShell = new SShShell(container.getDisplay());
						sshShell.openShell(profile);

						setIsDirty(true);

						if (sshShell.deleteEntry()) {
							engine.getStatusModel().removeEntryFromSSHList(profile);
						}

						sshProfileCombo.clearSelection();
						sshProfileCombo.deselectAll();
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

				String selection = engine.getStatusModel().getServerControllerSelection();
				if (!engine.getStatusModel().getServerControllerRunning() && !selection.equals("")) {
					// Create starter for selected server controller
					ControllerManager.getStarter().startServerController(selection);

					engine.getStatusModel().setServerControllerRunning(true);
					selectServerCombo.setEnabled(false);
				}
			}
		});

		btnStopServerController.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (engine.getStatusModel().getServerControllerRunning()) {
					// Stop starter
					ControllerManager.getStarter().stopServerController();
					engine.getStatusModel().setServerControllerRunning(false);
					selectServerCombo.setEnabled(true);
				}
			}
		});

	}

	public void addButtonListener() {
		addMininetButtonListener();
		addVagrantButtonListener();
		addTestButtonListener();
		addSshButtonListener();
		addServerControllerButtonListener();

	}

	private boolean noSwitch = false;
	private int currentPageIndex;

	private void showMessage(String msg) {
		MessageDialog.openInformation(container.getShell(), "NetIDE Workbench View", msg);
	}

	public void createLayout(Composite parent) {

		container = new Composite(parent, SWT.NONE);
		container.setLayout(new FillLayout());

		final ScrolledComposite sc2 = new ScrolledComposite(container, SWT.H_SCROLL | SWT.V_SCROLL | SWT.BORDER);
		sc2.setExpandHorizontal(true);
		sc2.setExpandVertical(true);

		final Composite startAppComposite = new Composite(sc2, SWT.BORDER);

		sc2.setContent(startAppComposite);

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

		composite_1 = new Composite(sshComposite, SWT.NONE);
		composite_1.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		composite_1.setLayout(new GridLayout(2, false));

		lblSShStatus = new Label(composite_1, SWT.NONE);
		lblSShStatus.setText("Status: Offline");
		new Label(composite_1, SWT.NONE);

		btnSSH_Up = new Button(composite_1, SWT.NONE);
		btnSSH_Up.setText("Start ssh Manager");
		new Label(composite_1, SWT.NONE);

		btnCloseSSH = new Button(composite_1, SWT.NONE);
		btnCloseSSH.setText("ssh Close");

		btnProvision_1 = new Button(composite_1, SWT.NONE);
		btnProvision_1.setText("Provision");

		composite = new Composite(sshComposite, SWT.NONE);
		GridData gd_composite = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_composite.widthHint = 400;
		composite.setLayoutData(gd_composite);
		composite.setLayout(new GridLayout(4, false));

		sshProfileCombo = new Combo(composite, SWT.BORDER);

		GridData gd_sshProfileCombo = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_sshProfileCombo.widthHint = 161;
		sshProfileCombo.setLayoutData(gd_sshProfileCombo);
		sshComboViewer = new ComboViewer(sshProfileCombo);

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
		vagrantButtons.setLayout(new GridLayout(2, false));

		vagrantStatusLabel = new Label(vagrantButtons, SWT.NONE);
		vagrantStatusLabel.setText("Status: Offline");
		new Label(vagrantButtons, SWT.NONE);

		btnVagrantUp = new Button(vagrantButtons, SWT.NONE);

		btnVagrantUp.setText("Vagrant Up");
		new Label(vagrantButtons, SWT.NONE);

		btnVagrantHalt = new Button(vagrantButtons, SWT.NONE);
		btnVagrantHalt.setText("Vagrant Halt");

		btnProvision_2 = new Button(vagrantButtons, SWT.NONE);
		btnProvision_2.setText("Provision");

		currentPageIndex = tabFolder.getSelectionIndex();
		new Label(startAppComposite, SWT.NONE);

		Composite selectServerController = new Composite(startAppComposite, SWT.BORDER);
		GridData gd_selectServerController = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_selectServerController.heightHint = 84;
		selectServerController.setLayoutData(gd_selectServerController);
		selectServerController.setLayout(new GridLayout(3, false));

		lblServerControllerStatus = new Label(selectServerController, SWT.NONE);
		GridData gd_lblServerControllerStatus = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_lblServerControllerStatus.widthHint = 109;
		lblServerControllerStatus.setLayoutData(gd_lblServerControllerStatus);
		lblServerControllerStatus.setText(Constants.LABEL_OFFLINE);
		new Label(selectServerController, SWT.NONE);
		new Label(selectServerController, SWT.NONE);

		selectServerCombo = new Combo(selectServerController, SWT.BORDER);
		selectServerCombo.add(NetIDE.CONTROLLER_POX);
		selectServerCombo.add(NetIDE.CONTROLLER_ODL);

		GridData gd_selectServerCombo = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_selectServerCombo.heightHint = 22;
		gd_selectServerCombo.widthHint = 166;
		selectServerCombo.setLayoutData(gd_selectServerCombo);

		serverComboViewer = new ComboViewer(selectServerCombo);

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

		tableViewer = new TableViewer(startAppComposite,
				SWT.SINGLE | SWT.H_SCROLL | SWT.V_SCROLL | SWT.FULL_SELECTION | SWT.BORDER);

		table = tableViewer.getTable();
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

		sc2.addControlListener(new ControlAdapter() {
			public void controlResized(ControlEvent e) {
				sc2.setMinSize(startAppComposite.computeSize(SWT.DEFAULT, SWT.DEFAULT));
			}
		});

	}

	@Override
	public void setFocus() {
		// Set the focus
	}

	@Override
	public void doSave(IProgressMonitor monitor) {
		
		// do saving
		engine.saveAllChanges();
		setIsDirty(false);
	}

	@Override
	public void doSaveAs() {
		// Do the Save As operation
	}

	@Override
	public boolean isDirty() {
		return this.isDirty;
	}

	private void setIsDirty(boolean dirty) {
		if (dirty != this.isDirty) {
			this.isDirty = dirty;
			this.firePropertyChange(PROP_DIRTY);
		}
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

	@Override
	public void done(IJobChangeEvent event) {
		if (event.getJob().getName().equals("VagrantManager")) {
			Display.getDefault().syncExec(new Runnable() {
				public void run() {
					engine.getStatusModel().setVagrantRunning(true);
				}
			});
		} else if (event.getJob().getName().equals("SshManager")) {
			Display.getDefault().syncExec(new Runnable() {

				public void run() {
					engine.getStatusModel().setSshRunning(true);
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
	private Label lblServerControllerStatus;
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
	private Combo selectServerCombo;
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
	private Combo sshProfileCombo;
	private Button btnEditTest;
	private Composite composite_1;
	private Button btnProvision_1;
	private Button btnProvision_2;
	private TableViewer tableViewer;
	private ComboViewer sshComboViewer;
	private ComboViewer serverComboViewer;

	public Label getServerControllerLabel() {
		return this.lblServerControllerStatus;
	}

	public Label getSSHStautsLabel() {
		return this.lblSShStatus;
	}

	public Label getVagrantStatusLabel() {
		return vagrantStatusLabel;
	}

	public Label getMininetStatusLable() {
		return mininetStatusLable;
	}

	public TableViewer getTableViewer() {
		return this.tableViewer;
	}

	public ComboViewer getSshComboViewer() {
		return this.sshComboViewer;
	}

	public ComboViewer getServerComboViewer() {
		return this.serverComboViewer;
	}
}

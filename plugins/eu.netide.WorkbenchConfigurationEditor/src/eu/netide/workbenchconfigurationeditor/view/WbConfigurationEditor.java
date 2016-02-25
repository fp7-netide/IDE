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
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.TabItem;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.IFileEditorInput;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.dialogs.ElementTreeSelectionDialog;
import org.eclipse.ui.model.BaseWorkbenchContentProvider;
import org.eclipse.ui.model.WorkbenchLabelProvider;
import org.eclipse.ui.part.EditorPart;

import eu.netide.configuration.utils.NetIDE;
import eu.netide.workbenchconfigurationeditor.controller.ControllerManager;
import eu.netide.workbenchconfigurationeditor.controller.WorkbenchConfigurationEditorEngine;
import eu.netide.workbenchconfigurationeditor.dialogs.ConfigurationShell;
import eu.netide.workbenchconfigurationeditor.dialogs.SShShell;
import eu.netide.workbenchconfigurationeditor.model.CompositionModel;
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

	private void addCoreButtonListener() {
		this.startCoreBtn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().startCore();
			}
		});

		this.stopCoreBtn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().stopCore();
			}
		});

		this.browseCompositionBtn.addSelectionListener(new SelectionAdapter() {
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

							selectedFile = (IFile) result[0];

							path = selectedFile.getFullPath().toOSString();
							CompositionModel m = new CompositionModel();
							m.setCompositionPath(path);
							engine.getStatusModel().addCompositionToList(m);
							setIsDirty(true);
						} else {
							showMessage("Please select a Composition.");
						}

					}
				}
			}
		});

		this.loadCompositionBtn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().loadComposition();
			}
		});
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

		btnInitVagrantFile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				// TODO:
				ControllerManager.getStarter().createVagrantFile();
			}
		});

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

		btnCopyApps.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				ControllerManager.getStarter().copyApps();
			}
		});

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
					model.setSshIdFile(result[2]);
					model.setUsername(result[3]);
					model.setProfileName(result[4]);

					model.setSecondUsername(result[5]);
					model.setSecondHost(result[6]);
					model.setSecondPort(result[7]);

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
		addCoreButtonListener();

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
		startAppComposite.setLayout(new GridLayout(1, false));

		tabFolder = new TabFolder(startAppComposite, SWT.BORDER);
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
		composite_1.setLayout(new GridLayout(5, false));

		lblSShStatus = new Label(composite_1, SWT.NONE);
		lblSShStatus.setText("Status: Offline");

		btnSSH_Up = new Button(composite_1, SWT.NONE);
		btnSSH_Up.setText("On");

		btnCloseSSH = new Button(composite_1, SWT.NONE);
		btnCloseSSH.setText("Off");

		btnProvision_1 = new Button(composite_1, SWT.NONE);
		btnProvision_1.setText("Provision");

		btnCopyApps = new Button(composite_1, SWT.NONE);

		btnCopyApps.setText("Copy Apps ");

		composite = new Composite(sshComposite, SWT.NONE);
		GridData gd_composite = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_composite.widthHint = 400;
		composite.setLayoutData(gd_composite);
		composite.setLayout(new GridLayout(4, false));

		sshProfileCombo = new Combo(composite, SWT.BORDER | SWT.READ_ONLY);

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

		Composite vagrantButtons = new Composite(tabFolder, SWT.NONE);
		vagrantTabItem.setControl(vagrantButtons);
		vagrantButtons.setLayout(new GridLayout(4, false));

		btnInitVagrantFile = new Button(vagrantButtons, SWT.NONE);

		btnInitVagrantFile.setText("Init Vagrant File");
		new Label(vagrantButtons, SWT.NONE);
		new Label(vagrantButtons, SWT.NONE);
		new Label(vagrantButtons, SWT.NONE);

		vagrantStatusLabel = new Label(vagrantButtons, SWT.NONE);
		vagrantStatusLabel.setText("Status: Offline");

		btnVagrantUp = new Button(vagrantButtons, SWT.NONE);

		btnVagrantUp.setText("Up");

		btnVagrantHalt = new Button(vagrantButtons, SWT.NONE);
		btnVagrantHalt.setText("Halt");

		btnProvision_2 = new Button(vagrantButtons, SWT.NONE);
		btnProvision_2.setText("Provision");

		currentPageIndex = tabFolder.getSelectionIndex();

		composite_2 = new Composite(startAppComposite, SWT.NONE);

		GridData gd_composite_2 = new GridData(SWT.FILL, SWT.TOP, false, false, 1, 1);
		gd_composite_2.widthHint = 624;
		gd_composite_2.heightHint = 175;
		composite_2.setLayoutData(gd_composite_2);
		composite_2.setLayout(new GridLayout(2, false));

		composite_3 = new Composite(composite_2, SWT.NONE);
		GridData gd_composite_3 = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_composite_3.widthHint = 300;
		gd_composite_3.heightHint = 155;
		composite_3.setLayoutData(gd_composite_3);
		composite_3.setLayout(new GridLayout(1, false));

		grpCore = new Group(composite_3, SWT.BORDER);

		grpCore.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		grpCore.setText("Core");
		grpCore.setLayout(new GridLayout(3, false));

		lblCoreStatus = new Label(grpCore, SWT.NONE);
		lblCoreStatus.setText("Status : Offline");

		startCoreBtn = new Button(grpCore, SWT.NONE);
		startCoreBtn.setText("On");

		stopCoreBtn = new Button(grpCore, SWT.NONE);
		stopCoreBtn.setText("Off");

		grpCompositionLoader = new Group(composite_3, SWT.NONE);
		grpCompositionLoader.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		grpCompositionLoader.setText("Composition Loader");
		grpCompositionLoader.setLayout(new GridLayout(3, false));
		new Label(grpCompositionLoader, SWT.NONE);
		new Label(grpCompositionLoader, SWT.NONE);
		new Label(grpCompositionLoader, SWT.NONE);

		combo_Composition = new Combo(grpCompositionLoader, SWT.NONE);
		GridData gd_combo_Composition = new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1);
		gd_combo_Composition.widthHint = 128;
		combo_Composition.setLayoutData(gd_combo_Composition);

		combo_Composition_Viewer = new ComboViewer(combo_Composition);

		browseCompositionBtn = new Button(grpCompositionLoader, SWT.NONE);
		browseCompositionBtn.setText("Browse");

		loadCompositionBtn = new Button(grpCompositionLoader, SWT.NONE);
		loadCompositionBtn.setText("Load");

		composite_4 = new Composite(composite_2, SWT.NONE);
		composite_4.setLayout(new GridLayout(1, false));
		GridData gd_composite_4 = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_composite_4.widthHint = 321;
		composite_4.setLayoutData(gd_composite_4);

		grpServerController = new Group(composite_4, SWT.NONE);
		grpServerController.setLayout(new GridLayout(4, false));
		grpServerController.setText("Server Controller");

		lblServerControllerStatus = new Label(grpServerController, SWT.NONE);
		lblServerControllerStatus.setText(Constants.LABEL_OFFLINE);

		selectServerCombo = new Combo(grpServerController, SWT.BORDER | SWT.READ_ONLY);
		GridData gd_selectServerCombo = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_selectServerCombo.widthHint = 123;
		selectServerCombo.setLayoutData(gd_selectServerCombo);
		selectServerCombo.add(NetIDE.CONTROLLER_POX);
		selectServerCombo.add(NetIDE.CONTROLLER_ODL);

		serverComboViewer = new ComboViewer(selectServerCombo);

		startServerController = new Button(grpServerController, SWT.BORDER);

		startServerController.setText("On");

		btnStopServerController = new Button(grpServerController, SWT.NONE);

		btnStopServerController.setText("Off");

		grpMininet = new Group(composite_4, SWT.NONE);
		grpMininet.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		grpMininet.setText("Mininet");
		grpMininet.setLayout(new GridLayout(3, false));

		mininetStatusLable = new Label(grpMininet, SWT.NONE);
		mininetStatusLable.setText("Status: Offline");

		btnMininetOn = new Button(grpMininet, SWT.NONE);
		btnMininetOn.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1));

		btnMininetOn.setText("On");

		btnMininetOff = new Button(grpMininet, SWT.NONE);

		btnMininetOff.setText("Off");

		grpConfigurationOverview = new Group(startAppComposite, SWT.NONE);
		grpConfigurationOverview.setLayout(new GridLayout(2, false));
		grpConfigurationOverview.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		grpConfigurationOverview.setText("Configuration Overview");

		tableViewer = new TableViewer(grpConfigurationOverview,
				SWT.SINGLE | SWT.H_SCROLL | SWT.V_SCROLL | SWT.FULL_SELECTION | SWT.BORDER);

		table = tableViewer.getTable();
		table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));

		TableColumn tc1 = new TableColumn(table, SWT.CENTER);
		TableColumn tc2 = new TableColumn(table, SWT.CENTER);
		TableColumn tc3 = new TableColumn(table, SWT.CENTER);
		TableColumn tc4 = new TableColumn(table, SWT.CENTER);
		TableColumn tc5 = new TableColumn(table, SWT.CENTER);
		tc1.setText("App Name");
		tc2.setText("Active");
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

		Composite buttonComposite = new Composite(grpConfigurationOverview, SWT.NONE);
		buttonComposite.setLayout(new GridLayout(1, false));

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

		testButtons = new Composite(grpConfigurationOverview, SWT.NONE);
		testButtons.setLayout(new GridLayout(3, false));

		btnAddTest = new Button(testButtons, SWT.NONE);
		btnAddTest.setText("Add");

		btnRemoveTest = new Button(testButtons, SWT.NONE);
		btnRemoveTest.setText("Remove");

		btnEditTest = new Button(testButtons, SWT.NONE);
		btnEditTest.setText("Edit");
		new Label(grpConfigurationOverview, SWT.NONE);

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
	private ComboViewer combo_Composition_Viewer;
	private Button browseCompositionBtn;
	private Button loadCompositionBtn;
	private Label lblCoreStatus;
	private Button startCoreBtn;
	private Button stopCoreBtn;
	private Group grpMininet;
	private Group grpCore;
	private Group grpServerController;
	private Composite composite_2;
	private Composite composite_3;
	private Composite composite_4;
	private Group grpCompositionLoader;
	private Group grpConfigurationOverview;
	private Button btnInitVagrantFile;
	private Button btnCopyApps;
	private Combo combo_Composition;

	public Label getCoreStatusLabel() {
		return this.lblCoreStatus;
	}

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

	public ComboViewer getCompositionComboViewer() {
		return this.combo_Composition_Viewer;
	}
}
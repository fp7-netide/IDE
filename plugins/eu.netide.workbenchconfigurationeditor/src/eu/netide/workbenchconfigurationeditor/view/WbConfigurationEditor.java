package eu.netide.workbenchconfigurationeditor.view;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.jobs.IJobChangeEvent;
import org.eclipse.core.runtime.jobs.IJobChangeListener;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ComboViewer;
import org.eclipse.jface.viewers.DoubleClickEvent;
import org.eclipse.jface.viewers.IDoubleClickListener;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.ControlAdapter;
import org.eclipse.swt.events.ControlEvent;
import org.eclipse.swt.events.DisposeEvent;
import org.eclipse.swt.events.DisposeListener;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
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
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.TabItem;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.IFileEditorInput;
import org.eclipse.ui.IViewPart;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.dialogs.ElementTreeSelectionDialog;
import org.eclipse.ui.model.BaseWorkbenchContentProvider;
import org.eclipse.ui.model.WorkbenchLabelProvider;
import org.eclipse.ui.part.EditorPart;

import eu.netide.configuration.utils.NetIDE;
import eu.netide.toolpanel.views.ReplayPanel;
import eu.netide.toolpanel.views.ToolPanel;
import eu.netide.workbenchconfigurationeditor.controller.ControllerManager;
import eu.netide.workbenchconfigurationeditor.controller.WorkbenchConfigurationEditorEngine;
import eu.netide.workbenchconfigurationeditor.dialogs.ConfigurationShell;
import eu.netide.workbenchconfigurationeditor.dialogs.SShShell;
import eu.netide.workbenchconfigurationeditor.model.CompositionModel;
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel;
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel;
import eu.netide.workbenchconfigurationeditor.model.TopologyModel;
import eu.netide.workbenchconfigurationeditor.util.Constants;

/**
 * 
 * @author Jan-Niclas Struewer
 *
 */
public class WbConfigurationEditor extends EditorPart implements IJobChangeListener {

	public static final String ID = "eu.netide.workbenchconfigurationeditor"; //$NON-NLS-1$
	private WbConfigurationEditor instanceWb = this;
	private WorkbenchConfigurationEditorEngine engine;

	private IFile file;

	private boolean isDirty;

	private ConfigurationShell tempShell;
	private LaunchConfigurationModel tmpModel;
	private ControllerManager controllerManager;

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

		setPartName(file.getName());

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
		controllerManager = new ControllerManager(engine.getStatusModel(), getFile());
		addButtonListener();
		if (sshProfileCombo.getSelectionIndex() != -1) {
			// lblSShStatus.setText("Status: waiting");
			checkSwitch();

			SshProfileModel model = engine.getStatusModel().getSshModelAtIndex();

			if (model != null) {
				controllerManager.startSSH(engine.getStatusModel().getModelList(), instanceWb, model);
			}
		}

	}

	public void addTopoButtonListener() {

		this.btnLoadTopo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.initTopo();
			}
		});

		this.btnBrowse_topo.addSelectionListener(new SelectionAdapter() {
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

							path = selectedFile.getFullPath().toString();
							path = "platform:/resource".concat(path);
							TopologyModel m = new TopologyModel();
							m.setTopologyPath(path);

							engine.getStatusModel().getTopologyModel().setTopologyPath(path);

							setIsDirty(true);
						} else {
							showMessage("Please select a Topology.");
						}

					}
				}
			}
		});
	}

	private void addCoreButtonListener() {
		this.startCoreBtn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.startCore();
			}
		});

		this.stopCoreBtn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.stopCore();
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

							path = selectedFile.getFullPath().toString();
							path = "platform:/resource".concat(path);
							CompositionModel m = new CompositionModel();
							m.setCompositionPath(path);
							engine.getStatusModel().getCompositionModel().setCompositionPath(path);

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
				controllerManager.loadComposition();
			}
		});
	}

	private void addMininetButtonListener() {
		btnMininetOn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.startMininet();
			}
		});

		btnMininetOff.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.stopMininet();
			}
		});
	}

	private void addVagrantButtonListener() {

		btnInitVagrantFile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				controllerManager.createVagrantFile();
			}
		});

		btnVagrantUp.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.startVagrant(instanceWb);
				checkSwitch();
			}
		});

		btnReattach.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0)
					controllerManager.reattachStarter();
			}
		});

		btnVagrantHalt.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				engine.getStatusModel().setVagrantRunning(false);
				controllerManager.haltVagrant();
				checkSwitch();
			}
		});
	}

	private void startApp() {
		if ((engine.getStatusModel().getSshRunning() || engine.getStatusModel().getVagrantRunning())) {
			if (table.getSelectionCount() > 0) {
				controllerManager.startApp();
			} else {
				showMessage("Make sure vagrant is running or a ssh connection is established.");
			}
		}
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
					controllerManager.stopStarter();
				}
			}
		});

		startBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				startApp();
			}
		});

		btnAddTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				tempShell = new ConfigurationShell(container.getDisplay());
				tempShell.openShell(null);

				tmpModel = tempShell.getModel();
				if (tmpModel != null) {
					boolean complete = true;
					if (tmpModel.getPlatform().equals("") || tmpModel.getAppPath().equals(""))
						complete = false;

					if (complete) {

						engine.getStatusModel().addEntryToModelList(tmpModel);
						setIsDirty(true);
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

					model = tempShell.getModel();
					if (model != null) {
						boolean complete = true;
						if (model.getPlatform().equals("") || model.getAppPath().equals(""))
							complete = false;

						if (complete) {

							setIsDirty(true);
						}

					}

				}
			}
		});

		tableViewer.addDoubleClickListener(new IDoubleClickListener() {

			@Override
			public void doubleClick(DoubleClickEvent event) {
				startApp();
			}

		});

		btnProvision_1.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				MessageBox messageBox = new MessageBox(container.getShell(), SWT.ICON_QUESTION | SWT.YES | SWT.NO);
				messageBox.setMessage("Do you really want to use provision, it will take a long time?");
				messageBox.setText("Provision ");
				int response = messageBox.open();
				if (response == SWT.YES)
					controllerManager.reprovision();
			}
		});
		btnProvision_2.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				MessageBox messageBox = new MessageBox(container.getShell(), SWT.ICON_QUESTION | SWT.YES | SWT.NO);
				messageBox.setMessage("Do you really want to use provision, it will take a long time?");
				messageBox.setText("Provision ");
				int response = messageBox.open();
				if (response == SWT.YES)
					controllerManager.reprovision();
			}
		});
	}

	private void addSshButtonListener() {

		btnCopyApps.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.copyApps();
			}
		});

		tabFolder.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				checkSwitch();

				if (noSwitch) {
					tabFolder.setSelection(currentPageIndex);
				} else {
					int newIndex = tabFolder.indexOf((TabItem) e.item);
					tabFolder.setSelection(newIndex);
					currentPageIndex = newIndex;
					engine.getStatusModel().setSshRunning(false);
					engine.getStatusModel().setVagrantRunning(false);
				}
			}
		});

		btnStopAll.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.stopSSH();
				checkSwitch();
			}
		});

		btnReloadSSH.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				// controllerManager.stopSSH();
				if (engine.getStatusModel().getSshRunning()) {
					controllerManager.recreateAll();

				} else {
					if (sshProfileCombo.getSelectionIndex() != -1) {
						lblSShStatus.setText("Status: waiting");

						SshProfileModel model = engine.getStatusModel().getSshModelAtIndex();

						if (model != null) {
							controllerManager.startSSH(engine.getStatusModel().getModelList(), instanceWb, model);
						}
					} else {
						showMessage("Please select / create a ssh Profile.");
					}
					checkSwitch();
				}
			}
		});

		btnCreateProfile.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				SShShell sshShell = new SShShell(container.getDisplay());
				sshShell.openShell(null);
				SshProfileModel result = sshShell.getResult();
				if (result != null) {

					engine.getStatusModel().addEntryToSSHList(result);

					sshProfileCombo.select(engine.getStatusModel().getProfileList().indexOf(result));
					engine.getStatusModel()
							.setSshComboSelectionIndex(engine.getStatusModel().getProfileList().indexOf(result));

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
							sshProfileCombo.clearSelection();
							sshProfileCombo.deselectAll();
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

				String selection = engine.getStatusModel().getServerControllerSelection();
				if (!engine.getStatusModel().getServerControllerRunning() && !selection.equals("")) {
					// Create starter for selected server controller
					controllerManager.startServerController(selection,
							engine.getStatusModel().getShimModel().getPort());

					engine.getStatusModel().setServerControllerRunning(true);
				}
			}
		});

		btnStopServerController.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (engine.getStatusModel().getServerControllerRunning()) {
					// Stop starter
					controllerManager.stopServerController();
					engine.getStatusModel().setServerControllerRunning(false);
					selectServerCombo.setEnabled(true);
				}
			}
		});

		btnImportTopology.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.importTopology();
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
		addTopoButtonListener();

	}

	private boolean noSwitch = false;

	private void checkSwitch() {

		boolean allControllerStopped = true;
		if (engine.getStatusModel().getCoreRunning() || engine.getStatusModel().getMininetRunning()
				|| engine.getStatusModel().getDebuggerRunning()
				|| engine.getStatusModel().getServerControllerRunning()) {
			allControllerStopped = false;
		} else {
			for (int i = 0; i < engine.getStatusModel().getModelList().size(); i++) {
				if (engine.getStatusModel().getModelAtIndex(i).getRunning()) {
					allControllerStopped = false;
				}
			}

		}
		if (allControllerStopped) {
			noSwitch = false;
			tabFolder.setEnabled(true);
			for (Control c : tabFolder.getTabList()) {
				c.setEnabled(true);

			}
		} else {
			noSwitch = true;
		}
	}

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
		GridData gd_tabFolder = new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1);
		gd_tabFolder.widthHint = 515;
		tabFolder.setLayoutData(gd_tabFolder);

		sshTabItem = new TabItem(tabFolder, SWT.NONE);
		sshTabItem.addDisposeListener(new DisposeListener() {
			public void widgetDisposed(DisposeEvent e) {
			}
		});
		sshTabItem.setText("SSH");

		sshComposite = new Composite(tabFolder, SWT.NONE);
		sshTabItem.setControl(sshComposite);
		sshComposite.setLayout(new GridLayout(1, false));

		composite_1 = new Composite(sshComposite, SWT.NONE);
		composite_1.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		composite_1.setLayout(new GridLayout(5, false));

		lblSShStatus = new Label(composite_1, SWT.NONE);
		GridData gd_lblSShStatus = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_lblSShStatus.widthHint = 96;
		lblSShStatus.setLayoutData(gd_lblSShStatus);
		lblSShStatus.setText("Status: Offline");

		btnReloadSSH = new Button(composite_1, SWT.NONE);
		btnReloadSSH.setText("Reload");

		btnStopAll = new Button(composite_1, SWT.NONE);

		btnStopAll.setText("Stop All");

		btnProvision_1 = new Button(composite_1, SWT.NONE);
		btnProvision_1.setText("Provision");

		btnCopyApps = new Button(composite_1, SWT.NONE);

		btnCopyApps.setText("Copy Apps ");
		new Label(composite_1, SWT.NONE);
		new Label(composite_1, SWT.NONE);
		new Label(composite_1, SWT.NONE);
		new Label(composite_1, SWT.NONE);

		btnCopyTopology = new Button(composite_1, SWT.NONE);
		btnCopyTopology.setText("Copy Topology");

		btnCopyTopology.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.copyTopology();
			}
		});
		composite = new Composite(sshComposite, SWT.NONE);
		GridData gd_composite = new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1);
		gd_composite.widthHint = 400;
		composite.setLayoutData(gd_composite);
		composite.setLayout(new GridLayout(4, false));

		sshProfileCombo = new Combo(composite, SWT.BORDER | SWT.READ_ONLY);
		sshProfileCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (sshProfileCombo.getSelectionIndex() != -1) {
					lblSShStatus.setText("Status: waiting");

					SshProfileModel model = engine.getStatusModel().getSshModelAtIndex();

					if (model != null) {
						controllerManager.startSSH(engine.getStatusModel().getModelList(), instanceWb, model);
					}
					checkSwitch();
				}

			}

		});

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
		gd_composite_2.heightHint = 290;
		composite_2.setLayoutData(gd_composite_2);
		composite_2.setLayout(new GridLayout(2, false));

		composite_3 = new Composite(composite_2, SWT.NONE);
		GridData gd_composite_3 = new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1);
		gd_composite_3.widthHint = 300;
		gd_composite_3.heightHint = 155;
		composite_3.setLayoutData(gd_composite_3);
		composite_3.setLayout(new GridLayout(1, false));

		grpCore = new Group(composite_3, SWT.BORDER);

		grpCore.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
		grpCore.setText("Core");
		grpCore.setLayout(new GridLayout(5, false));

		lblCoreStatus = new Label(grpCore, SWT.NONE);
		GridData gd_lblCoreStatus = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_lblCoreStatus.widthHint = 97;
		lblCoreStatus.setLayoutData(gd_lblCoreStatus);
		lblCoreStatus.setText("Status : Offline");

		startCoreBtn = new Button(grpCore, SWT.NONE);
		startCoreBtn.setText("On");

		stopCoreBtn = new Button(grpCore, SWT.NONE);
		stopCoreBtn.setText("Off");

		btnReattachCore = new Button(grpCore, SWT.NONE);
		btnReattachCore.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.reattachCore();
			}
		});
		btnReattachCore.setText("Reattach");
		new Label(grpCore, SWT.NONE);

		grpCompositionLoader = new Group(composite_3, SWT.NONE);
		grpCompositionLoader.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
		grpCompositionLoader.setText("Composition Loader");
		grpCompositionLoader.setLayout(new GridLayout(3, false));
		new Label(grpCompositionLoader, SWT.NONE);
		new Label(grpCompositionLoader, SWT.NONE);
		new Label(grpCompositionLoader, SWT.NONE);

		textCompositionPath = new Text(grpCompositionLoader, SWT.BORDER);

		textCompositionPath.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		textCompositionPath.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				setIsDirty(true);
			}

		});

		browseCompositionBtn = new Button(grpCompositionLoader, SWT.NONE);
		browseCompositionBtn.setText("Browse");

		loadCompositionBtn = new Button(grpCompositionLoader, SWT.NONE);
		loadCompositionBtn.setText("Load");

		composite_4 = new Composite(composite_2, SWT.NONE);
		composite_4.setLayout(new GridLayout(1, false));
		GridData gd_composite_4 = new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1);
		gd_composite_4.widthHint = 321;
		composite_4.setLayoutData(gd_composite_4);

		grpServerController = new Group(composite_4, SWT.NONE);
		grpServerController.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		grpServerController.setLayout(new GridLayout(5, false));
		grpServerController.setText("Shim");

		lblServerControllerStatus = new Label(grpServerController, SWT.NONE);
		GridData gd_lblServerControllerStatus = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_lblServerControllerStatus.widthHint = 56;
		lblServerControllerStatus.setLayoutData(gd_lblServerControllerStatus);
		lblServerControllerStatus.setText(Constants.LABEL_OFFLINE);

		selectServerCombo = new Combo(grpServerController, SWT.BORDER | SWT.READ_ONLY);
		selectServerCombo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				setIsDirty(true);
			}
		});
		GridData gd_selectServerCombo = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_selectServerCombo.widthHint = 123;
		selectServerCombo.setLayoutData(gd_selectServerCombo);
		selectServerCombo.add(NetIDE.CONTROLLER_POX);
		selectServerCombo.add(NetIDE.CONTROLLER_ODL);
		selectServerCombo.add(NetIDE.CONTROLLER_RYU);
		selectServerCombo.add(NetIDE.CONTROLLER_RYU_REST);

		serverComboViewer = new ComboViewer(selectServerCombo);

		startServerController = new Button(grpServerController, SWT.BORDER);

		startServerController.setText("On");

		btnStopServerController = new Button(grpServerController, SWT.NONE);
		btnStopServerController.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));

		btnStopServerController.setText("Off");

		btnReattachServer = new Button(grpServerController, SWT.NONE);
		btnReattachServer.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.reattachServerController();
			}
		});
		btnReattachServer.setText("Reattach");

		lblPort = new Label(grpServerController, SWT.NONE);
		lblPort.setText("Port");

		shimPortText = new Text(grpServerController, SWT.BORDER);
		GridData gd_text_shim_port = new GridData(SWT.LEFT, SWT.CENTER, true, false, 1, 1);
		gd_text_shim_port.widthHint = 32;
		shimPortText.setLayoutData(gd_text_shim_port);
		shimPortText.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				setIsDirty(true);
			}

		});

		btnImportTopology = new Button(grpServerController, SWT.NONE);
		btnImportTopology.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 3, 1));

		btnImportTopology.setText("Import Topology");

		grpMininet = new Group(composite_4, SWT.NONE);
		grpMininet.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		grpMininet.setText("Mininet");
		grpMininet.setLayout(new GridLayout(4, false));

		mininetStatusLable = new Label(grpMininet, SWT.NONE);
		GridData gd_mininetStatusLable = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_mininetStatusLable.widthHint = 99;
		mininetStatusLable.setLayoutData(gd_mininetStatusLable);
		mininetStatusLable.setText("Status: Offline");

		btnMininetOn = new Button(grpMininet, SWT.NONE);
		btnMininetOn.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1));

		btnMininetOn.setText("On");

		btnMininetOff = new Button(grpMininet, SWT.NONE);

		btnMininetOff.setText("Off");

		btnReattachMininet = new Button(grpMininet, SWT.NONE);
		btnReattachMininet.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.reattachMininet();
			}
		});
		btnReattachMininet.setText("Reattach");

		grpDebugger = new Group(composite_2, SWT.NONE);
		GridData gd_grpDebugger = new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 2);
		gd_grpDebugger.heightHint = 112;
		grpDebugger.setLayoutData(gd_grpDebugger);
		grpDebugger.setText("Debugger");
		grpDebugger.setLayout(new GridLayout(4, false));

		lblDebuggerStatus = new Label(grpDebugger, SWT.NONE);
		GridData gd_lblDebuggerStatus = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_lblDebuggerStatus.widthHint = 99;
		lblDebuggerStatus.setLayoutData(gd_lblDebuggerStatus);
		lblDebuggerStatus.setText("Status: Offline");

		btnDebuggerOn = new Button(grpDebugger, SWT.NONE);
		btnDebuggerOn.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.startDebugger();
			}
		});
		btnDebuggerOn.setText("On");

		btnDebuggerOff = new Button(grpDebugger, SWT.NONE);
		btnDebuggerOff.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.stopDebugger();
			}
		});
		btnDebuggerOff.setText("Off");

		btnDebuggerReattach = new Button(grpDebugger, SWT.NONE);
		btnDebuggerReattach.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				controllerManager.reattachDebugger();
			}
		});
		btnDebuggerReattach.setText("Reattach");

		btnToolView = new Button(grpDebugger, SWT.NONE);
		btnToolView.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				try {
					IViewPart view = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
							.showView("eu.netide.toolpanel.views.Toolpanel");
					if (view instanceof ToolPanel) {
						ToolPanel toolPanel = (ToolPanel) view;
						toolPanel.setBackend(controllerManager.getBackend());
						toolPanel.setFile(file);
						String toolpath = null;
						// if
						// (engine.getStatusModel().getSshModelAtIndex().getTools())
						toolPanel.setSshModel(engine.getStatusModel()
								.getSshModelAtIndex(engine.getStatusModel().getSshComboSelectionIndex()).getTools());
					}
				} catch (PartInitException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		btnToolView.setText("Show Runtime Tools");
		new Label(grpDebugger, SWT.NONE);
		new Label(grpDebugger, SWT.NONE);
		new Label(grpDebugger, SWT.NONE);

		btnShowReplayView = new Button(grpDebugger, SWT.NONE);
		btnShowReplayView.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				try {
					IViewPart view = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
							.showView("eu.netide.toolpanel.views.ReplayPanel");
					if (view instanceof ReplayPanel) {
						ReplayPanel replayPanel = (ReplayPanel) view;
						replayPanel.setFile(file);
						String toolpath = null;
						// if
						// (engine.getStatusModel().getSshModelAtIndex().getTools())
					}
				} catch (PartInitException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		btnShowReplayView.setText("Show Replay View");
		new Label(grpDebugger, SWT.NONE);
		new Label(grpDebugger, SWT.NONE);
		new Label(grpDebugger, SWT.NONE);

		grpTopology = new Group(composite_2, SWT.NONE);
		grpTopology.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		grpTopology.setText("Topology ");
		grpTopology.setLayout(new GridLayout(3, false));

		topo_text = new Text(grpTopology, SWT.BORDER);
		topo_text.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		topo_text.addModifyListener(new ModifyListener() {

			@Override
			public void modifyText(ModifyEvent e) {
				setIsDirty(true);
			}

		});

		btnBrowse_topo = new Button(grpTopology, SWT.NONE);
		btnBrowse_topo.setText("Browse");

		btnLoadTopo = new Button(grpTopology, SWT.NONE);
		btnLoadTopo.setText("Generate");
		new Label(composite_2, SWT.NONE);

		grpConfigurationOverview = new Group(startAppComposite, SWT.NONE);
		grpConfigurationOverview.setLayout(new GridLayout(2, false));
		grpConfigurationOverview.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
		grpConfigurationOverview.setText("Apps");

		tableViewer = new TableViewer(grpConfigurationOverview,
				SWT.SINGLE | SWT.H_SCROLL | SWT.V_SCROLL | SWT.FULL_SELECTION | SWT.BORDER);

		table = tableViewer.getTable();
		table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));

		TableColumn tc0 = new TableColumn(table, SWT.CENTER);
		TableColumn tc1 = new TableColumn(table, SWT.CENTER);
		TableColumn tc2 = new TableColumn(table, SWT.CENTER);
		TableColumn tc3 = new TableColumn(table, SWT.CENTER);
		TableColumn tc4 = new TableColumn(table, SWT.CENTER);
		TableColumn tc5 = new TableColumn(table, SWT.CENTER);
		TableColumn tc6 = new TableColumn(table, SWT.CENTER);
		TableColumn tc7 = new TableColumn(table, SWT.CENTER);

		tc0.setText("Name");
		tc1.setText("App Name");
		tc2.setText("Active");
		tc3.setText("Platform");
		tc4.setText("Client");
		tc5.setText("Port");
		tc6.setText("Flag Backend");
		tc7.setText("Flag App");
		tc0.setWidth(100);
		tc1.setWidth(120);
		tc2.setWidth(80);
		tc3.setWidth(100);
		tc4.setWidth(100);
		tc5.setWidth(100);
		tc6.setWidth(120);
		tc7.setWidth(100);

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
	private Button btnReloadSSH;
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
	private Button btnImportTopology;
	private Text textCompositionPath;
	private Button btnReattachCore;
	private Button btnReattachServer;
	private Button btnReattachMininet;
	private Group grpDebugger;
	private Button btnDebuggerReattach;
	private Button btnDebuggerOn;
	private Button btnDebuggerOff;
	private Label lblDebuggerStatus;
	private Group grpTopology;
	private Text topo_text;
	private Button btnBrowse_topo;
	private Button btnLoadTopo;
	private Button btnCopyTopology;
	private Button btnStopAll;
	private Button btnToolView;
	private Text shimPortText;
	private Label lblPort;
	private Button btnShowReplayView;

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

	public Button getSshReloadButton() {
		return this.btnReloadSSH;
	}

	public Button getBtnVagrantUp() {
		return btnVagrantUp;
	}

	public Button getBtnMininetOff() {
		return btnMininetOff;
	}

	public Button getBtnVagrantHalt() {
		return btnVagrantHalt;
	}

	public Button getBtnMininetOn() {
		return btnMininetOn;
	}

	public Button getStartCoreBtn() {
		return startCoreBtn;
	}

	public Button getStopCoreBtn() {
		return stopCoreBtn;
	}

	public Button getBtnProvision_1() {
		return btnProvision_1;
	}

	public Button getBtnCopyApps() {
		return btnCopyApps;
	}

	public Button getBtnProvision_2() {
		return btnProvision_2;
	}

	public Button getBtnStopServerController() {
		return btnStopServerController;
	}

	public Button getStartServerController() {
		return startServerController;
	}

	public Button getBtnImportTopology() {
		return btnImportTopology;
	}

	public Text getTextCompositionPath() {
		return textCompositionPath;
	}

	public Button getBtnReattachCore() {
		return btnReattachCore;
	}

	public Button getBtnReattachServer() {
		return btnReattachServer;
	}

	public Button getBtnReattachMininet() {
		return btnReattachMininet;
	}

	public Button getBtnDebuggerOn() {
		return btnDebuggerOn;
	}

	public Button getBtnDebuggerOff() {
		return btnDebuggerOff;
	}

	public Button getBtnDebuggerReattach() {
		return btnDebuggerReattach;
	}

	public Button getTopologySSHButton() {
		return btnCopyTopology;
	}

	public Label getLblDebuggerStatus() {
		return lblDebuggerStatus;
	}

	public Text getTopologyText() {
		return this.topo_text;
	}

	public TabFolder getTabFolder() {
		return tabFolder;
	}

	public Combo getSelectServerCombo() {
		return selectServerCombo;
	}

	public Text getShimPortText() {
		return this.shimPortText;
	}
}

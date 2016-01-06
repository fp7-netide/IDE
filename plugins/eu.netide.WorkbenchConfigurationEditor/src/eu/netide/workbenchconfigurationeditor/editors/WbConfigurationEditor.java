package eu.netide.workbenchconfigurationeditor.editors;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CCombo;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
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
import org.eclipse.swt.custom.CLabel;

/**
 * 
 * @author Jan-Niclas Struewer
 *
 */
public class WbConfigurationEditor extends EditorPart {

	public static final String ID = "workbenchconfigurationeditor.editors.WbConfigurationEditor"; //$NON-NLS-1$

	public WbConfigurationEditor() {

	}

	@Override
	public void init(IEditorSite site, IEditorInput input) throws PartInitException {

		IFileEditorInput fileInput = (IFileEditorInput) input;
		this.tableConfigMap = new HashMap<TableItem, LaunchConfigurationModel>();
		// fills the modelList with the data from the xml file
		this.serverControllerIsRunning = false;
		file = fileInput.getFile();
		doc = XmlHelper.getDocFromFile(file);
		modelList = XmlHelper.parseFileToModel(file, doc);
		StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).createVagrantFile(modelList);
		setSite(site);
		setInput(input);

		setPartName("Workbench");

	}

	// parsed xml document
	private Document doc;
	private IFile file;
	private ArrayList<LaunchConfigurationModel> modelList;

	private Composite container;
	private Table table;

	/**
	 * Create contents of the editor part.
	 * 
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		createLayout(parent);

		addContentToTable();
		addButtonListener();

	}

	private Button startBTN;
	private Button btnHaltTest;
	private Button btnReload;
	private Button btnReattach;
	private Button btnAddTest;
	private Button btnRemoveTest;
	private Button btnStopTest;
	private CCombo selectServerCombo;
	private Button startServerController;
	private Button btnMininetOn;

	public void createLayout(Composite parent) {
		container = new Composite(parent, SWT.NONE);
		container.setLayout(new GridLayout(1, false));

		Composite startAppComposite = new Composite(container, SWT.BORDER);
		GridData gd_startAppComposite = new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1);
		gd_startAppComposite.widthHint = 888;
		startAppComposite.setLayoutData(gd_startAppComposite);
		startAppComposite.setLayout(new GridLayout(3, false));

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

		Composite vagrantButtons = new Composite(startAppComposite, SWT.BORDER);
		vagrantButtons.setLayout(new GridLayout(1, false));

		vagrantStatusLabel = new Label(vagrantButtons, SWT.NONE);
		vagrantStatusLabel.setText("Status: Offline");

		btnVagrantUp = new Button(vagrantButtons, SWT.NONE);

		btnVagrantUp.setText("Vagrant Up");

		btnHaltTest = new Button(vagrantButtons, SWT.NONE);
		btnHaltTest.setText("Vagrant Halt");

		composite = new Composite(startAppComposite, SWT.NONE);
		composite.setLayout(new GridLayout(1, false));
		GridData gd_composite = new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1);
		gd_composite.widthHint = 115;
		composite.setLayoutData(gd_composite);

		mininetStatusLable = new Label(composite, SWT.NONE);
		mininetStatusLable.setText("Status: Offline");

		btnMininetOn = new Button(composite, SWT.NONE);

		btnMininetOn.setText("Mininet On");

		btnMininetOff = new Button(composite, SWT.NONE);

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
		tc5.setText("Server");
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
		new Label(startAppComposite, SWT.NONE);

		testButtons = new Composite(startAppComposite, SWT.NONE);
		GridData gd_testButtons = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_testButtons.widthHint = 518;
		testButtons.setLayoutData(gd_testButtons);
		testButtons.setLayout(new GridLayout(2, false));

		btnAddTest = new Button(testButtons, SWT.NONE);
		btnAddTest.setText("Add Test");

		btnRemoveTest = new Button(testButtons, SWT.NONE);
		btnRemoveTest.setText("Remove Test");
		new Label(startAppComposite, SWT.NONE);
		new Label(startAppComposite, SWT.NONE);
	}

	private void addContentToTable() {
		for (LaunchConfigurationModel c : modelList) {
			addTableEntry(c);
		}
	}

	/**
	 * used to find the corresponding model to the selected table row
	 */
	private HashMap<TableItem, LaunchConfigurationModel> tableConfigMap;

	/**
	 * 
	 * @param data
	 *            with 4 entries data[0] = pathName
	 */
	private void addTableEntry(LaunchConfigurationModel model) {
		String[] tmpS = new String[] { model.getAppName(), "offline", model.getPlatform(), model.getClientController(),
				model.getServerController() };
		TableItem tmp = new TableItem(table, SWT.NONE);
		tableConfigMap.put(tmp, model);
		tmp.setText(tmpS);
	}

	private ConfigurationShell tempShell;
	private LaunchConfigurationModel tmpModel;
	private Composite testButtons;
	private CLabel lblServerControllerStatus;
	private Button btnStopServerController;
	private boolean serverControllerIsRunning;
	private Button btnVagrantUp;
	private Composite composite;
	private Button btnMininetOff;
	private Label vagrantStatusLabel;
	private Label mininetStatusLable;

	private void addButtonListener() {

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

		btnVagrantUp.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				StarterStarter.getStarter(LaunchConfigurationModel.getTopology()).startVagrant();
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

		btnReattach.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0)
					StarterStarter.getStarter("").reattachStarter(tableConfigMap.get(table.getSelection()[0]));
			}
		});

		btnHaltTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				StarterStarter.getStarter("").haltVagrant();
				for (int i = 0; i < table.getItemCount(); i++) {
					table.getItem(i).setText(1, "offline");
					//TODO: check for unknown side effects StarterStarter.getStarter("").stopStarter(tableConfigMap.get(table.getItem(i)));
				}

			}
		});

		startBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				LaunchConfigurationModel toStart = null;
				if (table.getSelectionCount() > 0) {
					TableItem selectedItem = table.getSelection()[0];
					toStart = tableConfigMap.get(selectedItem);
					if (toStart != null) {
						selectedItem.setText(1, "active");
						startApp(toStart);
					}
				}
			}
		});

		btnAddTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

				tmpModel = new LaunchConfigurationModel();

				tempShell = new ConfigurationShell(container.getDisplay());

				String[] content = tempShell.getSelectedContent();
				if (content != null) {
					boolean complete = true;
					if (content[1].equals("") || content[4].equals(""))
						complete = false;

					if (complete) {
						tmpModel.setPlatform(content[1]);
						tmpModel.setClientController(content[2]);
						tmpModel.setServerController(content[3]);
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
	}

	private void startApp(final LaunchConfigurationModel toStart) {

		final StarterStarter s = StarterStarter.getStarter(LaunchConfigurationModel.getTopology());

		s.registerControllerFromConfig(toStart);

	}

	private void showMessage(String msg) {
		MessageDialog.openInformation(container.getShell(), "NetIDE Workbench View", msg);
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
}

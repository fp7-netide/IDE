package workbenchconfigurationeditor.editors;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.IFileEditorInput;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.part.EditorPart;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import workbenchconfigurationeditor.model.LaunchConfigurationModel;
import workbenchconfigurationeditor.model.XmlConstants;

/**
 * 
 * @author Jan-Niclas Struewer
 *
 */
public class WbConfigurationEditor extends EditorPart {

	public static final String ID = "workbenchconfigurationeditor.editors.WbConfigurationEditor"; //$NON-NLS-1$

	private IFileEditorInput input;

	private WbConfigurationEditor workbench;

	public WbConfigurationEditor() {
		this.workbench = this;
	}

	@Override
	public void init(IEditorSite site, IEditorInput input) throws PartInitException {

		IFileEditorInput fileInput = (IFileEditorInput) input;
		this.tableConfigMap = new HashMap<TableItem, LaunchConfigurationModel>();
		// fills the modelList with the data from the xml file
		parseFileToModel(fileInput);

		this.input = fileInput;
		setSite(site);
		setInput(input);

		setPartName("Workbench");

	}

	private void parseFileToModel(IFileEditorInput input) {
		try {
			IFile file = input.getFile();
			File xmlFile = new File(file.getRawLocationURI());
			modelList = new ArrayList<LaunchConfigurationModel>();

			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(xmlFile);
			doc.getDocumentElement().normalize();

			// System.out.println("Root element :" +
			// doc.getDocumentElement().getNodeName());

			if (doc.hasChildNodes()) {

				printNote(doc.getChildNodes(), null);

			}

		} catch (Exception e) {

		}

	}

	private ArrayList<LaunchConfigurationModel> modelList;

	private void printNote(NodeList nodeList, LaunchConfigurationModel model) {

		for (int count = 0; count < nodeList.getLength(); count++) {

			Node tempNode = nodeList.item(count);
			System.out.println("current node name: " + tempNode.getNodeName());
			// make sure it's element node.
			if (tempNode.getNodeType() == Node.ELEMENT_NODE) {

				switch (tempNode.getNodeName()) {
				case XmlConstants.ELEMENT_APP_PATH:
					System.out.println("Setting as node Value for app path: " + tempNode.getTextContent());
					model.setAppPath(tempNode.getTextContent());
					break;
				case XmlConstants.ELEMENT_TOPOLOGY_PATH:
					model.setTopology(tempNode.getTextContent());
					System.out.println("Setting as node topology for app path: " + tempNode.getTextContent());
					break;
				case XmlConstants.NODE_APP:
					model = new LaunchConfigurationModel();
					modelList.add(model);

					if (tempNode.hasAttributes()) {
						NamedNodeMap nodeMap = tempNode.getAttributes();

						for (int i = 0; i < nodeMap.getLength(); i++) {

							Node node = nodeMap.item(i);
							if (node.getNodeName().equals(XmlConstants.ATTRIBUTE_APP_ID)) {
								model.setID(Long.parseLong(node.getNodeValue()));
							} else {
								if (node.getNodeName().equals(XmlConstants.ATTRIBUTE_APP_NAME)) {
									model.setAppName(node.getNodeValue());
								}
							}
						}
					}
					break;
				case XmlConstants.ELEMENT_CLIENT_CONTROLLER:
					System.out.println("Setting as node client controller for app path: " + tempNode.getTextContent());
					model.setClientController(tempNode.getTextContent());
					break;
				case XmlConstants.ELEMENT_SERVER_CONTROLLER:
					System.out.println("Setting as node server controller for app path: " + tempNode.getTextContent());
					model.setServerController(tempNode.getTextContent());
					break;
				case XmlConstants.ELEMENT_PLATFORM:
					System.out.println("Setting as node platform for app path: " + tempNode.getTextContent());
					model.setPlatform(tempNode.getTextContent());
					break;
				default:
					System.err.println("No match for node: " + tempNode.getNodeName());

				}

				if (tempNode.hasChildNodes()) {
					// loop again if has child nodes
					printNote(tempNode.getChildNodes(), model);
				}
			}

		}

	}

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
	private Button btnTestBeenden;
	private Button btnReload;
	private Button btnStatus;
	private Button btnAddTest;
	private Button btnRemoveTest;

	public void createLayout(Composite parent) {
		container = new Composite(parent, SWT.NONE);

		Composite startAppComposite = new Composite(container, SWT.BORDER);
		startAppComposite.setLocation(10, 10);

		startAppComposite.setSize(523, 514);
		startAppComposite.setLayout(null);

		Composite buttonComposite = new Composite(startAppComposite, SWT.BORDER);

		buttonComposite.setBounds(408, 50, 85, 277);
		buttonComposite.setLayout(null);

		startBTN = new Button(buttonComposite, SWT.NONE);
		startBTN.setBounds(0, 0, 80, 30);

		startBTN.setText("Start");

		btnTestBeenden = new Button(buttonComposite, SWT.NONE);
		btnTestBeenden.setBounds(0, 36, 80, 30);
		btnTestBeenden.setText("Stop");

		btnReload = new Button(buttonComposite, SWT.NONE);
		btnReload.setBounds(0, 72, 80, 30);
		btnReload.setText("Reload");

		btnStatus = new Button(buttonComposite, SWT.NONE);
		btnStatus.setBounds(0, 108, 80, 30);
		btnStatus.setText("Status");

		btnAddTest = new Button(startAppComposite, SWT.NONE);

		btnAddTest.setBounds(20, 299, 100, 30);
		btnAddTest.setText("Add Test");

		btnRemoveTest = new Button(startAppComposite, SWT.NONE);
		btnRemoveTest.setBounds(126, 297, 100, 30);
		btnRemoveTest.setText("Remove Test");

		table = new Table(startAppComposite, SWT.BORDER | SWT.FULL_SELECTION);

		TableColumn tc1 = new TableColumn(table, SWT.CENTER);
		TableColumn tc2 = new TableColumn(table, SWT.CENTER);
		TableColumn tc3 = new TableColumn(table, SWT.CENTER);
		TableColumn tc4 = new TableColumn(table, SWT.CENTER);
		tc1.setText("App Name");
		tc2.setText("Aktiv");
		tc3.setText("test");
		tc4.setText("test 2");
		tc1.setWidth(120);
		tc2.setWidth(90);
		tc3.setWidth(90);
		tc4.setWidth(90);

		table.setBounds(10, 50, 392, 243);
		table.setHeaderVisible(true);
		table.setLinesVisible(true);
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

		String[] tmpS = new String[] { model.getAppName(), "offline" };
		TableItem tmp = new TableItem(table, SWT.NONE);
		tableConfigMap.put(tmp, model);
		tmp.setText(tmpS);
	}

	private ConfigurationShell tempShell;
	private LaunchConfigurationModel tmpModel;

	private void addButtonListener() {

		btnRemoveTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelectionCount() > 0) {
					TableItem[] toRemove = table.getSelection();
					for (TableItem i : toRemove) {
						LaunchConfigurationModel tmp = tableConfigMap.get(i);
						modelList.remove(tmp);
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

		startBTN.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {

			}
		});

		btnAddTest.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				tmpModel = new LaunchConfigurationModel();
				FileDialog dlg = new FileDialog(container.getShell(), SWT.OPEN);
				String path = dlg.open();
				if (path != null) {
					tmpModel.setAppPath(path);
					String pathNames[] = path.split("/");
					String pathName = pathNames[pathNames.length - 1];
					tmpModel.setAppName(pathName);
				} else {
					System.err.println("No valid path!");
				}

				tempShell = new ConfigurationShell(container.getDisplay());

				String[] content = tempShell.getSelectedContent();
				if (content != null) {
					tmpModel.setTopology(content[0]);
					tmpModel.setPlatform(content[1]);
					tmpModel.setClientController(content[2]);
					tmpModel.setServerController(content[3]);
				}

				modelList.add(tmpModel);
				addTableEntry(tmpModel);
				// TODO: generateCodeToXML
			}

		});
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

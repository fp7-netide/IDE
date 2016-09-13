package eu.netide.chartview.view;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.part.ViewPart;

/**
 * This sample class demonstrates how to plug-in a new workbench view. The view
 * shows data obtained from the model. The sample creates a dummy model on the
 * fly, but a real implementation would connect to the model available either in
 * this or another plug-in (e.g. the workspace). The view is connected to the
 * model using a content provider.
 * <p>
 * The view uses a label provider to define how model objects should be
 * presented in the view. Each view can present the same model objects using
 * different labels and icons, if needed. Alternatively, a single label provider
 * can be shared between views in order to ensure that objects of the same type
 * are presented in the same way everywhere.
 * <p>
 */

public class ChartView extends ViewPart {

	/**
	 * The ID of the view as specified by the extension.
	 */
	public static final String ID = "chartview.views.ChartView";
	private Text textTopoPath;

	/**
	 * The constructor.
	 */
	public ChartView() {
	}

	/**
	 * This is a callback that will allow us to create the viewer and initialize
	 * it.
	 */
	public void createPartControl(Composite parent) {
		this.createLayout(parent);

	

	}

	/**
	 * Passing the focus request to the viewer's control.
	 */
	public void setFocus() {

	}

	public void createLayout(Composite parent) {
		Composite container = new Composite(parent, SWT.NONE);
		container.setLayout(new FillLayout());

		final ScrolledComposite sc = new ScrolledComposite(container, SWT.H_SCROLL | SWT.V_SCROLL | SWT.BORDER);
		sc.setExpandHorizontal(true);
		sc.setExpandVertical(true);

		Composite mainComposite = new Composite(sc, SWT.BORDER);
		mainComposite.setLayout(new GridLayout(1, false));

		sc.setContent(mainComposite);

		Composite TopoComposite = new Composite(mainComposite, SWT.NONE);
		GridData gd_TopoComposite = new GridData(SWT.FILL, SWT.TOP, false, false, 1, 1);
		gd_TopoComposite.widthHint = 582;
		gd_TopoComposite.heightHint = 37;
		TopoComposite.setLayoutData(gd_TopoComposite);
		TopoComposite.setSize(297, 469);
		TopoComposite.setLayout(new GridLayout(4, false));

		Label topoLabel = new Label(TopoComposite, SWT.NONE);
		topoLabel.setText("Topology");

		textTopoPath = new Text(TopoComposite, SWT.BORDER);
		textTopoPath.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		Button btnBrowseTopo = new Button(TopoComposite, SWT.NONE);

		btnBrowseTopo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				
				// IFile selectedFile = null;
				// ElementTreeSelectionDialog dialog = new
				// ElementTreeSelectionDialog(container.getShell(),
				// new WorkbenchLabelProvider(), new BaseWorkbenchContentProvider());
				// dialog.setTitle("Tree Selection");
				// dialog.setMessage("Select the elements from the tree:");
				// dialog.setInput(ResourcesPlugin.getWorkspace().getRoot());
				// if (dialog.open() == ElementTreeSelectionDialog.OK) {
				// Object[] result = dialog.getResult();
				// if (result.length == 1) {
				// if (result[0] instanceof IFile) {
				//
				// selectedFile = (IFile) result[0];
				//
				// path = selectedFile.getFullPath().toString();
				// path = "platform:/resource".concat(path);
				// TopologyModel m = new TopologyModel();
				// m.setTopologyPath(path);
				//
				// engine.getStatusModel().getTopologyModel().setTopologyPath(path);
				//
				// setIsDirty(true);
				// } else {
				// showMessage("Please select a Topology.");
				//
				// TopologyImport topologyimport =
				// TopologyImportFactory.instance.createTopologyImport();
				// topologyimport.createTopologyModelFromFile(selectedFile);
				//
				// topo = sshManager.execWithReturn(cmd)
				// } else if (vagrantManager != null) {
				// topo = vagrantManager.execWithReturn(cmd)
				// path = "platform:/resource".concat(path);

				// var topo = execWithReturn(
				// "curl -s -u admin:admin
				// http://localhost:8181/restconf/operational/network-topology:network-topology/");
				// var topoImport =
				// TopologyImportFactory.instance.createTopologyImport();
				// topoImport.createTopologyModelFromString(topo,
				// manager.getProject().getFile("import.topology").getFullPath().toPortableString());
			}
		});
		btnBrowseTopo.setText("Browse Topology");

		Button btnLoadTopo = new Button(TopoComposite, SWT.NONE);
		btnLoadTopo.setText("Load Topology");

		SwtLiveChartViewer lcv = new SwtLiveChartViewer(mainComposite, SWT.NO_BACKGROUND);
		lcv.setLayoutData(new GridData(GridData.FILL_BOTH));
		lcv.addPaintListener(lcv);

	}
}

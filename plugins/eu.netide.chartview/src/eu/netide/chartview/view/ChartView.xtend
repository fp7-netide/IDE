package eu.netide.chartview.view

import com.fasterxml.jackson.databind.node.ArrayNode
import eu.netide.chartview.view.charts.MessagesPerAppChartViewer
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.ScrolledComposite
import org.eclipse.swt.layout.FillLayout
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.part.ViewPart

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
class ChartView extends ViewPart {
	/** 
	 * The ID of the view as specified by the extension.
	 */
	public static final String ID = "chartview.views.ChartView"
	public MessagesPerAppChartViewer viewer

	/** 
	 * The constructor.
	 */
	new() {
		
	}

	/** 
	 * This is a callback that will allow us to create the viewer and initialize
	 * it.
	 */
	override void createPartControl(Composite parent) {
		this.createLayout(parent)
	}

	/** 
	 * Passing the focus request to the viewer's control.
	 */
	override void setFocus() {
	}

	def void createLayout(Composite parent) {
		var Composite container = new Composite(parent, SWT.NONE)
		container.setLayout(new FillLayout())
		val ScrolledComposite sc = new ScrolledComposite(container,
			SWT.H_SCROLL.bitwiseOr(SWT.V_SCROLL).bitwiseOr(SWT.BORDER))
		sc.setExpandHorizontal(true)
		sc.setExpandVertical(true)
		val Composite mainComposite = new Composite(sc, SWT.BORDER)
		mainComposite.setLayout(new GridLayout(1, false))
		
		mainComposite.layoutData = new GridData(GridData.FILL_BOTH)
		sc.setContent(mainComposite)

				
		viewer = new MessagesPerAppChartViewer(mainComposite, SWT.NONE)
		viewer.setLayoutData(new GridData(GridData.FILL_BOTH));
		viewer.addPaintListener(viewer);
		mainComposite.layout()

	}
	
	def void update(ArrayNode log, Integer portId) {
		viewer.update(log, newArrayList("tx_packets"), portId)
	}
}

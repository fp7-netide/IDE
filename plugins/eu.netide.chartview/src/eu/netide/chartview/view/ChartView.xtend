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
import java.util.List
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent

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

	ArrayNode log = null
	List<String> datasets
	int portId

	/** 
	 * The constructor.
	 */
	new() {
		datasets = newArrayList("tx_bytes", "rx_bytes")
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
		mainComposite.setLayout(new GridLayout(2, false))

		mainComposite.layoutData = new GridData(GridData.FILL_BOTH)
		sc.setContent(mainComposite)

		viewer = new MessagesPerAppChartViewer(mainComposite, SWT.DOUBLE_BUFFERED)
		viewer.setLayoutData(new GridData(GridData.FILL_BOTH));
		viewer.addPaintListener(viewer);
		mainComposite.layout()

		val radioComposite = new Composite(mainComposite, SWT.NONE)
		radioComposite.layout = new GridLayout(1, true)

		val radioBytes = new Button(radioComposite, SWT.RADIO)
		radioBytes.text = "Bytes"
		radioBytes.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				datasets = newArrayList("tx_bytes", "rx_bytes")
				update(log, portId)
			}
		})
		radioBytes.selection = true

		val radioPackets = new Button(radioComposite, SWT.RADIO)
		radioPackets.text = "Packets"
		radioPackets.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				datasets = newArrayList("tx_packets", "rx_packets")
				update(log, portId)
			}
		})

		val radioDropped = new Button(radioComposite, SWT.RADIO)
		radioDropped.text = "Dropped"
		radioDropped.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				datasets = newArrayList("tx_dropped", "rx_dropped")
				update(log, portId)
			}
		})

		val radioErrors = new Button(radioComposite, SWT.RADIO)
		radioErrors.text = "Errors"
		radioErrors.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				datasets = newArrayList("tx_errors", "rx_errors")
				update(log, portId)
			}
		})

	}

	def void update(ArrayNode log, Integer portId) {
		this.log = log
		this.portId = portId
		viewer.update(log, datasets, portId)
	}
}

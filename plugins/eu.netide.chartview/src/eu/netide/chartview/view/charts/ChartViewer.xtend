package eu.netide.chartview.view.charts

import com.fasterxml.jackson.databind.node.ArrayNode
import java.util.List
import org.eclipse.birt.chart.api.ChartEngine
import org.eclipse.birt.chart.device.IDeviceRenderer
import org.eclipse.birt.chart.exception.ChartException
import org.eclipse.birt.chart.factory.GeneratedChartState
import org.eclipse.birt.chart.factory.Generator
import org.eclipse.birt.chart.model.Chart
import org.eclipse.birt.chart.model.ChartWithAxes
import org.eclipse.birt.core.framework.PlatformConfig
import org.eclipse.swt.events.PaintEvent
import org.eclipse.swt.events.PaintListener
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.widgets.Composite

abstract class ChartViewer extends Composite implements PaintListener {
	protected IDeviceRenderer idr = null
	protected Chart cm = null
	protected GeneratedChartState gcs = null
	/** 
	 * Used in building the chart for the first time
	 */
	protected boolean bFirstPaint = true

	// private static ILogger logger = Logger.getLogger(
	// JavaScriptViewer.class.getName( ) );
	/** 
	 * Constructor
	 */
	new(Composite parent, int style) {
		super(parent, style)
		try {
			var PlatformConfig config = new PlatformConfig()
			idr = ChartEngine::instance(config).getRenderer("dv.SWT") // $NON-NLS-1$
		} catch (ChartException pex) {
			System::err.println(pex)
		}

		cm = createLiveChart()
	}
	
	abstract def String getName()

	abstract def Chart createLiveChart()

	def abstract void updateDataSet(ChartWithAxes cwaBar) 





	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events
	 * .PaintEvent)
	 */
	abstract override void paintControl(PaintEvent e)
	
	abstract def void update(ArrayNode log, List<String> keys, int port)

	/*
	 * (non-Javadoc)
	 * 
	 * @see SelectionListener#widgetDefaultSelected(org.
	 * eclipse .swt.events.SelectionEvent)
	 */
	def protected void chartRefresh() {
		if (!isDisposed()) {
			val Generator gr = Generator::instance()
			updateDataSet((cm as ChartWithAxes))
			// Refresh
			try {
				gr.refresh(gcs)
			} catch (ChartException ex) {
				ex.printStackTrace()
			}

			redraw()
		}
	}

}

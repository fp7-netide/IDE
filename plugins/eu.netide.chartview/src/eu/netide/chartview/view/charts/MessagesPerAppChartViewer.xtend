package eu.netide.chartview.view.charts

import eu.netide.lib.netip.Message
import eu.netide.lib.netip.MessageType
import eu.netide.zmq.hub.client.IZmqNetIpListener
import java.util.Collections
import java.util.Map
import org.eclipse.birt.chart.device.IDeviceRenderer
import org.eclipse.birt.chart.exception.ChartException
import org.eclipse.birt.chart.factory.Generator
import org.eclipse.birt.chart.model.Chart
import org.eclipse.birt.chart.model.ChartWithAxes
import org.eclipse.birt.chart.model.attribute.ActionType
import org.eclipse.birt.chart.model.attribute.AxisType
import org.eclipse.birt.chart.model.attribute.Bounds
import org.eclipse.birt.chart.model.attribute.IntersectionType
import org.eclipse.birt.chart.model.attribute.LineAttributes
import org.eclipse.birt.chart.model.attribute.LineStyle
import org.eclipse.birt.chart.model.attribute.Position
import org.eclipse.birt.chart.model.attribute.RiserType
import org.eclipse.birt.chart.model.attribute.TickStyle
import org.eclipse.birt.chart.model.attribute.TriggerCondition
import org.eclipse.birt.chart.model.attribute.impl.BoundsImpl
import org.eclipse.birt.chart.model.attribute.impl.ColorDefinitionImpl
import org.eclipse.birt.chart.model.attribute.impl.TooltipValueImpl
import org.eclipse.birt.chart.model.component.Axis
import org.eclipse.birt.chart.model.component.Series
import org.eclipse.birt.chart.model.component.impl.SeriesImpl
import org.eclipse.birt.chart.model.data.NumberDataSet
import org.eclipse.birt.chart.model.data.SeriesDefinition
import org.eclipse.birt.chart.model.data.TextDataSet
import org.eclipse.birt.chart.model.data.impl.ActionImpl
import org.eclipse.birt.chart.model.data.impl.NumberDataSetImpl
import org.eclipse.birt.chart.model.data.impl.SeriesDefinitionImpl
import org.eclipse.birt.chart.model.data.impl.TextDataSetImpl
import org.eclipse.birt.chart.model.data.impl.TriggerImpl
import org.eclipse.birt.chart.model.impl.ChartWithAxesImpl
import org.eclipse.birt.chart.model.layout.Legend
import org.eclipse.birt.chart.model.layout.Plot
import org.eclipse.birt.chart.model.type.BarSeries
import org.eclipse.birt.chart.model.type.impl.BarSeriesImpl
import org.eclipse.swt.events.PaintEvent
import org.eclipse.swt.events.PaintListener
import org.eclipse.swt.graphics.GC
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.graphics.Rectangle
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display

class MessagesPerAppChartViewer extends ChartViewer implements IZmqNetIpListener, PaintListener {
	private Map<String, Integer> data
	Image imgChart
	GC gcImage
	Bounds bo

	/** 
	 * Used in building the chart for the first time
	 */
	new(Composite parent, int style) {
		super(parent, style)
	}

	override getName() {
		return "Traversing Messages"
	}

	override final Chart createLiveChart() {
		data = Collections.synchronizedMap(newHashMap())
		var ChartWithAxes cwaBar = ChartWithAxesImpl::create()
		// Plot
		cwaBar.getBlock().setBackground(ColorDefinitionImpl::WHITE())
		var Plot p = cwaBar.getPlot()
		p.getClientArea().setBackground(ColorDefinitionImpl::create(255, 255, 225))
		// Legend
		var Legend lg = cwaBar.getLegend()
		var LineAttributes lia = lg.getOutline()
		lg.getText().getFont().setSize(16)
		lia.setStyle(LineStyle::SOLID_LITERAL)
		lg.getInsets().setLeft(10)
		lg.getInsets().setRight(10)
		// Title
		cwaBar.getTitle().getLabel().getCaption().setValue("Traversing messages")
		// $NON-NLS-1$
		// X-Axis
		var Axis xAxisPrimary = cwaBar.getPrimaryBaseAxes().get(0)
		xAxisPrimary.setType(AxisType::TEXT_LITERAL)
		xAxisPrimary.getOrigin().setType(IntersectionType::VALUE_LITERAL)
		xAxisPrimary.getOrigin().setType(IntersectionType::MIN_LITERAL)
		xAxisPrimary.getTitle().getCaption().setValue("Category Text X-Axis")
		// $NON-NLS-1$
		xAxisPrimary.setTitlePosition(Position::BELOW_LITERAL)
		xAxisPrimary.getLabel().getCaption().getFont().setRotation(75)
		xAxisPrimary.setLabelPosition(Position::BELOW_LITERAL)
		xAxisPrimary.getMajorGrid().setTickStyle(TickStyle::BELOW_LITERAL)
		xAxisPrimary.getMajorGrid().getLineAttributes().setStyle(LineStyle::DOTTED_LITERAL)
		xAxisPrimary.getMajorGrid().getLineAttributes().setColor(ColorDefinitionImpl::create(64, 64, 64))
		xAxisPrimary.getMajorGrid().getLineAttributes().setVisible(true)
		// Y-Axis
		var Axis yAxisPrimary = cwaBar.getPrimaryOrthogonalAxis(xAxisPrimary)
		yAxisPrimary.getLabel().getCaption().setValue("Price Axis")
		// $NON-NLS-1$
		yAxisPrimary.getLabel().getCaption().getFont().setRotation(37)
		yAxisPrimary.setLabelPosition(Position::LEFT_LITERAL)
		yAxisPrimary.setTitlePosition(Position::LEFT_LITERAL)
		yAxisPrimary.getTitle().getCaption().setValue("Linear Value Y-Axis")
		// $NON-NLS-1$
		yAxisPrimary.setType(AxisType::LINEAR_LITERAL)
		yAxisPrimary.getMajorGrid().setTickStyle(TickStyle::LEFT_LITERAL)
		yAxisPrimary.getMajorGrid().getLineAttributes().setStyle(LineStyle::DOTTED_LITERAL)
		yAxisPrimary.getMajorGrid().getLineAttributes().setColor(ColorDefinitionImpl::BLUE())
		yAxisPrimary.getMajorGrid().getLineAttributes().setVisible(true)
		// X-Series
		var Series seCategory = SeriesImpl::create()
		var SeriesDefinition sdX = SeriesDefinitionImpl::create()
		xAxisPrimary.getSeriesDefinitions().add(sdX)
		sdX.getSeries().add(seCategory)
		// Y-Series (1)
		var BarSeries bs1 = (BarSeriesImpl::create() as BarSeries)
//		bs1.setSeriesIdentifier("# Messages")
		bs1.triggers.add(
			TriggerImpl::create(TriggerCondition::ONMOUSEOVER_LITERAL,
				ActionImpl::create(ActionType.SHOW_TOOLTIP_LITERAL,
					TooltipValueImpl::create(0, bs1.dataPoint.components.get(0).toString))))

		// $NON-NLS-1$
		bs1.setRiserOutline(null)
		bs1.setRiser(RiserType::RECTANGLE_LITERAL)
		var SeriesDefinition sdY = SeriesDefinitionImpl::create()
		yAxisPrimary.getSeriesDefinitions().add(sdY)
		sdY.getSeriesPalette().shift(-1)
		sdY.getSeries().add(bs1)
		// Update data
		updateDataSet(cwaBar)
		return cwaBar
	}

	override update(Message msg) {
		if (msg.header.messageType == MessageType.OPENFLOW) {
			synchronized (data) {
				if (!data.containsKey("" + msg.header.moduleId)) {
					data.put("" + msg.header.moduleId, 0)
				}
				var value = data.get("" + msg.header.moduleId)
				data.put("" + msg.header.moduleId, value + 1)
			}
		}
	}

	override final void updateDataSet(ChartWithAxes cwaBar) {
		var xarr = data.keySet.toList()
		var yarr = data.values.toList()

		if (data.keySet.length == 0) {
			xarr.add("0")
			yarr.add(0)
		}

		// Associate with Data Set
		var TextDataSet categoryValues = TextDataSetImpl.create(xarr)
		var NumberDataSet seriesOneValues = NumberDataSetImpl::create(yarr)
		// X-Axis
		var Axis xAxisPrimary = cwaBar.getPrimaryBaseAxes().get(0)
		var SeriesDefinition sdX = xAxisPrimary.getSeriesDefinitions().get(0)
		sdX.getSeries().get(0).setDataSet(categoryValues)
		// Y-Axis
		var Axis yAxisPrimary = cwaBar.getPrimaryOrthogonalAxis(xAxisPrimary)
		var SeriesDefinition sdY = yAxisPrimary.getSeriesDefinitions().get(0)
		sdY.getSeries().get(0).setDataSet(seriesOneValues)
	}

	// Live Date Set
//	static final String[] sa = #["SW1", "SW2"]
//	// $NON-NLS-1$//$NON-NLS-2$//$NON-NLS-3$//$NON-NLS-4$//$NON-NLS-5$
//	static final double[] da1 = #[56.99, 352.95, -201.95, 299.95, -95.95, 25.45, 129.33, -26.5, 43.5, 122]
//	static final double[] da2 = #[20, 35, 59, 105, 150, -37, -65, -99, -145, -185]
//	static final String[] sa = #["App1"]
//	static final int[] da1 = #[1]
//	override update(Message msg) {
//		if (msg.header.messageType == MessageType.OPENFLOW) {
//			synchronized (data) {
//				if (!data.containsKey("" + msg.header.moduleId)) {
//					data.put("" + msg.header.moduleId, 0)
//				}
//				var value = data.get("" + msg.header.moduleId)
//				data.put("" + msg.header.moduleId, value + 1)
//			}
//
//		}
//	}
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events
	 * .PaintEvent)
	 */
	override final void paintControl(PaintEvent e) {
		var Rectangle d = this.getClientArea()
		if (bFirstPaint) {
			imgChart = new Image(this.getDisplay(), d)
			gcImage = new GC(imgChart)
			idr.setProperty(IDeviceRenderer::GRAPHICS_CONTEXT, gcImage)
			bo = BoundsImpl::create(0, 0, d.width, d.height)
			bo.scale(72d / idr.getDisplayServer().getDpiResolution())
		}
		var Generator gr = Generator::instance()
		try {
			if (bFirstPaint) // ++++ added this line. But then data does not
			{
				gcs = gr.build(idr.getDisplayServer(), cm, bo, null, null, null)
			}

			gr.render(idr, gcs)
			var GC gc = e.gc
			gc.drawImage(imgChart, d.x, d.y)
		} catch (ChartException ce) {
			ce.printStackTrace()
		}

		bFirstPaint = false
		Display::getDefault().timerExec(500, ([|chartRefresh()] as Runnable))
	}

}

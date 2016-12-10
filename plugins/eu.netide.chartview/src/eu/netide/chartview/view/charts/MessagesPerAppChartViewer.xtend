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
import org.eclipse.birt.chart.model.type.LineSeries
import org.eclipse.birt.chart.model.type.impl.LineSeriesImpl
import com.fasterxml.jackson.databind.node.ArrayNode
import java.util.List

class MessagesPerAppChartViewer extends ChartViewer implements PaintListener {
	Image imgChart
	GC gcImage
	Bounds bo
	LineSeries series1
	LineSeries series2
	
	List<Integer> index
	List<Integer> first
	List<Integer> second

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
		index = newArrayList(0)
		first = newArrayList(0)
		second = newArrayList(0)
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
		cwaBar.getTitle().getLabel().getCaption().setValue("Port Statistics")
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
		yAxisPrimary.getLabel().getCaption().setValue("tx_bytes")
		// $NON-NLS-1$
		yAxisPrimary.getLabel().getCaption().getFont().setRotation(37)
		yAxisPrimary.setLabelPosition(Position::LEFT_LITERAL)
		yAxisPrimary.setTitlePosition(Position::LEFT_LITERAL)
		yAxisPrimary.getTitle().getCaption().setValue("Linear Value Y-Axis")
		// $NON-NLS-1$
		yAxisPrimary.setType(AxisType::LINEAR_LITERAL)
		yAxisPrimary.getMajorGrid().setTickStyle(TickStyle::LEFT_LITERAL)
		yAxisPrimary.getMajorGrid().getLineAttributes().setStyle(LineStyle::DOTTED_LITERAL)
		yAxisPrimary.getMajorGrid().getLineAttributes().setColor(ColorDefinitionImpl::RED())
		yAxisPrimary.getMajorGrid().getLineAttributes().setVisible(true)
		// X-Series
		var Series seCategory = SeriesImpl::create()
		var SeriesDefinition sdX = SeriesDefinitionImpl::create()
		xAxisPrimary.getSeriesDefinitions().add(sdX)
		sdX.getSeries().add(seCategory)
		// Y-Series (1)
		series1 = (LineSeriesImpl::create() as LineSeries)
		series2 = (LineSeriesImpl::create() as LineSeries)

		// $NON-NLS-1$
		// bs1.set(null)
		// bs1.setRiser(RiserType::RECTANGLE_LITERAL)
		var SeriesDefinition sdY = SeriesDefinitionImpl::create()
		yAxisPrimary.getSeriesDefinitions().add(sdY)
		sdY.getSeriesPalette().shift(-1)
		sdY.getSeries().add(series1)
		sdY.getSeries().add(series2)
		// Update data
		updateDataSet(cwaBar)
		return cwaBar
	}

	override update(ArrayNode log, List<String> keys, int port) {
		synchronized (index) {
			
			if (series1.seriesIdentifier != keys.get(0) || series2.seriesIdentifier != keys.get(0))
				bFirstPaint = true
			
			series1.seriesIdentifier = keys.get(0)
			series2.seriesIdentifier = keys.get(1)
			
			index.clear
			first.clear
			second.clear
			
			first = log.map[filter[get("port").asInt == port].map[get(keys.get(0)).asInt]].flatten.toList
			second = log.map[filter[get("port").asInt == port].map[get(keys.get(1)).asInt]].flatten.toList

			first.forEach [ element, i |
				index.add(i)
			]

		}
	}

	override final void updateDataSet(ChartWithAxes cwaBar) {

		if (first.empty || second.empty || index.empty) {
			first.add(0)
			second.add(0)
			index.add(0)
		}

		// Associate with Data Set
		var TextDataSet categoryValues = TextDataSetImpl.create(index)
		var NumberDataSet seriesOneValues = NumberDataSetImpl::create(first)
		var NumberDataSet seriesTwoValues = NumberDataSetImpl::create(second)
		// X-Axis
		var Axis xAxisPrimary = cwaBar.getPrimaryBaseAxes().get(0)
		var SeriesDefinition sdX = xAxisPrimary.getSeriesDefinitions().get(0)
		sdX.getSeries().get(0).setDataSet(categoryValues)
		// Y-Axis
		var Axis yAxisPrimary = cwaBar.getPrimaryOrthogonalAxis(xAxisPrimary)
		var SeriesDefinition sdY = yAxisPrimary.getSeriesDefinitions().get(0)
		sdY.getSeries().get(0).setDataSet(seriesOneValues)
		sdY.getSeries().get(1).setDataSet(seriesTwoValues)
	}

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
			bFirstPaint = false

		} catch (ChartException ce) {
			ce.printStackTrace()
		}

		Display::getDefault().timerExec(500, ([|chartRefresh()] as Runnable))
	}

}

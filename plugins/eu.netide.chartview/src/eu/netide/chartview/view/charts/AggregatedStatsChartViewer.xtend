package eu.netide.chartview.view.charts

import com.fasterxml.jackson.databind.node.ArrayNode
import java.util.List
import org.eclipse.birt.chart.device.IDeviceRenderer
import org.eclipse.birt.chart.exception.ChartException
import org.eclipse.birt.chart.factory.Generator
import org.eclipse.birt.chart.model.Chart
import org.eclipse.birt.chart.model.ChartWithAxes
import org.eclipse.birt.chart.model.attribute.AxisType
import org.eclipse.birt.chart.model.attribute.Bounds
import org.eclipse.birt.chart.model.attribute.IntersectionType
import org.eclipse.birt.chart.model.attribute.LineAttributes
import org.eclipse.birt.chart.model.attribute.LineStyle
import org.eclipse.birt.chart.model.attribute.Position
import org.eclipse.birt.chart.model.attribute.TickStyle
import org.eclipse.birt.chart.model.attribute.impl.BoundsImpl
import org.eclipse.birt.chart.model.attribute.impl.ColorDefinitionImpl
import org.eclipse.birt.chart.model.component.Axis
import org.eclipse.birt.chart.model.component.Series
import org.eclipse.birt.chart.model.component.impl.SeriesImpl
import org.eclipse.birt.chart.model.data.NumberDataSet
import org.eclipse.birt.chart.model.data.SeriesDefinition
import org.eclipse.birt.chart.model.data.TextDataSet
import org.eclipse.birt.chart.model.data.impl.NumberDataSetImpl
import org.eclipse.birt.chart.model.data.impl.SeriesDefinitionImpl
import org.eclipse.birt.chart.model.data.impl.TextDataSetImpl
import org.eclipse.birt.chart.model.impl.ChartWithAxesImpl
import org.eclipse.birt.chart.model.layout.Legend
import org.eclipse.birt.chart.model.layout.Plot
import org.eclipse.birt.chart.model.type.LineSeries
import org.eclipse.birt.chart.model.type.impl.LineSeriesImpl
import org.eclipse.swt.events.PaintEvent
import org.eclipse.swt.events.PaintListener
import org.eclipse.swt.graphics.GC
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.graphics.Rectangle
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display

class AggregatedStatsChartViewer extends ChartViewer implements PaintListener {
	Image imgChart
	GC gcImage
	Bounds bo
	LineSeries series1
	
	List<Integer> index
	List<Integer> first

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
		
//		xAxisPrimary.getMajorGrid().setTickStyle(TickStyle::BELOW_LITERAL)
//		xAxisPrimary.getMajorGrid().getLineAttributes().setStyle(LineStyle::DOTTED_LITERAL)
//		xAxisPrimary.getMajorGrid().getLineAttributes().setColor(ColorDefinitionImpl::create(64, 64, 64))
//		xAxisPrimary.getMajorGrid().getLineAttributes().setVisible(true)
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
		series1.markers.clear

		// $NON-NLS-1$
		// bs1.set(null)
		// bs1.setRiser(RiserType::RECTANGLE_LITERAL)
		var SeriesDefinition sdY = SeriesDefinitionImpl::create()
		
		yAxisPrimary.getSeriesDefinitions().add(sdY)
		sdY.getSeriesPalette().shift(-1)
		sdY.getSeries().add(series1)
		// Update data
		updateDataSet(cwaBar)
		return cwaBar
	}

	def update(ArrayNode log, List<String> keys) {
		synchronized (index) {
			
			if (series1.seriesIdentifier != keys.get(0))
				bFirstPaint = true
			
			series1.seriesIdentifier = keys.get(0)
			
			index.clear
			first.clear
			first = log.map[x | x.get(keys.get(0)).asInt].toList

			first.forEach [ element, i |
				index.add(i)
			]

		}
	}

	override final void updateDataSet(ChartWithAxes cwaBar) {

		if (first.empty || index.empty) {
			first.add(0)
			index.add(0)
		}

		// Associate with Data Set
		var TextDataSet categoryValues = TextDataSetImpl.create(index)
		var NumberDataSet seriesOneValues = NumberDataSetImpl::create(first)
		// X-Axis
		var Axis xAxisPrimary = cwaBar.getPrimaryBaseAxes().get(0)
		var SeriesDefinition sdX = xAxisPrimary.getSeriesDefinitions().get(0)
		sdX.getSeries().get(0).setDataSet(categoryValues)
		// Y-Axis
		var Axis yAxisPrimary = cwaBar.getPrimaryOrthogonalAxis(xAxisPrimary)
		var SeriesDefinition sdY = yAxisPrimary.getSeriesDefinitions().get(0)
		sdY.getSeries().get(0).setDataSet(seriesOneValues)
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
			//ce.printStackTrace()
		}

		Display::getDefault().timerExec(500, ([|chartRefresh()] as Runnable))
	}

}

package eu.netide.toolpanel.shells

import org.eclipse.swt.widgets.Shell
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import eu.netide.chartview.view.charts.MessagesPerAppChartViewer

class ChartShell extends Shell {
	new(Display display) {
		super(display, SWT.SHELL_TRIM)
		
		var composite = new Composite(this, SWT.NONE)
		var chart = new MessagesPerAppChartViewer(composite, SWT.NO_BACKGROUND)
	}
	
	protected override checkSubclass() {}
	
}
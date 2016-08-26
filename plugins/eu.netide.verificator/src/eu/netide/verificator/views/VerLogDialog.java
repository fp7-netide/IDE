package eu.netide.verificator.views;

import org.eclipse.core.databinding.beans.BeanProperties;
import org.eclipse.jface.databinding.viewers.ViewerSupport;
import org.eclipse.jface.dialogs.TitleAreaDialog;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;

import eu.netide.verificator.hub.server.VerHub;

public class VerLogDialog extends TitleAreaDialog {

	VerHub hub;
	private Table table;

	public VerLogDialog(Shell parentShell, VerHub hub) {
		super(parentShell);
		setShellStyle(SWT.RESIZE);
		this.hub = hub;
	}

	@Override
	protected Control createDialogArea(Composite parent) {
		Composite area = (Composite) super.createDialogArea(parent);
		
		TableViewer tableViewer = new TableViewer(area, SWT.BORDER | SWT.FULL_SELECTION);
		table = tableViewer.getTable();
		table.setLinesVisible(true);
		table.setHeaderVisible(true);
		table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
		
		TableColumn tblColumnDate = new TableColumn(table, SWT.NONE);
		tblColumnDate.setWidth(150);
		tblColumnDate.setText("Date");
		
		TableColumn tblColumnMsg = new TableColumn(table, SWT.NONE);
		tblColumnMsg.setWidth(300);
		tblColumnMsg.setText("Information");
		
		ViewerSupport.bind(tableViewer, hub.getLog(), BeanProperties.values(new String[] {"date", "msg"}));
		

				
		setHelpAvailable(false);
		setTitle(hub.getName());
		setMessage(hub.getAddress());
		
		return area;
	}
	
	@Override
	public boolean close() {
		return super.close();
		
	}
	protected Point getInitialSize() {
		return new Point(755, 581);
	}
}

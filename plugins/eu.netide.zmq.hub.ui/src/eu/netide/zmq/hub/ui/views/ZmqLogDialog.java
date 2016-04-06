package eu.netide.zmq.hub.ui.views;

import org.eclipse.core.databinding.beans.BeanProperties;
import org.eclipse.jface.databinding.viewers.ViewerSupport;
import org.eclipse.jface.dialogs.TitleAreaDialog;
import org.eclipse.jface.viewers.ListViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.widgets.Shell;

import eu.netide.zmq.hub.server.ZmqHub;

public class ZmqLogDialog extends TitleAreaDialog {

	ZmqHub hub;
	ListViewer listViewer;

	public ZmqLogDialog(Shell parentShell, ZmqHub hub) {
		super(parentShell);
		setShellStyle(SWT.RESIZE);
		this.hub = hub;
	}

	@Override
	protected Control createDialogArea(Composite parent) {
		Composite area = (Composite) super.createDialogArea(parent);

		listViewer = new ListViewer(area, SWT.BORDER | SWT.V_SCROLL);
		List list = listViewer.getList();
		list.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
		
		ViewerSupport.bind(listViewer, hub.getLog(), BeanProperties.value("msg"));
				
		setHelpAvailable(false);
		setTitle("Message Log");
		setMessage(hub.getAddress());

		return area;
	}

//	@Override
//	public void update(byte[] message) {
//		StringBuilder b = new StringBuilder();
//		b.append("[");
//		for (int i = 0; i < message.length; i++) {
//			b.append(Integer.toHexString(message[i]));
//			b.append(",");
//		}
//		b.deleteCharAt(b.length() - 1);
//		b.append("]");
//
//		Display.getDefault().asyncExec(new Runnable() {
//			public void run() {
//				if (message.length >= 20) {
//					NetIDEMessage msg = new NetIDEMessage(message); 
//					listViewer.add(msg);
//					listViewer.reveal(msg);
//				} else {
//					listViewer.add(b.toString());
//					listViewer.reveal(b.toString());
//				}
//				
//			}
//		});
//
//	}

	
	@Override
	public boolean close() {
		return super.close();
		
	}
	protected Point getInitialSize() {
		return new Point(755, 581);
	}
}

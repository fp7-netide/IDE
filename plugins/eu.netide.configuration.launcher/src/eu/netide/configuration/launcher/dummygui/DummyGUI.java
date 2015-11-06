package eu.netide.configuration.launcher.dummygui;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.ui.part.ViewPart;

import eu.netide.configuration.launcher.starters.IStarter;
import eu.netide.configuration.launcher.starters.VagrantManager;
import java.util.ArrayList;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.events.MouseAdapter;
import org.eclipse.swt.events.MouseEvent;

public class DummyGUI extends ViewPart {

	public static String ID = "eu.netide.configuration.launcher.dummygui";

	private VagrantManager vagrant;

	private ArrayList<IStarter> starters;

	private Group grpStarters;

	public DummyGUI() {}

	public void setVagrantManager(VagrantManager vm) {
		this.vagrant = vm;
	}

	public void setStarters(ArrayList<IStarter> starters) {
		this.starters = starters;

		for (final Control c : grpStarters.getChildren()) {
			c.dispose();
		}
		
		for (final IStarter starter : starters) {
			Label lblOdlShim = new Label(grpStarters, SWT.NONE);
			//lblOdlShim.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
			lblOdlShim.setText(starter.getName());

			Composite composite_1 = new Composite(grpStarters, SWT.NONE);
			composite_1.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
			composite_1.setLayout(new GridLayout(2, false));

			Button btnOn = new Button(composite_1, SWT.NONE);
			btnOn.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
			btnOn.setText("On");
			btnOn.addMouseListener(new MouseAdapter() {
				@Override
				public void mouseUp(MouseEvent e) {
					starter.syncStart();
				}
			});

			Button btnOff = new Button(composite_1, SWT.NONE);
			btnOff.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
			btnOff.setText("Off");
			btnOff.addMouseListener(new MouseAdapter() {
				@Override
				public void mouseUp(MouseEvent e) {
					starter.stop();
				}
			});
		}
		grpStarters.getParent().redraw();
		grpStarters.getParent().update();
		grpStarters.layout();
		
	}

	@Override
	public void createPartControl(Composite parent) {

		Composite composite = new Composite(parent, SWT.NONE);
		composite.setLayout(new GridLayout(1, false));

		Group grpVagrant = new Group(composite, SWT.NONE);
		grpVagrant.setLayout(new GridLayout(3, false));
		grpVagrant.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		grpVagrant.setText("Vagrant");

		Button btnNewButton = new Button(grpVagrant, SWT.NONE);
		btnNewButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				vagrant.asyncUp();
			}
		});
		btnNewButton.setBounds(0, 0, 70, 25);
		btnNewButton.setText("Up");

		Button btnNewButton_1 = new Button(grpVagrant, SWT.NONE);
		btnNewButton_1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				vagrant.asyncProvision();
			}
		});
		btnNewButton_1.setBounds(0, 0, 70, 25);
		btnNewButton_1.setText("Provision");

		Button btnNewButton_2 = new Button(grpVagrant, SWT.NONE);
		btnNewButton_2.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				vagrant.asyncHalt();
				setStarters(new ArrayList<IStarter>());
			}
		});
		btnNewButton_2.setBounds(0, 0, 70, 25);
		btnNewButton_2.setText("Halt");

		grpStarters = new Group(composite, SWT.NONE);
		grpStarters.setText("Starters");
		grpStarters.setLayout(new GridLayout(2, false));
		grpStarters.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, true, 1, 1));

		// TODO Auto-generated method stub

	}

	@Override
	public void setFocus() {
		// TODO Auto-generated method stub

	}
}

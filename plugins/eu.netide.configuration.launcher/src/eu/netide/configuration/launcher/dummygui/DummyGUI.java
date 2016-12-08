package eu.netide.configuration.launcher.dummygui;

import java.util.ArrayList;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.MouseAdapter;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.List;
import org.eclipse.ui.part.ViewPart;

import eu.netide.configuration.launcher.starters.IStarter;
import eu.netide.configuration.launcher.starters.IStarterRegistry;
import eu.netide.deployment.topologyimport.TopologyImport;
import eu.netide.deployment.topologyimport.TopologyImportFactory;
import eu.netide.configuration.launcher.managers.IManager;

public class DummyGUI extends ViewPart {

	public static String ID = "eu.netide.configuration.launcher.dummygui";

	private IManager manager;

	private IStarter mininet;

	private ArrayList<IStarter> starters;

	private Group grpStarters;

	private List list;

	private IStarterRegistry reg = IStarterRegistry.instance;

	private Composite parent;

	public DummyGUI() {
	}

	public void setManager(IManager manager) {
		this.manager = manager;
	}

	public void setMininet(IStarter mn) {
		this.mininet = mn;
	}

	public void refreshStarters() {
		list.removeAll();

		java.util.List<String> t = null;

		if (manager != null) {
			t = manager.getRunningSessions();
			for (String s : t)
				list.add(s.substring(s.indexOf(".") + 1));
		}

	}

	@Override
	public void createPartControl(final Composite parent) {

		this.parent = parent;
		Composite composite = new Composite(parent, SWT.NONE);
		composite.setLayout(new GridLayout(2, false));

		Group grpVagrant = new Group(composite, SWT.NONE);
		grpVagrant.setLayout(new GridLayout(5, false));
		grpVagrant.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 2));
		grpVagrant.setText("Manager");

		Button btnUp = new Button(grpVagrant, SWT.NONE);
		btnUp.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				manager.asyncUp();
			}
		});
		btnUp.setBounds(0, 0, 70, 25);
		btnUp.setText("Up");

		Button btnProvision = new Button(grpVagrant, SWT.NONE);
		btnProvision.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				manager.asyncProvision();
			}
		});
		btnProvision.setBounds(0, 0, 70, 25);
		btnProvision.setText("Provision");

		Button btnHalt = new Button(grpVagrant, SWT.NONE);
		btnHalt.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				manager.asyncHalt();
				list.removeAll();
			}
		});
		btnHalt.setBounds(0, 0, 70, 25);
		btnHalt.setText("Halt");

		Button btnGetSessions = new Button(grpVagrant, SWT.NONE);
		btnGetSessions.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				Job job = new Job("Get Sessions") {
					@Override
					protected IStatus run(IProgressMonitor monitor) {
						Display.getDefault().asyncExec(new Runnable() {
							@Override
							public void run() {
								refreshStarters();
							}
						});
						return Status.OK_STATUS;
					}
				};
				job.schedule();
			}
		});

		btnGetSessions.setText("Get Sessions");

		Button btnGetTopology = new Button(grpVagrant, SWT.NONE);
		btnGetTopology.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				String topo = manager.execWithReturn(
						"curl -s -u admin:admin http://localhost:8181/restconf/operational/network-topology:network-topology/");
				TopologyImport topoImport = TopologyImportFactory.instance.createTopologyImport();
				
//				topoImport.createTopologyModelFromString(topo, manager.getProject().getFile("import.topology").getFullPath().toPortableString());
			}
		});
		btnGetTopology.setText("Get Topology");

		Group grpMininet = new Group(composite, SWT.NONE);
		grpMininet.setText("Mininet");
		grpMininet.setLayout(new GridLayout(2, false));
		grpMininet.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 2));

		Button btnNewButton_3 = new Button(grpMininet, SWT.NONE);
		btnNewButton_3.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				mininet.syncStart();
			}
		});
		btnNewButton_3.setText("On");

		Button btnNewButton_4 = new Button(grpMininet, SWT.NONE);
		btnNewButton_4.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				mininet.stop();
			}
		});
		btnNewButton_4.setText("Off");

		grpStarters = new Group(composite, SWT.NONE);
		grpStarters.setText("Sessions");
		grpStarters.setLayout(new GridLayout(2, false));
		grpStarters.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, true, 2, 1));

		list = new List(grpStarters, SWT.BORDER | SWT.V_SCROLL);
		list.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

		Composite composite_1 = new Composite(grpStarters, SWT.NONE);
		composite_1.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false, false, 1, 1));
		composite_1.setLayout(new GridLayout(1, false));

		Button btnStartSession = new Button(composite_1, SWT.NONE);
		btnStartSession.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				String name = list.getSelection()[0];
				reg.get(name).asyncStart();
			}
		});
		btnStartSession.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		btnStartSession.setText("Start");

		Button btnStopSession = new Button(composite_1, SWT.NONE);
		btnStopSession.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		btnStopSession.setText("Stop");
		btnStopSession.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				String name = list.getSelection()[0];
				reg.get(name).stop();
			}
		});

		Button btnReattachSession = new Button(composite_1, SWT.NONE);
		btnReattachSession.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		btnReattachSession.setText("Reattach");
		btnReattachSession.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseUp(MouseEvent e) {
				String name = list.getSelection()[0];
				reg.get(name).reattach();
			}
		});

		refreshStarters();

		// TODO Auto-generated method stub

	}

	@Override
	public void setFocus() {
		// TODO Auto-generated method stub

	}
}

package eu.netide.toolpanel.views;

import org.eclipse.core.databinding.DataBindingContext;
import org.eclipse.core.databinding.UpdateValueStrategy;
import org.eclipse.core.databinding.beans.BeanProperties;
import org.eclipse.core.databinding.observable.value.IObservableValue;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.databinding.swt.WidgetProperties;
import org.eclipse.jface.viewers.ComboViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Scale;
import org.eclipse.swt.widgets.Spinner;
import org.eclipse.ui.part.ViewPart;

import eu.netide.toolpanel.connectors.LogConnector;

public class ReplayPanel extends ViewPart {
	private DataBindingContext m_bindingContext;
	private Scale scale;
	private Spinner spinner;
	private LogConnector log;
	private IFile file;

	private Composite composite_1;
	private Combo combo_1;
	private ComboViewer comboViewer;

	public ReplayPanel() {
		this.log = new LogConnector();
	}

	@Override
	public void createPartControl(Composite parent) {

		Composite composite = new Composite(parent, SWT.NONE);
		composite.setLayout(new FillLayout(SWT.HORIZONTAL));

		ScrolledComposite scrolledComposite_1 = new ScrolledComposite(composite,
				SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL);
		scrolledComposite_1.setExpandHorizontal(true);
		scrolledComposite_1.setExpandVertical(true);

		composite_1 = new Composite(scrolledComposite_1, SWT.NONE);
		composite_1.setLayout(new GridLayout(2, false));

		comboViewer = new ComboViewer(composite_1, SWT.READ_ONLY);
		combo_1 = comboViewer.getCombo();
		combo_1.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				IFile jsonfile = file.getProject().getFolder("statistics").getFile(combo_1.getText());
				log.fromFile(jsonfile);
			}
		});
		combo_1.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		new Label(composite_1, SWT.NONE);

		scale = new Scale(composite_1, SWT.NONE);
		scale.setMinimum(1);
		scale.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				log.handle(scale.getSelection());
			}
		});
		scale.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

		spinner = new Spinner(composite_1, SWT.BORDER);
		spinner.setMinimum(1);
		spinner.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				log.handle(scale.getSelection());
			}
		});
		spinner.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		scrolledComposite_1.setContent(composite_1);
		scrolledComposite_1.setMinSize(composite_1.computeSize(SWT.DEFAULT, SWT.DEFAULT));
		m_bindingContext = initDataBindings();
		// TODO Auto-generated method stub

	}

	@Override
	public void setFocus() {
		// TODO Auto-generated method stub

	}

	public void setFile(IFile file) {
		this.file = file;

		this.combo_1.setItems(new String[0]);
		try {
			for (IResource f : file.getProject().getFolder("statistics").members()) {
				if (f instanceof IFile) {
					IFile ifile = (IFile) f;
					if (ifile.getFileExtension().equals("json"))
						this.combo_1.add(ifile.getName());
				}
			}
			this.combo_1.select(0);
		} catch (CoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	protected DataBindingContext initDataBindings() {
		DataBindingContext bindingContext = new DataBindingContext();
		//
		IObservableValue observeSelectionScaleObserveWidget = WidgetProperties.selection().observe(scale);
		IObservableValue observeSelectionSpinnerObserveWidget = WidgetProperties.selection().observe(spinner);
		bindingContext.bindValue(observeSelectionScaleObserveWidget, observeSelectionSpinnerObserveWidget, null, null);
		//
		IObservableValue observeMaxScaleObserveWidget = WidgetProperties.maximum().observe(scale);
		IObservableValue sizeLogObserveValue = BeanProperties.value("size").observe(log);
		bindingContext.bindValue(observeMaxScaleObserveWidget, sizeLogObserveValue, null,
				new UpdateValueStrategy(UpdateValueStrategy.POLICY_UPDATE));
		//
		
		IObservableValue observeMaxSpinnerObserveWidget = WidgetProperties.maximum().observe(spinner);
//		IObservableValue sizeLogObserveValue = BeanProperties.value("size").observe(log);
		bindingContext.bindValue(observeMaxSpinnerObserveWidget, sizeLogObserveValue, null,
				new UpdateValueStrategy(UpdateValueStrategy.POLICY_UPDATE));
		return bindingContext;
	}
}

package eu.netide.workbenchconfigurationeditor.controller;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

import org.eclipse.core.databinding.DataBindingContext;
import org.eclipse.core.databinding.UpdateValueStrategy;
import org.eclipse.core.databinding.beans.BeanProperties;
import org.eclipse.core.databinding.observable.list.WritableList;
import org.eclipse.core.databinding.observable.value.IObservableValue;
import org.eclipse.core.resources.IFile;
import org.eclipse.jface.databinding.swt.WidgetProperties;
import org.eclipse.jface.databinding.viewers.ViewerSupport;
import org.eclipse.jface.viewers.ComboViewer;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.w3c.dom.Document;

import eu.netide.workbenchconfigurationeditor.model.CompositionModel;
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel;
import eu.netide.workbenchconfigurationeditor.model.ShimModel;
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel;
import eu.netide.workbenchconfigurationeditor.model.TopologyModel;
import eu.netide.workbenchconfigurationeditor.model.UiStatusModel;
import eu.netide.workbenchconfigurationeditor.util.Constants;
import eu.netide.workbenchconfigurationeditor.util.RunningBoolInverter;
import eu.netide.workbenchconfigurationeditor.util.RunningBoolToStringConverter;
import eu.netide.workbenchconfigurationeditor.util.RunningStringToBoolConverter;
import eu.netide.workbenchconfigurationeditor.view.WbConfigurationEditor;

public class WorkbenchConfigurationEditorEngine {

	private WbConfigurationEditor editor;
	// input object from editor
	private IFile inputFile;
	// xml representation of input file
	private Document doc;
	// representation of the ui status
	private UiStatusModel statusModel;
	// instance to link model and view
	private DataBindingContext ctx;

	public WorkbenchConfigurationEditorEngine(WbConfigurationEditor editor) {
		this.editor = editor;
		this.inputFile = editor.getFile();

		this.ctx = new DataBindingContext();

		initModel();
		initDataBinding();
	}

	private void initModel() {

		this.statusModel = loadXML();

		if (statusModel == null) {
			this.statusModel = new UiStatusModel();
		}

		// ControllerManager.initControllerManager(this.statusModel,
		// editor.getFile());
	}

	private void initDataBinding() {

		this.addStatusLabelDataBinding(this.editor.getServerControllerLabel(),
				Constants.SERVER_CONTROLLER_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getMininetStatusLable(), Constants.MININET_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getSSHStautsLabel(), Constants.SSH_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getVagrantStatusLabel(), Constants.VAGRANT_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getCoreStatusLabel(), Constants.CORE_RUNNING_MODEL);

		this.addTableDataBinding(this.statusModel.getModelList());


		//this.addButtonEnabledDataBinding(this.editor.getSshReloadButton(), Constants.SSH_RUNNING_MODEL);

		this.addButtonDisabledDataBinding(this.editor.getBtnVagrantUp(), Constants.VAGRANT_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnProvision_2(), Constants.VAGRANT_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnVagrantHalt(), Constants.VAGRANT_RUNNING_MODEL);

		this.addButtonDisabledDataBinding(this.editor.getBtnMininetOn(), Constants.MININET_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnMininetOff(), Constants.MININET_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnReattachMininet(), Constants.MININET_RUNNING_MODEL);

		this.addButtonDisabledDataBinding(this.editor.getStartCoreBtn(), Constants.CORE_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getStopCoreBtn(), Constants.CORE_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnReattachCore(), Constants.CORE_RUNNING_MODEL);

		this.addButtonEnabledDataBinding(this.editor.getBtnCopyApps(), Constants.SSH_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getTopologySSHButton(), Constants.SSH_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnProvision_1(), Constants.SSH_RUNNING_MODEL);
		
		this.addComboDisabledDataBinding(this.editor.getSelectServerCombo(), Constants.SERVER_CONTROLLER_RUNNING_MODEL);
		

		this.addButtonDisabledDataBinding(this.editor.getStartServerController(),
				Constants.SERVER_CONTROLLER_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnStopServerController(),
				Constants.SERVER_CONTROLLER_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnReattachServer(), Constants.SERVER_CONTROLLER_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnImportTopology(), Constants.SERVER_CONTROLLER_RUNNING_MODEL);

		this.addButtonDisabledDataBinding(this.editor.getBtnDebuggerOn(), Constants.DEBUGGER_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnDebuggerOff(), Constants.DEBUGGER_RUNNING_MODEL);
		this.addButtonEnabledDataBinding(this.editor.getBtnDebuggerReattach(), Constants.DEBUGGER_RUNNING_MODEL);

		this.addStatusLabelDataBinding(this.editor.getLblDebuggerStatus(), Constants.DEBUGGER_RUNNING_MODEL);

		this.addSshComboDataBinding(this.statusModel.getProfileList());
		this.addServerControllerComboDataBinding();
		this.addCompositionTextDataBinding(this.editor.getTextCompositionPath(), Constants.COMPOSITION_MODEL_PATH);
		this.addTopologyTextDataBinding(this.editor.getTopologyText(), Constants.TOPOLOGY_MODEL_PATH);

		this.addShimComboDataBinding(this.editor.getSelectServerCombo(), Constants.SERVER_COMBO_TEXT);
		
		// this.addTabFolderBinding(this.editor.getTabFolder().getTabList()[0],
		// Constants.VAGRANT_RUNNING_MODEL);
		// this.addTabFolderBinding(this.editor.getTabFolder().getTabList()[1],
		// Constants.SSH_RUNNING_MODEL);

	}

	private void addTabFolderBinding(Control tabItem, String property) {
		IObservableValue tfObs = WidgetProperties.enabled().observe(tabItem);
		IObservableValue sshOn = BeanProperties.value(UiStatusModel.class, property).observe(this.statusModel);
		UpdateValueStrategy modelToView = new UpdateValueStrategy();
		modelToView.setConverter(new RunningBoolInverter(Boolean.class, Boolean.class));
		UpdateValueStrategy viewToModel = new UpdateValueStrategy();
		this.ctx.bindValue(tfObs, sshOn, viewToModel, modelToView);
	}

	private void addCompositionTextDataBinding(Text text, String property) {
		IObservableValue textObs = WidgetProperties.text().observe(text);
		IObservableValue pathObs = BeanProperties.value(CompositionModel.class, property)
				.observe(this.statusModel.getCompositionModel());
		this.ctx.bindValue(textObs, pathObs);
	}

	private void addTopologyTextDataBinding(Text text, String property) {
		IObservableValue textObs = WidgetProperties.text().observe(text);
		IObservableValue pathObs = BeanProperties.value(TopologyModel.class, property)
				.observe(this.statusModel.getTopologyModel());
		this.ctx.bindValue(textObs, pathObs);
	}

	private void addSshComboDataBinding(ArrayList<SshProfileModel> profileList) {

		// bind sshmodellist to combobox content
		WritableList input = new WritableList(profileList, SshProfileModel.class);
		this.statusModel.setWritableProfileList(input);

		ComboViewer cv = this.editor.getSshComboViewer();
		ViewerSupport.bind(cv, input, BeanProperties.values(new String[] { Constants.PROFILE_NAME_MODEL }));

		// bind selectionIndex to model
		// selectionIndex == profileListIndex, use it to match selection to
		// actual model
		IObservableValue selection = WidgetProperties.singleSelectionIndex().observe(cv.getCombo());
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, Constants.SSH_COMBO_SELECTION_INDEX)
				.observe(this.statusModel);

		if (!input.isEmpty())
			cv.getCombo().select(0);

		this.ctx.bindValue(modelValue, selection);
	}

	private void addShimComboDataBinding(Combo combo, String property) {
		IObservableValue comboObs = WidgetProperties.text().observe(combo);
		IObservableValue selObs = BeanProperties.value(ShimModel.class, property)
				.observe(this.statusModel.getShimModel());
		this.ctx.bindValue(comboObs, selObs);
	}

	private void addServerControllerComboDataBinding() {

		ComboViewer cv = this.editor.getServerComboViewer();

		IObservableValue selection = WidgetProperties.text().observe(cv.getCombo());
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, Constants.SERVER_CONTROLLER_SELECTION)
				.observe(this.statusModel);

		cv.getCombo().select(0);

		this.ctx.bindValue(modelValue, selection);
	}

	private void addTableDataBinding(ArrayList<LaunchConfigurationModel> modelList) {
		WritableList input = new WritableList(modelList, LaunchConfigurationModel.class);

		this.statusModel.setWritableModelList(input);
		ViewerSupport
				.bind(this.editor.getTableViewer(), input,
						BeanProperties.values(new String[] { Constants.LaunchName, Constants.APP_NAME_MODEL,
								Constants.APP_RUNNING_MODEL, Constants.PLATFORM_MODEL,
								Constants.CLIENT_CONTROLLER_MODEL, Constants.PORT_MODEL, Constants.FLAG }));

		// bind selectionIndex to model
		// selectionIndex == profileListIndex, use it to match selection to
		// actual model
		IObservableValue selection = WidgetProperties.singleSelectionIndex()
				.observe(this.editor.getTableViewer().getTable());
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, Constants.LAUNCH_TABLE_INDEX)
				.observe(this.statusModel);

		this.ctx.bindValue(modelValue, selection);

	}

	private void addButtonEnabledDataBinding(Button button, String property) {

		IObservableValue widgetValue = WidgetProperties.enabled().observe(button);
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, property).observe(this.statusModel);
		this.ctx.bindValue(widgetValue, modelValue);
	}
	
	private void addComboEnabledDataBinding(Combo combo, String property) {

		IObservableValue widgetValue = WidgetProperties.enabled().observe(combo);
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, property).observe(this.statusModel);
		this.ctx.bindValue(widgetValue, modelValue);
	}
	
	private void addComboDisabledDataBinding(Combo combo, String property) {

		IObservableValue widgetValue = WidgetProperties.enabled().observe(combo);
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, property).observe(this.statusModel);
		UpdateValueStrategy modelToView = new UpdateValueStrategy();
		modelToView.setConverter(new RunningBoolInverter(Boolean.class, Boolean.class));
		UpdateValueStrategy viewToModel = new UpdateValueStrategy();

		this.ctx.bindValue(widgetValue, modelValue, viewToModel, modelToView);
	}

	private void addButtonDisabledDataBinding(Button button, String property) {

		IObservableValue widgetValue = WidgetProperties.enabled().observe(button);
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, property).observe(this.statusModel);
		UpdateValueStrategy modelToView = new UpdateValueStrategy();
		modelToView.setConverter(new RunningBoolInverter(Boolean.class, Boolean.class));
		UpdateValueStrategy viewToModel = new UpdateValueStrategy();

		this.ctx.bindValue(widgetValue, modelValue, viewToModel, modelToView);
	}

	private void addStatusLabelDataBinding(Label label, String property) {

		IObservableValue widgetValue = WidgetProperties.text().observe(label);
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, property).observe(this.statusModel);
		// WidgetProperties.font() bind with bool to display color corresponding
		// to running status
		UpdateValueStrategy modelToView = new UpdateValueStrategy();
		modelToView.setConverter(new RunningBoolToStringConverter());

		UpdateValueStrategy viewToModel = new UpdateValueStrategy();
		viewToModel.setConverter(new RunningStringToBoolConverter());

		this.ctx.bindValue(widgetValue, modelValue, viewToModel, modelToView);
	}

	public UiStatusModel getStatusModel() {
		return this.statusModel;
	}

	public Document getDoc() {
		return this.doc;
	}

	public UiStatusModel loadXML() {
		XMLDecoder decoder = null;
		try {
			decoder = new XMLDecoder(
					new BufferedInputStream(new FileInputStream(this.inputFile.getLocation().toString())));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (decoder != null) {

			UiStatusModel model = new UiStatusModel();
			ArrayList<LaunchConfigurationModel> am = new ArrayList<LaunchConfigurationModel>();
			ArrayList<SshProfileModel> pm = new ArrayList<SshProfileModel>();

			boolean moreObjects = true;

			while (moreObjects) {
				Object tmp;
				try {
					tmp = decoder.readObject();

					if (tmp instanceof CompositionModel) {
						model.setCompositionModel((CompositionModel) tmp);
					} else if (tmp instanceof TopologyModel) {
						model.setTopologyModel((TopologyModel) tmp);
					} else if (tmp instanceof ShimModel) {
						model.setShimModel((ShimModel) tmp);
					} else if (tmp instanceof ArrayList<?>) {
						ArrayList<?> a = (ArrayList<?>) tmp;
						if (!a.isEmpty()) {

							for (Object o : a) {
								if (o instanceof LaunchConfigurationModel) {
									am.add((LaunchConfigurationModel) o);
								} else if (o instanceof SshProfileModel) {
									pm.add((SshProfileModel) o);
								}
							}

						}

					}

				} catch (ArrayIndexOutOfBoundsException e) {
					moreObjects = false;
				}
			}

			decoder.close();

			model.setModelList(am);
			model.setProfileList(pm);

			return model;

		}
		return null;
	}

	public void saveAllChanges() {

		try {

			File file = new File(this.inputFile.getLocation().toString());

			if (!file.exists()) {
				System.out.println(file.createNewFile());
			}

			XMLEncoder encoder = new XMLEncoder(new BufferedOutputStream(new FileOutputStream(file)));

			encoder.writeObject(this.statusModel.getCompositionModel());
			encoder.writeObject(this.statusModel.getTopologyModel());
			encoder.writeObject(this.statusModel.getModelList());
			encoder.writeObject(this.statusModel.getProfileList());
			encoder.writeObject(this.statusModel.getShimModel());

			encoder.close();

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}

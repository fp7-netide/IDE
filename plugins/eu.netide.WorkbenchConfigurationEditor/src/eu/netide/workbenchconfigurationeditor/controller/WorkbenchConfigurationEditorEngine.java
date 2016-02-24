package eu.netide.workbenchconfigurationeditor.controller;

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
import org.eclipse.swt.widgets.Label;
import org.w3c.dom.Document;

import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel;
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel;
import eu.netide.workbenchconfigurationeditor.model.UiStatusModel;
import eu.netide.workbenchconfigurationeditor.util.Constants;
import eu.netide.workbenchconfigurationeditor.util.RunningBoolToStringConverter;
import eu.netide.workbenchconfigurationeditor.util.RunningStringToBoolConverter;
import eu.netide.workbenchconfigurationeditor.util.XmlHelper;
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
		doc = XmlHelper.getDocFromFile(inputFile);
		this.ctx = new DataBindingContext();

		// TODO: refactor creation process of controller manager
		// controllerManager = ControllerManager.getStarter(topoPath);
		initModel();
		initDataBinding();
	}

	//TODO: write data back to xml on a central point
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initModel() {
		this.statusModel = new UiStatusModel();
		this.statusModel.setMininetRunning(new Boolean(false));
		this.statusModel.setServerControllerRunning(new Boolean(false));
		this.statusModel.setSshRunning(new Boolean(false));
		this.statusModel.setVagrantRunning(new Boolean(false));

		ArrayList[] parsed = XmlHelper.parseFileToModel(inputFile, doc);
		this.statusModel.setModelList(parsed[0]);
		this.statusModel.setProfileList(parsed[1]);
		
		ControllerManager.initControllerManager(LaunchConfigurationModel.getTopology(), this.statusModel);
	}

	private void initDataBinding() {

		this.addStatusLabelDataBinding(this.editor.getServerControllerLabel(),
				Constants.SERVER_CONTROLLER_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getMininetStatusLable(), Constants.MININET_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getSSHStautsLabel(), Constants.SSH_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getVagrantStatusLabel(), Constants.VAGRANT_RUNNING_MODEL);

		this.addTableDataBinding(this.statusModel.getModelList());
		this.addComboDataBinding(this.statusModel.getProfileList());
		this.addServerControllerComboDataBinding();
	}

	private void addComboDataBinding(ArrayList<SshProfileModel> profileList) {

		// bind sshmodellist to combobox content
		WritableList input = new WritableList(profileList, SshProfileModel.class);
		
		ComboViewer cv = this.editor.getSshComboViewer();
		ViewerSupport.bind(cv, input, BeanProperties.values(new String[] { Constants.PROFILE_NAME_MODEL }));

		// bind selectionIndex to model
		// selectionIndex == profileListIndex, use it to match selection to
		// actual model
		IObservableValue selection = WidgetProperties.singleSelectionIndex().observe(cv.getCombo());
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, Constants.SSH_COMBO_SELECTION_INDEX)
				.observe(this.statusModel);

		this.ctx.bindValue(modelValue, selection);
	}

	private void addServerControllerComboDataBinding() {

		ComboViewer cv = this.editor.getServerComboViewer();

		IObservableValue selection = WidgetProperties.text().observe(cv.getCombo());
		IObservableValue modelValue = BeanProperties
				.value(UiStatusModel.class, Constants.SERVER_CONTROLLER_SELECTION).observe(this.statusModel);

		this.ctx.bindValue(modelValue, selection);
		
		
	}

	private void addTableDataBinding(ArrayList<LaunchConfigurationModel> modelList) {
		WritableList input = new WritableList(modelList, LaunchConfigurationModel.class);
		this.statusModel.setWritableModelList(input);
		ViewerSupport.bind(this.editor.getTableViewer(), input,
				BeanProperties.values(new String[] { Constants.APP_NAME_MODEL, Constants.APP_RUNNING_MODEL,
						Constants.PLATFORM_MODEL, Constants.CLIENT_CONTROLLER_MODEL, Constants.PORT_MODEL }));

		// bind selectionIndex to model
		// selectionIndex == profileListIndex, use it to match selection to
		// actual model
		IObservableValue selection = WidgetProperties.singleSelectionIndex()
				.observe(this.editor.getTableViewer().getTable());
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, Constants.LAUNCH_TABLE_INDEX)
				.observe(this.statusModel);

		this.ctx.bindValue(modelValue, selection);

	}

	private void addStatusLabelDataBinding(Label label, String property) {

		IObservableValue widgetValue = WidgetProperties.text().observe(label);
		IObservableValue modelValue = BeanProperties.value(UiStatusModel.class, property).observe(this.statusModel);

		UpdateValueStrategy modelToView = new UpdateValueStrategy();
		modelToView.setConverter(new RunningBoolToStringConverter());

		UpdateValueStrategy viewToModel = new UpdateValueStrategy();
		viewToModel.setConverter(new RunningStringToBoolConverter());

		this.ctx.bindValue(widgetValue, modelValue, viewToModel, modelToView);
	}
	public UiStatusModel getStatusModel(){
		return this.statusModel;
	}
}

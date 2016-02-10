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
import org.eclipse.swt.widgets.Label;
import org.w3c.dom.Document;

import dataBinding.RunningBoolToStringConverter;
import dataBinding.RunningStringToBoolConverter;
import eu.netide.workbenchconfigurationeditor.editors.ControllerManager;
import eu.netide.workbenchconfigurationeditor.editors.WbConfigurationEditor;
import eu.netide.workbenchconfigurationeditor.editors.XmlHelper;
import eu.netide.workbenchconfigurationeditor.model.Constants;
import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel;
import eu.netide.workbenchconfigurationeditor.model.SshProfileModel;
import eu.netide.workbenchconfigurationeditor.model.UiStatusModel;

public class WorkbenchConfigurationEditorEngine {

	private WbConfigurationEditor editor;
	// input object from editor
	private IFile inputFile;
	// xml representation of input file
	private Document doc;
	// list corresponding to doc
	private ArrayList<LaunchConfigurationModel> modelList;
	// list corresponding to doc
	private ArrayList<SshProfileModel> profileList;
	// object used for the starting process of the controller
	private ControllerManager controllerManager;
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

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void initModel() {
		this.statusModel = new UiStatusModel();
		this.statusModel.setMininetRunning(new Boolean(false));
		this.statusModel.setServerControllerRunning(new Boolean(false));
		this.statusModel.setSshRunning(new Boolean(false));
		this.statusModel.setVagrantRunning(new Boolean(false));

		ArrayList[] parsed = XmlHelper.parseFileToModel(inputFile, doc);

		modelList = parsed[0];
		profileList = parsed[1];
	}

	private void initDataBinding() {
		// TODO: get corresponding ui widgets

		this.addStatusLabelDataBinding(this.editor.getServerControllerLabel(),
				Constants.SERVER_CONTROLLER_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getMininetStatusLable(), Constants.MININET_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getSSHStautsLabel(), Constants.SSH_RUNNING_MODEL);
		this.addStatusLabelDataBinding(this.editor.getVagrantStatusLabel(), Constants.VAGRANT_RUNNING_MODEL);

		this.addTableDataBinding(modelList);
		// TODO: create dataBindingContext
		// TODO: link ui to context
		// TODO: display model info in ui
	}

	private void addTableDataBinding(ArrayList<LaunchConfigurationModel> modelList) {
		WritableList input = new WritableList(modelList, LaunchConfigurationModel.class);

		ViewerSupport.bind(this.editor.getTableViewer(), input,
				BeanProperties.values(new String[] { Constants.APP_NAME_MODEL, Constants.APP_RUNNING_MODEL,
						Constants.PLATFORM_MODEL, Constants.CLIENT_CONTROLLER_MODEL, Constants.PORT_MODEL }));
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

	private void initButtonListener() {
		// TODO: get corresponding ui buttons
		// TODO: add Button listeners
	}
}

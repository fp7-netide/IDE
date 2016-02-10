package dataBinding;

import org.eclipse.core.databinding.conversion.Converter;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.TableItem;

import eu.netide.workbenchconfigurationeditor.model.LaunchConfigurationModel;

public class LaunchModelToTableEntryConverter extends Converter{

	public LaunchModelToTableEntryConverter() {
		super(LaunchConfigurationModel.class, TableItem.class);
	}

	@Override
	public Object convert(Object fromObject) {
		if(fromObject instanceof LaunchConfigurationModel){
			LaunchConfigurationModel model = (LaunchConfigurationModel) fromObject;
			
			String[] content = new String[] { model.getAppName(), "offline", model.getPlatform(), model.getClientController(),
					model.getAppPort() };
			//TableItem tmp = new TableItem(table, SWT.NONE);
		}
		return null;
	}

}

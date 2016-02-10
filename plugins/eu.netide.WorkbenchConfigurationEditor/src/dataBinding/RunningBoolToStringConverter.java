package dataBinding;

import org.eclipse.core.databinding.conversion.Converter;

import eu.netide.workbenchconfigurationeditor.model.Constants;

public class RunningBoolToStringConverter extends Converter {

	public RunningBoolToStringConverter() {
		super(Boolean.class, String.class);
	}

	@Override
	public Object convert(Object fromObject) {
		if (fromObject instanceof Boolean) {
			Boolean bool = (Boolean) fromObject;

			if (bool) {
				return Constants.LABEL_RUNNING;
			} else {
				return Constants.LABEL_OFFLINE;
			}

		}
		return Constants.LABEL_OFFLINE;

	}

}

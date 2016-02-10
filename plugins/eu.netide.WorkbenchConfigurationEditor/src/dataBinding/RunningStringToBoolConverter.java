package dataBinding;

import org.eclipse.core.databinding.conversion.Converter;

import eu.netide.workbenchconfigurationeditor.model.Constants;

public class RunningStringToBoolConverter extends Converter {

	public RunningStringToBoolConverter() {
		super(null, null);
	}

	@Override
	public Object convert(Object fromObject) {
		if (fromObject instanceof String) {
			String string = (String) fromObject;

			if (string.equalsIgnoreCase(Constants.LABEL_RUNNING)) {
				return new Boolean(true);
			} else if (string.equalsIgnoreCase(Constants.LABEL_OFFLINE)) {
				return new Boolean(false);
			}

		}
		return new Boolean(false);

	}

}

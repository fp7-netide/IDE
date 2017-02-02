package eu.netide.workbenchconfigurationeditor.util;

import org.eclipse.core.databinding.conversion.Converter;

public class RunningBoolInverter extends Converter{

	public RunningBoolInverter(Object fromType, Object toType) {
		super(fromType, toType);
		// TODO Auto-generated constructor stub
	}

	@Override
	public Object convert(Object fromObject) {
		
		if (fromObject instanceof Boolean) {
			return !(Boolean)fromObject;
		}
		
		return null;
	}

}

package workbenchconfigurationeditor.model;

import java.util.ArrayList;
import java.util.List;

public class ConfigurationServiceProvider {
	
	private static ConfigurationServiceProvider providerService = new ConfigurationServiceProvider();
	private ArrayList<LaunchConfigurationModel> configurations = new ArrayList<LaunchConfigurationModel>();
	
	private ConfigurationServiceProvider(){
		configurations.add(new LaunchConfigurationModel(0, "SimpleSwitch", "DayLight", "Prox", "SimpleTopo"));
	}
	
	public static ConfigurationServiceProvider getInstance(){
		return providerService;
	}
	
	public List<LaunchConfigurationModel> getConfigurations(){
		return this.configurations;
	}
	
	public LaunchConfigurationModel getConfigByID(long id){
		for(LaunchConfigurationModel m : configurations){
			if(m.getID() == id){
				return m;
			}
		}
		return null;
	}
}

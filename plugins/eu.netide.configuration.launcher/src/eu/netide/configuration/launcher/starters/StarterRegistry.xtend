package eu.netide.configuration.launcher.starters

import java.util.Map
import java.util.HashMap

class StarterRegistry implements IStarterRegistry {
	
	private static IStarterRegistry registry
	
	private Map<String, IStarter> regmap
	
	def static init() {
		if (registry == null)
			registry = new StarterRegistry
		return registry
	}
	
	new() {
		regmap = new HashMap<String, IStarter>()
	}
	
	override register(String key, IStarter value) {
		regmap.put(key, value)
	}
	
	override get(String key) {
		regmap.get(key)
	}
	
	
	
}
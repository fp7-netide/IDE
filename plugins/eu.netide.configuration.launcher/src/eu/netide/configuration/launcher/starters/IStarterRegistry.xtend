package eu.netide.configuration.launcher.starters

import java.util.Set

interface IStarterRegistry {
	
	IStarterRegistry instance = StarterRegistry.init()
	
	def void register(String key, IStarter value)
	
	def void remove(String key)
	
	def IStarter get(String key)
	
	def Set<String> getKeys()
	
	def void clear()
	
}
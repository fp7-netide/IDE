package eu.netide.configuration.launcher.starters

interface IStarterRegistry {
	
	IStarterRegistry instance = StarterRegistry.init()
	
	def void register(String key, IStarter value)
	
	def IStarter get(String key)
	
}
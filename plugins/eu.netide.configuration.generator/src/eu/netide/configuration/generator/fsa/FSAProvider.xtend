package eu.netide.configuration.generator.fsa

class FSAProvider {
	static def get() {
		return new FileSystemAccess
	}
}
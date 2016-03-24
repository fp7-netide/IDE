package eu.netide.configuration.utils.fsa

class FSAProvider {
	static def get() {
		return new FileSystemAccess
	}
}
package eu.netide.configuration.generator.fsa

import org.eclipse.xtext.builder.EclipseResourceFileSystemAccess2

class FSAProvider {
	static def get() {
		return new FileSystemAccess
	}
}
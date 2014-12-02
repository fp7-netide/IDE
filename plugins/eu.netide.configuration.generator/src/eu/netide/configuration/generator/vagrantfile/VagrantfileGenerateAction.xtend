package eu.netide.configuration.generator.vagrantfile

import com.google.inject.Guice
import eu.netide.configuration.generator.CommonConfigurationModule
import java.util.HashMap
import java.util.Map
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtext.builder.EclipseResourceFileSystemAccess2
import org.eclipse.xtext.generator.OutputConfiguration

class VagrantfileGenerateAction {

	private IResource resource
	
	new (IResource f) {
		this.resource = f
	}

	def run() {
		var injector = Guice.createInjector(new CommonConfigurationModule)

		var fsaprovider = injector.getProvider(EclipseResourceFileSystemAccess2)
		var fsa = fsaprovider.get
		fsa.outputConfigurations = defaultConfig
		fsa.monitor = new NullProgressMonitor
		fsa.project = resource.project
		
		var generator = injector.getInstance(VagrantfileGenerator)

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(resource.fullPath.toString), true)

		generator.doGenerate(resource, res, fsa)
	}



	def Map<String, OutputConfiguration> defaultConfig() {

		val OutputConfiguration defaultOutput = new OutputConfiguration("DEFAULT_OUTPUT")
		defaultOutput.setDescription("Output Folder")

		//defaultOutput.setOutputDirectory("./src")
		defaultOutput.setOutputDirectory("./gen")
		defaultOutput.setOverrideExistingResources(true)
		defaultOutput.setCreateOutputDirectory(true)
		defaultOutput.setCleanUpDerivedResources(true)
		defaultOutput.setSetDerivedProperty(true)

		val Map<String, OutputConfiguration> map = new HashMap<String, OutputConfiguration>()
		map.put("DEFAULT_OUTPUT", defaultOutput)
		map
	}
}

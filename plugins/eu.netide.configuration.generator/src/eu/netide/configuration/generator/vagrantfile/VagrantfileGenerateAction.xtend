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
import java.util.List
import org.eclipse.debug.core.ILaunchConfiguration
import eu.netide.configuration.generator.fsa.FSAProvider

/**
 * Sets up the necessary tools to generate a Vagrantfile
 * 
 * @author Christian Stritzke
 */
class VagrantfileGenerateAction {

	private IResource resource
	private ILaunchConfiguration configuration
	
	new (IResource f, ILaunchConfiguration configuration) {
		this.resource = f
		this.configuration = configuration
	}

	def run() {
		var fsa = FSAProvider.get
		fsa.outputDirectory = "./gen"
		fsa.project = resource.project
		
		var fsa2 = FSAProvider.get
		fsa2.project = resource.project
		fsa2.generateFolder("results")
		
		var generator = new VagrantfileGenerator

		var resset = new ResourceSetImpl
		var res = resset.getResource(URI.createURI(resource.fullPath.toString), true)

		generator.doGenerate(resource, res, configuration, fsa)
	}



//	def Map<String, OutputConfiguration> defaultConfig() {
//
//		val OutputConfiguration defaultOutput = new OutputConfiguration("DEFAULT_OUTPUT")
//		defaultOutput.setDescription("Output Folder")
//
//		//defaultOutput.setOutputDirectory("./src")
//		defaultOutput.setOutputDirectory("./gen")
//		defaultOutput.setOverrideExistingResources(true)
//		defaultOutput.setCreateOutputDirectory(true)
//		defaultOutput.setCleanUpDerivedResources(true)
//		defaultOutput.setSetDerivedProperty(true)
//
//		val Map<String, OutputConfiguration> map = new HashMap<String, OutputConfiguration>()
//		map.put("DEFAULT_OUTPUT", defaultOutput)
//		map
//	}
}

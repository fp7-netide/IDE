package eu.netide.configuration.generator.vagrantfile

import eu.netide.configuration.generator.fsa.FSAProvider
import org.eclipse.core.resources.IResource
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

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
}

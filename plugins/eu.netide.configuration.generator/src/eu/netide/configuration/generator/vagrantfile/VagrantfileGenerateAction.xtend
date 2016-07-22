package eu.netide.configuration.generator.vagrantfile

import eu.netide.configuration.utils.fsa.FSAProvider
import org.eclipse.core.resources.IResource

/**
 * Sets up the necessary tools to generate a Vagrantfile
 * 
 * @author Christian Stritzke
 */
class VagrantfileGenerateAction {

	private IResource resource
	
	new (IResource f) {
		this.resource = f
	}

	def run() {
		var fsa = FSAProvider.get
		fsa.outputDirectory = "./gen"
		fsa.project = resource.project
		
		var fsa2 = FSAProvider.get
		fsa2.project = resource.project
		fsa2.generateFolder("results")
		
		var generator = new VagrantfileGenerator

		generator.doGenerate(resource, fsa)
	}
}

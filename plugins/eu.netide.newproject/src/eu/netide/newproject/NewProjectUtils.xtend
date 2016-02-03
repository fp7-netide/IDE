package eu.netide.newproject

import Topology.TopologyFactory
import Topology.TopologyPackage
import java.io.IOException
import org.eclipse.core.runtime.IPath
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

class NewProjectUtils {
	
	static def newTopologyModelFile(IPath path, String name) {
		
		TopologyPackage.eINSTANCE.eClass
		
		var factory = TopologyFactory.eINSTANCE
		
		var environment = factory.createNetworkEnvironment
		
		environment.name = name
		
		var resSet = new ResourceSetImpl
		
		var uri = URI.createURI(String.format("%s/%s.topology", path.toString, name))
				
		var resource  = resSet.createResource(uri)
		
		resource.contents.add(environment)
		
		try {
			resource.save(newHashMap())
		} catch (IOException e) {
			e.printStackTrace
		}
		
		return environment
		
		
	}
	
}
package eu.netide.configuration.generator

import Topology.Connector
import Topology.Host
import Topology.NetworkEnvironment
import Topology.Switch
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import Topology.NetworkElement

class ConfigurationGenerator implements IGenerator{
	
	override def doGenerate(Resource input, IFileSystemAccess fsa) {
		var ne = input.allContents.filter(typeof(NetworkEnvironment)).next
		fsa.generateFile("mininet/"+ne.envName+".py", ne.compile)
	}
	
	def compile (NetworkEnvironment ne) {
		
		var scounter = 0
		var hcounter = 0
		
		return '''
		from mininet.topo import Topo
		
		class «ne.envName» (Topo):
		    
		    def __init__( self ):
		    
		        Topo.__init__(self)
		    
		        # Adding Switches
		        «FOR Switch s : ne.networks.map[networkelements].flatten.filter(typeof(Switch))»
		        «s.fullname» = self.addSwitch('s«scounter++»')
		        «ENDFOR»
		        
		        # Adding Hosts
		        «FOR Host h : ne.networks.map[networkelements].flatten.filter(typeof(Host))»
		        «h.fullname» = self.addHost('h«hcounter++»')
		        «ENDFOR»
		        
		        # Adding Links
		        «FOR Connector c : ne.networks.map[connectors].flatten.filter(typeof(Connector))»
		        self.addLink(«c.connectedports.get(0).networkelement.fullname», «c.connectedports.get(1).networkelement.fullname»)
		        «ENDFOR»
		        
		topos = { '«ne.envName»': ( lambda: «ne.envName»() ) }
	'''
	}
	
	
	def fullname(NetworkElement n) {
		if (!(n.topology.name == null || n.topology.name.equals("")))
			n.topology.name + "_" + n.name
		else
			n.name
	}
	
	def envName(NetworkEnvironment n) {
		if (!(n.name == null || n.name.equals("")))
			n.name
		else
			"NetworkEnvironment"
	}
	
}
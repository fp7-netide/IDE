package eu.netide.configuration.generator

import Topology.Connector
import Topology.Host
import Topology.NetworkEnvironment
import Topology.Switch
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import Topology.NetworkElement
import Topology.Controller

class ConfigurationGenerator implements IGenerator {
	
	var nodemap = newHashMap()

	override def doGenerate(Resource input, IFileSystemAccess fsa) {
		var ne = input.allContents.filter(typeof(NetworkEnvironment)).next
		
		populateNodeMap(ne)
		
		fsa.generateFile("mininet/" + ne.envName + ".py", ne.compileTopo)
		fsa.generateFile("mininet/" + ne.envName + "_run.py", ne.compileRunscript)
	}
	
	def populateNodeMap(NetworkEnvironment ne) {
		var scounter = 1
		for (s : ne.networks.map[networkelements].flatten.filter(typeof(Switch))) nodemap.put(s.fullname, scounter++)
		
		var hcounter = 1
		for (h : ne.networks.map[networkelements].flatten.filter(typeof(Host))) nodemap.put(h.fullname, hcounter++)
		
		var ccounter = 1
		for (c : ne.controllers) nodemap.put(c.name, ccounter++)
		
		
	}

	def compileTopo(NetworkEnvironment ne) {


		return '''
			from mininet.topo import Topo
			from mininet.node import Controller, RemoteController
			
			class «ne.envName» (Topo):
			    
			    def __init__( self ):
			    
			        Topo.__init__(self)
			    
			        # Adding Switches
			        «FOR Switch s : ne.networks.map[networkelements].flatten.filter(typeof(Switch))»
			        	self.«s.fullname» = self.addSwitch('s«nodemap.get(s.fullname)»')
			        «ENDFOR»
			        
			        # Adding Hosts
			        «FOR Host h : ne.networks.map[networkelements].flatten.filter(typeof(Host))»
			        	self.«h.fullname» = self.addHost('h«nodemap.get(h.fullname)»')
			        «ENDFOR»
			        
			        # Adding Links
			        «FOR Connector c : ne.networks.map[connectors].flatten.filter(typeof(Connector))»
			        	self.addLink(self.«c.connectedports.get(0).networkelement.fullname», self.«c.connectedports.get(1).networkelement.
				fullname»)
			        «ENDFOR»
			        
			        
			topos = { '«ne.envName»': ( lambda: «ne.envName»() ) }
		'''
	}

	def CharSequence compileRunscript(NetworkEnvironment ne) {
				
		return '''
        from mininet.net import Mininet
        from mininet.node import Controller, OVSSwitch, RemoteController
        from mininet.cli import CLI
        from mininet.log import setLogLevel
        from «ne.envName» import «ne.envName»
        
                
        def setup_and_run_«ne.envName» ():
        
            topo = «ne.envName»()
            net = Mininet(topo=topo, build=False)
            
            «FOR Controller c : ne.controllers»
            «c.name» = net.addController('c«nodemap.get(c.name)»', controller=RemoteController, ip='«c.ip»', port=«c.portNo»)
            «ENDFOR»
            net.build()
            
            «FOR Controller c : ne.controllers»
            # Starting Controller «c.name»
            «c.name».start()
            
            «FOR Switch s : c.switches»
            net.get('s«nodemap.get(s.fullname)»').start([«c.name»])
            «ENDFOR»
            «ENDFOR»
            
            CLI(net)
            
            net.stop()
            
        if __name__ == '__main__':
            setLogLevel( 'info' ) # for CLI output
            setup_and_run_«ne.envName»()
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

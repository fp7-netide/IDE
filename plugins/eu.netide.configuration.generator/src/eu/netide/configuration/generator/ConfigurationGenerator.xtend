package eu.netide.configuration.generator

import Topology.Connector
import Topology.Controller
import Topology.Host
import Topology.NetworkElement
import Topology.NetworkEnvironment
import Topology.Switch
import eu.netide.configuration.utils.fsa.FileSystemAccess
import org.eclipse.emf.ecore.resource.Resource

/**
 * Generates a Mininet configuration based on the specified topology model
 * 
 * @author Christian Stritzke
 */
class ConfigurationGenerator  {

	var nodemap = newHashMap()

	def doGenerate(Resource input, FileSystemAccess fsa) {
		var ne = input.allContents.filter(typeof(NetworkEnvironment)).next

		populateNodeMap(ne)

		fsa.generateFile("mininet/" + ne.envName + ".py", ne.compileTopo)
		fsa.generateFile("mininet/" + ne.envName + "_run.py", ne.compileRunscript)
	}

	def populateNodeMap(NetworkEnvironment ne) {
		var scounter = 1
		var switches = ne.networks.map[networkelements].flatten.filter(typeof(Switch))
		var all_sdpid = switches.map[dpid]
		for (s : switches) {
			if (Integer.decode(s.dpid) > 0) {
				nodemap.put(s.fullname, s.dpid)
			} else {
				while (all_sdpid.toSet.contains(scounter))
					scounter++
				nodemap.put(s.fullname, scounter++)
			}

		}

		var hcounter = 1
		var hosts = ne.networks.map[networkelements].flatten.filter(typeof(Host))
		var all_hdpid = switches.map[dpid]
		for (h : hosts) {
			if (Integer.decode(h.dpid) > 0) {
				nodemap.put(h.fullname, h.dpid)
			} else {
				while (all_hdpid.toSet.contains(hcounter))
					hcounter++
				nodemap.put(h.fullname, hcounter++)
			}

		}

		var ccounter = 1
		for (c : ne.controllers)
			nodemap.put(c.name, ccounter++)

	}

	def compileTopo(NetworkEnvironment ne) {

		var switches = ne.networks.map[networkelements].flatten.filter(typeof(Switch))
		var hosts = ne.networks.map[networkelements].flatten.filter(typeof(Host))
		var connectors = ne.networks.map[connectors].flatten.filter(typeof(Connector))
		var hasIPs = switches.exists[x|x.ip != null && x.ip != ""] || hosts.exists[x|x.ip != null && x.ip != ""]

		return '''
			from mininet.topo import Topo
			from mininet.node import Controller, RemoteController
			
			
			def int2dpid( dpid ):
			   try:
			      dpid = hex( dpid )[ 2: ]
			      dpid = '0' * ( 16 - len( dpid ) ) + dpid
			      return dpid
			   except IndexError:
			      raise Exception( 'Unable to derive default datapath ID - '
			                       'please either specify a dpid or use a '
			               'canonical switch name such as s23.' )
			
			class «ne.envName» (Topo):
			    
			    def __init__( self ):
			    
			        Topo.__init__(self)
			    
			        # Adding Switches
			        «FOR Switch s : switches»
			        	self.«s.fullname» = self.addSwitch('«s.fullname»', dpid=int2dpid(«nodemap.get(s.fullname)»))
			        «ENDFOR»
			        
			        # Adding Hosts
			        «FOR Host h : hosts»
			        	self.«h.fullname» = self.addHost('«h.fullname»')
			        «ENDFOR»
			        
			        # Adding Links
			        «FOR Connector c : connectors»
			        	self.addLink(self.«c.connectedports.get(0).networkelement.fullname», self.«c.connectedports.get(1).networkelement.fullname»)
			        «ENDFOR»
			        
			    «IF hasIPs»
			    def SetIPConfiguration(self, net):
			        «FOR s : switches»
			        «IF s.ip != null && s.ip != ""»
			            net.get("«s.fullname»").setIP("«s.ip»"«IF s.prefix > 0», "«s.prefix»"«ENDIF»)
			        «ENDIF»
			        «ENDFOR»
			        «FOR h : hosts»
			        «IF h.ip != null && h.ip != ""»
			            net.get("«h.fullname»").setIP("«h.ip»"«IF h.prefix > 0», "«h.prefix»"«ENDIF»)
			        «ENDIF»
			        «ENDFOR»
			        «ENDIF»
			    
			topos = { '«ne.envName»': ( lambda: «ne.envName»() ) }
		'''
	}

	def compileRunscript(NetworkEnvironment ne) {

		var switches = ne.networks.map[networkelements].flatten.filter(typeof(Switch))
		var hosts = ne.networks.map[networkelements].flatten.filter(typeof(Host))
		var hasIPs = switches.exists[x|x.ip != null && x.ip != ""] || hosts.exists[x|x.ip != null && x.ip != ""]

		return '''
			from mininet.net import Mininet
			from mininet.node import Controller, OVSSwitch, RemoteController
			from mininet.cli import CLI
			from mininet.log import setLogLevel
			from «ne.envName» import «ne.envName»
			
			
			def setup_and_run_«ne.envName» ():
			    controllers = []
			    «FOR Controller c : ne.controllers»
			    	«c.name» = RemoteController( '«c.name»', ip='«c.ip»', port=«c.portNo» )
			    	controllers.append(«c.name»)
			    «ENDFOR»
			    
			    cmap = {
			    «FOR Switch s : switches»
			    	«IF s.controller != null»
			    		'«s.fullname»' : «s.controller.name»,
			    	«ENDIF»
			    «ENDFOR»
			    }
			    
			    class MultiSwitch( OVSSwitch ):
			        "Custom Switch() subclass that connects to different controllers"
			        def start( self, controllers ):
			            return OVSSwitch.start( self, [ cmap[ self.name ] ] )
			    
			    topo = «ne.envName»()
			    net = Mininet(topo=topo, switch=MultiSwitch, build=False)
			    for c in controllers:
			        net.addController(c)
			    net.build()
			    «IF hasIPs»
			    topo.SetIPConfiguration(net)
			    «ENDIF»
			    net.start()
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
			n.name.replaceAll("[-/()]", "_")
		else
			"NetworkEnvironment"
	}

}

package eu.netide.configuration.generator.vagrantfile

import Topology.NetworkElement
import Topology.NetworkEnvironment
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Platform
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import eu.netide.configuration.utils.NetIDEUtil
import Topology.Controller
import java.net.URL
import eu.netide.configuration.preferences.NetIDEPreferenceConstants
import eu.netide.configuration.generator.fsa.FileSystemAccess

/**
 * Generates and writes a Vagrantfile depending on required controller platforms and network applications.
 * 
 * @author Christian Stritzke
 */
class VagrantfileGenerator {

	private ILaunchConfiguration configuration

	def doGenerate(IResource resource, Resource input, ILaunchConfiguration configuration, FileSystemAccess fsa) {
		this.configuration = configuration
		fsa.generateFile(NetIDE.VAGRANTFILE_PATH + "Vagrantfile", input.compile(resource))
	}

	def compile(Resource input, IResource res) {

		var ne = input.allContents.filter(typeof(NetworkEnvironment)).next
		
		
		var projectName = res.fullPath.segment(0)
		
		var bundle = Platform.getBundle(NetIDE.LAUNCHER_PLUGIN)
		var url = bundle.getEntry("scripts/install_mininet.sh")
		var mininetscriptpath = scriptpath(url)

		url = bundle.getEntry("scripts/install_ryu.sh")
		var ryuscriptpath = scriptpath(url)

		url = bundle.getEntry("scripts/install_pyretic.sh")
		var pyreticscriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_pox.sh")
		var poxscriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_odl.sh")
		var odlscriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_engine.sh")
		var netideenginescriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_logger.sh")
		var loggerscriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_floodlight.sh")
		var floodlightscriptpath = scriptpath(url)

		var controllerPlatformKeys = input.allContents.filter(typeof(Controller)).map[c|
			String.format("controller_platform_%s", c.name)]
			
		var requiredPlatforms = controllerPlatformKeys.map[k|configuration.attributes.get(k) as String].toList
			
		var crosscontrollers = ne.controllers.filter[configuration.attributes.get("controller_platform_" + name) == NetIDE.CONTROLLER_ENGINE]
		
		var clientPlatforms = crosscontrollers.map[c | configuration.attributes.get("controller_platform_source_" + c.name) as String].toList
		
		var serverPlatforms = crosscontrollers.map[c | configuration.attributes.get("controller_platform_target_" + c.name) as String].toList
		
		requiredPlatforms.addAll(clientPlatforms)
		requiredPlatforms.addAll(serverPlatforms)

		var appPaths = ne.controllers.map [
			var platform = configuration.attributes.get("controller_platform_" + name)
			configuration.attributes.get(String.format("controller_data_%s_%s", name, platform)) as String
		].toSet.map[e|NetIDEUtil.absolutePath(e)]
		
		var proxyOn = Platform.getPreferencesService.getBoolean(NetIDEPreferenceConstants.ID, NetIDEPreferenceConstants.PROXY_ON, false, null)
		var proxyAddress = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID, NetIDEPreferenceConstants.PROXY_ADDRESS, "", null)

		var customBox = Platform.getPreferencesService.getBoolean(NetIDEPreferenceConstants.ID, NetIDEPreferenceConstants.CUSTOM_BOX, false, null)
		var customBoxName = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID, NetIDEPreferenceConstants.CUSTOM_BOX_NAME, "", null)

		return '''
			# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
			VAGRANTFILE_API_VERSION = "2"
			
			$path = "«mininetscriptpath»"
			
			«IF proxyOn»
			$proxysetup = <<SCRIPT
				echo "export all_proxy=socks://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export all_proxy=socks://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export all_proxy=socks://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh
				

				echo "export ALL_PROXY=socks://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export ALL_PROXY=socks://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export ALL_PROXY=socks://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh
				

				echo "export http_proxy=http://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export http_proxy=http://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export http_proxy=http://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh

				echo "export HTTP_PROXY=http://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export HTTP_PROXY=http://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export HTTP_PROXY=http://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh

				echo "export ftp_proxy=http://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export ftp_proxy=http://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export ftp_proxy=http://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh

				echo "export FTP_PROXY=http://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export FTP_PROXY=http://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export FTP_PROXY=http://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh

				echo "export https_proxy=http://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export https_proxy=http://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export https_proxy=http://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh

				echo "export HTTPS_PROXY=http://«proxyAddress»" | sudo tee -a /etc/profile
				echo "export HTTPS_PROXY=http://«proxyAddress»" | sudo tee -a /etc/environment
				echo "export HTTPS_PROXY=http://«proxyAddress»" | sudo tee -a /etc/profile.d/vagrant.sh
				
				echo 'Acquire::http::Proxy "http://«proxyAddress»";' | sudo tee -a /etc/apt/apt.conf.d/71proxy
				echo 'Acquire::ftp::Proxy "http://«proxyAddress»";' | sudo tee -a /etc/apt/apt.conf.d/71proxy
				
			SCRIPT
			«ENDIF»
			
			Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
			
				# We use a relatively new Ubuntu box
				«IF !customBox»
				config.vm.box = "ubuntu/trusty64"
				config.vm.provider "virtualbox" do |v|
			v.memory = 4096
				end
				«ELSE»
				config.vm.box = "«customBoxName»"
				«ENDIF»
				
				config.vm.provider "virtualbox" do |v|
				  v.name = "«projectName»"
				end
				
				«IF !customBox»
				# Configuring mininet
				«IF proxyOn»
				config.vm.provision "shell", inline: $proxysetup, privileged: false
				«ENDIF»
				config.vm.provision "shell", path: "«mininetscriptpath»", privileged: false
				config.vm.provision "shell", path: "«loggerscriptpath»", privileged: false
				«IF requiredPlatforms.contains("Ryu")»
					config.vm.provision "shell", path: "«ryuscriptpath»", privileged: false
				«ENDIF»
				«IF requiredPlatforms.contains("Pyretic")»
					config.vm.provision "shell", path: "«poxscriptpath»", privileged: false
					config.vm.provision "shell", path: "«pyreticscriptpath»", privileged: false
				«ENDIF»
				«IF requiredPlatforms.contains("POX")»
					config.vm.provision "shell", path: "«poxscriptpath»", privileged: false
				«ENDIF»
				«IF requiredPlatforms.contains("OpenDaylight")»
					config.vm.provision "shell", path: "«odlscriptpath»", privileged: false
				«ENDIF»
				«IF requiredPlatforms.contains("Floodlight")»
					config.vm.provision "shell", path: "«floodlightscriptpath»", privileged: false
				«ENDIF»
				«IF requiredPlatforms.contains(NetIDE.CONTROLLER_ENGINE)»
					config.vm.provision "shell", path: "«netideenginescriptpath»", privileged: false
					config.vm.provision "shell", path: "«ryuscriptpath»", privileged: false
					config.vm.provision "shell", path: "«pyreticscriptpath»", privileged: false
					config.vm.provision "shell", path: "«poxscriptpath»", privileged: false
					config.vm.provision "shell", path: "«odlscriptpath»", privileged: false
					config.vm.provision "shell", path: "«floodlightscriptpath»", privileged: false
				«ENDIF»
				«ENDIF»
				
				# Syncing the mininet configuration folder with the vm
				config.vm.synced_folder "«res.project.location»/gen/mininet", "/home/vagrant/mn-configs"
				
				# Syncing controller paths with the vm
				«FOR p : appPaths»
					config.vm.synced_folder "«p.removeLastSegments(1)»", "/home/vagrant/controllers/«p.removeFileExtension.lastSegment»"
				«ENDFOR»
				
			end
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
	
	def scriptpath(URL url) {
	
		if (Platform.getOS == Platform.OS_LINUX || Platform.getOS == Platform.OS_MACOSX)
			FileLocator.resolve(url).path
		else if (Platform.getOS == Platform.OS_WIN32)
			FileLocator.resolve(url).path.substring(1)
		
	}

}

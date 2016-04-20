package eu.netide.configuration.generator.vagrantfile

import Topology.NetworkElement
import Topology.NetworkEnvironment
import eu.netide.configuration.preferences.NetIDEPreferenceConstants
import eu.netide.configuration.utils.NetIDE
import eu.netide.configuration.utils.fsa.FileSystemAccess
import java.net.URL
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform

/**
 * Generates and writes a Vagrantfile depending on required controller platforms and network applications.
 * 
 * @author Christian Stritzke
 */
class VagrantfileGenerator {

	//private ILaunchConfiguration configuration

	def doGenerate(IResource resource, FileSystemAccess fsa) {
		var proxyOn = Platform.getPreferencesService.getBoolean(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.PROXY_ON, false, null)
		if (proxyOn)
			fsa.generateFile(NetIDE.VAGRANTFILE_PATH + "proxyconf.sh", proxySetupScript)
		fsa.generateFile(NetIDE.VAGRANTFILE_PATH + "Vagrantfile", compile(resource))
	}

	def compile(IResource res) {

		var projectName = res.fullPath.segment(0)
		
		

		var bundle = Platform.getBundle(NetIDE.LAUNCHER_PLUGIN)
		
		var url = bundle.getEntry("scripts/install_prereq.sh")
		var prereqpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_mininet.sh")
		var mininetscriptpath = scriptpath(url)

		url = bundle.getEntry("scripts/install_ryu.sh")
		var ryuscriptpath = scriptpath(url)

		url = bundle.getEntry("scripts/install_engine.sh")
		var netideenginescriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_core.sh")
		var corescriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_odl.sh")
		var odlscriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_floodlight.sh")
		var flscriptpath = scriptpath(url)
		
		url = bundle.getEntry("scripts/install_tools.sh")
		var toolscriptpath = scriptpath(url)

                url = bundle.getEntry("scripts/install_onos.sh")
                var onosscriptpath = scriptpath(url)

//		var controllerPlatformKeys = input.allContents.filter(typeof(Controller)).map [ c |
//			String.format("controller_platform_%s", c.name)
//		]

		var proxyOn = Platform.getPreferencesService.getBoolean(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.PROXY_ON, false, null)
			
		var customBox = Platform.getPreferencesService.getBoolean(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.CUSTOM_BOX, false, null)
		var customBoxName = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.CUSTOM_BOX_NAME, "", null)

		return '''
			# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
			VAGRANTFILE_API_VERSION = "2"
			
			Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
			
				config.vm.network "forwarded_port", guest: 5557, host: 5557
			
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
					# Installing prerequistes
					config.vm.provision "shell", path: "«prereqpath»", privileged: false
					# Configuring mininet
					«IF proxyOn»
						config.vm.provision "shell", path: "proxyconf.sh", privileged: false
					«ENDIF»
					config.vm.provision "shell", path: "«mininetscriptpath»", privileged: false
					config.vm.provision "shell", path: "«netideenginescriptpath»", privileged: false
					config.vm.provision "shell", path: "«ryuscriptpath»", privileged: false
					config.vm.provision "shell", path: "«corescriptpath»", privileged: false
					config.vm.provision "shell", path: "«odlscriptpath»", privileged: false
					config.vm.provision "shell", path: "«flscriptpath»", privileged: false
					config.vm.provision "shell", path: "«toolscriptpath»", privileged: false
                                        config.vm.provision "shell", path: "«onosscriptpath»", privileged: false
				«ENDIF»
				
				# Syncing the mininet configuration folder with the vm
				config.vm.synced_folder "«res.project.location»/gen/mininet", "/home/vagrant/netide/mn-configs", create:true
			
				# Syncing the debugger results folder with the vm
				config.vm.synced_folder "«res.project.location»/results", "/home/vagrant/netide/debug_results", create: true
				
				# Syncing the composition folder with the vm
				config.vm.synced_folder "«res.project.location»/composition", "/home/vagrant/netide/composition", create: true
				
				# Syncing controller paths with the vm
				config.vm.synced_folder "«res.project.location»/apps", "/home/vagrant/netide/apps", create:true

				
			end
		'''
	}

	def proxySetupScript() {
		var proxyAddress = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.PROXY_ADDRESS, "", null)

		return '''
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
			
			mkdir -p $HOME/.m2
			cat > $HOME/.m2/settings.xml << EOL
				«mavenProxyConfig»
			EOL
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

	def mavenProxyConfig() {
		var proxyon = Platform.getPreferencesService.getBoolean(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.PROXY_ADDRESS, false, null)
		var proxy = Platform.preferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.PROXY_ADDRESS, "", null).split(":", 2)
		var proxyHost = proxy.get(0)
		var proxyPort = proxy.get(1)

		return '''
			<settings>
			  <proxies>
			   <proxy>
			      <id>box-proxy</id>
			      <active>true</active>
			      <protocol>http</protocol>
			      <host>«proxyHost»</host>
			      <port>«proxyPort»</port>
			      <nonProxyHosts>localhost</nonProxyHosts>
			    </proxy>
			    <proxy>
			      <id>box-proxy-tls</id>
			      <active>true</active>
			      <protocol>https</protocol>
			      <host>«proxyHost»</host>
			      <port>«proxyPort»</port>
			      <nonProxyHosts>localhost</nonProxyHosts>
			    </proxy>
			  </proxies>
			</settings>
		'''

	}

}

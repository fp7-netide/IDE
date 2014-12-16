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

class VagrantfileGenerator {

	private ILaunchConfiguration configuration

	def doGenerate(IResource resource, Resource input, ILaunchConfiguration configuration, IFileSystemAccess fsa) {
		this.configuration = configuration
		fsa.generateFile(NetIDE.VAGRANTFILE_PATH + "Vagrantfile", input.compile(resource))
	}

	def compile(Resource input, IResource res) {

		var bundle = Platform.getBundle(NetIDE.LAUNCHER_PLUGIN)
		var url = bundle.getEntry("scripts/install_mininet.sh")
		var mininetscriptpath = FileLocator.resolve(url).path

		url = bundle.getEntry("scripts/install_ryu.sh")
		var ryuscriptpath = FileLocator.resolve(url).path

		var controllerPlatformKeys = configuration.attributes.keySet.filter[startsWith("controller_platform_")]
		var requiredPlatforms = controllerPlatformKeys.map[k|configuration.attributes.get(k) as String].toList

		var ne = input.allContents.filter(typeof(NetworkEnvironment)).next

		var appPaths = ne.controllers.map[
			var platform = configuration.attributes.get("controller_platform_" + name)
			configuration.attributes.get(String.format("controller_data_%s_%s", name, platform)) as String
			].toSet.map[e|NetIDEUtil.absolutePath(e)]

		return '''
			# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
			VAGRANTFILE_API_VERSION = "2"
			
			$path = "«mininetscriptpath»"
			
			Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
			
				# We use a relatively new Ubuntu box
				config.vm.box = "ubuntu/trusty64"
				
				# Configuring mininet
				config.vm.provision "shell", path: "«mininetscriptpath»", privileged: false
				
				«IF requiredPlatforms.contains("Ryu")»
					config.vm.provision "shell", path: "«ryuscriptpath»", privileged: false
				«ENDIF»
				
				# Syncing the mininet configuration folder with the vm
				config.vm.synced_folder "«res.project.location»/gen/mininet", "/home/vagrant/mn-configs"
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

}

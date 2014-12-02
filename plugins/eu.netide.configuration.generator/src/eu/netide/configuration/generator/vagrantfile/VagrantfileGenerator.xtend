package eu.netide.configuration.generator.vagrantfile

import Topology.NetworkElement
import Topology.NetworkEnvironment
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import eu.netide.configuration.utils.NetIDE
import org.eclipse.core.resources.IResource

class VagrantfileGenerator {
	
	def doGenerate(IResource resource, Resource input, IFileSystemAccess fsa) {
		fsa.generateFile(NetIDE.VAGRANTFILE_PATH + "Vagrantfile", resource.compile)
	}
	
	def compile (IResource res) {
		
		return '''
		$script = <<SCRIPT
		  cd
		  sudo apt-get update -y
		  sudo apt-get install git -y
		  git clone git://github.com/mininet/mininet
		  mininet/util/install.sh -a
		SCRIPT

		# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
		VAGRANTFILE_API_VERSION = "2"
		
		Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
		
			# We use a relatively new Ubuntu box
			config.vm.box = "ubuntu/trusty64"
			
			# Configuring mininet
			config.vm.provision "shell", inline: $script, privileged: false
			
			# Syncing the mininet configuration folder with the vm
			config.vm.synced_folder "«res.project.location»/gen/mininet", "/home/vagrant/mn-configs"
			
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
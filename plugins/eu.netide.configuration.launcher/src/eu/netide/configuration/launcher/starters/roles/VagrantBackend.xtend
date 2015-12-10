package eu.netide.configuration.launcher.starters.roles

import org.eclipse.core.runtime.Platform
import eu.netide.configuration.preferences.NetIDEPreferenceConstants

class VagrantBackend extends Backend {
	
	private String vagrantpath
	
	new() {
		this.vagrantpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.VAGRANT_PATH, "", null)
	}
	
	override cmdprefix() {
		return vagrantpath
	}
	
	override args() {
		return "ssh -c"
	}
	
}
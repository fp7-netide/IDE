package eu.netide.configuration.launcher.starters.backends

import static extension eu.netide.configuration.utils.NetIDEUtil.absolutePath
import org.eclipse.core.runtime.Platform
import eu.netide.configuration.preferences.NetIDEPreferenceConstants
import org.eclipse.xtend.lib.annotations.Accessors

class SshBackend extends Backend {
	
	@Accessors(PUBLIC_GETTER)
	private String hostname
	@Accessors(PUBLIC_GETTER)
	private int port
	@Accessors(PUBLIC_GETTER)
	private String idFile
	@Accessors(PUBLIC_GETTER)
	private String username
	@Accessors(PUBLIC_GETTER)
	private String sshpath
	
	
	new(String hostname, int port, String username, String idFile) {
		this.hostname = hostname
		this.port = port
		this.username = username
		this.idFile = idFile.absolutePath.toOSString
		this.sshpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.SSH_PATH, "", null)
	}
	
	override cmdprefix() {
		return sshpath
	}
	
	override args() {
		return String.format("-p %s -t -i %s %s@%s", port, idFile, username, hostname)
	}
}
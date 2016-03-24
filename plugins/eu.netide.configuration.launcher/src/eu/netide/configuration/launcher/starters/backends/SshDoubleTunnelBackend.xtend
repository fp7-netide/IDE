package eu.netide.configuration.launcher.starters.backends

import org.eclipse.core.runtime.Platform
import static extension eu.netide.configuration.utils.NetIDEUtil.absolutePath
import eu.netide.configuration.preferences.NetIDEPreferenceConstants

class SshDoubleTunnelBackend extends Backend {
	private String hostname1
	private int port1
	private String hostname2
	private int port2
	private String idFile
	private String username1
	private String username2
	private String sshpath

	new(String hostname1, int port1, String hostname2, int port2, String username1, String username2, String idFile) {
		this.hostname1 = hostname1
		this.port1 = port1
		this.hostname2 = hostname2
		this.port2 = port2
		this.username1 = username1
		this.username2 = username2
		this.idFile = idFile.absolutePath.toOSString
		this.sshpath = Platform.getPreferencesService.getString(NetIDEPreferenceConstants.ID,
			NetIDEPreferenceConstants.SSH_PATH, "", null)
	}

	override cmdprefix() {
		return sshpath
	}

	override args() {
		return String.format("-p %s -t -i %s %s@%s ssh -p %s -t %s@%s", port1, idFile, username1, hostname1, port2,
			username2, hostname2)
	}
}

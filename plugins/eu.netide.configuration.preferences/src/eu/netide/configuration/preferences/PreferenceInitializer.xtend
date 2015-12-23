package eu.netide.configuration.preferences;

import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer
import org.eclipse.core.runtime.Platform

/**
 * Class used to initialize default preference values.
 * 
 * @author Christian Stritzke
 */
public class PreferenceInitializer extends AbstractPreferenceInitializer {

	/*
	 * (non-Javadoc)
	 * 
	 * @see AbstractPreferenceInitializer#initializeDefaultPreferences()
	 */
	override initializeDefaultPreferences() {
		var store = Activator.getDefault().getPreferenceStore()
		store.setDefault(
			NetIDEPreferenceConstants.VAGRANT_PATH,
			switch Platform.getOS {
				case Platform.OS_LINUX: "/usr/bin/vagrant"
				case Platform.OS_WIN32: "C:\\Hashicorp\\Vagrant\\bin\\vagrant.exe"
			}
		)
		store.setDefault(
			NetIDEPreferenceConstants.SSH_PATH,
			switch Platform.getOS {
				case Platform.OS_LINUX: "/usr/bin/ssh"
				case Platform.OS_MACOSX: "/usr/bin/ssh"
			}
		)
		store.setDefault(
			NetIDEPreferenceConstants.SCP_PATH,
			switch Platform.getOS {
				case Platform.OS_LINUX: "/usr/bin/scp"
				case Platform.OS_MACOSX: "/usr/bin/scp"
			}
		)
	}
}

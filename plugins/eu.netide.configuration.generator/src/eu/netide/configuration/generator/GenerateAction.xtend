package eu.netide.configuration.generator

import Topology.NetworkEnvironment
import com.google.inject.Inject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.builder.EclipseResourceFileSystemAccess2
import com.google.inject.Provider
import org.eclipse.core.runtime.NullProgressMonitor
import java.util.Map
import org.eclipse.xtext.generator.OutputConfiguration
import java.util.HashMap

class GenerateAction {

	@Inject
	private Provider<EclipseResourceFileSystemAccess2> fsaprovider

	def run(NetworkEnvironment ne) {
		var file = getIFile(ne.eResource)
		var cg = new ConfigurationGenerator();
		var fsa = fsaprovider.get
		fsa.monitor = new NullProgressMonitor
		fsa.outputConfigurations = defaultConfig
		fsa.project = file.project
		cg.doGenerate(ne.eResource, fsa)
	}

	def getIFile(Resource res) {

		var eUri = res.getURI();
		if (eUri.isPlatformResource()) {
			var platformString = eUri.toPlatformString(true);
			return ResourcesPlugin.getWorkspace().getRoot().findMember(platformString);
		}
		return null;
	}

	def Map<String, OutputConfiguration> defaultConfig() {

		val OutputConfiguration defaultOutput = new OutputConfiguration("DEFAULT_OUTPUT")
		defaultOutput.setDescription("Output Folder")

		//defaultOutput.setOutputDirectory("./src")
		defaultOutput.setOutputDirectory("./gen")
		defaultOutput.setOverrideExistingResources(true)
		defaultOutput.setCreateOutputDirectory(true)
		defaultOutput.setCleanUpDerivedResources(true)
		defaultOutput.setSetDerivedProperty(true)

		val Map<String, OutputConfiguration> map = new HashMap<String, OutputConfiguration>()
		map.put("DEFAULT_OUTPUT", defaultOutput)
		map
	}

}

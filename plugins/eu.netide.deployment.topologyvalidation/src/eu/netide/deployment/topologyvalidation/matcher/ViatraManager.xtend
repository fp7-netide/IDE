package eu.netide.deployment.topologyvalidation.matcher

import java.util.Collection
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl
import org.eclipse.viatra.query.runtime.api.IPatternMatch
import org.eclipse.xtend.lib.annotations.Accessors
import eu.netide.deployment.topologyvalidation.restrictiontopology.ARootTopoModule

class ViatraManager {
	public static final String IMPORTED_MODEL_PATH = "model/UC2.topology"
	public static final String GENERATED_PATTERN_PATH = "queries/TopoQuery.vql"
	public static final String PATTERN_FQN = "matchTopology"

	private Collection<? extends IPatternMatch> matchSet = null
	@Accessors private URI importedModelUri = null
	@Accessors private URI generatedPatternUri = null
	@Accessors private String patternFQN = null

	new() {
		importedModelUri = URI.createFileURI(IMPORTED_MODEL_PATH)
		generatedPatternUri = URI.createFileURI(GENERATED_PATTERN_PATH)
		patternFQN = PATTERN_FQN
	}

	def getMatchSet() {
		if (this.matchSet === null) {
			process()
		}
		return this.matchSet
	}

	def setImportedModelUri(String uri) {
		importedModelUri= URI.createFileURI(uri)
	}

	def setGeneratedPatternUri(String uri) {
		generatedPatternUri= URI.createFileURI(uri)
	}

	def private void process() {
		var ViatraQueryHeadlessAdvanced viatra = new ViatraQueryHeadlessAdvanced()

		// Initializing topology metamodel
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl())
		this.matchSet = viatra.calculateMatchSet(importedModelUri, generatedPatternUri, patternFQN)
		// System.out.println(hla.executeDemo_GenericAPI_LoadFromVQL(importedModelURI, vPatternURI, PATTERN_FQN));
	}

	def prettyPrintMatches() {
		val sb = new StringBuilder
		prettyPrintMatches(sb, getMatchSet)
		return sb.toString
	}

//	def prettyPrintMatch(IPatternMatch match) {
//		val sb = new StringBuilder
//		prettyPrintMatches(sb, getMatchSet)
//		return sb.toString
//	}

	def private static prettyPrintMatches(StringBuilder results, Collection<? extends IPatternMatch> matches) {
		for (match : matches) {
			results.append(match.prettyPrint()+";\n");
		}
		if(matches.size() == 0) {
			results.append("Empty match set");
		}
		results.append("\n");
	}

	def returnSearcher () {
		val a = new ViatraSearcher<ARootTopoModule>(ARootTopoModule)[ map |
			return null
		]
		a.hashCode
	}
}

package eu.netide.deployment.topologyvalidation.matcher

import java.util.Collection
import java.util.HashMap
import org.eclipse.viatra.query.runtime.api.IPatternMatch

class MatchResult {
	public Collection<? extends IPatternMatch> matches
	public HashMap<String, Object> parameterMap

	new(Collection<? extends IPatternMatch> m, HashMap<String, Object> p) {
		matches = m
		parameterMap = p
	}
}
package eu.netide.deployment.topologyvalidation.restrictiontopology

import org.eclipse.xtend.lib.annotations.Accessors

/**
 * For simplicity this class handles one xbase string.
 * Further logic is suggested.
 */
class Restriction {

	@Accessors private String rule

	new(String r){
		rule=r
	}

	def render() {
		rule
	}

}

/*
 * generated by Xtext 2.10.0
 */
package eu.netide.deployment.topologyvalidation

/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class FlexTopoStandaloneSetup extends FlexTopoStandaloneSetupGenerated {

	def static void doSetup() {
		new FlexTopoStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}

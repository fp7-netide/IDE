/*
 * generated by Xtext 2.9.1
 */
package eu.netide.composition.language


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class CompositionStandaloneSetup extends CompositionStandaloneSetupGenerated {

	def static void doSetup() {
		new CompositionStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}

/*
* generated by Xtext
*/
package eu.netide.parameters.language;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class NetIDEParametersStandaloneSetup extends NetIDEParametersStandaloneSetupGenerated{

	public static void doSetup() {
		new NetIDEParametersStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

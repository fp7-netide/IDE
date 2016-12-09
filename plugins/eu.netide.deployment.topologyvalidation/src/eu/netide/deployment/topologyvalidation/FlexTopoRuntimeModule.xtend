
package eu.netide.deployment.topologyvalidation

import eu.netide.deployment.topologyvalidation.jvmmodel.FlexTopoXExpressionHelper
import eu.netide.deployment.topologyvalidation.jvmmodel.FlexTopoXbaseCompiler
import eu.netide.deployment.topologyvalidation.typesystem.FlexTopoTypeComputer
import org.eclipse.xtext.xbase.compiler.XbaseCompiler
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputer
import org.eclipse.xtext.xbase.util.XExpressionHelper

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class FlexTopoRuntimeModule extends AbstractFlexTopoRuntimeModule {

	def Class<? extends XbaseCompiler> bindXbaseCompiler() {
		FlexTopoXbaseCompiler
	}

	def Class<? extends ITypeComputer> bindITypeComputer() {
		FlexTopoTypeComputer
	}

    def Class<? extends XExpressionHelper> bindXExpressionHelper() {
        FlexTopoXExpressionHelper
    }
}

package eu.netide.deployment.topologyvalidation.jvmmodel

import eu.netide.deployment.topologyvalidation.flexTopo.XConnectionDeclaration
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.util.XExpressionHelper

class FlexTopoXExpressionHelper extends XExpressionHelper {
	override hasSideEffects(XExpression expr) {
        if (expr instanceof XConnectionDeclaration || expr.eContainer instanceof XConnectionDeclaration) {
            return true
        }
        super.hasSideEffects(expr)
    }
}
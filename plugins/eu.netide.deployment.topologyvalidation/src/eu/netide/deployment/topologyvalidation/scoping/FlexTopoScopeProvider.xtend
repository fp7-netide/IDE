package eu.netide.deployment.topologyvalidation.scoping

import eu.netide.deployment.topologyvalidation.flexTopo.FlexTopoPackage
import eu.netide.deployment.topologyvalidation.flexTopo.Gate
import eu.netide.deployment.topologyvalidation.flexTopo.ModuleDec
import eu.netide.deployment.topologyvalidation.flexTopo.ModuleGateIdentifier
import eu.netide.deployment.topologyvalidation.flexTopo.MultiGateIdent
import eu.netide.deployment.topologyvalidation.flexTopo.ParameterAsssignment
import eu.netide.deployment.topologyvalidation.flexTopo.ParameterDeclaration
import eu.netide.deployment.topologyvalidation.flexTopo.SwitchModuleDec
import eu.netide.deployment.topologyvalidation.flexTopo.ThisGateIdentifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.Scopes

/**
 * This class contains custom scoping description.
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class FlexTopoScopeProvider extends AbstractFlexTopoScopeProvider {

	override getScope(EObject context, EReference reference) {
		switch (context) {
			ParameterAsssignment case reference == FlexTopoPackage.Literals.PARAMETER_ASSSIGNMENT__NAME: {
				val module = context.eContainer as ModuleDec
				if (!(module instanceof SwitchModuleDec)) {
					if (module.type !== null) {
						val topoModule = module.type
						val candidates = EcoreUtil2.getAllContentsOfType(topoModule, ParameterDeclaration)
						val existingScope = Scopes.scopeFor(candidates)
						return existingScope
//		        		return new Filtering Scope(existingScope, [ ! module.parameters.contains(getEObjectOrProxy) ])
					}
				}
			}
			MultiGateIdent case reference == FlexTopoPackage.Literals.MULTI_GATE_IDENT__VALUE: {
				val gateIdentifier = context.eContainer
				switch (gateIdentifier) {
					ThisGateIdentifier: {
						val rootElement = EcoreUtil2.getRootContainer(context)
						val candidates = EcoreUtil2.getAllContentsOfType(rootElement, Gate)
						return Scopes.scopeFor(candidates)
					}
					ModuleGateIdentifier: {
						if (gateIdentifier.module.type !== null) {
							val rootElement = gateIdentifier.module.type
							val candidates = EcoreUtil2.getAllContentsOfType(rootElement, Gate)
							return Scopes.scopeFor(candidates)
						} else if (gateIdentifier.module instanceof SwitchModuleDec) {
//							TODO: implement?
							return null
						}
					}
				}
			}
			default: {
				return super.getScope(context, reference)
			}
		}
	}
}

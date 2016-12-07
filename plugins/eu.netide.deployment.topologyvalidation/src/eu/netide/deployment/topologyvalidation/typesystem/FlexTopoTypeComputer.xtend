package eu.netide.deployment.topologyvalidation.typesystem

import Topology.Connector
import Topology.TopologyFactory
import eu.netide.deployment.topologyvalidation.flexTopo.GateIdentifier
import eu.netide.deployment.topologyvalidation.flexTopo.ModuleGateIdentifier
import eu.netide.deployment.topologyvalidation.flexTopo.MultiGateIdent
import eu.netide.deployment.topologyvalidation.flexTopo.XConnectionDeclaration
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.annotations.typesystem.XbaseWithAnnotationsTypeComputer
import org.eclipse.xtext.xbase.typesystem.computation.ITypeComputationState
import org.eclipse.xtext.xbase.typesystem.computation.ITypeExpectation
import org.eclipse.xtext.xbase.typesystem.conformance.ConformanceFlags

class FlexTopoTypeComputer extends XbaseWithAnnotationsTypeComputer {

//	private static Switch sw = TopologyFactory.eINSTANCE.createSwitch
	private static Connector con = TopologyFactory.eINSTANCE.createConnector

	override computeTypes(XExpression expression, ITypeComputationState state) {

		if (expression instanceof XConnectionDeclaration) {
			_computeTypes(expression, state);
 			// check forum question: https://www.eclipse.org/forums/index.php/m/1748683/#msg_1748683
//		} else if (expression.eContainer() instanceof SwitchModuleDec) {
//			sw.eClass.EAllAttributes.forEach[
//				state.assignType(QualifiedName.create(it.name),
//					state.getReferenceOwner().newReferenceTo(it.EAttributeType.instanceClass).getType(),
//					state.getReferenceOwner().newReferenceTo(it.EAttributeType.instanceClass)
//				)
//			]
//			super.computeTypes(expression, state)
		} else if (expression.eContainer() instanceof XConnectionDeclaration) {
			con.eClass.EAllAttributes.forEach[
				state.assignType(QualifiedName.create(it.name),
					state.getReferenceOwner().newReferenceTo(it.EAttributeType.instanceClass).getType(),
					state.getReferenceOwner().newReferenceTo(it.EAttributeType.instanceClass)
				)
			]
			super.computeTypes(expression, state)
		} else {
			super.computeTypes(expression, state);
		}
	}

	def void _computeTypes(XConnectionDeclaration object, ITypeComputationState state) {

		_computeTypes(object.left, state)
		_computeTypes(object.right, state)
		if (object.constrain !== null) {
			val conditionExpectation = state.withExpectation(getRawTypeForName(Boolean.TYPE, state))
			conditionExpectation.computeTypes(object.constrain);
		}

		// TODO: why is this needed?
		for (ITypeExpectation expectation : state.getExpectations()) {
			val expectedType = expectation.getExpectedType();
			if (expectedType !== null && expectedType.isPrimitiveVoid()) {
				expectation.acceptActualType(expectedType, ConformanceFlags.CHECKED_SUCCESS);
			} else {
				expectation.acceptActualType(expectation.getReferenceOwner().newAnyTypeReference(),
					ConformanceFlags.UNCHECKED);
			}
		}
	}

	def void _computeTypes(GateIdentifier obj, ITypeComputationState state) {

		if (obj instanceof ModuleGateIdentifier) {
			if (obj.moduleNumber !== null) {
				val conditionExpectation = state.withExpectation(getRawTypeForName(Integer.TYPE, state))
				conditionExpectation.computeTypes(obj.moduleNumber);
			}
		}
		obj.gate?._computeTypes(state)
	}

	def void _computeTypes(MultiGateIdent obj, ITypeComputationState state) {

		if (obj.gateNumber !== null) {
			val conditionExpectation = state.withExpectation(getRawTypeForName(Integer.TYPE, state))
			conditionExpectation.computeTypes(obj.gateNumber);
		}
	}
}

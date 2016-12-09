/*
 * generated by Xtext 2.10.0
 */
package eu.netide.deployment.topologyvalidation.jvmmodel

import Topology.TopologyFactory
import com.google.inject.Inject
import eu.netide.deployment.topologyvalidation.flexTopo.ModuleDec
import eu.netide.deployment.topologyvalidation.flexTopo.MultiModuleDec
import eu.netide.deployment.topologyvalidation.flexTopo.SwitchModuleDec
import eu.netide.deployment.topologyvalidation.flexTopo.SwitchMultiModuleDec
import eu.netide.deployment.topologyvalidation.flexTopo.TopoModule
import eu.netide.deployment.topologyvalidation.restrictiontopology.ARootTopoModule
import eu.netide.deployment.topologyvalidation.restrictiontopology.ATopoModule
import eu.netide.deployment.topologyvalidation.restrictiontopology.Gate
import eu.netide.deployment.topologyvalidation.restrictiontopology.MultiModule
import eu.netide.deployment.topologyvalidation.restrictiontopology.ValSwitch
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

/**
 * <p>Infers a JVM model from the source model.</p>
 *
 * <p>The JVM model should contain all elements that would appear in the Java code
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>
 */
class FlexTopoJvmModelInferrer extends AbstractModelInferrer {

	/**
	 * convenience API to build and initialize JVM types and their members.
	 */
	@Inject extension JvmTypesBuilder
	@Inject extension IQualifiedNameProvider
	@Inject extension TypeReferenceSerializer

	/**
	 * The dispatch method {@code infer} is called for each instance of the
	 * given element's type that is contained in a resource.
	 *
	 * @param element
	 *            the model to create one or more
	 *            {@link JvmDeclaredType declared
	 *            types} from.
	 * @param acceptor
	 *            each created
	 *            {@link JvmDeclaredType type}
	 *            without a container should be passed to the acceptor in order
	 *            get attached to the current resource. The acceptor's
	 *            {@link IJvmDeclaredTypeAcceptor#accept(org.eclipse.xtext.common.types.JvmDeclaredType)
	 *            accept(..)} method takes the constructed empty type for the
	 *            pre-indexing phase. This one is further initialized in the
	 *            indexing phase using the lambda you pass as the last argument.
	 * @param isPreIndexingPhase
	 *            whether the method is called in a pre-indexing phase, i.e.
	 *            when the global index is not yet fully updated. You must not
	 *            rely on linking using the index if isPreIndexingPhase is
	 *            <code>true</code>.
	 */

	def dispatch void infer(TopoModule element, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		// Here you explain how your model is mapped to Java elements, by writing the actual translation code.
		acceptor.accept(element.toClass(element.fullyQualifiedName)) [

			fileHeader = '''Generated by NetIDEs Topology Validation.
			'''

			if (element.main) {
				superTypes += typeRef(ARootTopoModule)
			} else {
				superTypes += typeRef(ATopoModule)
			}

			documentation = element.documentation

			// add constructor accepting all parameters
			members += toConstructor(element) [
				parameters += element.toParameter("name", typeRef(String))
				for (p : element.parameters) {
					parameters += p.toParameter(p.name, p.type)
				}

				body = [
					append('''super(name);''')
					newLine
					for (p : element.parameters) {
						append('''this.«p.name» = «p.name»;''')
					}
					newLine
					append('''init();''')
				]
			]

			// add constructor accepting all parameters as Map
			members += toConstructor(element) [
				parameters += element.toParameter("name", typeRef(String))
				parameters += element.toParameter("parameterMap", typeRef(Map))

				body = [
					append("super(name);")
					newLine
					for (p : element.parameters) {
						append('''this.«p.name» = (''')
						referClass(element, p.type)
						append(
							''') parameterMap.get("«p.name»");'''
						)
						newLine
					}
					append('''init();''')

				]
			]

//			members += element.toMethod("getParameterMap", typeRef(Map))[
//				static = true
//				body = [
//					append('''
//					Map<String, Class<?>> result = new HashMap<String, Class<?>>();
//					«FOR p: element.parameters »
//						result.put("«p.name»", «p.type»);
//					«ENDFOR»
//					return result;
//					''')
//				]
//			]


			// add parameters as fields
			for (parameter : element.parameters) {
				members += parameter.toField(parameter.name, parameter.type)
				members += parameter.toGetter(parameter.name, parameter.type)
//				members += parameter.toSetter(parameter.name, parameter.type)
			}

			// initGates method
			members += element.toMethod("initGates", typeRef(Void::TYPE)) [
				body = [
					for (gate : element.gates) {
						append('''this.addGate("«gate.name»", new ''')
						referClass(element, Gate)
						append('''(this));''')
						newLine
					}
				]
			]

			// add submodule parameter calculation methods
			for (subModule : element.submodules) {
				for (p : subModule.parameters) {

					members +=
						p.toMethod("calculate_" + subModule.name + "_" + p.name.name, p.name.type ?: inferredType) [
							documentation = p.documentation
							// visibility = JvmVisibility.PRIVATE
							// see https://github.com/LorenzoBettini/Xtext2-experiments/blob/master/helloinferrer/org.xtext.example.helloinferrer/src/org/xtext/example/helloinferrer/jvmmodel/HelloInferrerJvmModelInferrer.xtend
							body = p.body
						]
				}
			}

			// ParameterMap method for each SubModule
			for (subModule : element.submodules) {
				members += toMethod(element, subModule.name + "ParameterMap", typeRef(HashMap)) [
					documentation = element.documentation

					body = [
						append('''HashMap<String, Object> map = new HashMap<String, Object>();''')
						newLine
						for (p : subModule.parameters) {
							append('''map.put("«p.name.name»", calculate_«subModule.name»_«p.name.name»()''')

							append(''');''')
							newLine
						}
						append('''return map;''')
					]
				]
			}

			// add methods calculating the length of a MultiModuleDec
			for (submodule : element.submodules.filter(MultiModuleDec)) {
				// TODO: return type check needed?
				members += submodule.toMethod('''lengthOf«submodule.name»''', typeRef(Integer)) [
					body = submodule.count
				]
			}

			// hack to assign types in constrain XExpression scope
			for (submodule : element.submodules.filter(typeof(SwitchModuleDec)).filter[constrain !==null]) {
				members += submodule.toMethod('''checkOf«submodule.name»''', typeRef(Boolean)) [
					val operation = it
					// TODO: is this needed?
					TopologyFactory.eINSTANCE.createSwitch.eClass.EAllAttributes.forEach[
						operation.parameters += element.toParameter(it.name, typeRef(it.EAttributeType.instanceClass))
					]

					body = submodule.constrain
				]
			}

			// initSubmodules method
			members += element.toMethod("initSubmodules", typeRef(Void::TYPE)) [

				body = [
					for (submodule : element.submodules) {
						newLine
						switch (submodule) {
							SwitchMultiModuleDec: {

								append('''this.addSubmodule("«submodule.name»", new ''')
								referClass(element, MultiModule)
								append("<")
								referClass(element, ValSwitch)
								append(">")
								append('''(lengthOf«submodule.name»(),
									"«submodule.type.name»",
									null,
									{ map -> new ''')
								referClass(element, ValSwitch)
								append('''() });''')
							}
							MultiModuleDec: {

								append('''this.addSubmodule("«submodule.name»", new ''')
								referClass(element, MultiModule)
								append('''<«submodule.type.name»>''')
								append('''(lengthOf«submodule.name»(),
									"«submodule.type.name»",
									«submodule.name»ParameterMap(),
									map -> { return new «submodule.type.name»("«submodule.type.name»", map); }));''')
							}
							SwitchModuleDec: {

								append('''this.addSubmodule("«submodule.name»", new ''')
								referClass(element, ValSwitch)
								if (submodule.constrain !== null) {
									val encodedConstrain=NodeModelUtils.findActualNodeFor(submodule.constrain).text
									.replace("\"","\\\"")
									.replace("\n", "\\n")
									.replace("\r", "\\r")
									append('''("«submodule.name»", "«encodedConstrain»"));''')
								} else {
									append('''("«submodule.name»"));''')
								}
							}
							ModuleDec: {

								append('''this.addSubmodule("«submodule.name»", new ''')
								append('''«submodule.type.name»("«submodule.name»", «submodule.name»ParameterMap()));''')
							}
							default: append("null")
						}
					}
				]
			]

			members += element.toToStringMethod(it)

			// initGateConnectors
			members += element.toMethod("initGateConnectors", typeRef(Void::TYPE)) [
				documentation = element.documentation
				body = element.connections
			]
		]
	}

	def referClass(ITreeAppendable appendable, EObject ctx, JvmTypeReference ref) {
		if (ref !== null) {
			appendable.serialize(ref, ctx)
		} else {
			// Class resolution error - error handling required here
			// A fallback to writing out the fqn of the class
			appendable.append(ref.qualifiedName)
		}
	}

	/*
	 * following two methods are taken from here:
	 * http://stackoverflow.com/questions/19478540/xtext-jvmmodelinferrer-initialize-field
	 */
	def referClass(ITreeAppendable appendable, EObject ctx, Class<?> clazz, JvmTypeReference... typeArgs) {
		val ref = typeRef(clazz, typeArgs)
		if (ref !== null) {
			appendable.serialize(ref, ctx)
		} else {
			// Class resolution error - error handling required here
			// A fallback to writing out the fqn of the class
			appendable.append(clazz.canonicalName)
		}
	}

	def serialize(ITreeAppendable appendable, JvmTypeReference ref, EObject ctx) {
		serialize(ref, ctx, appendable)
	}

//	def void referGateIdentifier(ITreeAppendable a, EObject ctx, GateIdentifier gi) {
//		if (gi.module == null) { // this gate
//			a.append('''this.getGates().get("«gi.gate.name»")''')
//		} else if (gi.module.^switch) { // Switch
//			a.append('(')
//			referClass(a, ctx, ExSwitch)
//			a.append(')')
//
//			a.append('''this.getSubmodules().get("«gi.module.name»")''')
//		} else if (gi.module.type instanceof TopoModule) { // Module
//			a.append('''this.getSubmodules().get("«gi.module.name»").getGates().get("«gi.gate.name»")''')
//		}
//	}
}
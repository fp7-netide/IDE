package eu.netide.deployment.topologyvalidation.jvmmodel

import eu.netide.deployment.topologyvalidation.flexTopo.GateIdentifier
import eu.netide.deployment.topologyvalidation.flexTopo.ModuleGateIdentifier
import eu.netide.deployment.topologyvalidation.flexTopo.MultiGateIdent
import eu.netide.deployment.topologyvalidation.flexTopo.MultiModuleDec
import eu.netide.deployment.topologyvalidation.flexTopo.ThisGateIdentifier
import eu.netide.deployment.topologyvalidation.flexTopo.XConnectionDeclaration
import eu.netide.deployment.topologyvalidation.restrictiontopology.MultiModule
import eu.netide.deployment.topologyvalidation.restrictiontopology.ValSwitch
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.compiler.XbaseCompiler
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable

class FlexTopoXbaseCompiler extends XbaseCompiler {

	override protected doInternalToJavaStatement(XExpression obj, ITreeAppendable b, boolean isReferenced) {
		if (obj instanceof XConnectionDeclaration) {
			b.trace(obj)
			b.newLine
			b.append("this.addGateConnector(")
			b.newLine
			_toJavaExpression(obj.left, b, isReferenced)
			b.append(", ")
			b.newLine
			_toJavaExpression(obj.right, b, isReferenced)
			if (obj.constrain !== null) {
				val encodedConstrain=NodeModelUtils.findActualNodeFor(obj.constrain).text
				.replace("\"","\\\"")
				.replace("\n", "\\n")
				.replace("\r", "\\r")
				b.append(''',
				"«encodedConstrain»"''')
			}
			b.append(");")
			b.newLine
			return
		}

		super.doInternalToJavaStatement(obj, b, isReferenced)
	}

	def _toJavaExpression(GateIdentifier gi, ITreeAppendable b, boolean isReferenced) {
		switch (gi) {
			ThisGateIdentifier: {
				b.append('''this''')
				b.append(".")
				_toJavaExpression(gi.gate, b, isReferenced)
			}
			ModuleGateIdentifier: {
					if ( gi.module instanceof MultiModuleDec) {
						b.append("((");

						b.append(MultiModule.simpleName)
						b.append(") ");
						b.append('''this.getSubmodules().get("«gi.module.name»")).''')

						if (gi.moduleNumber !== null) {
							b.append("get(")
							gi.moduleNumber.toJavaExpression(b)
							b.append(").")
						}
					} else {

						b.append('''this.getSubmodules().get("«gi.module.name»").''')
					}
					_toJavaExpression(gi.gate, b, isReferenced)
			}
		}
	}

	def _toJavaExpression(MultiGateIdent g, ITreeAppendable b, boolean isReferenced) {
		if (g !== null) {
			b.append('''getGates().get("«g.value.name»")''')
		} else {
			b.append('''getGates().get("«ValSwitch::GATE_IDENTIFIER»")''')
		}
	}
}

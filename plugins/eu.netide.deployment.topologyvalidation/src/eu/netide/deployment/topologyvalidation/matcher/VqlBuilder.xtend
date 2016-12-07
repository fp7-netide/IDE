package eu.netide.deployment.topologyvalidation.matcher

import Topology.Connector
import Topology.Switch
import Topology.TopologyFactory
import eu.netide.deployment.topologyvalidation.restrictiontopology.Connection
import eu.netide.deployment.topologyvalidation.restrictiontopology.ValSwitch
import java.io.BufferedWriter
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStreamWriter
import java.io.Writer
import java.util.LinkedList
import java.util.List
import eu.netide.deployment.topologyvalidation.restrictiontopology.Restriction

public class VqlBuilder {

	private static Switch sw = TopologyFactory.eINSTANCE.createSwitch
	private static Connector con = TopologyFactory.eINSTANCE.createConnector

	def private static newLine(StringBuilder sb) {
		sb.append("\n")
	}

	def private static String getIdentifier(ValSwitch s) {
		s.name + '_' + s.hashCode
	}

	def private static String getIdentifier(Connection c) {
		'connection_' + c.hashCode
	}

	def private static patternSignature(StringBuilder sb, List<ValSwitch> l) {
		sb.append(
		'''
		«FOR s : l SEPARATOR ", \n"»
			«s.identifier»: Switch
		«ENDFOR»
		''')
	}

	def private static switchInequalityRules(StringBuilder sb, LinkedList<ValSwitch> l) {
		val stack = l.clone as LinkedList<ValSwitch>

		while (stack.length > 1) {
			val current = stack.pop
			stack.forEach[
				sb.append('''	«current.identifier» != «identifier»;''')
				sb.newLine
			]
		}
		return sb
	}

	def private static connectionAttributeExtraction(LinkedList<Restriction> restrictions) {
		'''
		«FOR attribute : con.eClass.EAllAttributes.filter[attr | restrictions.exists[it.rule.contains(attr.name)]]»
			Connector.«attribute.name»(con, «attribute.name»);
		«ENDFOR»
		'''
	}

	def private static connectionPattern(Connection c, StringBuilder sb) {
		val patternName = c.identifier+"Constrain"
		sb.append('''
		@QueryExplorer(checked = false)
		pattern «patternName»(S1 : Switch, S2 : Switch) {
			Connector(con);
			Switch.ports.connector(S1,con);
			Switch.ports.connector(S2,con);

			«connectionAttributeExtraction(c.restrictions)»

			«FOR r : c.restrictions»
			check(«r.rule»);
			«ENDFOR»
		}

		''')
		return '''	find «patternName»(«c.left.identifier», «c.right.identifier»);
		'''
	}

	def private static connectionPatternCalls(StringBuilder sb, LinkedList<Connection> l, StringBuilder patternContainer) {
		// TODO: reuse connectionRule if same connection?
		l.forEach[ c |
			if (c.restrictions.empty) {
				sb.append(c.stdConnectionPatternCall)
			} else {
				sb.append(c.connectionPattern(patternContainer))
			}
		]
		return sb
	}

	def private static switchAttributeExtraction(LinkedList<Restriction> restrictions) {
		'''
		«FOR attribute : sw.eClass.EAllAttributes.filter[attr | restrictions.exists[it.rule.contains(attr.name)]]»
			Switch.«attribute.name»(sw, «attribute.name»);
		«ENDFOR»
		'''
	}

	def private static switchConstrainPattern(ValSwitch s, StringBuilder patternContainer) {
		val patternName = s.identifier+"Constrain"
		patternContainer.append('''
		@QueryExplorer(checked = false)
		pattern «patternName»(sw : Switch) {

			«switchAttributeExtraction(s.restrictions)»

			«FOR r:s.restrictions»
			check(«r.rule»);
			«ENDFOR»
		}
		''')
		return '''	find «patternName»(«s.identifier»);
		'''
	}

	def private static switchConstrainPatternCalls(StringBuilder sb, LinkedList<ValSwitch> l, StringBuilder patternContainer) {
		l.filter[!restrictions.empty].forEach[
			sb.append(switchConstrainPattern(patternContainer))
		]
		return sb
	}

	def private static stdConnectionPatternCall(Connection c) {
		'''	find connected(«c.left.identifier», «c.right.identifier»);
		'''
	}

	def private static stdConnectionPattern() {
		'''
		@QueryExplorer(checked = false)
		pattern connected(S1 : Switch, S2 : Switch) {
			Connector(con);
			Switch.ports.connector(S1,con);
			Switch.ports.connector(S2,con);
		}

		'''
	}

	def private static importSection() {
		'''
		import "eu.netide.configuration.topology"

		'''
	}

	/**
	 * builds something like this:
	 *
	 * pattern graphMatch(s1: Switch, s2: Switch, s3: Switch, s4: Switch, s5: Switch) {
	 * 	s1 != s2;
	 * 	s1 != s3;
	 * 	s1 != s4;
	 * 	s2 != s3;
	 * 	s2 != s4;
	 * 	s3 != s4;
	 *
	 * 	check(s3.ports >3)
	 *
	 * 	find connected (s1, s2);
	 * 	find connected (s2, s3);
	 * 	find connected (s3, s4);
	 * 	find connected (s4, s1);
	 * }
	 */
	def public static generateViatraQuery(String fileName, LinkedList<ValSwitch> switches, LinkedList<Connection> connections) {

			val mainPattern = new StringBuilder
			val patternContainer = new StringBuilder

			patternContainer.append(importSection)

			mainPattern
			.append('''pattern «ViatraManager.PATTERN_FQN» (''')
			.patternSignature(switches)
			.newLine
			.append(''') {
			''')
			.newLine
			.newLine

			.append("// define all Switches")
			.newLine
			.switchInequalityRules(switches)

			.newLine
			.append("// define all Switch Constrains")
			.newLine
			.switchConstrainPatternCalls(switches, patternContainer)

			.newLine
			.append("// define all Connections")
			.newLine
			.connectionPatternCalls(connections, patternContainer)
			.append('''}''')

			patternContainer
			.append(stdConnectionPattern)
			.append(mainPattern)
			patternContainer.writeToFile(fileName)

	// Initializing Xtext-based resource parser
	// Do not use if VIATRA Query tooling is loaded!
//		new EMFPatternLanguageStandaloneSetup().createInjectorAndDoEMFRegistration()
	// Create pattern resource file
//		val resourceSet = new ResourceSetImpl()
//      val vqlURI = URI.createFileURI(fileName)
//		val vqlRes = resourceSet.createResource(vqlURI)
	}

		def private static writeToFile(StringBuilder sb, String fileName) {
			val vqlFile = new File(fileName)
			vqlFile.getParentFile.mkdirs;
			vqlFile.delete
			vqlFile.createNewFile

			if (!vqlFile.canWrite) {
				return
			}
			var Writer writer = null
			try {
				writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(vqlFile, false), "utf-8"))
				writer.write(sb.toString());

			} catch (IOException ex) {
				// TODO: report
			} finally {
	   			try {writer.close();} catch (Exception ex) {/*ignore*/}
			}
		}
}
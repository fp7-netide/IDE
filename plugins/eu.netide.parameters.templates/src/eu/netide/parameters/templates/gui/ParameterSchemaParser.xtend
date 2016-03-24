package eu.netide.parameters.templates.gui

import eu.netide.parameters.language.paramschema.ParameterSchema
import java.util.HashMap
import org.eclipse.core.resources.IProject
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.resource.XtextResourceSet

class ParameterSchemaParser {

	HashMap<String, ParameterSchema> schemas

	new() {
		schemas = newHashMap()
	}

	def parse(IProject project) {

		var visitor = new ParameterSchemaVisitor
		project.accept(visitor)

		visitor.files.forEach [ f |
			var xtextResourceSet = new XtextResourceSet
			var resource = xtextResourceSet.getResource(URI.createURI(f.fullPath.toString), true)

			schemas.put(f.projectRelativePath.segment(1), resource.contents.get(0) as ParameterSchema)
		]
		schemas
	}
}

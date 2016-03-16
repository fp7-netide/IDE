package eu.netide.parameters.templates

import com.fasterxml.jackson.core.JsonProcessingException
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import com.github.jknack.handlebars.Context
import com.github.jknack.handlebars.Handlebars
import com.github.jknack.handlebars.io.FileTemplateLoader
import eu.netide.configuration.utils.fsa.FileSystemAccess
import org.eclipse.core.resources.IProject
import org.eclipse.jface.dialogs.MessageDialog
import org.eclipse.swt.widgets.Shell
import com.github.jknack.handlebars.ValueResolver

class TemplateRenderer {

	public def renderTemplates(String input, IProject project, Shell shell) {

		var folder = project.locationURI.rawPath + "/templates"

		var mapper = new ObjectMapper()

		var loader = new FileTemplateLoader(folder, "")

		val handlebars = new Handlebars(loader)

		val value = new ValueResolver {

			override propertySet(Object arg0) {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}

			override resolve(Object arg0) {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}

			override resolve(Object arg0, String arg1) {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}

		}

		try {
			val node = mapper.readValue(input, typeof(JsonNode))
			val keys = node.fields.map[key].toList

			val templateFolder = project.findMember("templates")

			var visitor = new TemplateVisitor

			templateFolder.accept(visitor)

			val fsa = new FileSystemAccess
			fsa.project = project
			fsa.outputDirectory = "./apps"

			visitor.files.forEach [ f |
				var loc = f.location.makeRelativeTo(templateFolder.location)

				var appname = loc.segment(0)

				if (keys.contains(appname)) {
					var context = Context.newBuilder(node.findValue(appname)).resolver(Resolver.instance).build()

					var template = handlebars.compile(loc.toString)
					fsa.generateFile(loc.removeFileExtension.toString, template.apply(context))
				}
			]

		} catch (JsonProcessingException e) {
			MessageDialog.openError(shell, "JSON Error", e.message)
		}

	}

}

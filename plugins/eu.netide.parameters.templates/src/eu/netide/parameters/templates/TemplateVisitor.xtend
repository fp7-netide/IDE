package eu.netide.parameters.templates

import org.eclipse.core.resources.IResourceVisitor
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.resources.IFile
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

class TemplateVisitor implements IResourceVisitor {
	@Accessors(PUBLIC_GETTER)
	ArrayList<IResource> files
	
	new() {
		files = newArrayList()
	}
	
	override visit(IResource resource) throws CoreException {
		if (resource instanceof IFile && resource.name.endsWith(".hbs")) {
			files.add(resource)
		}
		true
	}
}
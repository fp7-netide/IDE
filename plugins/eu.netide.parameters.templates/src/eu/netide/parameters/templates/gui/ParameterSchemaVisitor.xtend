package eu.netide.parameters.templates.gui

import org.eclipse.core.resources.IResourceVisitor
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import org.eclipse.core.resources.IFile

class ParameterSchemaVisitor implements IResourceVisitor {
	
	@Accessors(PUBLIC_GETTER)
	ArrayList<IResource> files
	
	new() {
		files = newArrayList()
	}
	
	override visit(IResource resource) throws CoreException {
		if (resource instanceof IFile && resource.name.endsWith(".params")) {
			files.add(resource)
		}
		true
	}
	
}
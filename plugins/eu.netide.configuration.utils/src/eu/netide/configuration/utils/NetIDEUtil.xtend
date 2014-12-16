package eu.netide.configuration.utils

import org.eclipse.core.runtime.Path
import org.eclipse.core.resources.ResourcesPlugin

class NetIDEUtil {
	
	
	static def absolutePath(String e) {
		if (e != null && e.startsWith("platform:/resource"))
					ResourcesPlugin.getWorkspace().getRoot().findMember(new Path(e).removeFirstSegments(2)).rawLocation
				else
					new Path(e)
		
	}
}
package eu.netide.configuration.utils

import org.eclipse.core.runtime.Path
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Platform

/**
 * Some useful methods for everyday use
 * 
 * @author Christian Stritzke
 */
class NetIDEUtil {
	
	
	static def absolutePath(String e) {
		if (e != null && e.startsWith("platform:/resource")) {
					if (Platform.getOS == Platform.OS_WIN32)
						ResourcesPlugin.getWorkspace().getRoot().findMember(new Path(e).removeFirstSegments(1)).rawLocation
					else if (Platform.getOS == Platform.OS_LINUX || Platform.getOS == Platform.OS_MACOSX)
						ResourcesPlugin.getWorkspace().getRoot().findMember(new Path(e).removeFirstSegments(2)).rawLocation

        } else {
        	var p = new Path(e)
            if (e.startsWith("file:/"))
            	new Path("/" + p.removeFirstSegments(1))
            else
                p
        }
	}
}
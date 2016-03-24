package eu.netide.configuration.utils

import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.common.util.URI

/**
 * Some useful methods for everyday use
 * 
 * @author Christian Stritzke
 */
class NetIDEUtil {
	static def absolutePath(String e) {
		if (e == null)
			return null;

		if (e.startsWith("platform:/resource")) {
			if (Platform.getOS == Platform.OS_WIN32)
				ResourcesPlugin.getWorkspace().getRoot().findMember(new Path(e).removeFirstSegments(1)).rawLocation
			else if (Platform.getOS == Platform.OS_LINUX || Platform.getOS == Platform.OS_MACOSX)
				ResourcesPlugin.getWorkspace().getRoot().findMember(new Path(e).removeFirstSegments(2)).rawLocation
		} else if (e.startsWith("file:/")) {
			if (Platform.getOS == Platform.OS_WIN32)
				new Path("" + new Path(e.substring(5)))
			else if (Platform.getOS == Platform.OS_LINUX || Platform.getOS == Platform.OS_MACOSX)
				new Path("/" + new Path(e).removeFirstSegments(1))
		} else {
			new Path(e)
		}
	}

	static def toPlatformUri(IResource file) {
		return URI.createPlatformResourceURI(file.fullPath.toString, false).toString
	}
}

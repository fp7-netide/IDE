package eu.netide.configuration.generator.fsa

import java.io.ByteArrayInputStream
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.NullProgressMonitor

class FileSystemAccess {

	String outputDirectory
	IProject project

	def setProject(IProject project) {
		this.project = project
	}

	def setOutputDirectory(String dir) {
		this.outputDirectory = dir
	}

	def generateFile(String filename, CharSequence content) {

		val monitor = new NullProgressMonitor

		val file = project.getFile(String.format("%s/%s", outputDirectory ?: ".", filename))

		for (var i = 2; i < file.fullPath.segmentCount; i++) {
			var folder = project.getFolder(
				file.fullPath.removeLastSegments(file.fullPath.segmentCount - i).removeFirstSegments(1))
			try {
				folder.create(false, true, monitor)
			} catch (CoreException e) {
			}

		}

		project.refreshLocal(IProject.DEPTH_INFINITE, monitor)

		if (file.accessible)
			file.setContents(new ByteArrayInputStream(content.toString.bytes), true, false, monitor)
		else
			file.create(new ByteArrayInputStream(content.toString.bytes), IResource.FORCE, monitor)

		project.refreshLocal(IProject.DEPTH_INFINITE, monitor)

	}

	def generateFolder(String foldername) {
		val monitor = new NullProgressMonitor

		val file = project.getFile(String.format("%s/%s", outputDirectory ?: "", foldername))

		for (var i = 2; i <= file.fullPath.segmentCount; i++) {
			var folder = project.getFolder(
				file.fullPath.removeLastSegments(file.fullPath.segmentCount - i).removeFirstSegments(1))
			try {
				folder.create(false, true, monitor)
			} catch (CoreException e) {
			}

		}

		project.refreshLocal(IProject.DEPTH_INFINITE, monitor)
		project.refreshLocal(IProject.DEPTH_INFINITE, monitor)
		return
	}
	

}

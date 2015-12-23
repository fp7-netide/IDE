package eu.netide.configuration.launcher.managers

import java.util.ArrayList
import org.eclipse.core.resources.IProject

interface IManager {
	def ArrayList<String> getRunningSessions()
	def void asyncHalt()
	def void asyncProvision()
	def void provision()
	def void asyncUp()
	def void exec(String cmd)
	def String execWithReturn (String cmd)
	def IProject getProject()
	
}
package eu.netide.configuration.launcher.managers

import java.util.ArrayList

interface IManager {
	def ArrayList<String> getRunningSessions()
	def void asyncHalt()
}
package eu.netide.configuration.launcher.starters.backends

abstract class Backend {

	abstract def String cmdprefix()
	abstract def String args()
}
package eu.netide.configuration.launcher.starters.backends

class SshBackend extends Backend {
	
	private String hostname
	private int port
	
	new(String hostname, int port) {
		this.hostname = hostname
		this.port = port
	}
	
	override cmdprefix() {
		return "ssh"
	}
	
	override args() {
		return String.format("ssh %s -p %s", hostname, port) 
	}
}
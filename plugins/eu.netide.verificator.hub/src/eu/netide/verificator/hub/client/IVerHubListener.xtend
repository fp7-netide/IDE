package eu.netide.verificator.hub.client

interface IVerHubListener {
	
	/**
	 * Can be called by a hub to send a byte array to a listener
	 * 
	 * @param message 
	 * The byte array of the received message 
	 */
	def void update(byte[] message)
	
}
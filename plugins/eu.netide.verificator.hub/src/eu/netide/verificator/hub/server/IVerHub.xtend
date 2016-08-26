package eu.netide.verificator.hub.server

import eu.netide.verificator.hub.client.IVerHubListener

interface IVerHub extends Runnable{
		
	public def void register(IVerHubListener listener)
	public def void remove(IVerHubListener listener)
	
	public def void setRunning(Boolean running)
	public def Boolean getRunning()
	
	public def void setAddress(String address)
	public def String getAddress()
	
	public def void setName(String name)
	public def String getName()
	
	
}

package eu.netide.deployment.topologyimport;

public class TopologyImportFactory {
	
	public static TopologyImportFactory instance = new TopologyImportFactory();
	
	public TopologyImport createTopologyImport() {
		return new TopologyImport();
	}

}

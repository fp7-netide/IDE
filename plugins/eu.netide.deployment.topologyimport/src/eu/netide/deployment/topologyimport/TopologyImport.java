package eu.netide.deployment.topologyimport;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;


/*import java.lang.reflect.InvocationTargetException;
import org.eclipse.emf.common.notify.Adapter;
import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.ecore.EAnnotation;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.Resource; */
import Topology.*;


public class TopologyImport {
	public static void main(String[] args) {
		
		File file = new File(args[0]);
		BufferedReader reader = null;
		
		TopologyFactory factory = TopologyFactory.eINSTANCE;
		NetworkEnvironment ne = factory.createNetworkEnvironment();
		ne.setName("TestNE");
		
		Network net = factory.createNetwork();
		net.setNetworkenvironment(ne);
		net.setName("TestNet");
		
		try {
		    reader = new BufferedReader(new FileReader(file));
		    String text = null;
		    int nr_switches = Integer.parseInt(reader.readLine());
		    String base_str = "sw";
		    HashMap<String, Switch> sw_list = new HashMap<String, Switch>();
		    for (int i=0 ; i < nr_switches; i++) {
		    	text = reader.readLine();
		    	String name = base_str + "_" +String.valueOf(i);
		    	Switch sw = factory.createSwitch();
		    	sw.setName(name);
		    	sw.setTopology(net);
		    	sw_list.put(name, sw);
		    }
		    int nr_edges = Integer.parseInt(reader.readLine());
		    HashMap<String, Connector> connector_list = new HashMap<String, Connector>();
		    HashMap<Connector, Port[]> port_list = new HashMap<Connector, Port[]>();
		    for (int i=0 ; i < nr_edges; i++) {
		    	text = reader.readLine();
		    	String[] edges = new String[2] ;
		    	Port[] ports = new Port[2];
		    	edges = text.split("   ");
		    	String name =  "edge_" +String.valueOf(i);
		    	//System.out.println(edges[0]+" "+edges[1]);
		    	Connector con = factory.createConnector();
				con.setNetwork(net);
				connector_list.put(name, con);
				Port port1= factory.createPort();
				port1.setConnector(con);
				Port port2 = factory.createPort();
				port2.setConnector(con);
				ports[0] = port1;
				ports[1] = port2;
				// port1.setNetworkelement(ne); WHICH Network Environment ?
				port_list.put(con, ports);
		    }
		    while ((text = reader.readLine()) != null) {
		    	System.out.println(text);
		    }
		} catch (FileNotFoundException e) {
		    e.printStackTrace();
		} catch (IOException e) {
		    e.printStackTrace();
		} 
		

		
		Switch sw = factory.createSwitch();
		sw.setName("TestSwitch");
		sw.setTopology(net);
		
		Host host = factory.createHost();
		host.setName("TestHost");
		host.setTopology(net);
		
		Connector con = factory.createConnector();
		con.setNetwork(net);
		
	    Port port = factory.createPort();
	    port.setConnector(con);
	    
	    
	    
		//Read from topology file
		//create objects 
	}
}

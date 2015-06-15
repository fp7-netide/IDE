package eu.netide.deployment.topologyimport;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;


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
		try {
		    reader = new BufferedReader(new FileReader(file));
		    String text = null;

		    while ((text = reader.readLine()) != null) {
		        //Do stuff - read lines
		    }
		} catch (FileNotFoundException e) {
		    e.printStackTrace();
		} catch (IOException e) {
		    e.printStackTrace();
		}
		
		TopologyFactory factory = TopologyFactory.eINSTANCE;
		NetworkEnvironment ne = factory.createNetworkEnvironment();
		ne.setName("TestNE");
		
		Network net = factory.createNetwork();
		net.setNetworkenvironment(ne);
		net.setName("TestNet");
		
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

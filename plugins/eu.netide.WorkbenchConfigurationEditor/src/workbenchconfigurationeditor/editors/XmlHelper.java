package workbenchconfigurationeditor.editors;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.eclipse.core.resources.IFile;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import workbenchconfigurationeditor.model.LaunchConfigurationModel;
import workbenchconfigurationeditor.model.XmlConstants;

public class XmlHelper {

	public static void saveContentToXml(Document doc, IFile file) {
		System.out.println("Location: " + file.getLocation());
		saveContentToXml(doc, new File(file.getLocation().toOSString()));
	}

	public static void saveContentToXml(Document doc, File file) {
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		Transformer transformer;
		try {
			transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);

			System.out.println(file.exists());
			StreamResult result = new StreamResult(file);

			// Output to console for testing
			// StreamResult result = new StreamResult(System.out);

			transformer.transform(source, result);

		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public static void addModelToXmlFile(Document doc, LaunchConfigurationModel model, IFile file) {
		Node wb = doc.getFirstChild();
		System.out.println("Node name: " + wb.getNodeName());
		if (wb.getNodeName().equals(XmlConstants.WORKBENCH)) {
			Element app = doc.createElement(XmlConstants.NODE_APP);
			app.setAttribute(XmlConstants.ATTRIBUTE_APP_NAME, model.getAppName());
			app.setAttribute(XmlConstants.ATTRIBUTE_APP_ID, "" + model.getID());

			Element appPath = doc.createElement(XmlConstants.ELEMENT_APP_PATH);
			appPath.setTextContent(model.getAppPath());
			app.appendChild(appPath);

			Element platform = doc.createElement(XmlConstants.ELEMENT_PLATFORM);
			platform.setTextContent(model.getPlatform());
			app.appendChild(platform);

			Element clientController = doc.createElement(XmlConstants.ELEMENT_CLIENT_CONTROLLER);
			clientController.setTextContent(model.getClientController());
			app.appendChild(clientController);

			Element serverController = doc.createElement(XmlConstants.ELEMENT_SERVER_CONTROLLER);
			serverController.setTextContent(model.getServerController());
			app.appendChild(serverController);

			wb.appendChild(app);

			XmlHelper.saveContentToXml(doc, file);

		}
	}

	public static void removeFromXml(Document doc, LaunchConfigurationModel model, IFile file) {
		System.out.println("to remove id :" + model.getID());
		Node workbenchNode = doc.getFirstChild();
		NodeList childs = workbenchNode.getChildNodes();
		System.out.println("element number: " + childs.getLength());
		for (int count = 0; count < childs.getLength(); count++) {
			Node tempNode = childs.item(count);

			System.out.println("tmp node name: " + tempNode.getNodeName());
			if (tempNode.getNodeName().equals(XmlConstants.NODE_APP)) {
				NamedNodeMap nodeMap = tempNode.getAttributes();

				for (int i = 0; i < nodeMap.getLength(); i++) {

					Node node = nodeMap.item(i);
					System.out.println("attribute node name: " + node.getNodeName());
					if (node.getNodeName().equals(XmlConstants.ATTRIBUTE_APP_ID)) {
						workbenchNode.removeChild(tempNode);
						System.out.println("found node");
						XmlHelper.saveContentToXml(doc, file);
					}
				}
			}

		}
	}

	public static Document getDocFromFile(IFile file) {
		File xmlFile = new File(file.getRawLocationURI());
		modelList = new ArrayList<LaunchConfigurationModel>();

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();

		Document doc = null;
		try {
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			doc = dBuilder.parse(xmlFile);
			doc.getDocumentElement().normalize();
		} catch (SAXException | IOException | ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return doc;
	}

	public static ArrayList<LaunchConfigurationModel> parseFileToModel(IFile file, Document doc) {
		try {
			File xmlFile = new File(file.getRawLocationURI());
			modelList = new ArrayList<LaunchConfigurationModel>();

			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			doc = dBuilder.parse(xmlFile);
			doc.getDocumentElement().normalize();

			// System.out.println("Root element :" +
			// doc.getDocumentElement().getNodeName());

			if (doc.hasChildNodes()) {

				printNote(doc.getChildNodes(), null);

			}

			return modelList;
		} catch (Exception e) {

		}
		return null;

	}

	private static ArrayList<LaunchConfigurationModel> modelList;

	public static void printNote(NodeList nodeList, LaunchConfigurationModel model) {

		for (int count = 0; count < nodeList.getLength(); count++) {

			Node tempNode = nodeList.item(count);
			System.out.println("current node name: " + tempNode.getNodeName());
			// make sure it's element node.
			if (tempNode.getNodeType() == Node.ELEMENT_NODE) {

				System.out.println("got here");
				switch (tempNode.getNodeName()) {
				case XmlConstants.ELEMENT_APP_PATH:
					System.out.println("Setting as node Value for app path: " + tempNode.getTextContent());
					model.setAppPath(tempNode.getTextContent());
					break;
				case XmlConstants.ELEMENT_TOPOLOGY_PATH:
					System.out.println("Setting as node topology for app path: " + tempNode.getTextContent());
					LaunchConfigurationModel.setTopology(tempNode.getTextContent());

					break;
				case XmlConstants.NODE_APP:
					model = new LaunchConfigurationModel();
					modelList.add(model);

					if (tempNode.hasAttributes()) {
						NamedNodeMap nodeMap = tempNode.getAttributes();

						for (int i = 0; i < nodeMap.getLength(); i++) {

							Node node = nodeMap.item(i);
							if (node.getNodeName().equals(XmlConstants.ATTRIBUTE_APP_ID)) {
								model.setID(node.getNodeValue());
							} else {
								if (node.getNodeName().equals(XmlConstants.ATTRIBUTE_APP_NAME)) {
									model.setAppName(node.getNodeValue());
								}
							}
						}
					}
					break;
				case XmlConstants.ELEMENT_CLIENT_CONTROLLER:
					System.out.println("Setting as node client controller for app path: " + tempNode.getTextContent());
					model.setClientController(tempNode.getTextContent());
					break;
				case XmlConstants.ELEMENT_SERVER_CONTROLLER:
					System.out.println("Setting as node server controller for app path: " + tempNode.getTextContent());
					model.setServerController(tempNode.getTextContent());
					break;
				case XmlConstants.ELEMENT_PLATFORM:
					System.out.println("Setting as node platform for app path: " + tempNode.getTextContent());
					model.setPlatform(tempNode.getTextContent());
					break;
				default:
					System.err.println("No match for node: " + tempNode.getNodeName());

				}

				if (tempNode.hasChildNodes()) {
					// loop again if has child nodes
					printNote(tempNode.getChildNodes(), model);
				}
			}

		}

	}
}

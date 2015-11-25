package workbenchconfigurationeditor.wizards;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.IPackageFragment;
import org.eclipse.jdt.core.IPackageFragmentRoot;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import workbenchconfigurationeditor.model.XmlConstants;

public class Configuration_Wizard extends Wizard implements INewWizard {

	private Configuration_Wizard_Page page;

	public Configuration_Wizard() {
		super();
		setWindowTitle("new Configuration Wizard");
	}

	@Override
	public String getWindowTitle() {
		return "Configuration Wizard";
	}

	@Override
	public void addPages() {

		page = new Configuration_Wizard_Page();
		addPage(page);

	}

	@Override
	public boolean performFinish() {

		return createNewFile(page.getFileName(), page.getTopologyPath());

	}

	private boolean createNewFile(final String fileName, String topoName) {

		String filePath = checkSelection();
		filePath += "/" + fileName + ".wb";

		File file = new File(filePath);

		if (!file.exists()) {
			try {
				System.out.println(file.createNewFile());
				writeContent(file, topoName);

				try {
					ResourcesPlugin.getWorkspace().getRoot().refreshLocal(IResource.DEPTH_INFINITE, null);

				} catch (CoreException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			} catch (IOException e) {
				e.printStackTrace();
				return false;
			}
		} else {
			return false;
		}

		return true;
	}

	private void writeContent(File file, String topoName) {
		try {
			
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// root elements
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("workbench");
			doc.appendChild(rootElement);

			// staff elements
			Element topo = doc.createElement(XmlConstants.ELEMENT_TOPOLOGY_PATH);
			topo.setTextContent(topoName);
			rootElement.appendChild(topo);
			
			// write the content into xml file
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(file);

			// Output to console for testing
			// StreamResult result = new StreamResult(System.out);

			transformer.transform(source, result);
			
		
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private ISelection selection;

	@Override
	public void init(IWorkbench workbench, IStructuredSelection selection) {
		this.selection = selection;

		checkSelection();
	}

	private String checkSelection() {

		String path = "";
		if (selection != null && selection.isEmpty() == false && selection instanceof IStructuredSelection) {

			IStructuredSelection ssel = (IStructuredSelection) selection;
			Object obj = ssel.getFirstElement();

			if (obj instanceof IPackageFragment) {
				IPackageFragment pf = (IPackageFragment) obj;
				path = pf.getResource().getLocation().toOSString();

			} else {
				if (obj instanceof IPackageFragmentRoot) {
					IPackageFragmentRoot pfr = (IPackageFragmentRoot) obj;
					path = pfr.getResource().getLocation().toOSString();
				} else {
					if (obj instanceof IJavaProject) {
						IJavaProject p = (IJavaProject) obj;

						path = p.getResource().getLocation().toOSString();
					} else {

						path = ResourcesPlugin.getWorkspace().getRoot().getLocation().toOSString();

					}
				}

			}

		} else {
			path = ResourcesPlugin.getWorkspace().getRoot().getFullPath().toString();
		}
		return path;

	}

}

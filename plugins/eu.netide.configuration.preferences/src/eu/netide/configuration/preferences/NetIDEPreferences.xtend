package eu.netide.configuration.preferences;

import org.eclipse.jface.preference.BooleanFieldEditor
import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.jface.preference.FileFieldEditor
import org.eclipse.jface.preference.StringFieldEditor
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage
import org.eclipse.jface.preference.ListEditor
import org.eclipse.swt.custom.TableEditor
import org.eclipse.jface.preference.PathEditor
import org.eclipse.swt.widgets.Composite
import org.eclipse.jface.window.Window

/**
 * This class represents a preference page that
 * is contributed to the Preferences dialog. By 
 * subclassing <samp>FieldEditorPreferencePage</samp>, we
 * can use the field support built into JFace that allows
 * us to create a page that is small and knows how to 
 * save, restore and apply itself.
 * <p>
 * This page is used to modify preferences only. They
 * are stored in the preference store that belongs to
 * the main plug-in class. That way, preferences can
 * be accessed directly via the preference store.
 * 
 * @author Christian Stritzke
 */
public class NetIDEPreferences extends FieldEditorPreferencePage implements IWorkbenchPreferencePage {

	public new() {
		super(GRID);
		setPreferenceStore(Activator.getDefault().getPreferenceStore());
		setDescription("NetIDE Preferences");
	}

	/**
	 * Creates the field editors. Field editors are abstractions of
	 * the common GUI blocks needed to manipulate various types
	 * of preferences. Each field editor knows how to save and
	 * restore itself.
	 */
	override createFieldEditors() {
		addField(new FileFieldEditor(NetIDEPreferenceConstants.VAGRANT_PATH, "&Vagrant path:", fieldEditorParent))
		addField(new FileFieldEditor(NetIDEPreferenceConstants.SSH_PATH, "&SSH Path:", fieldEditorParent))
		addField(new FileFieldEditor(NetIDEPreferenceConstants.SCP_PATH, "&SCP Path:", fieldEditorParent))
		addField(new BooleanFieldEditor(NetIDEPreferenceConstants.PROXY_ON, "&Use Proxy:", fieldEditorParent))
		addField(new StringFieldEditor(NetIDEPreferenceConstants.PROXY_ADDRESS, "Proxy Address:", fieldEditorParent))
		addField(new BooleanFieldEditor(NetIDEPreferenceConstants.CUSTOM_BOX, "Use Custom Box:", fieldEditorParent))
		addField(
			new StringFieldEditor(NetIDEPreferenceConstants.CUSTOM_BOX_NAME, "Custom Box Name:", fieldEditorParent))

		addField(new ListEditor(NetIDEPreferenceConstants.ZMQ_LIST, "ZeroMQ Sockets", fieldEditorParent) {

			override protected createList(String[] items) {
				return items.reduce[p1, p2|p1 + ";" + p2]
			}

			override protected getNewInputObject() {
				var dialog = new ZmqAddressDialog(shell)
				dialog.create
				if (dialog.open == Window.OK)
					return String.format("%s,%s", dialog.name, dialog.address)
				return null
			}

			override protected parseString(String stringList) {
				return stringList.split(";")
			}

		})

	}

	/* (non-Javadoc)
	 * @see IWorkbenchPreferencePage#init(org.eclipse.ui.IWorkbench)
	 */
	override init(IWorkbench workbench) {
	}

}

package eu.netide.configuration.preferences;

import org.eclipse.jface.preference.BooleanFieldEditor
import org.eclipse.jface.preference.DirectoryFieldEditor
import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.jface.preference.RadioGroupFieldEditor
import org.eclipse.jface.preference.StringFieldEditor
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage
import org.eclipse.jface.preference.FileFieldEditor

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
		addField(new BooleanFieldEditor(NetIDEPreferenceConstants.PROXY_ON, "&Use Proxy:", fieldEditorParent))
		addField(new StringFieldEditor(NetIDEPreferenceConstants.PROXY_ADDRESS, "Proxy Address:", fieldEditorParent))
		addField(new BooleanFieldEditor(NetIDEPreferenceConstants.CUSTOM_BOX, "Use Custom Box:", fieldEditorParent))
		addField(new StringFieldEditor(NetIDEPreferenceConstants.CUSTOM_BOX_NAME, "Custom Box Name:", fieldEditorParent))
		
//		addField(
//			new BooleanFieldEditor(PreferenceConstants.P_BOOLEAN, "&An example of a boolean preference",
//				getFieldEditorParent()));

//		addField(
//			new RadioGroupFieldEditor(
//				PreferenceConstants.P_CHOICE,
//				"An example of a multiple-choice preference",
//				1,
//				#[#[ "&Choice 1","choice1"	], #["C&hoice 2", "choice2" ]], getFieldEditorParent()));
//		addField(
//			new StringFieldEditor(PreferenceConstants.P_STRING, "A &text preference:", getFieldEditorParent()));
	}

	/* (non-Javadoc)
	 * @see IWorkbenchPreferencePage#init(org.eclipse.ui.IWorkbench)
	 */
	override init(IWorkbench workbench) {
	}
	
}

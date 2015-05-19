/**
 */
package sysreq;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Software</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link sysreq.Software#getControllers <em>Controllers</em>}</li>
 *   <li>{@link sysreq.Software#getProgramminglanguages <em>Programminglanguages</em>}</li>
 *   <li>{@link sysreq.Software#getLibraries <em>Libraries</em>}</li>
 * </ul>
 * </p>
 *
 * @see sysreq.SysreqPackage#getSoftware()
 * @model
 * @generated
 */
public interface Software extends EObject {
	/**
	 * Returns the value of the '<em><b>Controllers</b></em>' containment reference list.
	 * The list contents are of type {@link sysreq.Controller}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Controllers</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Controllers</em>' containment reference list.
	 * @see sysreq.SysreqPackage#getSoftware_Controllers()
	 * @model containment="true"
	 * @generated
	 */
	EList<Controller> getControllers();

	/**
	 * Returns the value of the '<em><b>Programminglanguages</b></em>' containment reference list.
	 * The list contents are of type {@link sysreq.ProgrammingLanguage}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Programminglanguages</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Programminglanguages</em>' containment reference list.
	 * @see sysreq.SysreqPackage#getSoftware_Programminglanguages()
	 * @model containment="true"
	 * @generated
	 */
	EList<ProgrammingLanguage> getProgramminglanguages();

	/**
	 * Returns the value of the '<em><b>Libraries</b></em>' containment reference list.
	 * The list contents are of type {@link sysreq.Library}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Libraries</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Libraries</em>' containment reference list.
	 * @see sysreq.SysreqPackage#getSoftware_Libraries()
	 * @model containment="true"
	 * @generated
	 */
	EList<Library> getLibraries();

} // Software

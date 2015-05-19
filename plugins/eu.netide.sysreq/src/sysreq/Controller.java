/**
 */
package sysreq;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Controller</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link sysreq.Controller#getName <em>Name</em>}</li>
 *   <li>{@link sysreq.Controller#getVersion <em>Version</em>}</li>
 *   <li>{@link sysreq.Controller#getProgramminglanguages <em>Programminglanguages</em>}</li>
 * </ul>
 * </p>
 *
 * @see sysreq.SysreqPackage#getController()
 * @model
 * @generated
 */
public interface Controller extends EObject {
	/**
	 * Returns the value of the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Name</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Name</em>' attribute.
	 * @see #setName(String)
	 * @see sysreq.SysreqPackage#getController_Name()
	 * @model required="true"
	 * @generated
	 */
	String getName();

	/**
	 * Sets the value of the '{@link sysreq.Controller#getName <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Name</em>' attribute.
	 * @see #getName()
	 * @generated
	 */
	void setName(String value);

	/**
	 * Returns the value of the '<em><b>Version</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Version</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Version</em>' attribute.
	 * @see #setVersion(String)
	 * @see sysreq.SysreqPackage#getController_Version()
	 * @model
	 * @generated
	 */
	String getVersion();

	/**
	 * Sets the value of the '{@link sysreq.Controller#getVersion <em>Version</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Version</em>' attribute.
	 * @see #getVersion()
	 * @generated
	 */
	void setVersion(String value);

	/**
	 * Returns the value of the '<em><b>Programminglanguages</b></em>' reference list.
	 * The list contents are of type {@link sysreq.ProgrammingLanguage}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Programminglanguages</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Programminglanguages</em>' reference list.
	 * @see sysreq.SysreqPackage#getController_Programminglanguages()
	 * @model ordered="false"
	 * @generated
	 */
	EList<ProgrammingLanguage> getProgramminglanguages();

} // Controller

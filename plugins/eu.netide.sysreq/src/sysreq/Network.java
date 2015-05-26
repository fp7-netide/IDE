/**
 */
package sysreq;

import Topology.NetworkEnvironment;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Network</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link sysreq.Network#getSwitchtype <em>Switchtype</em>}</li>
 *   <li>{@link sysreq.Network#getOf_version <em>Of version</em>}</li>
 *   <li>{@link sysreq.Network#getTopologyrequirements <em>Topologyrequirements</em>}</li>
 * </ul>
 * </p>
 *
 * @see sysreq.SysreqPackage#getNetwork()
 * @model
 * @generated
 */
public interface Network extends EObject {
	/**
	 * Returns the value of the '<em><b>Switchtype</b></em>' attribute list.
	 * The list contents are of type {@link java.lang.String}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Switchtype</em>' attribute list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Switchtype</em>' attribute list.
	 * @see sysreq.SysreqPackage#getNetwork_Switchtype()
	 * @model ordered="false"
	 * @generated
	 */
	EList<String> getSwitchtype();

	/**
	 * Returns the value of the '<em><b>Of version</b></em>' attribute list.
	 * The list contents are of type {@link java.lang.String}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Of version</em>' attribute list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Of version</em>' attribute list.
	 * @see sysreq.SysreqPackage#getNetwork_Of_version()
	 * @model ordered="false"
	 * @generated
	 */
	EList<String> getOf_version();

	/**
	 * Returns the value of the '<em><b>Topologyrequirements</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Topologyrequirements</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Topologyrequirements</em>' reference.
	 * @see #setTopologyrequirements(NetworkEnvironment)
	 * @see sysreq.SysreqPackage#getNetwork_Topologyrequirements()
	 * @model
	 * @generated
	 */
	NetworkEnvironment getTopologyrequirements();

	/**
	 * Sets the value of the '{@link sysreq.Network#getTopologyrequirements <em>Topologyrequirements</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Topologyrequirements</em>' reference.
	 * @see #getTopologyrequirements()
	 * @generated
	 */
	void setTopologyrequirements(NetworkEnvironment value);

} // Network

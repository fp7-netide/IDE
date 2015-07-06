/**
 */
package sysreq;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>System Requirements</b></em>'.
 * <!-- end-user-doc -->
 *
 * <!-- begin-model-doc -->
 * Root Element
 * <!-- end-model-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link sysreq.SystemRequirements#getHardware <em>Hardware</em>}</li>
 *   <li>{@link sysreq.SystemRequirements#getSoftware <em>Software</em>}</li>
 *   <li>{@link sysreq.SystemRequirements#getNetwork <em>Network</em>}</li>
 * </ul>
 * </p>
 *
 * @see sysreq.SysreqPackage#getSystemRequirements()
 * @model
 * @generated
 */
public interface SystemRequirements extends EObject {
	/**
	 * Returns the value of the '<em><b>Hardware</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Hardware</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Hardware</em>' containment reference.
	 * @see #setHardware(Hardware)
	 * @see sysreq.SysreqPackage#getSystemRequirements_Hardware()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Hardware getHardware();

	/**
	 * Sets the value of the '{@link sysreq.SystemRequirements#getHardware <em>Hardware</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Hardware</em>' containment reference.
	 * @see #getHardware()
	 * @generated
	 */
	void setHardware(Hardware value);

	/**
	 * Returns the value of the '<em><b>Software</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Software</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Software</em>' containment reference.
	 * @see #setSoftware(Software)
	 * @see sysreq.SysreqPackage#getSystemRequirements_Software()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Software getSoftware();

	/**
	 * Sets the value of the '{@link sysreq.SystemRequirements#getSoftware <em>Software</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Software</em>' containment reference.
	 * @see #getSoftware()
	 * @generated
	 */
	void setSoftware(Software value);

	/**
	 * Returns the value of the '<em><b>Network</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Network</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Network</em>' containment reference.
	 * @see #setNetwork(Network)
	 * @see sysreq.SysreqPackage#getSystemRequirements_Network()
	 * @model containment="true" required="true"
	 * @generated
	 */
	Network getNetwork();

	/**
	 * Sets the value of the '{@link sysreq.SystemRequirements#getNetwork <em>Network</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Network</em>' containment reference.
	 * @see #getNetwork()
	 * @generated
	 */
	void setNetwork(Network value);

} // SystemRequirements

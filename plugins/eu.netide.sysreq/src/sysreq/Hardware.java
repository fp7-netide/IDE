/**
 */
package sysreq;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Hardware</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link sysreq.Hardware#getArch <em>Arch</em>}</li>
 *   <li>{@link sysreq.Hardware#getCpucores <em>Cpucores</em>}</li>
 *   <li>{@link sysreq.Hardware#getCpufreq <em>Cpufreq</em>}</li>
 *   <li>{@link sysreq.Hardware#getMemory <em>Memory</em>}</li>
 * </ul>
 * </p>
 *
 * @see sysreq.SysreqPackage#getHardware()
 * @model
 * @generated
 */
public interface Hardware extends EObject {
	/**
	 * Returns the value of the '<em><b>Arch</b></em>' attribute list.
	 * The list contents are of type {@link java.lang.String}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Arch</em>' attribute list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Arch</em>' attribute list.
	 * @see sysreq.SysreqPackage#getHardware_Arch()
	 * @model ordered="false"
	 * @generated
	 */
	EList<String> getArch();

	/**
	 * Returns the value of the '<em><b>Cpucores</b></em>' attribute.
	 * The default value is <code>"1"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Cpucores</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Cpucores</em>' attribute.
	 * @see #setCpucores(int)
	 * @see sysreq.SysreqPackage#getHardware_Cpucores()
	 * @model default="1"
	 * @generated
	 */
	int getCpucores();

	/**
	 * Sets the value of the '{@link sysreq.Hardware#getCpucores <em>Cpucores</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Cpucores</em>' attribute.
	 * @see #getCpucores()
	 * @generated
	 */
	void setCpucores(int value);

	/**
	 * Returns the value of the '<em><b>Cpufreq</b></em>' attribute.
	 * The default value is <code>"800"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Cpufreq</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Cpufreq</em>' attribute.
	 * @see #setCpufreq(int)
	 * @see sysreq.SysreqPackage#getHardware_Cpufreq()
	 * @model default="800"
	 * @generated
	 */
	int getCpufreq();

	/**
	 * Sets the value of the '{@link sysreq.Hardware#getCpufreq <em>Cpufreq</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Cpufreq</em>' attribute.
	 * @see #getCpufreq()
	 * @generated
	 */
	void setCpufreq(int value);

	/**
	 * Returns the value of the '<em><b>Memory</b></em>' attribute.
	 * The default value is <code>"512"</code>.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Memory</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Memory</em>' attribute.
	 * @see #setMemory(int)
	 * @see sysreq.SysreqPackage#getHardware_Memory()
	 * @model default="512"
	 * @generated
	 */
	int getMemory();

	/**
	 * Sets the value of the '{@link sysreq.Hardware#getMemory <em>Memory</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Memory</em>' attribute.
	 * @see #getMemory()
	 * @generated
	 */
	void setMemory(int value);

} // Hardware

/**
 */
package parameters;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Basic Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link parameters.BasicType#getAtomictype <em>Atomictype</em>}</li>
 * </ul>
 * </p>
 *
 * @see parameters.ParametersPackage#getBasicType()
 * @model
 * @generated
 */
public interface BasicType extends Type {

	/**
	 * Returns the value of the '<em><b>Atomictype</b></em>' attribute.
	 * The literals are from the enumeration {@link parameters.AtomicType}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Atomictype</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Atomictype</em>' attribute.
	 * @see parameters.AtomicType
	 * @see #setAtomictype(AtomicType)
	 * @see parameters.ParametersPackage#getBasicType_Atomictype()
	 * @model
	 * @generated
	 */
	AtomicType getAtomictype();

	/**
	 * Sets the value of the '{@link parameters.BasicType#getAtomictype <em>Atomictype</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Atomictype</em>' attribute.
	 * @see parameters.AtomicType
	 * @see #getAtomictype()
	 * @generated
	 */
	void setAtomictype(AtomicType value);
} // BasicType

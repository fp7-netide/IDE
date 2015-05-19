/**
 */
package parameters;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Composite Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link parameters.CompositeType#getInnertypes <em>Innertypes</em>}</li>
 * </ul>
 * </p>
 *
 * @see parameters.ParametersPackage#getCompositeType()
 * @model
 * @generated
 */
public interface CompositeType extends Type {
	/**
	 * Returns the value of the '<em><b>Innertypes</b></em>' reference list.
	 * The list contents are of type {@link parameters.Type}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Innertypes</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Innertypes</em>' reference list.
	 * @see parameters.ParametersPackage#getCompositeType_Innertypes()
	 * @model required="true"
	 * @generated
	 */
	EList<Type> getInnertypes();

} // CompositeType

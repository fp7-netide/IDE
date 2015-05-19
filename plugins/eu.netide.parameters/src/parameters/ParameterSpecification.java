/**
 */
package parameters;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Parameter Specification</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link parameters.ParameterSpecification#getTypes <em>Types</em>}</li>
 *   <li>{@link parameters.ParameterSpecification#getParameters <em>Parameters</em>}</li>
 * </ul>
 * </p>
 *
 * @see parameters.ParametersPackage#getParameterSpecification()
 * @model
 * @generated
 */
public interface ParameterSpecification extends EObject {
	/**
	 * Returns the value of the '<em><b>Types</b></em>' containment reference list.
	 * The list contents are of type {@link parameters.Type}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Types</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Types</em>' containment reference list.
	 * @see parameters.ParametersPackage#getParameterSpecification_Types()
	 * @model containment="true"
	 * @generated
	 */
	EList<Type> getTypes();

	/**
	 * Returns the value of the '<em><b>Parameters</b></em>' containment reference list.
	 * The list contents are of type {@link parameters.Parameter}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Parameters</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Parameters</em>' containment reference list.
	 * @see parameters.ParametersPackage#getParameterSpecification_Parameters()
	 * @model containment="true"
	 * @generated
	 */
	EList<Parameter> getParameters();

} // ParameterSpecification

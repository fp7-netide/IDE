/**
 */
package parameters;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

/**
 * <!-- begin-user-doc -->
 * The <b>Package</b> for the model.
 * It contains accessors for the meta objects to represent
 * <ul>
 *   <li>each class,</li>
 *   <li>each feature of each class,</li>
 *   <li>each operation of each class,</li>
 *   <li>each enum,</li>
 *   <li>and each data type</li>
 * </ul>
 * <!-- end-user-doc -->
 * @see parameters.ParametersFactory
 * @model kind="package"
 * @generated
 */
public interface ParametersPackage extends EPackage {
	/**
	 * The package name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNAME = "parameters";

	/**
	 * The package namespace URI.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNS_URI = "eu.netide.parameters";

	/**
	 * The package namespace name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNS_PREFIX = "eu.netide";

	/**
	 * The singleton instance of the package.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	ParametersPackage eINSTANCE = parameters.impl.ParametersPackageImpl.init();

	/**
	 * The meta object id for the '{@link parameters.impl.ParameterImpl <em>Parameter</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see parameters.impl.ParameterImpl
	 * @see parameters.impl.ParametersPackageImpl#getParameter()
	 * @generated
	 */
	int PARAMETER = 0;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER__NAME = 0;

	/**
	 * The feature id for the '<em><b>Type</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER__TYPE = 1;

	/**
	 * The number of structural features of the '<em>Parameter</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER_FEATURE_COUNT = 2;

	/**
	 * The number of operations of the '<em>Parameter</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link parameters.impl.ParameterSpecificationImpl <em>Parameter Specification</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see parameters.impl.ParameterSpecificationImpl
	 * @see parameters.impl.ParametersPackageImpl#getParameterSpecification()
	 * @generated
	 */
	int PARAMETER_SPECIFICATION = 1;

	/**
	 * The feature id for the '<em><b>Types</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER_SPECIFICATION__TYPES = 0;

	/**
	 * The feature id for the '<em><b>Parameters</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER_SPECIFICATION__PARAMETERS = 1;

	/**
	 * The number of structural features of the '<em>Parameter Specification</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER_SPECIFICATION_FEATURE_COUNT = 2;

	/**
	 * The number of operations of the '<em>Parameter Specification</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PARAMETER_SPECIFICATION_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link parameters.impl.TypeImpl <em>Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see parameters.impl.TypeImpl
	 * @see parameters.impl.ParametersPackageImpl#getType()
	 * @generated
	 */
	int TYPE = 2;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TYPE__NAME = 0;

	/**
	 * The feature id for the '<em><b>Constraints</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TYPE__CONSTRAINTS = 1;

	/**
	 * The number of structural features of the '<em>Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TYPE_FEATURE_COUNT = 2;

	/**
	 * The number of operations of the '<em>Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int TYPE_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link parameters.impl.CompositeTypeImpl <em>Composite Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see parameters.impl.CompositeTypeImpl
	 * @see parameters.impl.ParametersPackageImpl#getCompositeType()
	 * @generated
	 */
	int COMPOSITE_TYPE = 3;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int COMPOSITE_TYPE__NAME = TYPE__NAME;

	/**
	 * The feature id for the '<em><b>Constraints</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int COMPOSITE_TYPE__CONSTRAINTS = TYPE__CONSTRAINTS;

	/**
	 * The feature id for the '<em><b>Innertypes</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int COMPOSITE_TYPE__INNERTYPES = TYPE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Composite Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int COMPOSITE_TYPE_FEATURE_COUNT = TYPE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Composite Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int COMPOSITE_TYPE_OPERATION_COUNT = TYPE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link parameters.impl.BasicTypeImpl <em>Basic Type</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see parameters.impl.BasicTypeImpl
	 * @see parameters.impl.ParametersPackageImpl#getBasicType()
	 * @generated
	 */
	int BASIC_TYPE = 4;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASIC_TYPE__NAME = TYPE__NAME;

	/**
	 * The feature id for the '<em><b>Constraints</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASIC_TYPE__CONSTRAINTS = TYPE__CONSTRAINTS;

	/**
	 * The feature id for the '<em><b>Atomictype</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASIC_TYPE__ATOMICTYPE = TYPE_FEATURE_COUNT + 0;

	/**
	 * The number of structural features of the '<em>Basic Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASIC_TYPE_FEATURE_COUNT = TYPE_FEATURE_COUNT + 1;

	/**
	 * The number of operations of the '<em>Basic Type</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int BASIC_TYPE_OPERATION_COUNT = TYPE_OPERATION_COUNT + 0;

	/**
	 * The meta object id for the '{@link parameters.impl.ConstraintImpl <em>Constraint</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see parameters.impl.ConstraintImpl
	 * @see parameters.impl.ParametersPackageImpl#getConstraint()
	 * @generated
	 */
	int CONSTRAINT = 5;

	/**
	 * The feature id for the '<em><b>Constraint</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONSTRAINT__CONSTRAINT = 0;

	/**
	 * The number of structural features of the '<em>Constraint</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONSTRAINT_FEATURE_COUNT = 1;

	/**
	 * The number of operations of the '<em>Constraint</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONSTRAINT_OPERATION_COUNT = 0;


	/**
	 * The meta object id for the '{@link parameters.AtomicType <em>Atomic Type</em>}' enum.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see parameters.AtomicType
	 * @see parameters.impl.ParametersPackageImpl#getAtomicType()
	 * @generated
	 */
	int ATOMIC_TYPE = 6;

	/**
	 * Returns the meta object for class '{@link parameters.Parameter <em>Parameter</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Parameter</em>'.
	 * @see parameters.Parameter
	 * @generated
	 */
	EClass getParameter();

	/**
	 * Returns the meta object for the attribute '{@link parameters.Parameter#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see parameters.Parameter#getName()
	 * @see #getParameter()
	 * @generated
	 */
	EAttribute getParameter_Name();

	/**
	 * Returns the meta object for the reference '{@link parameters.Parameter#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Type</em>'.
	 * @see parameters.Parameter#getType()
	 * @see #getParameter()
	 * @generated
	 */
	EReference getParameter_Type();

	/**
	 * Returns the meta object for class '{@link parameters.ParameterSpecification <em>Parameter Specification</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Parameter Specification</em>'.
	 * @see parameters.ParameterSpecification
	 * @generated
	 */
	EClass getParameterSpecification();

	/**
	 * Returns the meta object for the containment reference list '{@link parameters.ParameterSpecification#getTypes <em>Types</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Types</em>'.
	 * @see parameters.ParameterSpecification#getTypes()
	 * @see #getParameterSpecification()
	 * @generated
	 */
	EReference getParameterSpecification_Types();

	/**
	 * Returns the meta object for the containment reference list '{@link parameters.ParameterSpecification#getParameters <em>Parameters</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Parameters</em>'.
	 * @see parameters.ParameterSpecification#getParameters()
	 * @see #getParameterSpecification()
	 * @generated
	 */
	EReference getParameterSpecification_Parameters();

	/**
	 * Returns the meta object for class '{@link parameters.Type <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Type</em>'.
	 * @see parameters.Type
	 * @generated
	 */
	EClass getType();

	/**
	 * Returns the meta object for the attribute '{@link parameters.Type#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see parameters.Type#getName()
	 * @see #getType()
	 * @generated
	 */
	EAttribute getType_Name();

	/**
	 * Returns the meta object for the containment reference list '{@link parameters.Type#getConstraints <em>Constraints</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Constraints</em>'.
	 * @see parameters.Type#getConstraints()
	 * @see #getType()
	 * @generated
	 */
	EReference getType_Constraints();

	/**
	 * Returns the meta object for class '{@link parameters.CompositeType <em>Composite Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Composite Type</em>'.
	 * @see parameters.CompositeType
	 * @generated
	 */
	EClass getCompositeType();

	/**
	 * Returns the meta object for the reference list '{@link parameters.CompositeType#getInnertypes <em>Innertypes</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Innertypes</em>'.
	 * @see parameters.CompositeType#getInnertypes()
	 * @see #getCompositeType()
	 * @generated
	 */
	EReference getCompositeType_Innertypes();

	/**
	 * Returns the meta object for class '{@link parameters.BasicType <em>Basic Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Basic Type</em>'.
	 * @see parameters.BasicType
	 * @generated
	 */
	EClass getBasicType();

	/**
	 * Returns the meta object for the attribute '{@link parameters.BasicType#getAtomictype <em>Atomictype</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Atomictype</em>'.
	 * @see parameters.BasicType#getAtomictype()
	 * @see #getBasicType()
	 * @generated
	 */
	EAttribute getBasicType_Atomictype();

	/**
	 * Returns the meta object for class '{@link parameters.Constraint <em>Constraint</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Constraint</em>'.
	 * @see parameters.Constraint
	 * @generated
	 */
	EClass getConstraint();

	/**
	 * Returns the meta object for the attribute '{@link parameters.Constraint#getConstraint <em>Constraint</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Constraint</em>'.
	 * @see parameters.Constraint#getConstraint()
	 * @see #getConstraint()
	 * @generated
	 */
	EAttribute getConstraint_Constraint();

	/**
	 * Returns the meta object for enum '{@link parameters.AtomicType <em>Atomic Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for enum '<em>Atomic Type</em>'.
	 * @see parameters.AtomicType
	 * @generated
	 */
	EEnum getAtomicType();

	/**
	 * Returns the factory that creates the instances of the model.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the factory that creates the instances of the model.
	 * @generated
	 */
	ParametersFactory getParametersFactory();

	/**
	 * <!-- begin-user-doc -->
	 * Defines literals for the meta objects that represent
	 * <ul>
	 *   <li>each class,</li>
	 *   <li>each feature of each class,</li>
	 *   <li>each operation of each class,</li>
	 *   <li>each enum,</li>
	 *   <li>and each data type</li>
	 * </ul>
	 * <!-- end-user-doc -->
	 * @generated
	 */
	interface Literals {
		/**
		 * The meta object literal for the '{@link parameters.impl.ParameterImpl <em>Parameter</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see parameters.impl.ParameterImpl
		 * @see parameters.impl.ParametersPackageImpl#getParameter()
		 * @generated
		 */
		EClass PARAMETER = eINSTANCE.getParameter();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute PARAMETER__NAME = eINSTANCE.getParameter_Name();

		/**
		 * The meta object literal for the '<em><b>Type</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference PARAMETER__TYPE = eINSTANCE.getParameter_Type();

		/**
		 * The meta object literal for the '{@link parameters.impl.ParameterSpecificationImpl <em>Parameter Specification</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see parameters.impl.ParameterSpecificationImpl
		 * @see parameters.impl.ParametersPackageImpl#getParameterSpecification()
		 * @generated
		 */
		EClass PARAMETER_SPECIFICATION = eINSTANCE.getParameterSpecification();

		/**
		 * The meta object literal for the '<em><b>Types</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference PARAMETER_SPECIFICATION__TYPES = eINSTANCE.getParameterSpecification_Types();

		/**
		 * The meta object literal for the '<em><b>Parameters</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference PARAMETER_SPECIFICATION__PARAMETERS = eINSTANCE.getParameterSpecification_Parameters();

		/**
		 * The meta object literal for the '{@link parameters.impl.TypeImpl <em>Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see parameters.impl.TypeImpl
		 * @see parameters.impl.ParametersPackageImpl#getType()
		 * @generated
		 */
		EClass TYPE = eINSTANCE.getType();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute TYPE__NAME = eINSTANCE.getType_Name();

		/**
		 * The meta object literal for the '<em><b>Constraints</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference TYPE__CONSTRAINTS = eINSTANCE.getType_Constraints();

		/**
		 * The meta object literal for the '{@link parameters.impl.CompositeTypeImpl <em>Composite Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see parameters.impl.CompositeTypeImpl
		 * @see parameters.impl.ParametersPackageImpl#getCompositeType()
		 * @generated
		 */
		EClass COMPOSITE_TYPE = eINSTANCE.getCompositeType();

		/**
		 * The meta object literal for the '<em><b>Innertypes</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference COMPOSITE_TYPE__INNERTYPES = eINSTANCE.getCompositeType_Innertypes();

		/**
		 * The meta object literal for the '{@link parameters.impl.BasicTypeImpl <em>Basic Type</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see parameters.impl.BasicTypeImpl
		 * @see parameters.impl.ParametersPackageImpl#getBasicType()
		 * @generated
		 */
		EClass BASIC_TYPE = eINSTANCE.getBasicType();

		/**
		 * The meta object literal for the '<em><b>Atomictype</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute BASIC_TYPE__ATOMICTYPE = eINSTANCE.getBasicType_Atomictype();

		/**
		 * The meta object literal for the '{@link parameters.impl.ConstraintImpl <em>Constraint</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see parameters.impl.ConstraintImpl
		 * @see parameters.impl.ParametersPackageImpl#getConstraint()
		 * @generated
		 */
		EClass CONSTRAINT = eINSTANCE.getConstraint();

		/**
		 * The meta object literal for the '<em><b>Constraint</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute CONSTRAINT__CONSTRAINT = eINSTANCE.getConstraint_Constraint();

		/**
		 * The meta object literal for the '{@link parameters.AtomicType <em>Atomic Type</em>}' enum.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see parameters.AtomicType
		 * @see parameters.impl.ParametersPackageImpl#getAtomicType()
		 * @generated
		 */
		EEnum ATOMIC_TYPE = eINSTANCE.getAtomicType();

	}

} //ParametersPackage

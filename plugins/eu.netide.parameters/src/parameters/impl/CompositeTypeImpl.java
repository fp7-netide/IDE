/**
 */
package parameters.impl;

import java.util.Collection;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.util.EObjectResolvingEList;

import parameters.CompositeType;
import parameters.ParametersPackage;
import parameters.Type;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Composite Type</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link parameters.impl.CompositeTypeImpl#getInnertypes <em>Innertypes</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class CompositeTypeImpl extends TypeImpl implements CompositeType {
	/**
	 * The cached value of the '{@link #getInnertypes() <em>Innertypes</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInnertypes()
	 * @generated
	 * @ordered
	 */
	protected EList<Type> innertypes;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected CompositeTypeImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return ParametersPackage.Literals.COMPOSITE_TYPE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Type> getInnertypes() {
		if (innertypes == null) {
			innertypes = new EObjectResolvingEList<Type>(Type.class, this, ParametersPackage.COMPOSITE_TYPE__INNERTYPES);
		}
		return innertypes;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case ParametersPackage.COMPOSITE_TYPE__INNERTYPES:
				return getInnertypes();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case ParametersPackage.COMPOSITE_TYPE__INNERTYPES:
				getInnertypes().clear();
				getInnertypes().addAll((Collection<? extends Type>)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case ParametersPackage.COMPOSITE_TYPE__INNERTYPES:
				getInnertypes().clear();
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case ParametersPackage.COMPOSITE_TYPE__INNERTYPES:
				return innertypes != null && !innertypes.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //CompositeTypeImpl

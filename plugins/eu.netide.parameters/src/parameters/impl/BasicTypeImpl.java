/**
 */
package parameters.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import parameters.AtomicType;
import parameters.BasicType;
import parameters.ParametersPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Basic Type</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link parameters.impl.BasicTypeImpl#getAtomictype <em>Atomictype</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class BasicTypeImpl extends TypeImpl implements BasicType {
	/**
	 * The default value of the '{@link #getAtomictype() <em>Atomictype</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAtomictype()
	 * @generated
	 * @ordered
	 */
	protected static final AtomicType ATOMICTYPE_EDEFAULT = AtomicType.STRING;
	/**
	 * The cached value of the '{@link #getAtomictype() <em>Atomictype</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAtomictype()
	 * @generated
	 * @ordered
	 */
	protected AtomicType atomictype = ATOMICTYPE_EDEFAULT;
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected BasicTypeImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return ParametersPackage.Literals.BASIC_TYPE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public AtomicType getAtomictype() {
		return atomictype;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setAtomictype(AtomicType newAtomictype) {
		AtomicType oldAtomictype = atomictype;
		atomictype = newAtomictype == null ? ATOMICTYPE_EDEFAULT : newAtomictype;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ParametersPackage.BASIC_TYPE__ATOMICTYPE, oldAtomictype, atomictype));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case ParametersPackage.BASIC_TYPE__ATOMICTYPE:
				return getAtomictype();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case ParametersPackage.BASIC_TYPE__ATOMICTYPE:
				setAtomictype((AtomicType)newValue);
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
			case ParametersPackage.BASIC_TYPE__ATOMICTYPE:
				setAtomictype(ATOMICTYPE_EDEFAULT);
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
			case ParametersPackage.BASIC_TYPE__ATOMICTYPE:
				return atomictype != ATOMICTYPE_EDEFAULT;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuffer result = new StringBuffer(super.toString());
		result.append(" (atomictype: ");
		result.append(atomictype);
		result.append(')');
		return result.toString();
	}

} //BasicTypeImpl

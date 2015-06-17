/**
 */
package sysreq.impl;

import Topology.NetworkEnvironment;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EDataTypeUniqueEList;

import sysreq.Network;
import sysreq.SysreqPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Network</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link sysreq.impl.NetworkImpl#getSwitchtype <em>Switchtype</em>}</li>
 *   <li>{@link sysreq.impl.NetworkImpl#getOf_version <em>Of version</em>}</li>
 *   <li>{@link sysreq.impl.NetworkImpl#getTopologyrequirements <em>Topologyrequirements</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class NetworkImpl extends MinimalEObjectImpl.Container implements Network {
	/**
	 * The cached value of the '{@link #getSwitchtype() <em>Switchtype</em>}' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSwitchtype()
	 * @generated
	 * @ordered
	 */
	protected EList<String> switchtype;

	/**
	 * The cached value of the '{@link #getOf_version() <em>Of version</em>}' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOf_version()
	 * @generated
	 * @ordered
	 */
	protected EList<String> of_version;

	/**
	 * The cached value of the '{@link #getTopologyrequirements() <em>Topologyrequirements</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTopologyrequirements()
	 * @generated
	 * @ordered
	 */
	protected NetworkEnvironment topologyrequirements;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected NetworkImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return SysreqPackage.Literals.NETWORK;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<String> getSwitchtype() {
		if (switchtype == null) {
			switchtype = new EDataTypeUniqueEList<String>(String.class, this, SysreqPackage.NETWORK__SWITCHTYPE);
		}
		return switchtype;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<String> getOf_version() {
		if (of_version == null) {
			of_version = new EDataTypeUniqueEList<String>(String.class, this, SysreqPackage.NETWORK__OF_VERSION);
		}
		return of_version;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NetworkEnvironment getTopologyrequirements() {
		if (topologyrequirements != null && topologyrequirements.eIsProxy()) {
			InternalEObject oldTopologyrequirements = (InternalEObject)topologyrequirements;
			topologyrequirements = (NetworkEnvironment)eResolveProxy(oldTopologyrequirements);
			if (topologyrequirements != oldTopologyrequirements) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, SysreqPackage.NETWORK__TOPOLOGYREQUIREMENTS, oldTopologyrequirements, topologyrequirements));
			}
		}
		return topologyrequirements;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NetworkEnvironment basicGetTopologyrequirements() {
		return topologyrequirements;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setTopologyrequirements(NetworkEnvironment newTopologyrequirements) {
		NetworkEnvironment oldTopologyrequirements = topologyrequirements;
		topologyrequirements = newTopologyrequirements;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.NETWORK__TOPOLOGYREQUIREMENTS, oldTopologyrequirements, topologyrequirements));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case SysreqPackage.NETWORK__SWITCHTYPE:
				return getSwitchtype();
			case SysreqPackage.NETWORK__OF_VERSION:
				return getOf_version();
			case SysreqPackage.NETWORK__TOPOLOGYREQUIREMENTS:
				if (resolve) return getTopologyrequirements();
				return basicGetTopologyrequirements();
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
			case SysreqPackage.NETWORK__SWITCHTYPE:
				getSwitchtype().clear();
				getSwitchtype().addAll((Collection<? extends String>)newValue);
				return;
			case SysreqPackage.NETWORK__OF_VERSION:
				getOf_version().clear();
				getOf_version().addAll((Collection<? extends String>)newValue);
				return;
			case SysreqPackage.NETWORK__TOPOLOGYREQUIREMENTS:
				setTopologyrequirements((NetworkEnvironment)newValue);
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
			case SysreqPackage.NETWORK__SWITCHTYPE:
				getSwitchtype().clear();
				return;
			case SysreqPackage.NETWORK__OF_VERSION:
				getOf_version().clear();
				return;
			case SysreqPackage.NETWORK__TOPOLOGYREQUIREMENTS:
				setTopologyrequirements((NetworkEnvironment)null);
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
			case SysreqPackage.NETWORK__SWITCHTYPE:
				return switchtype != null && !switchtype.isEmpty();
			case SysreqPackage.NETWORK__OF_VERSION:
				return of_version != null && !of_version.isEmpty();
			case SysreqPackage.NETWORK__TOPOLOGYREQUIREMENTS:
				return topologyrequirements != null;
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
		result.append(" (switchtype: ");
		result.append(switchtype);
		result.append(", of_version: ");
		result.append(of_version);
		result.append(')');
		return result.toString();
	}

} //NetworkImpl

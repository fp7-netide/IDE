/**
 */
package sysreq.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import sysreq.Hardware;
import sysreq.Network;
import sysreq.Software;
import sysreq.SysreqPackage;
import sysreq.SystemRequirements;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>System Requirements</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link sysreq.impl.SystemRequirementsImpl#getHardware <em>Hardware</em>}</li>
 *   <li>{@link sysreq.impl.SystemRequirementsImpl#getSoftware <em>Software</em>}</li>
 *   <li>{@link sysreq.impl.SystemRequirementsImpl#getNetwork <em>Network</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class SystemRequirementsImpl extends MinimalEObjectImpl.Container implements SystemRequirements {
	/**
	 * The cached value of the '{@link #getHardware() <em>Hardware</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getHardware()
	 * @generated
	 * @ordered
	 */
	protected Hardware hardware;

	/**
	 * The cached value of the '{@link #getSoftware() <em>Software</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSoftware()
	 * @generated
	 * @ordered
	 */
	protected Software software;

	/**
	 * The cached value of the '{@link #getNetwork() <em>Network</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNetwork()
	 * @generated
	 * @ordered
	 */
	protected Network network;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected SystemRequirementsImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return SysreqPackage.Literals.SYSTEM_REQUIREMENTS;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Hardware getHardware() {
		return hardware;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetHardware(Hardware newHardware, NotificationChain msgs) {
		Hardware oldHardware = hardware;
		hardware = newHardware;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE, oldHardware, newHardware);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setHardware(Hardware newHardware) {
		if (newHardware != hardware) {
			NotificationChain msgs = null;
			if (hardware != null)
				msgs = ((InternalEObject)hardware).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE, null, msgs);
			if (newHardware != null)
				msgs = ((InternalEObject)newHardware).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE, null, msgs);
			msgs = basicSetHardware(newHardware, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE, newHardware, newHardware));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Software getSoftware() {
		return software;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetSoftware(Software newSoftware, NotificationChain msgs) {
		Software oldSoftware = software;
		software = newSoftware;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE, oldSoftware, newSoftware);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setSoftware(Software newSoftware) {
		if (newSoftware != software) {
			NotificationChain msgs = null;
			if (software != null)
				msgs = ((InternalEObject)software).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE, null, msgs);
			if (newSoftware != null)
				msgs = ((InternalEObject)newSoftware).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE, null, msgs);
			msgs = basicSetSoftware(newSoftware, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE, newSoftware, newSoftware));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Network getNetwork() {
		return network;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetNetwork(Network newNetwork, NotificationChain msgs) {
		Network oldNetwork = network;
		network = newNetwork;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK, oldNetwork, newNetwork);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setNetwork(Network newNetwork) {
		if (newNetwork != network) {
			NotificationChain msgs = null;
			if (network != null)
				msgs = ((InternalEObject)network).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK, null, msgs);
			if (newNetwork != null)
				msgs = ((InternalEObject)newNetwork).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK, null, msgs);
			msgs = basicSetNetwork(newNetwork, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK, newNetwork, newNetwork));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE:
				return basicSetHardware(null, msgs);
			case SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE:
				return basicSetSoftware(null, msgs);
			case SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK:
				return basicSetNetwork(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE:
				return getHardware();
			case SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE:
				return getSoftware();
			case SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK:
				return getNetwork();
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
			case SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE:
				setHardware((Hardware)newValue);
				return;
			case SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE:
				setSoftware((Software)newValue);
				return;
			case SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK:
				setNetwork((Network)newValue);
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
			case SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE:
				setHardware((Hardware)null);
				return;
			case SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE:
				setSoftware((Software)null);
				return;
			case SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK:
				setNetwork((Network)null);
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
			case SysreqPackage.SYSTEM_REQUIREMENTS__HARDWARE:
				return hardware != null;
			case SysreqPackage.SYSTEM_REQUIREMENTS__SOFTWARE:
				return software != null;
			case SysreqPackage.SYSTEM_REQUIREMENTS__NETWORK:
				return network != null;
		}
		return super.eIsSet(featureID);
	}

} //SystemRequirementsImpl

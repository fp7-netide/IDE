/**
 */
package sysreq.impl;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import sysreq.Library;
import sysreq.ProgrammingLanguage;
import sysreq.SysreqPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Library</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link sysreq.impl.LibraryImpl#getName <em>Name</em>}</li>
 *   <li>{@link sysreq.impl.LibraryImpl#getVersion <em>Version</em>}</li>
 *   <li>{@link sysreq.impl.LibraryImpl#getProgramminglanguage <em>Programminglanguage</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class LibraryImpl extends MinimalEObjectImpl.Container implements Library {
	/**
	 * The default value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected static final String NAME_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getName() <em>Name</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getName()
	 * @generated
	 * @ordered
	 */
	protected String name = NAME_EDEFAULT;

	/**
	 * The default value of the '{@link #getVersion() <em>Version</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVersion()
	 * @generated
	 * @ordered
	 */
	protected static final String VERSION_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getVersion() <em>Version</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getVersion()
	 * @generated
	 * @ordered
	 */
	protected String version = VERSION_EDEFAULT;

	/**
	 * The cached value of the '{@link #getProgramminglanguage() <em>Programminglanguage</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProgramminglanguage()
	 * @generated
	 * @ordered
	 */
	protected ProgrammingLanguage programminglanguage;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected LibraryImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return SysreqPackage.Literals.LIBRARY;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getName() {
		return name;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setName(String newName) {
		String oldName = name;
		name = newName;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.LIBRARY__NAME, oldName, name));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getVersion() {
		return version;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setVersion(String newVersion) {
		String oldVersion = version;
		version = newVersion;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.LIBRARY__VERSION, oldVersion, version));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ProgrammingLanguage getProgramminglanguage() {
		if (programminglanguage != null && programminglanguage.eIsProxy()) {
			InternalEObject oldProgramminglanguage = (InternalEObject)programminglanguage;
			programminglanguage = (ProgrammingLanguage)eResolveProxy(oldProgramminglanguage);
			if (programminglanguage != oldProgramminglanguage) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, SysreqPackage.LIBRARY__PROGRAMMINGLANGUAGE, oldProgramminglanguage, programminglanguage));
			}
		}
		return programminglanguage;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ProgrammingLanguage basicGetProgramminglanguage() {
		return programminglanguage;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setProgramminglanguage(ProgrammingLanguage newProgramminglanguage) {
		ProgrammingLanguage oldProgramminglanguage = programminglanguage;
		programminglanguage = newProgramminglanguage;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.LIBRARY__PROGRAMMINGLANGUAGE, oldProgramminglanguage, programminglanguage));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case SysreqPackage.LIBRARY__NAME:
				return getName();
			case SysreqPackage.LIBRARY__VERSION:
				return getVersion();
			case SysreqPackage.LIBRARY__PROGRAMMINGLANGUAGE:
				if (resolve) return getProgramminglanguage();
				return basicGetProgramminglanguage();
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
			case SysreqPackage.LIBRARY__NAME:
				setName((String)newValue);
				return;
			case SysreqPackage.LIBRARY__VERSION:
				setVersion((String)newValue);
				return;
			case SysreqPackage.LIBRARY__PROGRAMMINGLANGUAGE:
				setProgramminglanguage((ProgrammingLanguage)newValue);
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
			case SysreqPackage.LIBRARY__NAME:
				setName(NAME_EDEFAULT);
				return;
			case SysreqPackage.LIBRARY__VERSION:
				setVersion(VERSION_EDEFAULT);
				return;
			case SysreqPackage.LIBRARY__PROGRAMMINGLANGUAGE:
				setProgramminglanguage((ProgrammingLanguage)null);
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
			case SysreqPackage.LIBRARY__NAME:
				return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
			case SysreqPackage.LIBRARY__VERSION:
				return VERSION_EDEFAULT == null ? version != null : !VERSION_EDEFAULT.equals(version);
			case SysreqPackage.LIBRARY__PROGRAMMINGLANGUAGE:
				return programminglanguage != null;
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
		result.append(" (name: ");
		result.append(name);
		result.append(", version: ");
		result.append(version);
		result.append(')');
		return result.toString();
	}

} //LibraryImpl

/**
 */
package sysreq.impl;

import java.util.Collection;

import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

import sysreq.Controller;
import sysreq.Library;
import sysreq.ProgrammingLanguage;
import sysreq.Software;
import sysreq.SysreqPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Software</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link sysreq.impl.SoftwareImpl#getControllers <em>Controllers</em>}</li>
 *   <li>{@link sysreq.impl.SoftwareImpl#getProgramminglanguages <em>Programminglanguages</em>}</li>
 *   <li>{@link sysreq.impl.SoftwareImpl#getLibraries <em>Libraries</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class SoftwareImpl extends MinimalEObjectImpl.Container implements Software {
	/**
	 * The cached value of the '{@link #getControllers() <em>Controllers</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getControllers()
	 * @generated
	 * @ordered
	 */
	protected EList<Controller> controllers;

	/**
	 * The cached value of the '{@link #getProgramminglanguages() <em>Programminglanguages</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getProgramminglanguages()
	 * @generated
	 * @ordered
	 */
	protected EList<ProgrammingLanguage> programminglanguages;

	/**
	 * The cached value of the '{@link #getLibraries() <em>Libraries</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getLibraries()
	 * @generated
	 * @ordered
	 */
	protected EList<Library> libraries;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected SoftwareImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return SysreqPackage.Literals.SOFTWARE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Controller> getControllers() {
		if (controllers == null) {
			controllers = new EObjectContainmentEList<Controller>(Controller.class, this, SysreqPackage.SOFTWARE__CONTROLLERS);
		}
		return controllers;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<ProgrammingLanguage> getProgramminglanguages() {
		if (programminglanguages == null) {
			programminglanguages = new EObjectContainmentEList<ProgrammingLanguage>(ProgrammingLanguage.class, this, SysreqPackage.SOFTWARE__PROGRAMMINGLANGUAGES);
		}
		return programminglanguages;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Library> getLibraries() {
		if (libraries == null) {
			libraries = new EObjectContainmentEList<Library>(Library.class, this, SysreqPackage.SOFTWARE__LIBRARIES);
		}
		return libraries;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case SysreqPackage.SOFTWARE__CONTROLLERS:
				return ((InternalEList<?>)getControllers()).basicRemove(otherEnd, msgs);
			case SysreqPackage.SOFTWARE__PROGRAMMINGLANGUAGES:
				return ((InternalEList<?>)getProgramminglanguages()).basicRemove(otherEnd, msgs);
			case SysreqPackage.SOFTWARE__LIBRARIES:
				return ((InternalEList<?>)getLibraries()).basicRemove(otherEnd, msgs);
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
			case SysreqPackage.SOFTWARE__CONTROLLERS:
				return getControllers();
			case SysreqPackage.SOFTWARE__PROGRAMMINGLANGUAGES:
				return getProgramminglanguages();
			case SysreqPackage.SOFTWARE__LIBRARIES:
				return getLibraries();
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
			case SysreqPackage.SOFTWARE__CONTROLLERS:
				getControllers().clear();
				getControllers().addAll((Collection<? extends Controller>)newValue);
				return;
			case SysreqPackage.SOFTWARE__PROGRAMMINGLANGUAGES:
				getProgramminglanguages().clear();
				getProgramminglanguages().addAll((Collection<? extends ProgrammingLanguage>)newValue);
				return;
			case SysreqPackage.SOFTWARE__LIBRARIES:
				getLibraries().clear();
				getLibraries().addAll((Collection<? extends Library>)newValue);
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
			case SysreqPackage.SOFTWARE__CONTROLLERS:
				getControllers().clear();
				return;
			case SysreqPackage.SOFTWARE__PROGRAMMINGLANGUAGES:
				getProgramminglanguages().clear();
				return;
			case SysreqPackage.SOFTWARE__LIBRARIES:
				getLibraries().clear();
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
			case SysreqPackage.SOFTWARE__CONTROLLERS:
				return controllers != null && !controllers.isEmpty();
			case SysreqPackage.SOFTWARE__PROGRAMMINGLANGUAGES:
				return programminglanguages != null && !programminglanguages.isEmpty();
			case SysreqPackage.SOFTWARE__LIBRARIES:
				return libraries != null && !libraries.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //SoftwareImpl

/**
 */
package sysreq.impl;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EDataTypeUniqueEList;

import sysreq.Hardware;
import sysreq.SysreqPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Hardware</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link sysreq.impl.HardwareImpl#getArch <em>Arch</em>}</li>
 *   <li>{@link sysreq.impl.HardwareImpl#getCpucores <em>Cpucores</em>}</li>
 *   <li>{@link sysreq.impl.HardwareImpl#getCpufreq <em>Cpufreq</em>}</li>
 *   <li>{@link sysreq.impl.HardwareImpl#getMemory <em>Memory</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class HardwareImpl extends MinimalEObjectImpl.Container implements Hardware {
	/**
	 * The cached value of the '{@link #getArch() <em>Arch</em>}' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getArch()
	 * @generated
	 * @ordered
	 */
	protected EList<String> arch;

	/**
	 * The default value of the '{@link #getCpucores() <em>Cpucores</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCpucores()
	 * @generated
	 * @ordered
	 */
	protected static final int CPUCORES_EDEFAULT = 1;

	/**
	 * The cached value of the '{@link #getCpucores() <em>Cpucores</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCpucores()
	 * @generated
	 * @ordered
	 */
	protected int cpucores = CPUCORES_EDEFAULT;

	/**
	 * The default value of the '{@link #getCpufreq() <em>Cpufreq</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCpufreq()
	 * @generated
	 * @ordered
	 */
	protected static final int CPUFREQ_EDEFAULT = 800;

	/**
	 * The cached value of the '{@link #getCpufreq() <em>Cpufreq</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCpufreq()
	 * @generated
	 * @ordered
	 */
	protected int cpufreq = CPUFREQ_EDEFAULT;

	/**
	 * The default value of the '{@link #getMemory() <em>Memory</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMemory()
	 * @generated
	 * @ordered
	 */
	protected static final int MEMORY_EDEFAULT = 512;

	/**
	 * The cached value of the '{@link #getMemory() <em>Memory</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMemory()
	 * @generated
	 * @ordered
	 */
	protected int memory = MEMORY_EDEFAULT;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected HardwareImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return SysreqPackage.Literals.HARDWARE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<String> getArch() {
		if (arch == null) {
			arch = new EDataTypeUniqueEList<String>(String.class, this, SysreqPackage.HARDWARE__ARCH);
		}
		return arch;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getCpucores() {
		return cpucores;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setCpucores(int newCpucores) {
		int oldCpucores = cpucores;
		cpucores = newCpucores;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.HARDWARE__CPUCORES, oldCpucores, cpucores));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getCpufreq() {
		return cpufreq;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setCpufreq(int newCpufreq) {
		int oldCpufreq = cpufreq;
		cpufreq = newCpufreq;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.HARDWARE__CPUFREQ, oldCpufreq, cpufreq));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getMemory() {
		return memory;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setMemory(int newMemory) {
		int oldMemory = memory;
		memory = newMemory;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, SysreqPackage.HARDWARE__MEMORY, oldMemory, memory));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case SysreqPackage.HARDWARE__ARCH:
				return getArch();
			case SysreqPackage.HARDWARE__CPUCORES:
				return getCpucores();
			case SysreqPackage.HARDWARE__CPUFREQ:
				return getCpufreq();
			case SysreqPackage.HARDWARE__MEMORY:
				return getMemory();
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
			case SysreqPackage.HARDWARE__ARCH:
				getArch().clear();
				getArch().addAll((Collection<? extends String>)newValue);
				return;
			case SysreqPackage.HARDWARE__CPUCORES:
				setCpucores((Integer)newValue);
				return;
			case SysreqPackage.HARDWARE__CPUFREQ:
				setCpufreq((Integer)newValue);
				return;
			case SysreqPackage.HARDWARE__MEMORY:
				setMemory((Integer)newValue);
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
			case SysreqPackage.HARDWARE__ARCH:
				getArch().clear();
				return;
			case SysreqPackage.HARDWARE__CPUCORES:
				setCpucores(CPUCORES_EDEFAULT);
				return;
			case SysreqPackage.HARDWARE__CPUFREQ:
				setCpufreq(CPUFREQ_EDEFAULT);
				return;
			case SysreqPackage.HARDWARE__MEMORY:
				setMemory(MEMORY_EDEFAULT);
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
			case SysreqPackage.HARDWARE__ARCH:
				return arch != null && !arch.isEmpty();
			case SysreqPackage.HARDWARE__CPUCORES:
				return cpucores != CPUCORES_EDEFAULT;
			case SysreqPackage.HARDWARE__CPUFREQ:
				return cpufreq != CPUFREQ_EDEFAULT;
			case SysreqPackage.HARDWARE__MEMORY:
				return memory != MEMORY_EDEFAULT;
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
		result.append(" (arch: ");
		result.append(arch);
		result.append(", cpucores: ");
		result.append(cpucores);
		result.append(", cpufreq: ");
		result.append(cpufreq);
		result.append(", memory: ");
		result.append(memory);
		result.append(')');
		return result.toString();
	}

} //HardwareImpl

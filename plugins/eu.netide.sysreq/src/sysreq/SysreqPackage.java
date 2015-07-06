/**
 */
package sysreq;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
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
 * @see sysreq.SysreqFactory
 * @model kind="package"
 *        annotation="http://www.eclipse.org/OCL/Import configuration='../../eu.netide.configuration/model/Topology.ecore#/' ecore='http://www.eclipse.org/emf/2002/Ecore#/'"
 * @generated
 */
public interface SysreqPackage extends EPackage {
	/**
	 * The package name.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNAME = "sysreq";

	/**
	 * The package namespace URI.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	String eNS_URI = "eu.netide.sysreq";

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
	SysreqPackage eINSTANCE = sysreq.impl.SysreqPackageImpl.init();

	/**
	 * The meta object id for the '{@link sysreq.impl.SystemRequirementsImpl <em>System Requirements</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see sysreq.impl.SystemRequirementsImpl
	 * @see sysreq.impl.SysreqPackageImpl#getSystemRequirements()
	 * @generated
	 */
	int SYSTEM_REQUIREMENTS = 0;

	/**
	 * The feature id for the '<em><b>Hardware</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SYSTEM_REQUIREMENTS__HARDWARE = 0;

	/**
	 * The feature id for the '<em><b>Software</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SYSTEM_REQUIREMENTS__SOFTWARE = 1;

	/**
	 * The feature id for the '<em><b>Network</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SYSTEM_REQUIREMENTS__NETWORK = 2;

	/**
	 * The number of structural features of the '<em>System Requirements</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SYSTEM_REQUIREMENTS_FEATURE_COUNT = 3;

	/**
	 * The number of operations of the '<em>System Requirements</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SYSTEM_REQUIREMENTS_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link sysreq.impl.NetworkImpl <em>Network</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see sysreq.impl.NetworkImpl
	 * @see sysreq.impl.SysreqPackageImpl#getNetwork()
	 * @generated
	 */
	int NETWORK = 1;

	/**
	 * The feature id for the '<em><b>Switchtype</b></em>' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NETWORK__SWITCHTYPE = 0;

	/**
	 * The feature id for the '<em><b>Of version</b></em>' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NETWORK__OF_VERSION = 1;

	/**
	 * The feature id for the '<em><b>Topologyrequirements</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NETWORK__TOPOLOGYREQUIREMENTS = 2;

	/**
	 * The number of structural features of the '<em>Network</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NETWORK_FEATURE_COUNT = 3;

	/**
	 * The number of operations of the '<em>Network</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int NETWORK_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link sysreq.impl.HardwareImpl <em>Hardware</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see sysreq.impl.HardwareImpl
	 * @see sysreq.impl.SysreqPackageImpl#getHardware()
	 * @generated
	 */
	int HARDWARE = 2;

	/**
	 * The feature id for the '<em><b>Arch</b></em>' attribute list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int HARDWARE__ARCH = 0;

	/**
	 * The feature id for the '<em><b>Cpucores</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int HARDWARE__CPUCORES = 1;

	/**
	 * The feature id for the '<em><b>Cpufreq</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int HARDWARE__CPUFREQ = 2;

	/**
	 * The feature id for the '<em><b>Memory</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int HARDWARE__MEMORY = 3;

	/**
	 * The number of structural features of the '<em>Hardware</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int HARDWARE_FEATURE_COUNT = 4;

	/**
	 * The number of operations of the '<em>Hardware</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int HARDWARE_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link sysreq.impl.SoftwareImpl <em>Software</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see sysreq.impl.SoftwareImpl
	 * @see sysreq.impl.SysreqPackageImpl#getSoftware()
	 * @generated
	 */
	int SOFTWARE = 3;

	/**
	 * The feature id for the '<em><b>Controllers</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SOFTWARE__CONTROLLERS = 0;

	/**
	 * The feature id for the '<em><b>Programminglanguages</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SOFTWARE__PROGRAMMINGLANGUAGES = 1;

	/**
	 * The feature id for the '<em><b>Libraries</b></em>' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SOFTWARE__LIBRARIES = 2;

	/**
	 * The number of structural features of the '<em>Software</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SOFTWARE_FEATURE_COUNT = 3;

	/**
	 * The number of operations of the '<em>Software</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int SOFTWARE_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link sysreq.impl.ControllerImpl <em>Controller</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see sysreq.impl.ControllerImpl
	 * @see sysreq.impl.SysreqPackageImpl#getController()
	 * @generated
	 */
	int CONTROLLER = 4;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTROLLER__NAME = 0;

	/**
	 * The feature id for the '<em><b>Version</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTROLLER__VERSION = 1;

	/**
	 * The feature id for the '<em><b>Programminglanguages</b></em>' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTROLLER__PROGRAMMINGLANGUAGES = 2;

	/**
	 * The number of structural features of the '<em>Controller</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTROLLER_FEATURE_COUNT = 3;

	/**
	 * The number of operations of the '<em>Controller</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int CONTROLLER_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link sysreq.impl.ProgrammingLanguageImpl <em>Programming Language</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see sysreq.impl.ProgrammingLanguageImpl
	 * @see sysreq.impl.SysreqPackageImpl#getProgrammingLanguage()
	 * @generated
	 */
	int PROGRAMMING_LANGUAGE = 5;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PROGRAMMING_LANGUAGE__NAME = 0;

	/**
	 * The feature id for the '<em><b>Version</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PROGRAMMING_LANGUAGE__VERSION = 1;

	/**
	 * The number of structural features of the '<em>Programming Language</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PROGRAMMING_LANGUAGE_FEATURE_COUNT = 2;

	/**
	 * The number of operations of the '<em>Programming Language</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int PROGRAMMING_LANGUAGE_OPERATION_COUNT = 0;

	/**
	 * The meta object id for the '{@link sysreq.impl.LibraryImpl <em>Library</em>}' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see sysreq.impl.LibraryImpl
	 * @see sysreq.impl.SysreqPackageImpl#getLibrary()
	 * @generated
	 */
	int LIBRARY = 6;

	/**
	 * The feature id for the '<em><b>Name</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LIBRARY__NAME = 0;

	/**
	 * The feature id for the '<em><b>Version</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LIBRARY__VERSION = 1;

	/**
	 * The feature id for the '<em><b>Programminglanguage</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LIBRARY__PROGRAMMINGLANGUAGE = 2;

	/**
	 * The number of structural features of the '<em>Library</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LIBRARY_FEATURE_COUNT = 3;

	/**
	 * The number of operations of the '<em>Library</em>' class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 * @ordered
	 */
	int LIBRARY_OPERATION_COUNT = 0;


	/**
	 * Returns the meta object for class '{@link sysreq.SystemRequirements <em>System Requirements</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>System Requirements</em>'.
	 * @see sysreq.SystemRequirements
	 * @generated
	 */
	EClass getSystemRequirements();

	/**
	 * Returns the meta object for the containment reference '{@link sysreq.SystemRequirements#getHardware <em>Hardware</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Hardware</em>'.
	 * @see sysreq.SystemRequirements#getHardware()
	 * @see #getSystemRequirements()
	 * @generated
	 */
	EReference getSystemRequirements_Hardware();

	/**
	 * Returns the meta object for the containment reference '{@link sysreq.SystemRequirements#getSoftware <em>Software</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Software</em>'.
	 * @see sysreq.SystemRequirements#getSoftware()
	 * @see #getSystemRequirements()
	 * @generated
	 */
	EReference getSystemRequirements_Software();

	/**
	 * Returns the meta object for the containment reference '{@link sysreq.SystemRequirements#getNetwork <em>Network</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference '<em>Network</em>'.
	 * @see sysreq.SystemRequirements#getNetwork()
	 * @see #getSystemRequirements()
	 * @generated
	 */
	EReference getSystemRequirements_Network();

	/**
	 * Returns the meta object for class '{@link sysreq.Network <em>Network</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Network</em>'.
	 * @see sysreq.Network
	 * @generated
	 */
	EClass getNetwork();

	/**
	 * Returns the meta object for the attribute list '{@link sysreq.Network#getSwitchtype <em>Switchtype</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute list '<em>Switchtype</em>'.
	 * @see sysreq.Network#getSwitchtype()
	 * @see #getNetwork()
	 * @generated
	 */
	EAttribute getNetwork_Switchtype();

	/**
	 * Returns the meta object for the attribute list '{@link sysreq.Network#getOf_version <em>Of version</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute list '<em>Of version</em>'.
	 * @see sysreq.Network#getOf_version()
	 * @see #getNetwork()
	 * @generated
	 */
	EAttribute getNetwork_Of_version();

	/**
	 * Returns the meta object for the reference '{@link sysreq.Network#getTopologyrequirements <em>Topologyrequirements</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Topologyrequirements</em>'.
	 * @see sysreq.Network#getTopologyrequirements()
	 * @see #getNetwork()
	 * @generated
	 */
	EReference getNetwork_Topologyrequirements();

	/**
	 * Returns the meta object for class '{@link sysreq.Hardware <em>Hardware</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Hardware</em>'.
	 * @see sysreq.Hardware
	 * @generated
	 */
	EClass getHardware();

	/**
	 * Returns the meta object for the attribute list '{@link sysreq.Hardware#getArch <em>Arch</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute list '<em>Arch</em>'.
	 * @see sysreq.Hardware#getArch()
	 * @see #getHardware()
	 * @generated
	 */
	EAttribute getHardware_Arch();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.Hardware#getCpucores <em>Cpucores</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Cpucores</em>'.
	 * @see sysreq.Hardware#getCpucores()
	 * @see #getHardware()
	 * @generated
	 */
	EAttribute getHardware_Cpucores();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.Hardware#getCpufreq <em>Cpufreq</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Cpufreq</em>'.
	 * @see sysreq.Hardware#getCpufreq()
	 * @see #getHardware()
	 * @generated
	 */
	EAttribute getHardware_Cpufreq();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.Hardware#getMemory <em>Memory</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Memory</em>'.
	 * @see sysreq.Hardware#getMemory()
	 * @see #getHardware()
	 * @generated
	 */
	EAttribute getHardware_Memory();

	/**
	 * Returns the meta object for class '{@link sysreq.Software <em>Software</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Software</em>'.
	 * @see sysreq.Software
	 * @generated
	 */
	EClass getSoftware();

	/**
	 * Returns the meta object for the containment reference list '{@link sysreq.Software#getControllers <em>Controllers</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Controllers</em>'.
	 * @see sysreq.Software#getControllers()
	 * @see #getSoftware()
	 * @generated
	 */
	EReference getSoftware_Controllers();

	/**
	 * Returns the meta object for the containment reference list '{@link sysreq.Software#getProgramminglanguages <em>Programminglanguages</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Programminglanguages</em>'.
	 * @see sysreq.Software#getProgramminglanguages()
	 * @see #getSoftware()
	 * @generated
	 */
	EReference getSoftware_Programminglanguages();

	/**
	 * Returns the meta object for the containment reference list '{@link sysreq.Software#getLibraries <em>Libraries</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the containment reference list '<em>Libraries</em>'.
	 * @see sysreq.Software#getLibraries()
	 * @see #getSoftware()
	 * @generated
	 */
	EReference getSoftware_Libraries();

	/**
	 * Returns the meta object for class '{@link sysreq.Controller <em>Controller</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Controller</em>'.
	 * @see sysreq.Controller
	 * @generated
	 */
	EClass getController();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.Controller#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see sysreq.Controller#getName()
	 * @see #getController()
	 * @generated
	 */
	EAttribute getController_Name();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.Controller#getVersion <em>Version</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Version</em>'.
	 * @see sysreq.Controller#getVersion()
	 * @see #getController()
	 * @generated
	 */
	EAttribute getController_Version();

	/**
	 * Returns the meta object for the reference list '{@link sysreq.Controller#getProgramminglanguages <em>Programminglanguages</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference list '<em>Programminglanguages</em>'.
	 * @see sysreq.Controller#getProgramminglanguages()
	 * @see #getController()
	 * @generated
	 */
	EReference getController_Programminglanguages();

	/**
	 * Returns the meta object for class '{@link sysreq.ProgrammingLanguage <em>Programming Language</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Programming Language</em>'.
	 * @see sysreq.ProgrammingLanguage
	 * @generated
	 */
	EClass getProgrammingLanguage();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.ProgrammingLanguage#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see sysreq.ProgrammingLanguage#getName()
	 * @see #getProgrammingLanguage()
	 * @generated
	 */
	EAttribute getProgrammingLanguage_Name();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.ProgrammingLanguage#getVersion <em>Version</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Version</em>'.
	 * @see sysreq.ProgrammingLanguage#getVersion()
	 * @see #getProgrammingLanguage()
	 * @generated
	 */
	EAttribute getProgrammingLanguage_Version();

	/**
	 * Returns the meta object for class '{@link sysreq.Library <em>Library</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for class '<em>Library</em>'.
	 * @see sysreq.Library
	 * @generated
	 */
	EClass getLibrary();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.Library#getName <em>Name</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Name</em>'.
	 * @see sysreq.Library#getName()
	 * @see #getLibrary()
	 * @generated
	 */
	EAttribute getLibrary_Name();

	/**
	 * Returns the meta object for the attribute '{@link sysreq.Library#getVersion <em>Version</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the attribute '<em>Version</em>'.
	 * @see sysreq.Library#getVersion()
	 * @see #getLibrary()
	 * @generated
	 */
	EAttribute getLibrary_Version();

	/**
	 * Returns the meta object for the reference '{@link sysreq.Library#getProgramminglanguage <em>Programminglanguage</em>}'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the meta object for the reference '<em>Programminglanguage</em>'.
	 * @see sysreq.Library#getProgramminglanguage()
	 * @see #getLibrary()
	 * @generated
	 */
	EReference getLibrary_Programminglanguage();

	/**
	 * Returns the factory that creates the instances of the model.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the factory that creates the instances of the model.
	 * @generated
	 */
	SysreqFactory getSysreqFactory();

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
		 * The meta object literal for the '{@link sysreq.impl.SystemRequirementsImpl <em>System Requirements</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see sysreq.impl.SystemRequirementsImpl
		 * @see sysreq.impl.SysreqPackageImpl#getSystemRequirements()
		 * @generated
		 */
		EClass SYSTEM_REQUIREMENTS = eINSTANCE.getSystemRequirements();

		/**
		 * The meta object literal for the '<em><b>Hardware</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SYSTEM_REQUIREMENTS__HARDWARE = eINSTANCE.getSystemRequirements_Hardware();

		/**
		 * The meta object literal for the '<em><b>Software</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SYSTEM_REQUIREMENTS__SOFTWARE = eINSTANCE.getSystemRequirements_Software();

		/**
		 * The meta object literal for the '<em><b>Network</b></em>' containment reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SYSTEM_REQUIREMENTS__NETWORK = eINSTANCE.getSystemRequirements_Network();

		/**
		 * The meta object literal for the '{@link sysreq.impl.NetworkImpl <em>Network</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see sysreq.impl.NetworkImpl
		 * @see sysreq.impl.SysreqPackageImpl#getNetwork()
		 * @generated
		 */
		EClass NETWORK = eINSTANCE.getNetwork();

		/**
		 * The meta object literal for the '<em><b>Switchtype</b></em>' attribute list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute NETWORK__SWITCHTYPE = eINSTANCE.getNetwork_Switchtype();

		/**
		 * The meta object literal for the '<em><b>Of version</b></em>' attribute list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute NETWORK__OF_VERSION = eINSTANCE.getNetwork_Of_version();

		/**
		 * The meta object literal for the '<em><b>Topologyrequirements</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference NETWORK__TOPOLOGYREQUIREMENTS = eINSTANCE.getNetwork_Topologyrequirements();

		/**
		 * The meta object literal for the '{@link sysreq.impl.HardwareImpl <em>Hardware</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see sysreq.impl.HardwareImpl
		 * @see sysreq.impl.SysreqPackageImpl#getHardware()
		 * @generated
		 */
		EClass HARDWARE = eINSTANCE.getHardware();

		/**
		 * The meta object literal for the '<em><b>Arch</b></em>' attribute list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute HARDWARE__ARCH = eINSTANCE.getHardware_Arch();

		/**
		 * The meta object literal for the '<em><b>Cpucores</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute HARDWARE__CPUCORES = eINSTANCE.getHardware_Cpucores();

		/**
		 * The meta object literal for the '<em><b>Cpufreq</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute HARDWARE__CPUFREQ = eINSTANCE.getHardware_Cpufreq();

		/**
		 * The meta object literal for the '<em><b>Memory</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute HARDWARE__MEMORY = eINSTANCE.getHardware_Memory();

		/**
		 * The meta object literal for the '{@link sysreq.impl.SoftwareImpl <em>Software</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see sysreq.impl.SoftwareImpl
		 * @see sysreq.impl.SysreqPackageImpl#getSoftware()
		 * @generated
		 */
		EClass SOFTWARE = eINSTANCE.getSoftware();

		/**
		 * The meta object literal for the '<em><b>Controllers</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SOFTWARE__CONTROLLERS = eINSTANCE.getSoftware_Controllers();

		/**
		 * The meta object literal for the '<em><b>Programminglanguages</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SOFTWARE__PROGRAMMINGLANGUAGES = eINSTANCE.getSoftware_Programminglanguages();

		/**
		 * The meta object literal for the '<em><b>Libraries</b></em>' containment reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference SOFTWARE__LIBRARIES = eINSTANCE.getSoftware_Libraries();

		/**
		 * The meta object literal for the '{@link sysreq.impl.ControllerImpl <em>Controller</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see sysreq.impl.ControllerImpl
		 * @see sysreq.impl.SysreqPackageImpl#getController()
		 * @generated
		 */
		EClass CONTROLLER = eINSTANCE.getController();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute CONTROLLER__NAME = eINSTANCE.getController_Name();

		/**
		 * The meta object literal for the '<em><b>Version</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute CONTROLLER__VERSION = eINSTANCE.getController_Version();

		/**
		 * The meta object literal for the '<em><b>Programminglanguages</b></em>' reference list feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference CONTROLLER__PROGRAMMINGLANGUAGES = eINSTANCE.getController_Programminglanguages();

		/**
		 * The meta object literal for the '{@link sysreq.impl.ProgrammingLanguageImpl <em>Programming Language</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see sysreq.impl.ProgrammingLanguageImpl
		 * @see sysreq.impl.SysreqPackageImpl#getProgrammingLanguage()
		 * @generated
		 */
		EClass PROGRAMMING_LANGUAGE = eINSTANCE.getProgrammingLanguage();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute PROGRAMMING_LANGUAGE__NAME = eINSTANCE.getProgrammingLanguage_Name();

		/**
		 * The meta object literal for the '<em><b>Version</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute PROGRAMMING_LANGUAGE__VERSION = eINSTANCE.getProgrammingLanguage_Version();

		/**
		 * The meta object literal for the '{@link sysreq.impl.LibraryImpl <em>Library</em>}' class.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @see sysreq.impl.LibraryImpl
		 * @see sysreq.impl.SysreqPackageImpl#getLibrary()
		 * @generated
		 */
		EClass LIBRARY = eINSTANCE.getLibrary();

		/**
		 * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute LIBRARY__NAME = eINSTANCE.getLibrary_Name();

		/**
		 * The meta object literal for the '<em><b>Version</b></em>' attribute feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EAttribute LIBRARY__VERSION = eINSTANCE.getLibrary_Version();

		/**
		 * The meta object literal for the '<em><b>Programminglanguage</b></em>' reference feature.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		EReference LIBRARY__PROGRAMMINGLANGUAGE = eINSTANCE.getLibrary_Programminglanguage();

	}

} //SysreqPackage

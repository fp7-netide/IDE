/*******************************************************************************
 * Copyright (c) 2004-2011 Abel Hegedus, Istvan Rath and Daniel Varro
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Abel Hegedus - initial API and implementation
 *    Istvan Rath - refactorings to accommodate to generic/patternspecific API differences
 *    Sven Uthe - refoctorings to VIATRA 1.4.1 removed deprecated methods
 *******************************************************************************/
package eu.netide.deployment.topologyvalidation.matcher;



import java.util.Collection;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.viatra.query.patternlanguage.emf.EMFPatternLanguageStandaloneSetup;
import org.eclipse.viatra.query.patternlanguage.emf.eMFPatternLanguage.PatternModel;
import org.eclipse.viatra.query.patternlanguage.emf.specification.SpecificationBuilder;
import org.eclipse.viatra.query.patternlanguage.helper.CorePatternLanguageHelper;
import org.eclipse.viatra.query.patternlanguage.patternLanguage.Pattern;
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine;
import org.eclipse.viatra.query.runtime.api.IPatternMatch;
import org.eclipse.viatra.query.runtime.api.ViatraQueryMatcher;
import org.eclipse.viatra.query.runtime.emf.EMFScope;
import org.eclipse.viatra.query.runtime.exception.ViatraQueryException;

import Topology.TopologyPackage;

/**
 * @author Abel Hegedus
 * @author Istvan Rath
 * @author Sven Uthe
 *
 */
public class ViatraQueryHeadlessAdvanced {

    public static Resource loadModel(String modelPath) {
        URI fileURI = URI.createFileURI(modelPath);
        return loadModel(fileURI);
    }

	public static Resource loadModel(URI fileURI) {

		// register resource factory
		EPackage.Registry.INSTANCE.put("eu.netide.configuration.topology", TopologyPackage.eINSTANCE);
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("topology", new XMIResourceFactoryImpl());

		// Loads the resource
		ResourceSet resourceSet = new ResourceSetImpl();
		Resource resource = resourceSet.getResource(fileURI, true);
		return resource;
	}

	public void prettyPrintMatches(StringBuilder results, Collection<? extends IPatternMatch> matches) {
		for (IPatternMatch match : matches) {
			results.append(match.prettyPrint()+";\n");
		}
		if(matches.size() == 0) {
			results.append("Empty match set");
		}
		results.append("\n");
	}

	/**
	 * TODO rename and rewrite function
	 * Returns the match set for patternFQN over the model in modelPath in pretty printed form
	 *
	 * @param modelPath
	 * @param patternFQN
	 * @return
	 */
	public Collection<? extends IPatternMatch> calculateMatchSet(URI modelURI, URI fileURI, String patternFQN) {
		final StringBuilder results = new StringBuilder();
        Collection<? extends IPatternMatch> matches = null;
		Resource resource = loadModel(modelURI);
		if (resource != null) {
			try {
				// get all matches of the pattern
				// create an *unmanaged* engine to ensure that noone else is going
				// to use our engine
				AdvancedViatraQueryEngine engine = AdvancedViatraQueryEngine.createUnmanagedEngine(new EMFScope(resource));
				// instantiate a pattern matcher through the registry, by only knowing its FQN
				// assuming that there is a pattern definition registered matching 'patternFQN'

				Pattern p = null;

		        // Initializing Xtext-based resource parser
			    // Do not use if VIATRA Query tooling is loaded!
		        new EMFPatternLanguageStandaloneSetup().createInjectorAndDoEMFRegistration();

				//Loading pattern resource from file
		        ResourceSet resourceSet = new ResourceSetImpl();

			    Resource patternResource = resourceSet.getResource(fileURI, true);

			    // navigate to the pattern definition that we want
			    if (patternResource != null) {
		            if (patternResource.getErrors().size() == 0 && patternResource.getContents().size() >= 1) {
		                EObject topElement = patternResource.getContents().get(0);
		                //if (topElement instanceof PatternMatcher) {
		                	for (Pattern _p  : ((PatternModel) topElement).getPatterns()) {
		                		if (patternFQN.equals(CorePatternLanguageHelper.getFullyQualifiedName(_p))) {
		                			p = _p; break;
		                		}
		                //	}
		                }
		            }
		        }
			    if (p == null) {
			        throw new RuntimeException(String.format("Pattern %s not found", patternFQN));
			    }
			    SpecificationBuilder builder = new SpecificationBuilder();
//			    final IQuerySpecification<? extends ViatraQueryMatcher<? extends IPatternMatch>> specification = builder.getOrCreateSpecification(p);
//			    QuerySpecificationRegistry.registerQuerySpecification(specification);
//
//			    // Initialize matcher from specification
//                ViatraQueryMatcher<? extends IPatternMatch> matcher = engine.getMatcher(specification);

                ViatraQueryMatcher<? extends IPatternMatch> matcher = engine.getMatcher(builder.getOrCreateSpecification(p));
				if (matcher!=null) {
					matches = matcher.getAllMatches();
					// TODO: process matches
				}

				// wipe the engine
				engine.wipe();
				// after a wipe, new patterns can be rebuilt with much less overhead than
				// complete traversal (as the base indexes will be kept)

				// completely dispose of the engine once's it is not needed
				engine.dispose();
				resource.unload();
			} catch (ViatraQueryException e) {
				e.printStackTrace();
				results.append(e.getMessage());
			}
		} else {
			results.append("Resource not found");
		}
		return matches;
	}

}

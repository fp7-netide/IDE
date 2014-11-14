package eu.netide.configuration.generator;

import org.eclipse.core.internal.resources.Workspace;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.runtime.IExtensionRegistry;
import org.eclipse.core.runtime.Platform;
import org.eclipse.xtext.builder.EclipseResourceFileSystemAccess2;
import org.eclipse.xtext.builder.builderState.IBuilderState;
import org.eclipse.xtext.builder.clustering.ClusteringBuilderState;
import org.eclipse.xtext.builder.impl.BuildScheduler;
import org.eclipse.xtext.builder.impl.DirtyStateAwareResourceDescriptions;
import org.eclipse.xtext.builder.impl.QueuedBuildData;
import org.eclipse.xtext.builder.impl.ToBeBuiltComputer;
import org.eclipse.xtext.builder.resourceloader.IResourceLoader;
import org.eclipse.xtext.builder.resourceloader.ResourceLoaderProviders;
import org.eclipse.xtext.builder.trace.TraceMarkers;
import org.eclipse.xtext.generator.trace.TraceFileNameProvider;
import org.eclipse.xtext.generator.trace.TraceRegionSerializer;
import org.eclipse.xtext.resource.IExternalContentSupport;
import org.eclipse.xtext.resource.IResourceDescriptions;
import org.eclipse.xtext.resource.XtextResourceSet;
import org.eclipse.xtext.ui.containers.WorkspaceProjectsStateHelper;
import org.eclipse.xtext.ui.editor.DirtyStateManager;
import org.eclipse.xtext.ui.editor.IDirtyStateManager;
import org.eclipse.xtext.ui.notification.IStateChangeEventBroker;
import org.eclipse.xtext.ui.notification.StateChangeEventBroker;
import org.eclipse.xtext.ui.resource.IResourceSetProvider;
import org.eclipse.xtext.ui.resource.IStorage2UriMapper;
import org.eclipse.xtext.ui.resource.Storage2UriMapperImpl;
import org.eclipse.xtext.ui.resource.UriValidator;
import org.eclipse.xtext.ui.resource.XtextResourceSetProvider;
import org.eclipse.xtext.ui.shared.JdtHelper;
import org.eclipse.xtext.ui.shared.contribution.ISharedStateContributionRegistry;
import org.eclipse.xtext.ui.shared.internal.SharedStateContributionRegistryImpl;
import org.eclipse.xtext.ui.util.IJdtHelper;

import com.google.inject.AbstractModule;
import com.google.inject.Scopes;
import com.google.inject.Singleton;
import com.google.inject.name.Names;

/**
 * Common binding for Google Guice. It includes every binding needed by FileSystemAccess (which
 * cannot be configured otherwise).
 * 
 * Thomas: Don't mind the SuppressWarnings...
 * 
 * Sebastian: All bindings where currently copied from the link below to establish xtext 2.5.3
 * compatibility (we came from 2.4.0). We should investigate what's the optimal way to resolve these
 * bindings.
 * 
 * TODO See comment by Sebastian.
 * 
 * @see http
 *      ://git.eclipse.org/c/tmf/org.eclipse.xtext.git/plain/plugins/org.eclipse.xtext.ui.shared/
 *      src/org/eclipse/xtext/ui/shared/internal/SharedModule.java
 * @author Thomas Zolynski, Sebastian Lehrig
 */
@SuppressWarnings("restriction")
public class CommonConfigurationModule extends AbstractModule {

    private String projectURI = "eu.netide.configuration.generator";

    public String getProjectURI() {
        return projectURI;
    }

    public void setProjectURI(String projectURI) {
        this.projectURI = projectURI;
    }

    @Override
    protected void configure() {
        // ProjectURI
        bind(String.class).annotatedWith(Names.named("ProjectURI")).toInstance(getProjectURI());

        // Trace
        bind(TraceMarkers.class).toInstance(new TraceMarkers());
        bind(TraceFileNameProvider.class).toInstance(new TraceFileNameProvider());
        bind(TraceRegionSerializer.class).toInstance(new TraceRegionSerializer());

        // Storage
        bind(IWorkspace.class).to(Workspace.class);
        bind(IExtensionRegistry.class).toInstance(Platform.getExtensionRegistry());
        bind(ISharedStateContributionRegistry.class).to(SharedStateContributionRegistryImpl.class);
        bind(IStorage2UriMapper.class).to(Storage2UriMapperImpl.class);

        // builder
        bind(QueuedBuildData.class);
        bind(BuildScheduler.class);
        bind(ToBeBuiltComputer.class);
        bind(IResourceLoader.class).toProvider(ResourceLoaderProviders.getSerialLoader());

        bind(IResourceSetProvider.class).to(XtextResourceSetProvider.class);
        bind(XtextResourceSet.class);

        bind(WorkspaceProjectsStateHelper.class);
        bind(UriValidator.class);
        bind(IResourceLoader.class).annotatedWith(Names.named(ClusteringBuilderState.RESOURCELOADER_GLOBAL_INDEX))
                .toProvider(ResourceLoaderProviders.getSerialLoader());

        bind(IExternalContentSupport.IExternalContentProvider.class).to(IDirtyStateManager.class).in(Scopes.SINGLETON);
        bind(IDirtyStateManager.class).to(DirtyStateManager.class).in(Scopes.SINGLETON);
        bind(IStateChangeEventBroker.class).to(StateChangeEventBroker.class).in(Scopes.SINGLETON);
        bind(IResourceDescriptions.class).to(DirtyStateAwareResourceDescriptions.class).in(Scopes.SINGLETON);
        bind(IJdtHelper.class).to(JdtHelper.class).asEagerSingleton();
        bind(IResourceLoader.class).annotatedWith(Names.named(ClusteringBuilderState.RESOURCELOADER_CROSS_LINKING))
                .toProvider(ResourceLoaderProviders.getSerialLoader());
        bind(IResourceLoader.Sorter.class);
        bind(IBuilderState.class).to(ClusteringBuilderState.class).in(Scopes.SINGLETON);
        //bind(EclipseResourceFileSystemAccess2.class).toProvider(FSAProvider.class).in(Singleton.class);

    }
}

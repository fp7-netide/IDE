package eu.netide.perspective

import org.eclipse.sirius.ui.tools.api.views.modelexplorerview.IModelExplorerView
import org.eclipse.ui.IPageLayout
import org.eclipse.ui.IPerspectiveFactory
import org.eclipse.ui.console.IConsoleConstants
import org.eclipse.debug.ui.IDebugUIConstants
import org.eclipse.jdt.ui.JavaUI

class PerspectiveFactory implements IPerspectiveFactory {

	override createInitialLayout(IPageLayout layout) {

		var leftFolder = layout.createFolder("left", IPageLayout.LEFT, 0.2f, layout.editorArea)
		leftFolder.addView(IModelExplorerView.ID)
		leftFolder.addView(IPageLayout.ID_PROJECT_EXPLORER)

		var bottomFolder = layout.createFolder("bottom", IPageLayout.BOTTOM, 0.7f, layout.editorArea)
		bottomFolder.addView(IConsoleConstants.ID_CONSOLE_VIEW)
		bottomFolder.addView(IPageLayout.ID_PROP_SHEET)

		layout.addView(IPageLayout.ID_EDITOR_AREA, IPageLayout.LEFT, 0.7f, layout.editorArea)

		layout.addActionSet(IDebugUIConstants.ID_RUN_LAUNCH_GROUP)
		layout.addActionSet(JavaUI.ID_ACTION_SET)
		layout.addActionSet(JavaUI.ID_ELEMENT_CREATION_ACTION_SET)

		layout.addShowViewShortcut(IPageLayout.ID_OUTLINE)
		layout.addShowViewShortcut(IPageLayout.ID_PROBLEM_VIEW)
		layout.addShowViewShortcut(IPageLayout.ID_TASK_LIST)
		layout.addShowViewShortcut(IPageLayout.ID_PROJECT_EXPLORER)
	}

}

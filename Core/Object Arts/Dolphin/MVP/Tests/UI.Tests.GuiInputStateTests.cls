"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.GuiInputStateTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.GuiInputStateTests guid: (Core.GUID fromString: '{ffd595c0-c167-4954-836b-2a542d455034}')!

UI.Tests.GuiInputStateTests comment: ''!

!UI.Tests.GuiInputStateTests methodsFor!

testTopLevelWindows
	| top1 view top2 top3 |
	top1 := SessionManager inputState topLevelWindows.
	self assert: (top1 noDifference: SessionManager inputState topLevelWindowsInZOrder).
	"Verify that child windows created on the design desktop are enumerated by #topLevelWindows. This is an old bug that came back with high-DPI changes, although it didn't break preservation of edited child views in VCs across image saves this time because the windows to save are now enumerated with #toplevelWindowsInZOrder, which uses a Windows API to enumerate the top-level windows (much slower, but preserves z-order)."
	view := (ResourceIdentifier class: TextPresenter selector: #resource_Default_view) loadWithContext: #{Tools.DesignDesktopView} value default forEdit: true.
	top2 := SessionManager inputState topLevelWindows.
	top3 := SessionManager inputState topLevelWindowsInZOrder.
	view destroy.
	self assert: (top2 difference: top1) single equals: view.
	self assert: (top2 noDifference: top3).

	! !

!UI.Tests.GuiInputStateTests categoriesForMethods!
testTopLevelWindows!public!tests! !
!


"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.ViewComposerTest'
	instanceVariableNames: 'vc sampleClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ViewComposerTest guid: (Core.GUID fromString: '{84c0e504-bdda-4d87-92dc-53b89f80f634}')!
Tools.Tests.ViewComposerTest comment: ''!
!Tools.Tests.ViewComposerTest categoriesForClass!Unclassified! !
!Tools.Tests.ViewComposerTest methodsFor!

doArenaDropOf: subPresenterType operation: aSymbol
	| overShell ddSession |
	self denyIsNil: aSymbol.
	ddSession := self dragResourceFor: subPresenterType.
	aSymbol ifNotNil: [ddSession defaultOperation: aSymbol].
	overShell := vc arena mapPoint: 50 @ 50 to: View desktop.
	"To avoid any dependency on the state of the runtime environment (such as the desktop being
	locked, or there being other Windows on top of the VC), we simulate the dragging over the VC
	arena"
	ddSession
		dragPoint: overShell;
		dropTarget: vc arena;
		dropTargetEnter;
		giveFeedback.
	ddSession
		dropTargetOver;
		giveFeedback.
	self assert: ddSession operation equals: aSymbol.
	ddSession
		dropTargetDrop;
		dropTarget: nil;
		endTrackingAt: 0 @ 0.
	^ddSession!

dragResourceFor: resourceName
	| session toolbox |
	toolbox := vc instVarNamed: 'toolboxPresenter'.
	session := InternalDragDropSession dragSource: toolbox view
				item: (ResourceIdentifier class: resourceName).
	toolbox resourcesPresenter onDragResource: session.
	session startTrackingAt: 20 @ 20.
	^session!

getButtonResource
	^(ResourceIdentifier class: PushButton name: 'Push button') resource!

getContainerResource
	^(ResourceIdentifier class: ContainerView) resource!

openTestSubjectOn: aResourceId
	^vc
		ifNil: 
			[vc := aResourceId
						ifNil: [ViewComposer show]
						ifNotNil: 
							[vc := ViewComposer create
										openOn: aResourceId;
										show;
										yourself]]
		ifNotNil: [vc openOn: aResourceId]!

openTestSubjectOnNewShell
	^self openTestSubjectOn: (ResourceIdentifier class: Shell)!

sampleClass
	^sampleClass
		ifNil: 
			[sampleClass := Tools.Tests.ViewComposerTest
						subclass: #ViewComposerTestSample
						instanceVariableNames: ''
						classVariableNames: ''
						poolDictionaries: ''
						classInstanceVariableNames: '']!

tearDown
	DragDropSession current ifNotNil: [:dd | dd cancelTrackingAt: 0 @ 0].
	sampleClass ifNotNil: [sampleClass removeFromSystem].
	vc destroy.
	vc := nil!

testBasicEdit
	| sampleResourceIdentifier rid |
	"Test open a default view that is reasonably complex"
	rid := ResourceIdentifier class: ViewComposer.
	self openTestSubjectOn: rid.
	self assert: vc caption equals: rid displayString, '(UI.ShellView)'.
	self assert: vc composingView class identicalTo: ShellView.
	self assert: vc primarySelection equals: vc composingView.
	"Test saving"
	sampleResourceIdentifier := ResourceIdentifier class: self sampleClass.
	vc resourceIdentifier: sampleResourceIdentifier.
	vc viewSave.
	self assert: (self sampleClass class includesSelector: #resource_Default_view).
	vc viewCloseNoPrompt.
	self assertIsNil: vc composingView.
	self assert: vc hasComposingView not.
	self assert: vc caption equals: 'View Composer'.
	self assert: vc viewHierarchyPresenter model isEmpty.

	"Test we can reload what we saved"
	vc openOn: sampleResourceIdentifier.
	self assert: vc composingView class identicalTo: ShellView.
	self assert: vc primarySelection equals: vc composingView!

testCutCopyPaste
	| shell container button |
	self openTestSubjectOnNewShell.
	shell := vc composingView.
	container := vc
				pasteResource: self getContainerResource
				context: shell
				position: 0 @ 0.
	self assert: container class equals: ContainerView.
	container name: 'container'.
	button := vc
				pasteResource: self getButtonResource
				context: container
				position: 0 @ 0.
	self assert: button class equals: PushButton.
	button name: 'button'.
	vc selection: button.
	vc copySelection.
	vc selection: shell.
	vc pasteClipboard.
	"Check new button exists in shell"
	self assert: vc primarySelection class identicalTo: PushButton.
	self assert: vc primarySelection parentView identicalTo: shell.
	self deny: vc primarySelection identicalTo: button.
	"Check old button still exists"
	self assert: button isOpen.
	self assert: button parentView identicalTo: container.
	"Now try cut"
	vc selection: button.
	vc cutSelection.
	vc selection: shell.
	vc pasteClipboard.
	"Check new button exists in shell"
	self assert: vc primarySelection class identicalTo: PushButton.
	self assert: vc primarySelection parentView identicalTo: shell.
	self deny: vc primarySelection identicalTo: button.
	"Check old button has gone"
	self assert: button isOpen not.
	self deny: button parentView identicalTo: container!

testDragResourceOverEmptyArena
	| session |
	self openTestSubjectOn: nil.
	vc onDragOverArena: (session := self dragResourceFor: Shell).
	self assert: session operation identicalTo: #copy.
	self assert: session suggestedTarget identicalTo: vc arena!

testDropResourceLinkOverShell
	"Drop a Checkbox link onto a shell"

	| ddSession |
	self openTestSubjectOnNewShell.
	ddSession := self doArenaDropOf: TextPresenter operation: #link.
	self assert: vc primarySelection isKindOf: ReferenceView.
	self assert: vc primarySelection resourceIdentifier
		equals: (ResourceIdentifier class: TextPresenter).
	ddSession!

testDropResourceOverEmptyArena
	"Drop a shell onto an empty arena"
	self openTestSubjectOn: nil.
	self doArenaDropOf: Shell operation: #copy.
	self assert: vc composingView isKindOf: ShellView!

testDropResourceOverHierarchy
	"Drop a Checkbox onto a shell"

	| session |
	self openTestSubjectOnNewShell.
	session := self dragResourceFor: TextPresenter.
	session
		operation: #copy;
		suggestedTarget: vc viewHierarchyPresenter model roots first.
	vc onDropOverHierarchy: session.
	self assert: vc primarySelection isKindOf: TextEdit!

testDropResourceOverShell
	"Drop a Checkbox onto a shell"
	self openTestSubjectOn: nil.
	self doArenaDropOf: TextPresenter operation: #copy.
	self assert: vc primarySelection isKindOf: TextEdit!

testExit
	"Exiting the view composer used to raise an error
	due to trying to redraw the adornment after the view was closed.
	
	N.B. we must simulate the way the command will actually be routed
	through #performCommand: in order to trigger the bug."

	| query |
	self openTestSubjectOnNewShell.
	query := vc commandPolicy query: (CommandDescription command: #exit).
	self shouldnt: [query perform] raise: Error.
	self deny: vc isOpen!

testIgnoreShellPreferredExtent
	"Check to make sure that the VC doesn't allow the choice of shell extents
	even when they are marked as #userPreferredExtent"

	self openTestSubjectOnNewShell.
	self assert: vc composingView usePreferredExtent.
	"If this test fails check to see that ShellView>>resourcce_Default_view does indeed have an
	extent of 600@400 when saved by the VC"
	self assert: vc composingView extent equals: 600 @ 400!

testNoDragResourceOverInUseArena
	| session toolbox |
	self openTestSubjectOnNewShell.
	toolbox := vc instVarNamed: 'toolboxPresenter'.
	session := InternalDragDropSession dragSource: toolbox view item: (ResourceIdentifier class: Shell).
	toolbox resourcesPresenter onDragResource: session.
	session
		startTrackingAt: 20 @ 20;
		operation: #copy.
	vc onDragOverArena: session.
	self assertIsNil: session operation.
	self assertIsNil: session suggestedTarget!

testPasteToArena
	"Get a ShellView to paste"

	| shell button |
	self openTestSubjectOnNewShell.
	shell := vc composingView.
	vc copySelection.
	vc viewCloseNoPrompt.
	"Paste to empty view composer"
	self assert: vc canPaste.
	vc pasteClipboard.
	shell := vc primarySelection.
	self assert: shell class equals: ShellView.
	"Get a PushButton to paste"
	button := vc
				pasteResource: self getButtonResource
				context: shell
				position: 0 @ 0.
	vc selection: button.
	vc copySelection.
	vc viewCloseNoPrompt.
	"Paste to empty view composer"
	vc pasteClipboard.
	"Check new button exists"
	self assert: vc primarySelection class identicalTo: PushButton.
	self assert: vc primarySelection parentView identicalTo: View desktop.
	vc viewCloseNoPrompt!

testWidenSelection
	| shell browser |
	self openTestSubjectOn: (ResourceIdentifier class: Smalltalk.MethodHistoryBrowser name: 'Default view').
	shell := vc composingView.
	browser := shell viewNamed: 'slider'.
	vc selection: browser.
	self assert: vc primarySelection identicalTo: browser.
	vc widenSelection.
	self assert: vc primarySelection identicalTo: browser parentView.
	vc widenSelection.
	self assert: vc primarySelection identicalTo: browser parentView parentView.
	vc widenSelection.
	self assert: vc primarySelection identicalTo: shell.
	vc widenSelection.
	self assert: vc primarySelection identicalTo: shell!

testZOrderPreservedByMutate
	| shell |
	self openTestSubjectOnNewShell.
	shell := vc pasteContext.
	1 to: 3
		do: 
			[:i |
			| view |
			view := vc
						pasteResource: (ResourceIdentifier class: TextPresenter name: 'Default view') resource
						context: shell
						position: (20 * i) @ (10 * i).
			view name: i printString].
	self assert: (shell subViews collect: [:each | each name]) asArray equals: #('1' '2' '3').
	vc selection: shell.
	vc mutateTo: ContainerView.
	self assert: (shell subViews collect: [:each | each name]) asArray equals: #('1' '2' '3')! !
!Tools.Tests.ViewComposerTest categoriesFor: #doArenaDropOf:operation:!helpers!private! !
!Tools.Tests.ViewComposerTest categoriesFor: #dragResourceFor:!helpers!private! !
!Tools.Tests.ViewComposerTest categoriesFor: #getButtonResource!helpers!private! !
!Tools.Tests.ViewComposerTest categoriesFor: #getContainerResource!helpers!private! !
!Tools.Tests.ViewComposerTest categoriesFor: #openTestSubjectOn:!helpers!private! !
!Tools.Tests.ViewComposerTest categoriesFor: #openTestSubjectOnNewShell!helpers!private! !
!Tools.Tests.ViewComposerTest categoriesFor: #sampleClass!accessing!private! !
!Tools.Tests.ViewComposerTest categoriesFor: #tearDown!private!running! !
!Tools.Tests.ViewComposerTest categoriesFor: #testBasicEdit!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testCutCopyPaste!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testDragResourceOverEmptyArena!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testDropResourceLinkOverShell!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testDropResourceOverEmptyArena!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testDropResourceOverHierarchy!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testDropResourceOverShell!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testExit!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testIgnoreShellPreferredExtent!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testNoDragResourceOverInUseArena!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testPasteToArena!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testWidenSelection!public!unit tests! !
!Tools.Tests.ViewComposerTest categoriesFor: #testZOrderPreservedByMutate!public!unit tests! !


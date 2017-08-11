"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ViewComposerTest
	instanceVariableNames: 'vc testClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ViewComposerTest guid: (GUID fromString: '{84c0e504-bdda-4d87-92dc-53b89f80f634}')!
ViewComposerTest comment: ''!
!ViewComposerTest categoriesForClass!Unclassified! !
!ViewComposerTest methodsFor!

doArenaDropOf: subPresenterType operation: aSymbol
	| overShell ddSession |
	ddSession := self dragResourceFor: subPresenterType.
	aSymbol ifNotNil: [ddSession defaultOperation: aSymbol].
	overShell := vc arena mapPoint: 50 @ 50 to: View desktop.
	"We need to send two drag events as the VC waits for a drag-move after drag-enter before setting up for the drop."
	ddSession continueTrackingAt: overShell from: ddSession dragPoint.
	ddSession continueTrackingAt: overShell + 1 from: ddSession dragPoint.
	self assert: ddSession operation equals: aSymbol.
	self assert: ddSession suggestedTarget equals: vc composingView ?? vc arena.
	ddSession endTrackingAt: overShell.
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

setUp
	vc := ViewComposer show.
	testClass := ViewComposerTest 
				subclass: #ViewComposerTestSample
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: ''
				classInstanceVariableNames: ''!

tearDown
	DragDropSession current ifNotNil: [:dd | dd cancelTrackingAt: 0 @ 0].
	testClass removeFromSystem.
	vc destroy.
	vc := nil!

testBasicEdit
	| sampleResourceIdentifier |
	self assert: vc caption equals: 'View Composer'.
	"Test open something reasonably complex"
	vc openOn: (ResourceIdentifier class: MethodBrowserShell).
	self assert: vc composingView class sameAs: ShellView.
	self assert: vc primarySelection equals: vc composingView.
	"Test saving"
	sampleResourceIdentifier := ResourceIdentifier class: testClass.
	vc resourceIdentifier: sampleResourceIdentifier.
	vc viewSave.
	self assert: (testClass class includesSelector: #resource_Default_view).
	vc viewCloseNoPrompt.
	self assertIsNil: vc composingView.
	self assert: vc hasComposingView not.
	self assert: vc caption equals: 'View Composer'.
	self assert: vc viewHierarchyPresenter model isEmpty.

	"Test we can reload what we saved"
	vc openOn: sampleResourceIdentifier.
	self assert: vc composingView class sameAs: ShellView.
	self assert: vc primarySelection equals: vc composingView.
	vc viewCloseNoPrompt!

testCutCopyPaste
	| shell container button |
	vc newShellView.
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
	self assert: vc primarySelection class sameAs: PushButton.
	self assert: vc primarySelection parentView sameAs: shell.
	self deny: vc primarySelection sameAs: button.
	"Check old button still exists"
	self assert: button isOpen.
	self assert: button parentView sameAs: container.
	"Now try cut"
	vc selection: button.
	vc cutSelection.
	vc selection: shell.
	vc pasteClipboard.
	"Check new button exists in shell"
	self assert: vc primarySelection class sameAs: PushButton.
	self assert: vc primarySelection parentView sameAs: shell.
	self deny: vc primarySelection sameAs: button.
	"Check old button has gone"
	self assert: button isOpen not.
	self deny: button parentView sameAs: container!

testDragResourceOverEmptyArena
	| session |
	vc onDragOverArena: (session := self dragResourceFor: Shell).
	self assert: session operation sameAs: #copy.
	self assert: session suggestedTarget sameAs: vc arena!

testDropResourceLinkOverShell
	"Drop a Checkbox link onto a shell"

	| ddSession |
	vc newShellView.
	ddSession := self doArenaDropOf: TextPresenter operation: #link.
	self assert: vc primarySelection isKindOf: ReferenceView.
	self assert: vc primarySelection resourceIdentifier equals: (ResourceIdentifier class: TextPresenter).
	ddSession!

testDropResourceOverEmptyArena
	"Drop a shell onto an empty arena"

	self doArenaDropOf: Shell operation: #copy.
	self assert: vc composingView isKindOf: ShellView!

testDropResourceOverHierarchy
	"Drop a Checkbox onto a shell"

	| session |
	vc newShellView.
	session := self dragResourceFor: TextPresenter.
	session
		operation: #copy;
		suggestedTarget: vc viewHierarchyPresenter model roots first.
	vc onDropOverHierarchy: session.
	self assert: vc primarySelection isKindOf: TextEdit!

testDropResourceOverShell
	"Drop a Checkbox onto a shell"

	self doArenaDropOf: TextPresenter operation: #copy.
	self assert: vc primarySelection isKindOf: TextEdit!

testIgnoreShellPreferredExtent
	"Check to make sure that the VC doesn't allow the choice of shell extents
	even when they are marked as #userPreferredExtent"

	vc openOn: (ResourceIdentifier class: Shell).
	self assert: vc composingView usePreferredExtent.
	"If this test fails check to see that ShellView>>resourcce_Default_view does indeed have an
	extent of 600@400 when saved by the VC"
	self assert: vc composingView extent equals: 600 @ 400!

testNoDragResourceOverInUseArena
	| session toolbox |
	vc newShellView.
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
	vc newShellView.
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
	self assert: vc primarySelection class sameAs: PushButton.
	self assert: vc primarySelection parentView sameAs: View desktop.
	vc viewCloseNoPrompt!

testWidenSelection
	| chb classTree |
	vc openOn: (ResourceIdentifier class: ClassBrowserShell name: 'Default view').
	chb := vc composingView.
	classTree := chb viewNamed: 'classes'.
	vc selection: classTree.
	self assert: vc primarySelection sameAs: classTree.
	vc widenSelection.
	self assert: vc primarySelection sameAs: classTree parentView.
	vc widenSelection.
	self assert: vc primarySelection sameAs: classTree parentView parentView.
	vc widenSelection.
	self assert: vc primarySelection sameAs: chb.
	vc widenSelection.
	self assert: vc primarySelection sameAs: chb!

testZOrderPreservedByMutate
	| shell |
	vc newShellView.
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
!ViewComposerTest categoriesFor: #doArenaDropOf:operation:!private!unit tests! !
!ViewComposerTest categoriesFor: #dragResourceFor:!private!unit tests! !
!ViewComposerTest categoriesFor: #getButtonResource!private!unit tests! !
!ViewComposerTest categoriesFor: #getContainerResource!private!unit tests! !
!ViewComposerTest categoriesFor: #setUp!private!unit tests! !
!ViewComposerTest categoriesFor: #tearDown!private!unit tests! !
!ViewComposerTest categoriesFor: #testBasicEdit!public!unit tests! !
!ViewComposerTest categoriesFor: #testCutCopyPaste!public!unit tests! !
!ViewComposerTest categoriesFor: #testDragResourceOverEmptyArena!public!unit tests! !
!ViewComposerTest categoriesFor: #testDropResourceLinkOverShell!public!unit tests! !
!ViewComposerTest categoriesFor: #testDropResourceOverEmptyArena!public!unit tests! !
!ViewComposerTest categoriesFor: #testDropResourceOverHierarchy!public!unit tests! !
!ViewComposerTest categoriesFor: #testDropResourceOverShell!public!unit tests! !
!ViewComposerTest categoriesFor: #testIgnoreShellPreferredExtent!public!unit tests! !
!ViewComposerTest categoriesFor: #testNoDragResourceOverInUseArena!public!unit tests! !
!ViewComposerTest categoriesFor: #testPasteToArena!public!unit tests! !
!ViewComposerTest categoriesFor: #testWidenSelection!public!unit tests! !
!ViewComposerTest categoriesFor: #testZOrderPreservedByMutate!public!unit tests! !


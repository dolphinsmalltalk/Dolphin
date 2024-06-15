"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #ViewComposerTest
	instanceVariableNames: 'sampleClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ViewComposerTest guid: (GUID fromString: '{84c0e504-bdda-4d87-92dc-53b89f80f634}')!

ViewComposerTest comment: ''!

!ViewComposerTest categoriesForClass!Unclassified! !

!ViewComposerTest methodsFor!

classToTest
	^ViewComposer!

destroyPresenter
	presenter ifNil: [^self].
	presenter destroy.
	presenter := nil!

doArenaDropOf: subPresenterType operation: aSymbol
	| overShell ddSession |
	self denyIsNil: aSymbol.
	ddSession := self dragResourceFor: subPresenterType.
	aSymbol ifNotNil: [ddSession defaultOperation: aSymbol].
	overShell := presenter arena mapPointToScreen: 50 @ 50.
	"To avoid any dependency on the state of the runtime environment (such as the desktop being
	locked, or there being other Windows on top of the VC), we simulate the dragging over the VC
	arena"
	ddSession
		dragPoint: overShell;
		dropTarget: presenter arena;
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
	toolbox := presenter instVarNamed: 'toolboxPresenter'.
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
	^presenter
		ifNil: 
			[presenter := aResourceId
						ifNil: [ViewComposer show]
						ifNotNil: 
							[presenter := ViewComposer create
										openOn: aResourceId;
										show;
										yourself]]
		ifNotNil: [presenter openOn: aResourceId]!

openTestSubjectOnNewShell
	^self openTestSubjectOn: (ResourceIdentifier class: Shell)!

sampleClass
	^sampleClass
		ifNil: 
			[sampleClass := ViewComposerTest
						subclass: #ViewComposerTestSample
						instanceVariableNames: ''
						classVariableNames: ''
						poolDictionaries: ''
						classInstanceVariableNames: '']!

shouldSetupPresenter
	^false!

tearDown
	DragDropSession current ifNotNil: [:dd | dd cancelTrackingAt: 0 @ 0].
	sampleClass ifNotNil: [sampleClass removeFromSystem].
	super tearDown!

testBasicEdit
	| sampleResourceIdentifier rid |
	"Test open a default view that is reasonably complex"
	rid := ResourceIdentifier class: ViewComposer.
	self openTestSubjectOn: rid.
	self assert: presenter composingView dpiAwareness equals: DpiAwareness gdiScaled.
	self assert: presenter composingView dpi equals: 96.
	self assert: presenter arena dpi equals: 96.
	self assert: presenter caption equals: rid displayString , '(ShellView)'.
	self assert: presenter composingView class identicalTo: ShellView.
	self assert: presenter primarySelection equals: presenter composingView.
	"Test saving"
	sampleResourceIdentifier := ResourceIdentifier class: self sampleClass.
	presenter resourceIdentifier: sampleResourceIdentifier.
	presenter viewSave.
	self assert: (self sampleClass class includesSelector: #resource_Default_view).
	presenter viewCloseNoPrompt.
	self assertIsNil: presenter composingView.
	self assert: presenter hasComposingView not.
	self assert: presenter caption equals: 'View Composer'.
	self assert: presenter viewHierarchyPresenter model isEmpty.

	"Test we can reload what we saved"
	presenter openOn: sampleResourceIdentifier.
	self assert: presenter composingView class identicalTo: ShellView.
	self assert: presenter primarySelection equals: presenter composingView!

testCutCopyPaste
	| shell container button |
	self openTestSubjectOnNewShell.
	shell := presenter composingView.
	container := presenter
				pasteResource: self getContainerResource
				context: shell
				position: 0 @ 0.
	self assert: container class equals: ContainerView.
	container name: 'container'.
	button := presenter
				pasteResource: self getButtonResource
				context: container
				position: 0 @ 0.
	self assert: button class equals: PushButton.
	button name: 'button'.
	presenter selection: button.
	presenter copySelection.
	presenter selection: shell.
	presenter pasteClipboard.
	"Check new button exists in shell"
	self assert: presenter primarySelection class identicalTo: PushButton.
	self assert: presenter primarySelection parentView identicalTo: shell.
	self deny: presenter primarySelection identicalTo: button.
	"Check old button still exists"
	self assert: button isOpen.
	self assert: button parentView identicalTo: container.
	"Now try cut"
	presenter selection: button.
	presenter cutSelection.
	presenter selection: shell.
	presenter pasteClipboard.
	"Check new button exists in shell"
	self assert: presenter primarySelection class identicalTo: PushButton.
	self assert: presenter primarySelection parentView identicalTo: shell.
	self deny: presenter primarySelection identicalTo: button.
	"Check old button has gone"
	self assert: button isOpen not.
	self deny: button parentView identicalTo: container!

testDragResourceOverEmptyArena
	| session |
	self openTestSubjectOn: nil.
	presenter onDragOverArena: (session := self dragResourceFor: Shell).
	self assert: session operation identicalTo: #copy.
	self assert: session suggestedTarget identicalTo: presenter arena!

testDropResourceLinkOverShell
	"Drop a Checkbox link onto a shell"

	| ddSession |
	self openTestSubjectOnNewShell.
	ddSession := self doArenaDropOf: TextPresenter operation: #link.
	self assert: presenter primarySelection isKindOf: ReferenceView.
	self assert: presenter primarySelection resourceIdentifier
		equals: (ResourceIdentifier class: TextPresenter).
	ddSession!

testDropResourceOverEmptyArena
	"Drop a shell onto an empty arena"
	self openTestSubjectOn: nil.
	self doArenaDropOf: Shell operation: #copy.
	self assert: presenter composingView isKindOf: ShellView!

testDropResourceOverHierarchy
	"Drop a Checkbox onto a shell"

	| session |
	self openTestSubjectOnNewShell.
	session := self dragResourceFor: TextPresenter.
	session
		operation: #copy;
		suggestedTarget: presenter viewHierarchyPresenter model roots first.
	presenter onDropOverHierarchy: session.
	self assert: presenter primarySelection isKindOf: TextEdit!

testDropResourceOverShell
	"Drop a Checkbox onto a shell"
	self openTestSubjectOn: nil.
	self doArenaDropOf: TextPresenter operation: #copy.
	self assert: presenter primarySelection isKindOf: TextEdit!

testExit
	"Exiting the view composer used to raise an error
	due to trying to redraw the adornment after the view was closed.
	
	N.B. we must simulate the way the command will actually be routed
	through #performCommand: in order to trigger the bug."

	| query |
	self openTestSubjectOnNewShell.
	query := presenter commandPolicy query: (CommandDescription command: #exit).
	self shouldnt: [query perform] raise: Error.
	self deny: presenter isOpen!

testIgnoreShellPreferredExtent
	"Check to make sure that the VC doesn't allow the choice of shell extents
	even when they are marked as #userPreferredExtent"

	self openTestSubjectOnNewShell.
	self assert: presenter composingView usePreferredExtent.
	"If this test fails check to see that ShellView>>resourcce_Default_view does indeed have an
	extent of 600@400 when saved by the VC. Remember that if we ask the "
	self assert: (presenter composingView inDpiAwarenessContextDo: [presenter composingView extent]) equals: 600 @ 400!

testNoDragResourceOverInUseArena
	| session toolbox |
	self openTestSubjectOnNewShell.
	toolbox := presenter instVarNamed: 'toolboxPresenter'.
	session := InternalDragDropSession dragSource: toolbox view item: (ResourceIdentifier class: Shell).
	toolbox resourcesPresenter onDragResource: session.
	session
		startTrackingAt: 20 @ 20;
		operation: #copy.
	presenter onDragOverArena: session.
	self assertIsNil: session operation.
	self assertIsNil: session suggestedTarget!

testPasteToArena
	"Get a ShellView to paste"

	| shell button |
	self openTestSubjectOnNewShell.
	shell := presenter composingView.
	presenter copySelection.
	presenter viewCloseNoPrompt.
	"Paste to empty view composer"
	self assert: presenter canPaste.
	presenter pasteClipboard.
	shell := presenter primarySelection.
	self assert: shell class equals: ShellView.
	"Get a PushButton to paste"
	button := presenter
				pasteResource: self getButtonResource
				context: shell
				position: 0 @ 0.
	presenter selection: button.
	presenter copySelection.
	presenter viewCloseNoPrompt.
	"Paste to empty view composer"
	presenter pasteClipboard.
	"Check new button exists"
	self assert: presenter primarySelection class identicalTo: PushButton.
	self assert: presenter primarySelection parentView isDesktop.
	presenter viewCloseNoPrompt!

testWidenSelection
	| shell browser |
	self openTestSubjectOn: (ResourceIdentifier class: MethodHistoryBrowser name: 'Default view').
	shell := presenter composingView.
	browser := shell viewNamed: 'slider'.
	presenter selection: browser.
	self assert: presenter primarySelection identicalTo: browser.
	presenter widenSelection.
	self assert: presenter primarySelection identicalTo: browser parentView.
	presenter widenSelection.
	self assert: presenter primarySelection identicalTo: browser parentView parentView.
	presenter widenSelection.
	self assert: presenter primarySelection identicalTo: shell.
	presenter widenSelection.
	self assert: presenter primarySelection identicalTo: shell!

testZOrderPreservedByMutate
	| shell |
	self openTestSubjectOnNewShell.
	shell := presenter pasteContext.
	1 to: 3
		do: 
			[:i |
			| view |
			view := presenter
						pasteResource: (ResourceIdentifier class: TextPresenter name: 'Default view') resource
						context: shell
						position: (20 * i) @ (10 * i).
			view name: i printString].
	self assert: (shell subViews collect: [:each | each name]) asArray equals: #('1' '2' '3').
	presenter selection: shell.
	presenter mutateTo: ContainerView.
	self assert: (shell subViews collect: [:each | each name]) asArray equals: #('1' '2' '3')!

viewClass
	^ShellView! !

!ViewComposerTest categoriesForMethods!
classToTest!helpers!private! !
destroyPresenter!public!Running! !
doArenaDropOf:operation:!helpers!private! !
dragResourceFor:!helpers!private! !
getButtonResource!helpers!private! !
getContainerResource!helpers!private! !
openTestSubjectOn:!helpers!private! !
openTestSubjectOnNewShell!helpers!private! !
sampleClass!accessing!private! !
shouldSetupPresenter!helpers!private! !
tearDown!private!running! !
testBasicEdit!public!unit tests! !
testCutCopyPaste!public!unit tests! !
testDragResourceOverEmptyArena!public!unit tests! !
testDropResourceLinkOverShell!public!unit tests! !
testDropResourceOverEmptyArena!public!unit tests! !
testDropResourceOverHierarchy!public!unit tests! !
testDropResourceOverShell!public!unit tests! !
testExit!public!unit tests! !
testIgnoreShellPreferredExtent!public!unit tests! !
testNoDragResourceOverInUseArena!public!unit tests! !
testPasteToArena!public!unit tests! !
testWidenSelection!public!unit tests! !
testZOrderPreservedByMutate!public!unit tests! !
viewClass!constants!private! !
!

!ViewComposerTest class methodsFor!

resource_Vertical_view_D6
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 131073 560 0 482 8 4278190080 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 482 656 8 4294905305 234 256 98 6 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 848 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 1 754 63 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'imageTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1264 0 930 31 0 7 0 0 0 1264 962 576 8 #resource_File_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1053 1 754 155 51 1264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 91 2 0 0 25 0 0 0] 1216 1232 0 27 8 'fileTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1536 0 930 31 0 7 0 0 0 1536 962 576 8 #resource_Smalltalk_tools 0 1010 202 208 98 1 1074 1104 98 2 754 63 1 754 991 51 1536 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1216 1232 0 27 8 'smalltalkTools' 234 256 1216 98 0 234 240 1216 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 1010 202 208 98 2 1074 1104 98 2 754 1 1 754 1679 51 560 1074 8 #updateSize 1216 560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 71 3 0 0 25 0 0 0] 98 3 848 1536 1264 1232 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140853004 1 2112 0 482 656 0 7 0 0 0 2112 0 8 4294905043 234 256 98 6 853766 ##(Smalltalk.StatusBarItem)  1 37 2112 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association)  8 #Smalltalk 48 8 #developmentSystem 8 #changedIcon 8 #imageIndex 2304 7 257 0 0 8 'modificationStatus' 2258 1 301 2112 0 2290 0 0 2322 4 1 2352 8 'doIt' 8 '[:r | r notNil ifTrue: [r extent displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] 8 #extent 8 #displayString 8 '' 2544 7 257 0 1074 8 #extentImage 98 0 8 ##(Smalltalk.ViewComposer)  1049670 1 ##(Smalltalk.IconImageManager)  8 'extentStatus' 2258 1 301 2112 0 2290 0 0 2322 4 1 2352 8 'doIt' 8 '[:r | r notNil ifTrue: [r position displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] 8 #position 2640 2656 2800 7 257 0 1074 8 #positionImage 2704 2720 2752 8 'positionStatus' 98 3 2784 2528 2272 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 2112 0 0 1010 202 208 98 1 1074 1104 98 2 754 1 1095 754 1679 45 2112 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 35 2 0 0 71 3 0 0 57 2 0 0] 98 0 1232 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 3152 0 0 0 7 0 0 0 3152 1180166 ##(Smalltalk.ProportionalLayout)  234 240 1216 16 234 256 98 2 410 3168 98 15 0 3152 98 2 8 1140850688 131073 3312 0 0 0 7 0 0 0 3312 3234 202 8 ##(Smalltalk.Dictionary)  98 2 2418 410 3168 98 15 0 3312 98 2 8 1140850688 131073 3456 0 0 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 16 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #cutSelection 8 'Cu&t' 1 1 0 0 0 3570 1 3602 8 #copySelection 8 '&Copy' 1 1 0 0 0 3570 1 3602 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 3570 1 3602 8 #clearSelection 8 '&Delete' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3570 1 3602 8 #editContextMenu 8 'Set Conte&xt Menu...' 1 1 0 0 0 3858 4097 3570 1 3602 8 #toggleTabStop 8 'Make Tab &Stop' 1 1 0 0 0 3570 1 3602 8 #toggleGroupStop 8 'Make &Group Stop' 1 1 0 0 0 3858 4097 3522 0 16 98 7 3570 1 3602 8 #alignLefts 8 '&Lefts' 1 1 0 0 0 3570 1 3602 8 #alignCenters 8 '&Centres' 1 1 0 0 0 3570 1 3602 8 #alignRights 8 '&Rights' 1 1 0 0 0 3858 4097 3570 1 3602 8 #alignTops 8 '&Tops' 1 1 0 0 0 3570 1 3602 8 #alignMiddles 8 '&Middles' 1 1 0 0 0 3570 1 3602 8 #alignBottoms 8 '&Bottoms' 1 1 0 0 0 8 'View Alig&n' 0 134217729 0 0 0 0 0 3522 0 16 98 5 3570 1 3602 8 #matchWidths 8 '&Widths' 1 1 0 0 0 3570 1 3602 8 #matchHeights 8 '&Heights' 1 1 0 0 0 3570 1 3602 8 #matchFonts 8 '&Fonts' 1 1 0 0 0 3570 1 3602 8 #matchForegroundColors 8 'Foreground &Colors' 1 1 0 0 0 3570 1 3602 8 #matchBackgroundColors 8 '&Background Colors' 1 1 0 0 0 8 'View Matc&h' 0 134217729 0 0 0 0 0 3522 0 16 98 4 3570 1 3602 8 #zFront 8 'Bring to &Front' 1 1 0 0 0 3570 1 3602 8 #zForward 8 'Bring F&orward' 1 1 0 0 0 3570 1 3602 8 #zBackward 8 'Send B&ackward' 1 1 0 0 0 3570 1 3602 8 #zBack 8 'Send to Bac&k' 1 1 0 0 0 8 'View &Arrange' 0 134217729 0 0 0 0 0 3858 4097 3570 1 3602 8 #mutate 8 'M&utate View...' 1 1 0 0 0 3522 0 16 98 2 3570 1 3602 8 #dereference 8 'De&reference to Copy' 1 1 0 0 0 3570 1 3602 8 #editReference 8 '&Edit' 1 1 0 0 0 8 '&Reference View' 8 #referenceViewMenu 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3456 3234 234 240 98 4 410 3168 98 15 0 3456 98 2 8 1140850688 131073 5568 0 0 0 7 0 0 0 5568 530 1 1 0 410 8 ##(Smalltalk.SlideyInneyOuteyThing)  98 23 0 5568 98 2 8 1140850688 131073 5648 0 917766 ##(Smalltalk.PluggableColor)  1074 8 #toolBackgroundColor 98 0 8 ##(Smalltalk.SmalltalkSystem)  0 519 0 0 0 5648 655878 ##(Smalltalk.CardLayout)  202 208 98 5 2418 8 'Arrange' 410 864 98 14 0 410 8 ##(Smalltalk.SlidingCardTray)  98 22 0 5648 98 2 8 1140850688 131073 5952 0 482 8 4278190080 0 7 0 0 0 5952 5840 234 256 98 10 410 576 98 25 0 5952 98 2 8 1140853580 131137 6096 0 482 8 4278190080 0 517 0 674 0 16 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 6096 482 6176 8 4294905305 234 256 98 4 410 864 98 14 0 6096 98 2 8 1140850688 131073 6320 0 930 31 0 5 0 0 0 6320 962 576 8 #resource_View_composer_alignment_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 339 51 6320 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 169 0 0 0 25 0 0 0] 1216 1232 0 27 8 'alignmentTools' 410 864 98 14 0 6096 98 2 8 1140850688 131073 6592 0 930 31 0 5 0 0 0 6592 962 576 8 #resource_View_composer_match_size_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 51 754 201 51 6592 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 100 0 0 0 50 0 0 0] 1216 1232 0 27 8 'matchSizeTools' 234 256 1216 202 208 1216 234 240 1216 0 1 0 754 33 33 754 45 45 0 1890 1 1 1 1010 202 208 98 2 1074 1104 98 2 754 1 37 754 515 55 6096 1074 2048 1216 6096 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 1 1 0 0 45 0 0 0] 98 2 6320 6592 1232 0 27 8 'alignTools' 410 864 98 14 0 5952 98 2 8 1140850688 131073 7152 0 930 31 0 7 0 0 0 7152 962 576 8 #resource_Edit_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 37 754 515 55 7152 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 1 1 0 0 45 0 0 0] 1216 1232 0 27 8 'editTools' 5920 8 'arrangementTools' 410 864 98 14 0 5952 98 2 8 1140850688 131073 7440 0 930 31 0 5 0 0 0 7440 962 576 8 #resource_View_composer_spacing_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 37 754 515 55 7440 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 1 1 0 0 45 0 0 0] 1216 1232 0 27 8 'layoutTools' 410 864 98 14 0 5952 98 2 8 1140850688 131073 7712 0 930 31 0 5 0 0 0 7712 962 576 8 #resource_View_composer_nudge_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 37 754 515 55 7712 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 1 1 0 0 45 0 0 0] 1216 1232 0 27 8 'nudgeTools' 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 5648 98 2 8 1140916738 1 7984 590662 2 ##(Smalltalk.ListModel)  202 208 98 5 8 'Edit' 5904 8 'Nudge' 8 'Align' 8 'Layout' 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  5744 0 1 0 0 0 7984 0 8 4294902173 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  2752 0 0 0 0 0 8 #noIcons 0 0 0 0 0 1010 202 208 98 3 1074 1104 98 2 754 1 1 754 531 147 7984 1074 8 #basicSelectionsByIndex: 98 1 98 1 3 7984 1074 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 7984 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 9 1 0 0 73 0 0 0] 98 0 1232 0 27 0 5648 754 33 33 1049862 ##(Smalltalk.ButtonInteractor)  5952 0 590342 ##(Smalltalk.Rectangle)  754 479 3 754 511 35 1 3602 8 #togglePin 8 'Pin or Unpin the tray' 1 1 0 0 0 1010 202 208 98 1 1074 1104 98 2 754 9 9 754 515 91 5952 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 5 1 0 0 49 0 0 0] 98 5 7152 5920 7712 6096 7440 1232 0 27 98 2 8 1140850688 131073 5920 0 930 31 0 5 0 0 0 5920 962 576 8 #resource_View_composer_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 37 754 515 55 5920 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 1 1 0 0 45 0 0 0] 1216 1232 0 27 2418 8144 7712 2418 8160 6096 2418 8176 7440 2418 8128 7152 7152 234 256 1216 0 7984 5952 754 201 201 401 1 524319 0 0 1010 202 208 98 1 1074 1104 98 2 754 1 899 754 531 147 5648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 193 1 0 0 9 1 0 0 10 2 0 0] 98 2 5952 7984 1232 0 27 0 0 410 8 ##(Smalltalk.ScrollingDecorator)  98 18 0 5568 98 2 8 1143996416 131073 9360 0 0 0 7 0 0 0 9360 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout)  16 234 256 98 2 410 8 ##(Smalltalk.ViewComposerArena)  98 22 0 9360 98 2 8 1140850944 1 9504 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 196934 1 ##(Smalltalk.RGB)  28306427 0 535 0 0 0 9504 0 0 852486 ##(Smalltalk.NullConverter)  0 0 0 0 8 #normal 0 8610 754 21 21 754 21 21 0 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 1577 1397 9504 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 20 3 0 0 186 2 0 0] 98 0 1232 0 27 8 'arena' 0 754 1 1 16 754 17 17 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 531 899 9360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 9 1 0 0 193 1 0 0] 98 1 9504 1232 0 27 234 256 98 2 5648 8 'toolbarsSlidey' 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 531 1045 5568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 9 1 0 0 10 2 0 0] 98 2 9360 5648 1232 0 27 524806 ##(Smalltalk.Fraction)  521 323 410 5664 98 23 0 3456 98 2 8 1140850688 131073 10384 0 5730 1074 5776 98 0 5808 0 519 0 0 0 10384 5826 202 208 98 1 2418 590662 1 ##(Smalltalk.CardLabel)  8 'Property Inspector' 2290 0 0 2322 6 1 80 8 'doIt' 8 '(CardLabel text: ''Property Inspector'' iconBlock: [PublishedAspectInspector icon])' 8 #[45 30 34 112 47 161 106 194 105] 983558 ##(Smalltalk.VariableBinding)  8 #CardLabel 10560 10592 10690 8 #PublishedAspectInspector 8 ##(Smalltalk.PublishedAspectInspector)  8 #icon 8 #text:iconBlock: 10608 11 1 0 21659 410 3168 98 15 0 410 5968 98 22 0 10384 98 2 8 1140850688 131073 10848 0 482 8 4278190080 0 7 0 0 0 10848 10496 234 256 1216 0 410 8000 98 28 0 10384 98 2 8 1140916866 1 10960 8066 202 208 98 1 10576 0 8208 10448 0 1 0 0 0 10960 0 8 4294902173 8240 8256 2752 0 0 0 0 0 8 #smallIcons 0 0 0 0 0 1010 202 208 98 3 1074 1104 98 2 754 1 1 754 205 1045 10960 1074 8416 98 1 98 1 3 10960 1074 8480 98 2 -1 1 10960 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 10 2 0 0] 98 0 1232 0 27 0 10384 754 33 33 8578 10848 0 8610 754 5 3 754 37 35 1 3602 8688 8 'Pin or Unpin the tray' 1 1 0 0 0 1010 202 208 98 1 1074 1104 98 2 754 9 9 754 143 1029 10848 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 75 0 0 0 6 2 0 0] 98 1 10816 1232 0 27 98 2 8 1140850688 131073 10816 0 482 8 4278190080 0 7 0 0 0 10816 3234 202 3408 98 3 2418 410 864 98 14 0 10816 98 2 8 1140850688 131073 11744 0 0 0 7 0 0 0 11744 962 10768 8 #resource_Vertical_view 0 1010 202 208 98 1 1074 1104 98 2 754 1 311 754 143 683 11744 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 155 0 0 0 71 0 0 0 240 1 0 0] 1216 1232 0 27 327734 ##(Smalltalk.Float)  8 102 102 102 102 102 102 230 63 2418 410 8 ##(Smalltalk.TreeView)  98 27 0 10816 98 2 8 1140916771 1 12032 590918 3 ##(Smalltalk.TreeModel)  0 8208 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 1216 482 11664 0 31 0 0 0 12032 0 8 4294908185 8240 8256 2752 0 0 0 0 0 234 240 1216 17 11088 1 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 143 293 12032 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 71 0 0 0 146 0 0 0] 98 0 1232 0 27 11986 8 51 51 51 51 51 51 211 63 2418 410 8 ##(Smalltalk.Splitter)  98 12 0 10816 98 2 8 1140850688 1 12432 0 482 11664 0 519 0 0 0 12432 1010 202 208 98 1 1074 1104 98 2 754 1 293 754 143 19 12432 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 146 0 0 0 71 0 0 0 155 0 0 0] 98 0 1232 0 27 1 16 234 256 98 4 11744 8 'inspector' 12032 8 'viewHierarchy' 0 1010 202 208 98 1 1074 1104 98 2 754 1 37 754 143 993 10816 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 71 0 0 0 2 2 0 0] 98 3 12032 12432 11744 1232 0 27 10816 234 256 1216 0 10960 10848 754 201 201 401 1 524319 0 0 1010 202 208 98 1 1074 1104 98 2 754 549 1 754 205 1045 10384 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 120 1 0 0 10 2 0 0] 98 2 10848 10960 1232 0 27 10354 201 323 32 234 256 98 2 10384 8 'inspectorSlidey' 0 1010 202 208 98 2 1074 1104 98 2 754 927 1 754 753 1045 3456 1074 8 #contextMenu: 98 1 3536 3456 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 1 0 0 0 0 0 0 71 3 0 0 10 2 0 0] 98 3 5568 410 12448 98 12 0 3456 98 2 8 1140850688 1 13376 0 482 8 4278190080 0 519 0 0 0 13376 1010 202 208 98 1 1074 1104 98 2 754 531 1 754 19 1045 13376 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 1 0 0 0 0 0 0 18 1 0 0 10 2 0 0] 98 0 1232 0 27 10384 1232 0 27 11986 8 169 26 84 171 104 22 234 63 2418 410 5664 98 23 0 3312 98 2 8 1140850688 131073 13664 0 5730 1074 5776 98 0 5808 0 519 0 0 0 13664 5826 202 208 98 1 2418 10562 8 'View Toolbox' 2290 0 0 2322 7 1 80 8 'doIt' 8 '(CardLabel text: ''View Toolbox'' iconBlock: [Icon fromId: ''View.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 10560 13856 8 ##(Smalltalk.Icon)  8 'View.ico' 8 #fromId: 10800 13872 11 1 0 0 410 864 98 14 0 410 5968 98 22 0 13664 98 2 8 1140850688 131073 14032 0 482 8 4278190080 0 7 0 0 0 14032 13776 234 256 98 2 14000 8 'toolbox' 0 410 8000 98 28 0 13664 98 2 8 1140916864 1 14176 8066 202 208 98 1 13840 0 8208 13728 0 1 0 0 0 14176 0 8 4294902173 8240 8256 2752 0 0 0 0 0 11088 0 0 0 0 0 1010 202 208 98 3 1074 1104 98 2 754 1 1 754 909 1045 14176 1074 8416 98 1 98 1 3 14176 1074 8480 98 2 -1 1 14176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 198 1 0 0 10 2 0 0] 98 0 1232 0 27 0 13664 754 33 33 8578 14032 0 8610 754 811 3 754 843 35 1 3602 8688 8 'Pin or Unpin the tray' 1 1 0 0 0 1010 202 208 98 1 1074 1104 98 2 754 55 9 754 847 1029 14032 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 4 0 0 0 194 1 0 0 6 2 0 0] 98 1 14000 1232 0 27 98 2 8 1140850688 131073 14000 0 482 8 4278190080 0 1031 0 0 0 14000 962 8 ##(Smalltalk.ResourceToolboxPresenter)  8 #resource_Default_view 0 1010 202 208 98 1 1074 1104 98 2 754 1 37 754 847 993 14000 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 167 1 0 0 2 2 0 0] 1216 1232 0 27 14000 234 256 1216 0 14176 14032 754 745 959 401 1 524319 0 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 909 1045 13664 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 198 1 0 0 10 2 0 0] 98 2 14032 14176 1232 0 27 11986 8 239 126 69 238 48 131 239 63 32 234 256 98 2 13664 8 'toolsSlidey' 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 1679 1045 3312 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 71 3 0 0 10 2 0 0] 98 3 13664 410 12448 98 12 0 3312 98 2 8 1140850688 1 15488 0 482 8 4278190080 0 519 0 0 0 15488 1010 202 208 98 1 1074 1104 98 2 754 909 1 754 19 1045 15488 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 198 1 0 0 0 0 0 0 207 1 0 0 10 2 0 0] 98 0 1232 0 27 3456 1232 0 27 8 'main' 0 1010 202 208 98 1 1074 1104 98 2 754 1 51 754 1679 1045 3152 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 71 3 0 0 35 2 0 0] 98 1 3312 1232 0 27 234 256 98 4 2112 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 7 3522 0 16 98 16 3570 1 3602 8 #newShellView 8 '&New Shell View' 9373 1 13954 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ShellView.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 3570 1 3602 8 #newDialogView 8 'New &Dialog View' 1 1 13954 0 16 16160 8 'DialogView.ico' 16208 0 0 3858 4097 3570 1 3602 8 #viewOpen 8 '&Open...' 9375 1 0 0 0 3570 1 3602 8 #viewClose 8 '&Close' 1 1 0 0 0 3570 1 3602 8 #viewRevert 8 '&Revert' 1 1 13954 0 16 16160 8 'Revert.ico' 16208 0 0 3858 4097 3570 1 3602 8 #viewImport 8 '&Import View...' 1 1 0 0 0 3570 1 3602 8 #viewExport 8 '&Export View...' 1 1 0 0 0 3858 4097 3570 1 3602 8 #viewSave 8 '&Save' 1 1 13954 0 16 16160 8 'FileSave.ico' 16208 0 0 3570 1 3602 8 #viewSaveAs 8 'Save &As...' 1 1 0 0 0 3858 4097 3570 1 3602 8 #viewTest 8 '&Test' 9385 1 0 0 0 3858 4097 3570 1 3602 8 #exit 8 'E&xit' 17639 1 13954 0 16 16160 8 'CloseWindow.ico' 16208 0 0 8 '&File' 0 134217729 0 0 20517 0 0 3522 0 16 98 12 3570 1 3602 8 #viewUndo 8 '&Undo' 9397 1 13954 0 16 16160 8 'EditUndo.ico' 16208 0 0 3570 1 3602 8 #viewRedo 8 '&Redo' 9395 1 13954 0 16 16160 8 'EditRedo.ico' 16208 0 0 3858 4097 3570 1 3602 3632 8 'Cu&t' 9393 1 13954 0 16 16160 8 'EditCut.ico' 16208 0 0 3570 1 3602 3696 8 '&Copy' 9351 1 13954 0 16 16160 8 'EditCopy.ico' 16208 0 0 3570 1 3602 3760 8 '&Paste' 9389 1 13954 0 16 16160 8 'EditPaste.ico' 16208 0 0 3570 1 3602 3824 8 '&Delete' 1 1 13954 0 16 16160 8 'EditClear.ico' 16208 0 0 3858 4097 3570 1 3602 8 #widenSelection 8 '&Widen Selection' 9387 1 0 0 0 3570 1 3602 8 #selectAll 8 'Select &All' 9347 1 0 0 0 3858 4097 3570 1 3602 8 #refreshPublishedAspects 8 'Refresh Inspector' 1257 1 13954 0 16 16160 8 'Refresh.ico' 16208 0 0 8 '&Edit' 0 134217729 0 0 20537 0 0 3522 0 16 98 17 3570 1 3602 8 #editMenuBar 8 '&Menu Bar...' 1 1 0 0 0 3570 1 3602 3920 8 '&Context Menu...' 1 1 0 0 0 3858 4097 3570 1 3602 4000 8 'Make &Tab Stop' 1 1 0 0 0 3570 1 3602 4064 8 'Make &Group Stop' 1 1 0 0 0 3858 4097 3522 0 16 98 7 3570 1 3602 4176 8 '&Lefts' 1 1 0 0 0 3570 1 3602 4240 8 '&Centres' 1 1 0 0 0 3570 1 3602 4304 8 '&Rights' 1 1 0 0 0 3858 4097 3570 1 3602 4384 8 '&Tops' 1 1 0 0 0 3570 1 3602 4448 8 '&Middles' 1 1 0 0 0 3570 1 3602 4512 8 '&Bottoms' 1 1 0 0 0 8 '&Align' 0 134217729 0 0 20559 0 0 3522 0 16 98 5 3570 1 3602 4624 8 '&Widths' 1 1 0 0 0 3570 1 3602 4688 8 '&Heights' 1 1 0 0 0 3570 1 3602 4752 8 '&Fonts' 1 1 0 0 0 3570 1 3602 4816 8 'Foreground &Colors' 1 1 0 0 0 3570 1 3602 4880 8 '&Background Colors' 1 1 0 0 0 8 'Matc&h' 0 134217729 0 0 20571 0 0 3522 0 16 98 4 3570 1 3602 4992 8 'Bring to &Front' 9357 1 0 0 0 3570 1 3602 5056 8 'Bring F&orward' 13453 1 0 0 0 3570 1 3602 5120 8 'Send B&ackward' 13463 1 0 0 0 3570 1 3602 5184 8 'Send to Bac&k' 9367 1 0 0 0 8 'A&rrange' 0 134217729 0 0 20581 0 0 3522 0 16 98 4 3570 1 3602 8 #nudgeLeft 8 '&Left' 9803 1 0 0 0 3570 1 3602 8 #nudgeRight 8 '&Right' 9807 1 0 0 0 3570 1 3602 8 #nudgeUp 8 '&Up' 9805 1 0 0 0 3570 1 3602 8 #nudgeDown 8 '&Down' 9809 1 0 0 0 8 '&Nudge' 0 134217729 0 0 20591 0 0 3522 0 16 98 4 3570 1 3602 8 #increaseHeight 8 '&Taller' 13905 1 0 0 0 3570 1 3602 8 #increaseWidth 8 '&Fatter' 13903 1 0 0 0 3570 1 3602 8 #decreateHeight 8 '&Shorter' 13901 1 0 0 0 3570 1 3602 8 #decreaseWidth 8 'Th&inner' 13899 1 0 0 0 8 'Gro&w' 0 134217729 0 0 20601 0 0 3858 4097 3522 0 16 98 3 3570 1 3602 8 #distributeHorizontally 8 'Distri&bute Evenly' 1 1 0 0 0 3570 1 3602 8 #increaseHorizontalGaps 8 '&Increase' 1 1 0 0 0 3570 1 3602 8 #decreaseHorizontalGaps 8 '&Decrease' 1 1 0 0 0 8 'Hori&zontal Spacing' 0 134217729 0 0 20609 0 0 3522 0 16 98 3 3570 1 3602 8 #distributeVertically 8 'Distri&bute Evenly' 1 1 0 0 0 3570 1 3602 8 #increaseVerticalGaps 8 '&Increase' 1 1 0 0 0 3570 1 3602 8 #decreaseVerticalGaps 8 '&Decrease' 1 1 0 0 0 8 '&Vertical Spacing' 0 134217729 0 0 20617 0 0 3858 4097 3570 1 3602 5280 8 'M&utate View...' 1 1 0 0 0 3570 1 3602 5376 8 '&Dereference to Copy' 1 1 0 0 0 8 '&Modify' 0 134217729 0 0 20623 0 0 3522 0 16 98 15 3570 1 3602 8 #browseIt 8 '&Browse It' 9349 1 13954 0 16 16160 8 'ClassBrowserShell.ico' 16208 0 0 3570 1 3602 8 #displayIt 8 '&Display It' 9353 1 13954 0 16 16160 8 'DisplayIt.ico' 16208 0 0 3570 1 3602 8 #evaluateIt 8 '&Evaluate It' 9355 1 13954 0 16 16160 8 'EvaluateIt.ico' 16208 0 0 3570 1 3602 8 #inspectIt 8 '&Inspect It' 9363 1 13954 0 16 16160 8 'BasicInspector.ico' 16208 0 0 3570 1 3602 8 #debugIt 8 'Deb&ug It' 1269 1 13954 0 16 16160 8 'Debugger.ico' 16208 0 0 3570 1 3602 8 #fileItIn 8 '&File it In' 1 1 0 0 0 3858 4097 3570 1 3602 8 #chooseEvaluationPools 8 '&Pools...' 1 1 13954 0 16 16160 8 'Dictionary.ico' 16208 0 0 3858 4097 3570 1 3602 8 #browseDefinitions 8 'Defi&nitions...' 1271 1 0 0 0 3570 1 3602 8 #browseReferences 8 '&References...' 5367 1 0 0 0 3858 4097 3570 1 3602 8 #accept 8 '&Accept' 9383 1 0 0 0 3858 4097 3522 0 16 98 9 3570 1 3602 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 3570 1 3602 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 3570 1 3602 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 3570 1 3602 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 3570 1 3602 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 3570 1 3602 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 3570 1 3602 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 3858 4097 3522 0 16 98 2 3570 1 3602 459270 ##(Smalltalk.Message)  8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 3570 1 3602 21810 21840 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 20663 0 0 8 '&Options' 0 134217729 0 0 20665 0 0 8 '&Workspace' 0 134217729 0 0 20667 0 0 3522 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 20669 0 0 3522 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 20671 0 0 3522 0 16 98 19 3570 1 3602 8 #helpContents 8 '&Contents' 1025 1 13954 0 16 16160 49 786694 ##(Smalltalk.ShellLibrary)  0 0 3570 1 3602 8 #help 8 'On this &Tool' 1249 1 0 0 0 3570 1 3602 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3858 4097 3570 1 3602 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 3858 4097 3570 1 3602 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3570 1 3602 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3570 1 3602 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3522 0 16 98 4 3570 2097153 3602 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 13954 0 16 16160 8 'TipOfTheDay.ico' 16208 0 0 3570 1 3602 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 13954 0 16 16160 8 'TipOfTheDay.ico' 16208 0 0 3858 4097 3570 1 3602 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 20693 0 0 3858 4097 3570 1 3602 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3570 1 3602 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3570 1 3602 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3570 1 3602 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 3858 4097 3570 1 3602 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 13954 0 16 16160 8 'LiveUpdate.ico' 16208 0 0 3858 4097 3570 1 3602 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 13954 0 16 16160 8 '!!APPLICATION' 16208 0 0 8 '&Help' 0 134217729 0 0 20707 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1010 202 208 98 3 1074 1104 98 2 754 3359 21 754 1711 1251 416 1074 8 #text: 98 1 8 'View Composer' 416 1074 8 #updateMenuBar 1216 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 230 9 0 0 123 2 0 0] 98 3 560 3152 2112 1232 0 27 )! !

!ViewComposerTest class categoriesForMethods!
resource_Vertical_view_D6!public!resources-views! !
!


"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.RewriteChangesBrowser'
	instanceVariableNames: 'changesPresenter differencesPresenter compositeChange'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RewriteChangesBrowser guid: (Core.GUID fromString: '{99c85442-1f6a-4912-a74b-7449ae28471b}')!
Tools.RewriteChangesBrowser comment: ''!
!Tools.RewriteChangesBrowser categoriesForClass!MVP-Presenters! !
!Tools.RewriteChangesBrowser methodsFor!

acceptAllChanges
	RefactoryChangeManager instance performChange: compositeChange.
	self exit!

acceptChanges
	| changes |
	changes := self changes.
	compositeChange changesSize = changes size
		ifTrue: [self acceptAllChanges]
		ifFalse: [self acceptChanges: changes]!

acceptChanges: aCollection
	RefactoryChangeManager instance performChange: (compositeChange copy
				changes: aCollection;
				yourself).
	self removeChanges: aCollection!

acceptClassChanges
	self change changeClass ifNotNil: 
			[:class | 
			self acceptChanges: (changesPresenter model select: [:each | each changeClass == class])]!

acceptPackageChanges
	self change package ifNotNil: 
			[:package | 
			self acceptChanges: (changesPresenter model select: [:each | each package == package])]!

browseIt
	"Open a new default browser on the current image definition of the method which will
	be modified by the selected change."

	| change |
	change := self change.
	change changeClass
		ifNotNil: 
			[:class |
			(class compiledMethodAt: change selector ifAbsent: nil)
				ifNil: [SmalltalkSystem current browseClass: class]
				ifNotNil: [:method | SmalltalkSystem current browseMethod: method]]!

change
	| changes |
	changes := self changes.
	^changes size = 1 ifTrue: [changes first]!

changes
	^changesPresenter selections!

createChangesTree
	| changesTree |
	changesTree := ExpandingTreeModel withRoots: {compositeChange}.
	changesTree getChildrenBlock: [:each | each changes].
	changesPresenter model: changesTree!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	changesPresenter := self add: TreePresenter new name: 'changes'.
	differencesPresenter := self add: DifferencesPresenter new name: 'differences'.
	differencesPresenter
		beforeTitle: 'Current';
		afterTitle: 'After Change'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	changesPresenter
		when: #actionPerformed
			send: #browseIt
			to: self;
		when: #selectionChanged
			send: #onChangeSelected
			to: self.
	self developmentSystem
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self!

deferredSelectCaret
	[self selectCaret] postToMessageQueue!

methodChanged: aCompiledMethod 
	self change ifNotNil: 
			[:change | 
			(aCompiledMethod selector == change selector 
				and: [aCompiledMethod methodClass == change changeClass]) ifTrue: [self onChangeSelected]]!

model: aCompositeRefactoryChange
	"compositeChange changes: changesPresenter model"
	super model: self class defaultModel.
	compositeChange := aCompositeRefactoryChange.
	self createChangesTree!

onChangeSelected
	| change |
	change := self change.
	change
		ifNil: 
			[differencesPresenter clear.
			^self].
	differencesPresenter
		styler: (change selector ifNil: [SmalltalkExpressionStyler new] ifNotNil: [SmalltalkMethodStyler new]);
		compare: change beforeText with: change afterText!

onMethodAdded: aCompilationResult 
	self methodChanged: aCompilationResult method!

onMethodRemoved: aCompiledMethod 
	self methodChanged: aCompiledMethod!

onMethodUpdated: aCompilationResult 
	self methodChanged: aCompilationResult method!

onViewAvailable
	super onViewAvailable.
	differencesPresenter
		textFont: MethodWorkspace actualFont;
		styler: SmalltalkMethodStyler new;
		textStyles: MethodWorkspace textStyles.
	changesPresenter expand: compositeChange!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>."

	| selector |
	selector := aCommandQuery commandSymbol.
	(#(#browseIt #acceptClassChanges #acceptPackageChanges #removeClassChanges #removePackageChanges #inspectIt)
		includes: selector)
			ifTrue: 
				[aCommandQuery isEnabled: self change notNil.
				^true].
	(#(#acceptChanges #removeChanges) includes: selector)
		ifTrue: 
			[| selected |
			selected := self changes size.
			aCommandQuery
				isEnabled: selected > 0;
				text: (aCommandQuery description expandMacrosWithArguments: {selected = 1} locale: Locale smalltalk).
			^true].
	^super queryCommand: aCommandQuery!

refresh
	self createChangesTree.
	changesPresenter expand: compositeChange!

removeChanges
	self removeChanges: self changes!

removeChanges: aCollection 
	changesPresenter model removeAll: aCollection.
	aCollection do: [:each | compositeChange removeChange: each].

	"The browser is more useful if it automatically selects another item when some are deleted"
	self deferredSelectCaret!

removeChangesMatching: discriminatorBlock 
	self removeChanges: (changesPresenter model select: discriminatorBlock)!

removeClassChanges
	self change classReference
		ifNotNil: [:class | self removeChangesMatching: [:each | each classReference = class]]!

removePackageChanges
	self change package 
		ifNotNil: [:package | self removeChangesMatching: [:each | each package == package]]!

selectCaret
	| caret |
	caret := changesPresenter view caretIndex.
	^caret isZero ifFalse: [changesPresenter view selectionsByIndex: {caret}]!

setInitialFocus
	changesPresenter view tabFirst!

updateCaption
	self caption: compositeChange displayString! !
!Tools.RewriteChangesBrowser categoriesForMethods!
acceptAllChanges!commands!public! !
acceptChanges!commands!public! !
acceptChanges:!helpers!private! !
acceptClassChanges!commands!public! !
acceptPackageChanges!commands!public! !
browseIt!commands!public! !
change!accessing!private! !
changes!accessing!public! !
createChangesTree!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
deferredSelectCaret!helpers!private! !
methodChanged:!helpers!private! !
model:!accessing!public! !
onChangeSelected!event handling!public! !
onMethodAdded:!event handling!public! !
onMethodRemoved:!event handling!public! !
onMethodUpdated:!event handling!public! !
onViewAvailable!event handling!public! !
queryCommand:!commands!private! !
refresh!commands!private! !
removeChanges!commands!public! !
removeChanges:!helpers!private! !
removeChangesMatching:!helpers!private! !
removeClassChanges!commands!public! !
removePackageChanges!commands!public! !
selectCaret!helpers!private! !
setInitialFocus!operations!public! !
updateCaption!public!updating! !
!

!Tools.RewriteChangesBrowser class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^MethodBrowser icon!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 519 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 519 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 6 #{Graphics.Color} #default 8 1853287488 550 #{Core.IdentityDictionary} 4 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 416 nil nil nil 7 nil nil nil 416 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Search_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 306 615 1 306 437 51 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 306 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 736 nil nil nil 7 nil nil nil 736 482 #{UI.Toolbar} #resource_Find_tools nil 514 50 1 562 #createAt:extent: 50 2 306 201 51 306 109 51 736 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 25 0 0 0 154 0 0 0 50 0 0 0] 688 704 nil 27 8 'findTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 482 #{UI.Toolbar} #resource_Smalltalk_tools nil 514 50 1 562 #createAt:extent: 50 2 306 63 1 306 553 51 960 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 688 704 nil 27 8 'smalltalkTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1184 nil nil nil 7 nil nil nil 1184 482 #{UI.Toolbar} #resource_Image_tools nil 514 50 1 562 #createAt:extent: 50 2 306 1 1 306 63 51 1184 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 688 704 nil 27 8 'imageTools' nil nil nil 386 0 550 #{Core.OrderedCollection} 0 nil nil 1 nil 306 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 514 50 1 562 #createAt:extent: 50 2 306 1 1 306 1169 101 160 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 50 5 1184 960 416 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140853580 131137 1648 nil nil nil 519 nil nil nil 1648 nil 8 1853287488 386 0 nil nil nil 386 4 49583 1094 1 #{UI.ToolbarIconButton} 1648 1 1350 4 #{UI.CommandDescription} #removeChanges 8 'Remove Change(s)' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditClear.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil 49583 49585 1762 1648 1 1794 #acceptChanges 8 'Accept Change(s)' 1 1 1842 nil true 1874 8 'FileSave.ico' 1936 65541 nil 49585 49587 1762 1648 1 1794 #acceptAllChanges nil 1 1 1842 nil true 1874 8 'FileSaveAll.ico' 1936 65541 nil 49587 49589 1762 1648 1 1794 #refresh 8 'Refresh' 1 1 1842 nil true 1874 8 'Refresh.ico' 1936 65541 nil 49589 50 5 1776 1968 2064 2144 582 1 #{UI.ToolbarSeparator} 1648 1 nil nil 1 nil nil nil nil nil 514 50 1 562 #createAt:extent: 50 2 306 1 51 306 201 51 1648 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 100 0 0 0 50 0 0 0] 8 #() 704 nil 29 736 704 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 2432 nil nil nil 7 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 306 193 193 nil 2432 nil 8 1852980448 386 1 1862 1 #{UI.StatusBarItem} 8193 -1 2432 nil 518 #{Core.Message} #displayString 8 #() 2626 #iconImageIndex 2656 nil 8 'errors' nil nil nil 50 1 2608 1094 1 #{UI.StatusBarNullItem} 8705 1 2432 nil nil 514 50 1 562 #createAt:extent: 50 2 306 1 643 306 1169 41 2432 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 704 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2896 nil nil nil 7 nil nil nil 2896 518 #{UI.ProportionalLayout} 294 #{Core.Dictionary} 3 518 #{Core.Association} 18 #{UI.ListTreeView} 50 59 nil 2896 50 2 8 1140920649 1 3056 838 2 #{UI.ListModel} 1426 0 nil 6 #{Kernel.IdentitySearchPolicy} 352 nil 15 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 1794 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3250 1 1794 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3250 1 1794 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3250 1 1794 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3250 1 1794 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3250 1 1794 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3250 1 1794 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3458 4097 3250 2097153 1794 #browseIt 8 '&Browse Method' 1 1 1842 nil true 1874 8 'ClassBrowserShell.ico' 1936 65541 nil nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 3056 nil 8 1853243664 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 3792 7 257 nil 2672 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1426 4 3142 5 #{UI.ListViewColumn} 8 'Change' 291 #left 2640 nil nil nil 3056 nil 3 nil nil 3938 8 'Class' 289 #left 2640 2626 #<= 8 #() 2626 #classReference 8 #() nil 3056 2672 3 nil nil 3938 8 'Selector' 291 #left 2640 3778 0 nil 3810 3 83886081 3776 8 'doIt' 8 '[:a :b | a isNil or: [b notNil and: [a <= b]]]' 8 #[29 105 17 223 2 58 106 18 222 4 233 1 130 106 59 106] 4112 #or: #and: 7 513 nil 2626 #selector 8 #() nil 3056 2672 3 nil nil 3938 8 'Package' 301 #left 2640 3778 0 nil 3810 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 4256 7 513 nil 3778 0 nil 3810 7 1 3776 8 'doIt' 8 '[:each | 
each changeClass ifNotNil: [:changeClass |
	((changeClass compiledMethodAt: each selector ifAbsent: nil)
		ifNil: [changeClass]) owningPackage]]' 8 #[33 105 226 0 100 222 10 70 226 1 60 192 100 223 1 74 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 4336 #ifNotNil: #ifNil: 7 65793 nil nil 3056 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil 201 nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 3184 1426 0 3778 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4432 #defaultGetChildrenBlock 212361507 8 #[30 105 226 0 106] #children 4480 7 257 nil 3778 0 nil 4498 2 3 4432 #defaultGetParentBlock 212367203 8 #[30 105 226 0 106] #parent 4544 7 257 nil 3778 0 nil 4498 2 3 4432 #defaultHasChildrenBlock 212372739 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4448 3778 0 nil 4498 1 83886083 4432 #defaultFilterBlock 212355235 8 #[29 105 17 157 106] 4640 7 257 nil nil 294 #{Core.IdentitySet} 0 4690 0 45 1 nil nil nil nil nil nil nil 514 50 2 562 #createAt:extent: 50 2 306 1 1 306 1169 213 3056 562 #text: 50 1 8 'Change' 3056 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 8 #() 704 nil 2029 5 3026 18 #{UI.ReferenceView} 50 14 nil 2896 50 2 8 1140850688 131073 4944 nil nil nil 7 nil nil nil 4944 482 #{UI.DifferencesPresenter} #resource_Default_view nil 514 50 1 562 #createAt:extent: 50 2 306 1 223 306 1169 321 4944 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 688 704 nil 27 7 3026 18 #{UI.Splitter} 50 12 nil 2896 50 2 8 1140850688 1 5168 nil nil nil 519 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 5168 nil 1 #left nil nil nil 306 1 1 306 9 9 nil 5264 nil 514 50 1 562 #createAt:extent: 50 2 306 1 213 306 1169 11 5168 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 8 #() 704 nil 27 1 true 386 1 3056 8 'changes' nil 514 50 1 562 #createAt:extent: 50 2 306 1 101 306 1169 543 2896 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 50 3 3056 5168 4944 704 nil 27 386 2 2432 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 3202 nil true 50 3 3250 1 1794 #saveImage 8 'Sa&ve Image' 1 1 1842 nil true 1874 8 'Snapshot.ico' 1936 65541 nil nil nil 3458 4097 3250 1 1794 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 49599 nil nil 3202 nil true 50 6 3250 1 1794 #copySelection 8 '&Copy' 9351 1 1842 nil true 1874 8 'EditCopy.ico' 1936 65541 nil nil nil 3250 1 1794 #selectAll 8 'Select &All' 9347 1 nil nil nil 3458 4097 3250 1 1794 #find 8 '&Find…' 9357 1 1842 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 3250 1 1794 #findNext 8 'Find &Next' 1253 1 1842 nil true 1874 8 'FindNext.ico' 1936 65541 nil nil nil 3250 1 1794 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 49611 nil nil 3202 nil true 50 10 3250 1 1794 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3250 1 1794 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3250 1 1794 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3250 1 1794 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 3458 4097 3250 1 1794 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3250 1 1794 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3250 1 1794 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3458 4097 3250 2097153 1794 #browseIt 8 '&Browse Method' 1 1 3696 nil nil 8 '&Change' nil 134217729 nil nil 49629 nil nil 3202 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 49631 nil nil 3202 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 49633 nil nil 3202 nil true 50 15 3250 1 1794 #helpContents 8 '&Contents' 1025 1 1842 nil true 1874 8 'Help.ico' 1936 65541 nil nil nil 3250 1 1794 #help 8 'On this &Tool' 1249 1 nil nil nil 3250 1 1794 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3458 4097 3250 1 1794 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5906 8 $🎓 nil 338 #orchid 338 #white nil nil 1 nil nil nil nil 3458 4097 3250 1 1794 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3250 1 1794 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3250 1 1794 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3458 4097 3250 1 1794 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1842 nil true 1874 8 '!!APPLICATION' 1936 65541 nil nil nil 3250 1 1794 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3250 1 1794 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3458 4097 3250 1 1794 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5906 8 $🐬 nil nil 338 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 49657 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 514 50 2 562 #createAt:extent: 50 2 306 6143 21 306 1201 801 32 562 #text: 50 1 8 'Rewrite Results Browser' 32 642 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 50 3 160 2896 2432 704 nil 27)! !
!Tools.RewriteChangesBrowser class categoriesForMethods!
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!


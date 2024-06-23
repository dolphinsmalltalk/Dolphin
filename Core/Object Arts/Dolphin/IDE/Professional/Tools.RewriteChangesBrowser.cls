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
	<commandQuery: #queryChangesCommand:>
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
	<commandQuery: #hasChange>
	self change changeClass
		ifNotNil: [:class | self acceptChanges: (changesPresenter model select: [:each | each changeClass == class])]!

acceptPackageChanges
	self change package ifNotNil: 
			[:package | 
			self acceptChanges: (changesPresenter model select: [:each | each package == package])]!

browseIt
	"Open a new default browser on the current image definition of the method which will
	be modified by the selected change."

	<commandQuery: #hasChange>
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

hasChange
	^self change notNil!

inspectChange
	<commandQuery: #hasChange>
	self change inspect!

inspectItCommand
	self hasChange ifTrue: [#inspectChange].
	^super inspectItCommand!

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

queryChangesCommand: aCommandQuery
	| changes |
	changes := self changes.
	changes isEmpty ifTrue: [^self].
	aCommandQuery
		beEnabled;
		text: aCommandQuery description << changes size = 1!

refresh
	self createChangesTree.
	changesPresenter expand: compositeChange!

removeChanges
	<commandQuery: #queryChangesCommand:>
	self removeChanges: self changes!

removeChanges: aCollection 
	changesPresenter model removeAll: aCollection.
	aCollection do: [:each | compositeChange removeChange: each].

	"The browser is more useful if it automatically selects another item when some are deleted"
	self deferredSelectCaret!

removeChangesMatching: discriminatorBlock 
	self removeChanges: (changesPresenter model select: discriminatorBlock)!

removeClassChanges
	<commandQuery: #hasChange>
	self change classReference
		ifNotNil: [:class | self removeChangesMatching: [:each | each classReference = class]]!

removePackageChanges
	<commandQuery: #hasChange>
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
acceptAllChanges!commands-actions!public! !
acceptChanges!commands-actions!public! !
acceptChanges:!helpers!private! !
acceptClassChanges!commands-actions!public! !
acceptPackageChanges!commands-actions!public! !
browseIt!commands-actions!public! !
change!accessing!private! !
changes!accessing!public! !
createChangesTree!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
deferredSelectCaret!helpers!private! !
hasChange!commands-queries!private! !
inspectChange!commands-actions!public! !
inspectItCommand!commands-mappings!private! !
methodChanged:!helpers!private! !
model:!accessing!public! !
onChangeSelected!event handling!public! !
onMethodAdded:!event handling!public! !
onMethodRemoved:!event handling!public! !
onMethodUpdated:!event handling!public! !
onViewAvailable!event handling!public! !
queryChangesCommand:!commands-queries!private! !
refresh!commands-actions!private! !
removeChanges!commands-actions!public! !
removeChanges:!helpers!private! !
removeChangesMatching:!helpers!private! !
removeClassChanges!commands-actions!public! !
removePackageChanges!commands-actions!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Find_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 306 201 51 306 109 51 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 25 0 0 0 154 0 0 0 50 0 0 0] 8 #() 306 193 193 nil 27 8 'findTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 736 nil nil nil 5 nil nil nil 736 482 #{UI.Toolbar} #resource_Image_tools nil 514 50 1 562 #createAt:extent: 50 2 306 1 1 306 63 51 736 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 688 704 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 482 #{UI.Toolbar} #resource_Search_tools nil 514 50 1 562 #createAt:extent: 50 2 306 615 1 306 437 51 960 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 688 704 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1184 nil nil nil 5 nil nil nil 1184 482 #{UI.Toolbar} #resource_Smalltalk_tools nil 514 50 1 562 #createAt:extent: 50 2 306 63 1 306 553 51 1184 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 688 704 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 1 nil 306 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 514 50 1 562 #createAt:extent: 50 2 306 1 1 306 1169 101 160 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 50 5 736 1184 960 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140853580 131137 1632 nil nil nil 517 nil nil nil 1632 nil nil 370 #{Core.IdentityDictionary} 688 nil nil nil nil 50 5 1094 1 #{UI.ToolbarIconButton} 1632 1 1350 4 #{UI.CommandDescription} #removeChanges 8 'Remove Change(s)' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditClear.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 1730 1632 1 1762 #acceptChanges 8 'Accept Change(s)' 1 1 1810 nil true 1842 8 'FileSave.ico' 1904 65541 nil nil 1730 1632 1 1762 #acceptAllChanges nil 1 1 1810 nil true 1842 8 'FileSaveAll.ico' 1904 65541 nil nil 1730 1632 1 1762 #refresh 8 'Refresh' 1 1 1810 nil true 1842 8 'Refresh.ico' 1904 65541 nil nil 582 1 #{UI.ToolbarSeparator} 1632 1 nil nil 1 nil nil nil nil nil 514 50 1 562 #createAt:extent: 50 2 306 1 51 306 201 51 1632 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 100 0 0 0 50 0 0 0] 8 #() 704 nil 29 416 704 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 2384 nil nil nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 306 193 193 nil 2384 nil nil 370 #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 2384 nil 518 #{Core.Message} #displayString 8 #() 2578 #iconImageIndex 2608 nil 8 'errors' nil nil nil 50 1 2560 1094 1 #{UI.StatusBarNullItem} 8705 1 2384 nil nil 514 50 1 562 #createAt:extent: 50 2 306 1 643 306 1169 41 2384 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 704 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2848 nil nil nil 5 nil nil nil 2848 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 3 518 #{Core.Association} 18 #{UI.ListTreeView} 50 59 nil 2848 50 2 8 1140920649 1 3024 838 2 #{UI.ListModel} 1410 0 nil 6 #{Kernel.IdentitySearchPolicy} 352 nil 13 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 1762 #acceptChanges 8 '&Accept <?Change:Changes>' 1 17 nil nil nil 3218 1 1762 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3218 1 1762 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3218 1 1762 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3218 1 1762 #removeChanges 8 '&Remove <?Change:Changes>' 1 17 nil nil nil 3218 1 1762 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3218 1 1762 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3426 4097 3218 2097153 1762 #browseIt 8 '&Browse Method' 1 1 1810 nil true 1842 8 'ClassBrowserShell.ico' 1904 65541 nil nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 3024 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 3744 7 257 nil 2624 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1410 4 3142 5 #{UI.ListViewColumn} 8 'Change' 291 #left 2592 nil nil nil 3024 nil 3 nil nil 3890 8 'Class' 289 #left 2592 2578 #<= 8 #() 2578 #classReference 8 #() nil 3024 2624 3 nil nil 3890 8 'Selector' 291 #left 2592 3730 0 nil 3762 3 83886081 3728 8 'doIt' 8 '[:a :b | a isNil or: [b notNil and: [a <= b]]]' 8 #[29 105 17 223 2 58 106 18 222 4 233 1 130 106 59 106] 4064 #or: #and: 7 513 nil 2578 #selector 8 #() nil 3024 2624 3 nil nil 3890 8 'Package' 301 #left 2592 3730 0 nil 3762 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 4208 7 513 nil 3730 0 nil 3762 7 1 3728 8 'doIt' 8 '[:each | 
each changeClass ifNotNil: [:changeClass |
	((changeClass compiledMethodAt: each selector ifAbsent: nil)
		ifNil: [changeClass]) owningPackage]]' 8 #[33 105 226 0 100 222 10 70 226 1 60 192 100 223 1 74 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 4288 #ifNotNil: #ifNil: 7 65793 nil nil 3024 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil 201 nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 3152 1410 0 3730 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4384 #defaultGetChildrenBlock 212361507 8 #[30 105 226 0 106] #children 4432 7 257 nil 3730 0 nil 4450 2 3 4384 #defaultGetParentBlock 212367203 8 #[30 105 226 0 106] #parent 4496 7 257 nil 3730 0 nil 4450 2 3 4384 #defaultHasChildrenBlock 212372739 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4400 3730 0 nil 4450 1 83886083 4384 #defaultFilterBlock 212355235 8 #[29 105 17 157 106] 4592 7 257 nil nil 294 #{Core.IdentitySet} 0 4642 0 45 1 nil nil nil nil nil nil nil 514 50 2 562 #createAt:extent: 50 2 306 1 1 306 1169 213 3024 562 #text: 50 1 8 'Change' 3024 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 8 #() 704 nil 2029 5 2994 18 #{UI.Splitter} 50 12 nil 2848 50 2 8 1140850688 1 4896 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 4896 nil 1 #left nil nil nil 306 1 1 306 9 9 nil 4992 nil 514 50 1 562 #createAt:extent: 50 2 306 1 213 306 1169 11 4896 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 8 #() 704 nil 27 1 2994 18 #{UI.ReferenceView} 50 14 nil 2848 50 2 8 1140850688 131073 5184 nil nil nil 5 nil nil nil 5184 482 #{UI.DifferencesPresenter} #resource_Default_view nil 514 50 1 562 #createAt:extent: 50 2 306 1 223 306 1169 321 5184 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 688 704 nil 27 7 true 370 #{Core.IdentityDictionary} 50 2 3024 8 'changes' nil 514 50 1 562 #createAt:extent: 50 2 306 1 101 306 1169 543 2848 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 50 3 3024 4896 5184 704 nil 27 370 #{Core.IdentityDictionary} 50 4 2384 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 3170 nil true 50 3 3218 1 1762 #saveImage 8 'Sa&ve Image' 1 1 1810 nil true 1842 8 'Snapshot.ico' 1904 65541 nil nil nil 3426 4097 3218 1 1762 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 3170 nil true 50 6 3218 1 1762 #copySelection 8 '&Copy' 9351 1 1810 nil true 1842 8 'EditCopy.ico' 1904 65541 nil nil nil 3218 1 1762 #selectAll 8 'Select &All' 9347 1 nil nil nil 3426 4097 3218 1 1762 #find 8 '&Find…' 9357 1 1810 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 3218 1 1762 #findNext 8 'Find &Next' 1253 1 1810 nil true 1842 8 'FindNext.ico' 1904 65541 nil nil nil 3218 1 1762 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3170 nil true 50 10 3218 1 1762 #acceptChanges 8 '&Accept <?Change:Changes>' 1 17 nil nil nil 3218 1 1762 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3218 1 1762 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3218 1 1762 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 3426 4097 3218 1 1762 #removeChanges 8 '&Remove <?Change:Changes>' 1 17 nil nil nil 3218 1 1762 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3218 1 1762 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3426 4097 3218 2097153 1762 #browseIt 8 '&Browse Method' 1 1 3664 nil nil 8 '&Change' nil 134217729 nil nil nil nil nil 3170 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 3170 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 3170 nil true 50 15 3218 1 1762 #helpContents 8 '&Contents' 1025 1 1810 nil true 1842 8 'Help.ico' 1904 65541 nil nil nil 3218 1 1762 #help 8 'On this &Tool' 1249 1 nil nil nil 3218 1 1762 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3426 4097 3218 1 1762 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5890 8 $🎓 nil 338 #orchid 338 #white nil nil 1 nil nil nil nil 3426 4097 3218 1 1762 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3218 1 1762 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3218 1 1762 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3426 4097 3218 1 1762 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1810 nil true 1842 8 '!!APPLICATION' 1904 65541 nil nil nil 3218 1 1762 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3218 1 1762 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3426 4097 3218 1 1762 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5890 8 $🐬 nil nil 338 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 514 50 2 562 #createAt:extent: 50 2 306 6143 21 306 1201 801 32 562 #text: 50 1 8 'Rewrite Results Browser' 32 642 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 50 3 160 2848 2384 704 nil 27)! !

!Tools.RewriteChangesBrowser class categoriesForMethods!
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!


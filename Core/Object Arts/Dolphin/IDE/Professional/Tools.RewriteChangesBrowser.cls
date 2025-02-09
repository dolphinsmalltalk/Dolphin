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
		text: aCommandQuery description << (changes size = 1)!

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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 384 nil nil nil 5 nil nil nil 384 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Find_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[100 0 0 0 25 0 0 0 154 0 0 0 50 0 0 0] 193 416 8 '' 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'findTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 736 nil nil nil 5 nil nil nil 736 450 #{UI.Toolbar} #resource_Image_tools nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 768 8 '' 736 3 672 690 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 976 nil nil nil 5 nil nil nil 976 450 #{UI.Toolbar} #resource_Search_tools nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1008 8 '' 976 3 672 690 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1216 nil nil nil 5 nil nil nil 1216 450 #{UI.Toolbar} #resource_Smalltalk_tools nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1248 8 '' 1216 3 672 690 193 193 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 1355 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 193 192 8 '' 160 3 50 5 736 1216 976 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140853580 131137 1664 nil nil nil 517 nil nil nil 1664 nil nil 338 #{Core.IdentityDictionary} 672 nil nil nil nil 50 5 1606 2 #{UI.ToolbarIconButton} 1664 1 1350 4 #{UI.CommandDescription} #removeChanges 8 'Remove Change(s)' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditClear.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil 1762 1664 1 1794 #acceptChanges 8 'Accept Change(s)' 1 1 1842 nil true 1874 8 'FileSave.ico' 1936 65541 nil nil nil nil 1762 1664 1 1794 #acceptAllChanges nil 1 1 1842 nil true 1874 8 'FileSaveAll.ico' 1936 65541 nil nil nil nil 1762 1664 1 1794 #refresh 8 'Refresh' 1 1 1842 nil true 1874 8 'Refresh.ico' 1936 65541 nil nil nil nil 582 1 #{UI.ToolbarSeparator} 1664 1 nil nil 9 1 nil nil nil nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 25 0 0 0 100 0 0 0 50 0 0 0] 193 1696 8 '' 1664 3 8 #() 690 193 193 nil 31 384 690 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 2448 nil nil nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2448 nil nil 338 #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 2448 nil 518 #{Core.Message} #displayString 8 #() 2626 #iconImageIndex 2656 nil 8 'errors' nil nil nil 50 1 2608 1094 1 #{UI.StatusBarNullItem} 8705 1 2448 nil nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 193 2480 8 '' 2448 3 8 #() 690 193 193 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2912 nil nil nil 5 nil nil nil 2912 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 3 518 #{Core.Association} 18 #{UI.ListTreeView} 50 59 nil 2912 50 2 8 1140920649 1 3088 838 2 #{UI.ListModel} 1458 0 nil 6 #{Kernel.IdentitySearchPolicy} 320 nil 13 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 1794 #acceptChanges 8 '&Accept <?Change:Changes>' 1 17 nil nil nil 3282 1 1794 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3282 1 1794 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3282 1 1794 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3282 1 1794 #removeChanges 8 '&Remove <?Change:Changes>' 1 17 nil nil nil 3282 1 1794 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3282 1 1794 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3490 4097 3282 2097153 1794 #browseIt 8 '&Browse Method' 1 1 1842 nil true 1874 8 'ClassBrowserShell.ico' 1936 65541 nil nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 3088 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 3808 7 257 nil 2672 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1458 4 3142 5 #{UI.ListViewColumn} 8 'Change' 291 #left 2640 nil nil nil 3088 nil 3 nil nil 3954 8 'Class' 289 #left 2640 2626 #<= 8 #() 2626 #classReference 8 #() nil 3088 2672 3 nil nil 3954 8 'Selector' 291 #left 2640 3794 0 nil 3826 3 83886081 3792 8 'doIt' 8 '[:a :b | a isNil or: [b notNil and: [a <= b]]]' 8 #[29 105 17 223 2 58 106 18 222 4 233 1 130 106 59 106] 4128 #or: #and: 7 513 nil 2626 #selector 8 #() nil 3088 2672 3 nil nil 3954 8 'Package' 301 #left 2640 3794 0 nil 3826 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 4272 7 513 nil 3794 0 nil 3826 7 1 3792 8 'doIt' 8 '[:each | 
each changeClass ifNotNil: [:changeClass |
	((changeClass compiledMethodAt: each selector ifAbsent: nil)
		ifNil: [changeClass]) owningPackage]]' 8 #[33 105 226 0 100 222 10 70 226 1 60 192 100 223 1 74 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 4352 #ifNotNil: #ifNil: 7 65793 nil nil 3088 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil 201 nil 1 262 #{UI.ListViewVirtualUpdateMode} 3088 nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 3216 1458 0 3794 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4480 #defaultGetChildrenBlock 212361507 8 #[30 105 226 0 106] #children 4528 7 257 nil 3794 0 nil 4546 2 3 4480 #defaultGetParentBlock 212367203 8 #[30 105 226 0 106] #parent 4592 7 257 nil 3794 0 nil 4546 2 3 4480 #defaultHasChildrenBlock 212372739 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4496 3794 0 nil 4546 1 83886083 4480 #defaultFilterBlock 212355235 8 #[29 105 17 157 106] 4688 7 257 nil nil 294 #{Core.IdentitySet} 0 4738 0 45 1 nil nil nil nil nil nil nil 482 50 2 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 193 3120 8 'Change' 3088 530 #contextMenu: 50 1 3248 3088 3 8 #() 690 193 193 nil 2029 5 3058 18 #{UI.Splitter} 50 12 nil 2912 50 2 8 1140850688 1 4992 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 4992 nil 1 #left nil nil nil 690 1 1 690 9 9 nil 5088 nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 193 5024 8 '' 4992 3 8 #() 690 193 193 nil 27 1 3058 18 #{UI.ReferenceView} 50 14 nil 2912 50 2 8 1140850688 131073 5296 nil nil nil 5 nil nil nil 5296 450 #{UI.DifferencesPresenter} #resource_Default_view nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 193 5328 8 '' 5296 3 672 690 193 193 nil 27 7 true 338 #{Core.IdentityDictionary} 50 2 3088 8 'changes' nil 482 50 1 530 #createWindow: 50 1 578 610 8 #[0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 193 2944 8 '' 2912 3 50 3 3088 4992 5296 690 193 193 nil 27 338 #{Core.IdentityDictionary} 50 4 2448 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 3234 nil true 50 3 3282 1 1794 #saveImage 8 'Sa&ve Image' 1 1 1842 nil true 1874 8 'Snapshot.ico' 1936 65541 nil nil nil 3490 4097 3282 1 1794 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 3234 nil true 50 6 3282 1 1794 #copySelection 8 '&Copy' 9351 1 1842 nil true 1874 8 'EditCopy.ico' 1936 65541 nil nil nil 3282 1 1794 #selectAll 8 'Select &All' 9347 1 nil nil nil 3490 4097 3282 1 1794 #find 8 '&Find…' 9357 1 1842 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 3282 1 1794 #findNext 8 'Find &Next' 1253 1 1842 nil true 1874 8 'FindNext.ico' 1936 65541 nil nil nil 3282 1 1794 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3234 nil true 50 10 3282 1 1794 #acceptChanges 8 '&Accept <?Change:Changes>' 1 17 nil nil nil 3282 1 1794 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3282 1 1794 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3282 1 1794 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 3490 4097 3282 1 1794 #removeChanges 8 '&Remove <?Change:Changes>' 1 17 nil nil nil 3282 1 1794 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3282 1 1794 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3490 4097 3282 2097153 1794 #browseIt 8 '&Browse Method' 1 1 3728 nil nil 8 '&Change' nil 134217729 nil nil nil nil nil 3234 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 3234 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 3234 nil true 50 15 3282 1 1794 #helpContents 8 '&Contents' 1025 1 1842 nil true 1874 8 'Help.ico' 1936 65541 nil nil nil 3282 1 1794 #help 8 'On this &Tool' 1249 1 nil nil nil 3282 1 1794 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3490 4097 3282 1 1794 #learnSmalltalk 8 'Learn Smalltalk' 1 1 6034 8 $🎓 nil 306 #orchid 306 #white nil nil 1 nil nil nil nil 3490 4097 3282 1 1794 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3282 1 1794 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3282 1 1794 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3490 4097 3282 1 1794 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1842 nil true 1874 8 '!!APPLICATION' 1936 65541 nil nil nil 3282 1 1794 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3282 1 1794 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3490 4097 3282 1 1794 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6034 8 $🐬 nil nil 306 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil nil nil 193 482 50 1 530 #createWindow: 50 1 578 518 #{Graphics.Rectangle} 690 7679 21 690 8879 821 193 80 8 'Rewrite Results Browser' 32 1 50 3 160 2912 2448 690 193 193 nil 27)! !

!Tools.RewriteChangesBrowser class categoriesForMethods!
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!


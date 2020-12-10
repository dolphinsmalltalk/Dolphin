"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.RewriteChangesBrowser'
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
	self acceptChanges: self changes!

acceptChanges: aCollection 
	RefactoryChangeManager instance performChange: (compositeChange
				copy;
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
	Smalltalk developmentSystem 
		browseMethod: (change changeClass compiledMethodAt: change selector)!

change
	| changes |
	changes := self changes.
	^changes size = 1 ifTrue: [changes first]!

changes
	^changesPresenter selections!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	changesPresenter := self add: ListPresenter new name: 'changes'.
	differencesPresenter := self add: DifferencesPresenter new name: 'differences'.
	differencesPresenter
		beforeTitle: 'Current Method';
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
	(self systemModel)
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
	super model: self class defaultModel.
	compositeChange := aCompositeRefactoryChange.
	changesPresenter list: compositeChange changes.
	compositeChange changes: changesPresenter model!

onChangeSelected
	| change method class |
	change := self change.
	change ifNil: 
			[differencesPresenter clear.
			^self].
	class := change changeClass.
	method := class compiledMethodAt: change selector ifAbsent: [].
	differencesPresenter compare: (method ifNil: [''] ifNotNil: [:m | m getSource])
		with: change source!

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
		textStyles: MethodWorkspace textStyles!

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

removeChanges
	self removeChanges: self changes!

removeChanges: aCollection 
	changesPresenter model removeAll: aCollection.

	"The browser is more useful if it automatically selects another item when some are deleted"
	self deferredSelectCaret!

removeChangesMatching: discriminatorBlock 
	self removeChanges: (changesPresenter model select: discriminatorBlock)!

removeClassChanges
	self change changeClass 
		ifNotNil: [:class | self removeChangesMatching: [:each | each changeClass == class]]!

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
!Tools.RewriteChangesBrowser categoriesFor: #acceptAllChanges!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #acceptChanges!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #acceptChanges:!helpers!private! !
!Tools.RewriteChangesBrowser categoriesFor: #acceptClassChanges!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #acceptPackageChanges!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #browseIt!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #change!accessing!private! !
!Tools.RewriteChangesBrowser categoriesFor: #changes!accessing!public! !
!Tools.RewriteChangesBrowser categoriesFor: #createComponents!initializing!public! !
!Tools.RewriteChangesBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.RewriteChangesBrowser categoriesFor: #deferredSelectCaret!helpers!private! !
!Tools.RewriteChangesBrowser categoriesFor: #methodChanged:!helpers!private! !
!Tools.RewriteChangesBrowser categoriesFor: #model:!accessing!public! !
!Tools.RewriteChangesBrowser categoriesFor: #onChangeSelected!event handling!public! !
!Tools.RewriteChangesBrowser categoriesFor: #onMethodAdded:!event handling!public! !
!Tools.RewriteChangesBrowser categoriesFor: #onMethodRemoved:!event handling!public! !
!Tools.RewriteChangesBrowser categoriesFor: #onMethodUpdated:!event handling!public! !
!Tools.RewriteChangesBrowser categoriesFor: #onViewAvailable!event handling!public! !
!Tools.RewriteChangesBrowser categoriesFor: #queryCommand:!commands!private! !
!Tools.RewriteChangesBrowser categoriesFor: #removeChanges!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #removeChanges:!helpers!private! !
!Tools.RewriteChangesBrowser categoriesFor: #removeChangesMatching:!helpers!private! !
!Tools.RewriteChangesBrowser categoriesFor: #removeClassChanges!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #removePackageChanges!commands!public! !
!Tools.RewriteChangesBrowser categoriesFor: #selectCaret!helpers!private! !
!Tools.RewriteChangesBrowser categoriesFor: #setInitialFocus!operations!public! !
!Tools.RewriteChangesBrowser categoriesFor: #updateCaption!public!updating! !

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 8 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Smalltalk_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 674 63 1 674 553 51 784 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 850 ##(UI.Toolbar) #resource_Image_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 63 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1072 1088 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 850 ##(UI.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 615 1 674 437 51 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1600 nil nil nil 7 nil nil nil 1600 850 ##(UI.Toolbar) #resource_Find_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 155 51 674 109 51 1600 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 25 0 0 0 131 0 0 0 50 0 0 0] 1072 1088 nil 27 8 'findTools' 170 192 1072 138 144 1072 nil nil 1 nil 674 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1169 101 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 34 5 1120 784 1360 410 ##(UI.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 2080 nil nil nil 519 nil nil nil 2080 nil 8 1801306032 170 192 1072 170 192 34 6 51973 1311814 1 ##(UI.ToolbarIconButton) 2080 1 1377606 4 ##(UI.CommandDescription) #acceptAllChanges nil 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FileSaveAll.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 51973 51971 2210 2080 1 2242 #acceptChanges 8 'Accept Change(s)' 1 1 2274 nil true 2320 8 'FileSave.ico' 2368 51971 51969 2210 2080 1 2242 #removeChanges 8 'Remove Change(s)' 1 1 2274 nil true 2320 8 'EditClear.ico' 2368 51969 34 4 2480 2400 2224 1245766 1 ##(UI.ToolbarSeparator) 2080 1 nil nil 1 nil nil nil nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 51 674 155 51 2080 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 77 0 0 0 50 0 0 0] 8 #() 1088 nil 27 1600 1088 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2768 nil nil nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 2768 nil 8 1801004784 170 192 34 2 1050374 ##(UI.StatusBarItem) 1 -1 2768 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'errors' 138 144 34 1 2960 1311750 ##(UI.StatusBarNullItem) 513 1 2768 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 643 674 1169 41 2768 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 1088 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3216 nil nil nil 7 nil nil nil 3216 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 3 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 3216 34 2 8 1140850688 1 3376 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3376 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3472 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 213 674 1169 11 3376 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 8 #() 1088 nil 27 1 3346 410 ##(UI.ListView) 34 45 nil 3216 34 2 8 1140920393 1 3680 787270 2 ##(UI.ListModel) 138 144 1072 nil 1769478 ##(Kernel.IdentitySearchPolicy) 720 nil 15 461638 4 ##(UI.Menu) nil true 34 10 1180742 2 ##(UI.CommandMenuItem) 1 2242 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3874 1 2242 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3874 1 2242 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3874 1 2242 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3874 1 2242 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3874 1 2242 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3874 1 2242 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4082 4097 3874 2097153 2242 #browseIt 8 '&Browse Method' 1 1 2274 nil true 2320 8 'ClassBrowserShell.ico' 2368 nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 3680 nil 8 1801282304 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 4400 7 257 nil ##(UI.ListView) 1639750 1 ##(Graphics.IconImageManager) nil nil nil 674 65 65 nil nil 138 144 34 4 1117254 5 ##(UI.ListViewColumn) 8 'Class' 301 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() 4386 0 nil 4418 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each displayClassName]' 8 #[30 105 17 158 106] #displayClassName 4672 7 257 nil nil 3680 ##(UI.IconicListAbstract) 1 nil nil 4578 8 'Selector' 401 #left ##(UI.BasicListAbstract) 4626 #<= 8 #() 4386 0 nil 4418 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each selector]' 8 #[30 105 17 158 106] #selector 4816 7 257 nil nil 3680 ##(UI.IconicListAbstract) 1 nil nil 4578 8 'Package' 201 #left 4386 0 nil 4418 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each | each name]' 8 #[30 105 17 158 106] #name 4928 7 257 nil 4386 0 nil 4418 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5008 7 513 nil 4386 0 nil 4418 6 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:each |
((each changeClass compiledMethodAt: each selector ifAbsent:[])
	ifNil: [each changeClass]
	ifNotNil: [:method | method]) owningPackage]' 8 #[33 105 17 158 17 159 34 192 100 223 3 73 158 110 70 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 5088 4386 0 nil 4418 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 34 2 8 '[]' nil 8 #[29 105 60 106] 5168 7 1 nil 7 65793 nil nil 3680 nil 1 nil nil 4578 8 'Change' 261 #left 4626 #yourself 8 #() 4626 #<= 5312 4626 #changeString 5312 nil 3680 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 1169 213 3680 946 #contextMenu: 34 1 3840 3680 946 #text: 34 1 8 'Class' 3680 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 8 #() 1088 nil 35 5 3346 410 ##(UI.ReferenceView) 34 14 nil 3216 34 2 8 1140850688 131073 5632 nil nil nil 7 nil nil nil 5632 850 ##(UI.DifferencesPresenter) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 223 674 1169 321 5632 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 1072 1088 nil 27 7 true 170 192 34 2 3680 8 'changes' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 101 674 1169 543 3216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 34 3 3680 3376 5632 1088 nil 27 170 192 34 4 2768 8 'statusbar' 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 6 3826 nil true 34 3 3874 1 2242 #saveImage 8 'Sa&ve Image' 1 1 2274 nil true 2320 8 'Snapshot.ico' 2368 nil nil 4082 4097 3874 1 2242 #exit 8 '&Close' 17639 1 1378630 1 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 51983 nil nil 3826 nil true 34 6 3874 1 2242 #copySelection 8 '&Copy' 9351 1 2274 nil true 2320 8 'EditCopy.ico' 2368 nil nil 3874 1 2242 #selectAll 8 'Select &All' 9347 1 nil nil nil 4082 4097 3874 1 2242 #find 8 '&Find...' 9357 1 2274 nil true 2320 47 983302 ##(OS.ShellLibrary) nil nil 3874 1 2242 #findNext 8 'Find &Next' 1253 1 2274 nil true 2320 8 'FindNext.ico' 2368 nil nil 3874 1 2242 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 51995 nil nil 3826 nil true 34 10 3874 1 2242 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3874 1 2242 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3874 1 2242 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3874 1 2242 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 4082 4097 3874 1 2242 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3874 1 2242 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3874 1 2242 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4082 4097 3874 2097153 2242 #browseIt 8 '&Browse Method' 1 1 4320 nil nil 8 '&Change' nil 134217729 nil nil 52013 nil nil 3826 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 52015 nil nil 3826 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 52017 nil nil 3826 nil true 34 15 3874 1 2242 #helpContents 8 '&Contents' 1025 1 2274 nil true 2320 8 'Help.ico' 2368 nil nil 3874 1 2242 #help 8 'On this &Tool' 1249 1 nil nil nil 3874 1 2242 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4082 4097 3874 1 2242 #learnSmalltalk 8 'Learn Smalltalk' 1 1 6354 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 4082 4097 3874 1 2242 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3874 1 2242 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3874 1 2242 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4082 4097 3874 1 2242 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2274 nil true 2320 8 '!!APPLICATION' 2368 nil nil 3874 1 2242 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3874 1 2242 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4082 4097 3874 1 2242 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6354 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 52041 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 6143 21 674 1201 801 416 946 #text: 34 1 8 'Rewrite Results Browser' 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 34 3 528 3216 2768 1088 nil 27 )! !
!Tools.RewriteChangesBrowser class categoriesFor: #icon!constants!public! !
!Tools.RewriteChangesBrowser class categoriesFor: #publishedAspects!operations!public! !
!Tools.RewriteChangesBrowser class categoriesFor: #resource_Default_view!public!resources-views! !


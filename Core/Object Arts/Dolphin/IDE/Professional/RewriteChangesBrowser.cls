"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #RewriteChangesBrowser
	instanceVariableNames: 'changesPresenter differencesPresenter compositeChange'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RewriteChangesBrowser guid: (GUID fromString: '{99c85442-1f6a-4912-a74b-7449ae28471b}')!

RewriteChangesBrowser comment: ''!

!RewriteChangesBrowser categoriesForClass!MVP-Presenters! !

!RewriteChangesBrowser methodsFor!

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
				text: (aCommandQuery description expandMacrosWith: selected = 1).
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
	^caret isZero ifFalse: [changesPresenter view selectionsByIndex: (Array with: caret)]!

setInitialFocus
	changesPresenter view tabFirst!

updateCaption
	self caption: compositeChange displayString! !

!RewriteChangesBrowser categoriesForMethods!
acceptAllChanges!commands!public! !
acceptChanges!commands!public! !
acceptChanges:!helpers!private! !
acceptClassChanges!commands!public! !
acceptPackageChanges!commands!public! !
browseIt!commands!public! !
change!accessing!private! !
changes!accessing!public! !
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
removeChanges!commands!public! !
removeChanges:!helpers!private! !
removeChangesMatching:!helpers!private! !
removeClassChanges!commands!public! !
removePackageChanges!commands!public! !
selectCaret!helpers!private! !
setInitialFocus!operations!public! !
updateCaption!public!updating! !
!

!RewriteChangesBrowser class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 327686 ##(Smalltalk.Color) #default 8 1962208256 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 752 nil nil nil 7 nil nil nil 752 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 784 8 '' 752 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 818 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1152 8 '' 1120 3 1056 1074 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 818 ##(Smalltalk.Toolbar) #resource_Find_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[77 0 0 0 25 0 0 0 131 0 0 0 50 0 0 0] 193 1408 8 '' 1376 3 1056 1074 193 193 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1632 nil nil nil 7 nil nil nil 1632 818 ##(Smalltalk.Toolbar) #resource_Search_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1664 8 '' 1632 3 1056 1074 193 193 nil 27 8 'searchTools' nil nil nil 170 192 1056 138 144 1056 nil nil 9 1309 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 193 560 8 '' 528 3 34 5 752 1120 1632 410 ##(Smalltalk.Toolbar) 34 28 nil 528 34 2 8 1140853580 131137 2112 nil nil nil 519 nil nil nil 2112 nil 8 1962208256 170 192 1056 nil nil nil 170 192 34 6 13969 1115206 1 ##(Smalltalk.ToolbarIconButton) 2112 1 1180998 4 ##(Smalltalk.CommandDescription) #acceptAllChanges nil 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileSaveAll.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 13969 13967 2242 2112 1 2274 #acceptChanges 8 'Accept Change(s)' 1 1 2306 nil true 2352 8 'FileSave.ico' 2400 13967 13965 2242 2112 1 2274 #removeChanges 8 'Remove Change(s)' 1 1 2306 nil true 2352 8 'EditClear.ico' 2400 13965 34 4 2512 2432 2256 1049158 1 ##(Smalltalk.ToolbarSeparator) 2112 1 nil nil 9 1 nil nil nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 25 0 0 0 77 0 0 0 50 0 0 0] 193 2144 8 '' 2112 3 8 #() 1074 193 193 nil 31 1376 1074 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850956 1 2832 nil nil nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2832 nil 8 1961901280 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2832 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' nil nil nil 138 144 34 1 3008 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2832 nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 193 2864 8 '' 2832 3 8 #() 1074 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3280 nil nil nil 7 nil nil nil 3280 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 3 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ReferenceView) 34 14 nil 3280 34 2 8 1140850688 131073 3440 nil nil nil 7 nil nil nil 3440 818 ##(Smalltalk.DifferencesPresenter) #resource_Default_view nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 193 3472 8 '' 3440 3 1056 1074 193 193 nil 27 7 3410 410 ##(Smalltalk.ListView) 34 45 nil 3280 34 2 8 1140920393 1 3696 590662 2 ##(Smalltalk.ListModel) 138 144 1056 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 688 nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 2274 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3890 1 2274 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3890 1 2274 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3890 1 2274 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3890 1 2274 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3890 1 2274 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3890 1 2274 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4098 4097 3890 2097153 2274 #browseIt 8 '&Browse Method' 1 1 2306 nil true 2352 8 'ClassBrowserShell.ico' 2400 nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 3696 nil 8 1962164432 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 4416 7 257 nil ##(Smalltalk.ListView) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 1074 65 65 nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Class' 301 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 4402 0 nil 4434 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each displayClassName]' 8 #[30 105 17 158 106] #displayClassName 4688 7 257 nil nil 3696 ##(Smalltalk.IconicListAbstract) 1 nil nil 4594 8 'Selector' 401 #left ##(Smalltalk.BasicListAbstract) 4642 #<= 8 #() 4402 0 nil 4434 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each selector]' 8 #[30 105 17 158 106] #selector 4832 7 257 nil nil 3696 ##(Smalltalk.IconicListAbstract) 1 nil nil 4594 8 'Package' 201 #left 4402 0 nil 4434 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each name]' 8 #[30 105 17 158 106] #name 4944 7 257 nil 4402 0 nil 4434 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5024 7 513 nil 4402 0 nil 4434 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each |
((each changeClass compiledMethodAt: each selector ifAbsent:[])
	ifNil: [each changeClass]
	ifNotNil: [:method | method]) owningPackage]' 8 #[33 105 17 158 17 159 34 192 100 223 3 73 158 110 70 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 5104 4402 0 nil 4434 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[]' nil 8 #[29 105 60 106] 5184 7 1 nil 7 65793 nil nil 3696 nil 1 nil nil 4594 8 'Change' 261 #left 4642 #yourself 8 #() 4642 #<= 5328 4642 #changeString 5328 nil 3696 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 193 3728 8 'Class' 3696 914 #contextMenu: 34 1 3856 3696 3 8 #() 1074 193 193 nil 35 5 3410 410 ##(Smalltalk.Splitter) 34 12 nil 3280 34 2 8 1140850688 1 5616 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 5616 nil 1 #left nil nil nil 1074 1 1 1074 9 9 nil 5712 nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 193 5648 8 '' 5616 3 8 #() 1074 193 193 nil 27 1 true 170 192 34 2 3696 8 'changes' nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 193 3312 8 '' 3280 3 34 3 3696 5616 3440 1074 193 193 nil 27 170 192 34 4 528 8 'toolbar' 2832 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 3842 nil true 34 3 3890 1 2274 #saveImage 8 'Sa&ve Image' 1 1 2306 nil true 2352 8 'Snapshot.ico' 2400 nil nil 4098 4097 3890 1 2274 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 13979 nil nil 3842 nil true 34 6 3890 1 2274 #copySelection 8 '&Copy' 9351 1 2306 nil true 2352 8 'EditCopy.ico' 2400 nil nil 3890 1 2274 #selectAll 8 'Select &All' 9347 1 nil nil nil 4098 4097 3890 1 2274 #find 8 '&Find...' 9357 1 2306 nil true 2352 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3890 1 2274 #findNext 8 'Find &Next' 1253 1 2306 nil true 2352 8 'FindNext.ico' 2400 nil nil 3890 1 2274 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 13991 nil nil 3842 nil true 34 10 3890 1 2274 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3890 1 2274 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3890 1 2274 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3890 1 2274 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 4098 4097 3890 1 2274 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3890 1 2274 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3890 1 2274 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4098 4097 3890 2097153 2274 #browseIt 8 '&Browse Method' 1 1 4336 nil nil 8 '&Change' nil 134217729 nil nil 14009 nil nil 3842 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 14011 nil nil 3842 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 14013 nil nil 3842 nil true 34 15 3890 1 2274 #helpContents 8 '&Contents' 1025 1 2306 nil true 2352 8 'Help.ico' 2400 nil nil 3890 1 2274 #help 8 'On this &Tool' 1249 1 nil nil nil 3890 1 2274 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4098 4097 3890 1 2274 #learnSmalltalk 8 'Learn Smalltalk' 1 1 6434 $\x1F393 nil 674 #orchid 674 #white nil nil 1 nil nil nil nil 4098 4097 3890 1 2274 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3890 1 2274 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3890 1 2274 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4098 4097 3890 1 2274 #dolphinHomePage 8 'Dolphin Homepage' 1 1 2306 nil true 2352 8 '!!APPLICATION' 2400 nil nil 3890 1 2274 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3890 1 2274 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4098 4097 3890 1 2274 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6434 $\x1F42C nil nil 674 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 14037 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[255 9 0 0 10 0 0 0 87 12 0 0 154 1 0 0] 193 448 8 'Rewrite Results Browser' 416 1 34 3 528 3280 2832 1074 193 193 nil 27 )! !

!RewriteChangesBrowser class categoriesForMethods!
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!


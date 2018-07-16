"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #RewriteChangesBrowser
	instanceVariableNames: 'changesPresenter differencesPresenter compositeChange'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RewriteChangesBrowser guid: (GUID fromString: '{99c85442-1f6a-4912-a74b-7449ae28471b}')!
RewriteChangesBrowser comment: ''!
!RewriteChangesBrowser categoriesForClass!Development!MVP-Presenters! !
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
!RewriteChangesBrowser categoriesFor: #acceptAllChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #acceptChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #acceptChanges:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #acceptClassChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #acceptPackageChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #browseIt!commands!public! !
!RewriteChangesBrowser categoriesFor: #change!accessing!private! !
!RewriteChangesBrowser categoriesFor: #changes!accessing!public! !
!RewriteChangesBrowser categoriesFor: #createComponents!initializing!public! !
!RewriteChangesBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!RewriteChangesBrowser categoriesFor: #deferredSelectCaret!helpers!private! !
!RewriteChangesBrowser categoriesFor: #methodChanged:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #model:!accessing!public! !
!RewriteChangesBrowser categoriesFor: #onChangeSelected!event handling!public! !
!RewriteChangesBrowser categoriesFor: #onMethodAdded:!event handling!public! !
!RewriteChangesBrowser categoriesFor: #onMethodRemoved:!event handling!public! !
!RewriteChangesBrowser categoriesFor: #onMethodUpdated:!event handling!public! !
!RewriteChangesBrowser categoriesFor: #queryCommand:!commands!private! !
!RewriteChangesBrowser categoriesFor: #removeChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #removeChanges:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #removeChangesMatching:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #removeClassChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #removePackageChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #selectCaret!helpers!private! !
!RewriteChangesBrowser categoriesFor: #setInitialFocus!operations!public! !
!RewriteChangesBrowser categoriesFor: #updateCaption!public!updating! !

!RewriteChangesBrowser class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^MethodBrowser icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 1 674 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Search_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 661 1 674 433 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 63 1 674 599 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Find_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 155 51 674 109 51 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 25 0 0 0 131 0 0 0 50 0 0 0] 1088 1104 nil 27 8 'findTools' 170 192 1088 138 144 1088 170 176 1088 nil 1 nil 674 33 33 674 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 1169 101 528 962 #updateSizePosted 1088 528 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 34 5 800 1376 1136 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 2144 nil nil nil 519 nil nil nil 2144 706 736 8 1912794480 170 192 1088 170 192 34 6 33545 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 2144 1 1180998 4 ##(Smalltalk.CommandDescription) #removeChanges 8 'Remove Change(s)' 1 1 nil 33545 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 7 674 193 33 11 33547 2290 2144 1 2322 #acceptChanges 8 'Accept Change(s)' 1 1 nil 33547 2370 nil true 2416 8 'FileBar.bmp' 2464 nil 7 674 161 33 5 33549 2290 2144 1 2322 #acceptAllChanges nil 1 1 nil 33549 2560 7 34 4 2304 2512 2608 1049158 1 ##(Smalltalk.ToolbarSeparator) 2144 1 170 176 34 4 2384 1 2560 13 nil 1 nil 674 33 33 674 45 45 nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 51 674 155 51 2144 962 #updateSizePosted 1088 2144 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 77 0 0 0 50 0 0 0] 8 #() 1104 nil 27 1616 1104 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2928 nil nil nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 2928 nil 8 1912526784 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2928 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 138 144 34 1 3120 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2928 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 643 674 1169 41 2928 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3408 nil nil nil 7 nil nil nil 3408 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 3 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 3408 34 2 8 1140850688 1 3568 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3568 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3664 nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 213 674 1169 11 3568 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 8 #() 1104 nil 27 1 3538 410 ##(Smalltalk.ReferenceView) 34 14 nil 3408 34 2 8 1140850688 131073 3872 nil nil nil 7 nil nil nil 3872 866 ##(Smalltalk.DifferencesPresenter) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 223 674 1169 321 3872 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 1088 1104 nil 27 7 3538 410 ##(Smalltalk.ListView) 34 30 nil 3408 34 2 8 1140920393 1 4112 590662 2 ##(Smalltalk.ListModel) 138 144 1088 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 706 736 nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 2322 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 4322 1 2322 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 4322 1 2322 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 4322 1 2322 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4322 1 2322 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 4322 1 2322 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 4322 1 2322 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4530 4097 4322 2097153 2322 #browseIt 8 '&Browse Method' 1 1 263494 3 ##(Smalltalk.Icon) nil true 2416 8 'ClassBrowserShell.ico' 2464 nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 4112 nil 8 1912800272 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 4864 7 257 nil ##(Smalltalk.ListView) 3152 nil nil nil 674 65 65 nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Class' 301 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 4850 0 nil 4882 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each displayClassName]' 8 #[30 105 17 158 106] #displayClassName 5056 7 257 nil nil 4112 ##(Smalltalk.IconicListAbstract) 1 nil nil 5010 8 'Selector' 401 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 4850 0 nil 4882 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each selector]' 8 #[30 105 17 158 106] #selector 5168 7 257 nil nil 4112 ##(Smalltalk.IconicListAbstract) 1 nil nil 5010 8 'Package' 201 #left 4850 0 nil 4882 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each name]' 8 #[30 105 17 158 106] #name 5280 7 257 nil 4850 0 nil 4882 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5360 7 513 nil 4850 0 nil 4882 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each |
((each changeClass compiledMethodAt: each selector ifAbsent:[])
	ifNil: [each changeClass]
	ifNotNil: [:method | method]) owningPackage]' 8 #[33 105 17 158 17 159 34 192 100 223 3 73 158 110 70 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 5440 4850 0 nil 4882 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[]' nil 8 #[29 105 60 106] 5520 7 1 nil 7 65793 nil nil 4112 nil 1 nil nil 5010 8 'Change' 261 #left 459270 ##(Smalltalk.Message) #yourself 8 #() 5650 #<= 5680 5650 #changeString 5680 nil 4112 nil 3 nil nil #report 1088 nil 131169 nil 34 4 nil nil 674 1 1 nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 1 1 674 1169 213 4112 962 #contextMenu: 34 1 4288 4112 962 #text: 34 1 8 'Class' 4112 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 8 #() 1104 nil 27 5 true 170 192 34 2 4112 8 'changes' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 101 674 1169 543 3408 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 34 3 4112 3568 3872 1104 nil 27 170 192 34 4 528 8 'toolbar' 2928 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 4274 nil true 34 3 4322 1 2322 #saveImage 8 'Sa&ve Image' 1 1 nil nil nil 4530 4097 4322 1 2322 #exit 8 '&Close' 17639 1 nil nil nil 8 '&File' nil 134217729 nil nil 33457 nil nil 4274 nil true 34 6 4322 1 2322 #copySelection 8 '&Copy' 9351 1 nil nil nil 4322 1 2322 #selectAll 8 'Select &All' 9347 1 nil nil nil 4530 4097 4322 1 2322 #find 8 '&Find...' 9357 1 4770 nil true 2416 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4322 1 2322 #findNext 8 'Find &Next' 1253 1 nil nil nil 4322 1 2322 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 33469 nil nil 4274 nil true 34 10 4322 1 2322 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 4322 1 2322 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 4322 1 2322 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 4322 1 2322 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 4530 4097 4322 1 2322 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 4322 1 2322 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 4322 1 2322 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4530 4097 4322 2097153 2322 #browseIt 8 '&Browse Method' 1 1 4784 nil nil 8 '&Change' nil 134217729 nil nil 33487 nil nil 4274 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 33489 nil nil 4274 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 33491 nil nil 4274 nil true 34 15 4322 1 2322 #helpContents 8 '&Contents' 1025 1 4770 nil true 2416 49 6704 nil nil 4322 1 2322 #help 8 'On this &Tool' 1249 1 nil nil nil 4322 1 2322 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4530 4097 4322 1 2322 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 4530 4097 4322 1 2322 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4322 1 2322 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4322 1 2322 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4530 4097 4322 1 2322 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 4322 1 2322 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4322 1 2322 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4530 4097 4322 1 2322 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4770 nil true 2416 8 '!!APPLICATION' 2464 nil nil 8 '&Help' nil 134217729 nil nil 33515 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 3839 21 674 1201 801 416 962 #text: 34 1 8 'Rewrite Results Browser' 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 3 528 3408 2928 1104 nil 27 )! !
!RewriteChangesBrowser class categoriesFor: #icon!constants!public! !
!RewriteChangesBrowser class categoriesFor: #resource_Default_view!public!resources-views! !


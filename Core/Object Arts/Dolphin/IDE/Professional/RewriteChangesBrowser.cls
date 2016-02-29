"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #RewriteChangesBrowser
	instanceVariableNames: 'changesPresenter differencesPresenter compositeChange'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RewriteChangesBrowser guid: (GUID fromString: '{99C85442-1F6A-4912-A74B-7449AE28471B}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851468 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 482 512 8 4294903529 234 256 98 6 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 63 1 738 991 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 738 193 193 0 27 8 'smalltalkTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Find_tools 0 962 202 208 98 1 1026 1056 98 2 738 155 51 738 109 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 25 0 0 0 131 0 0 0 50 0 0 0] 1168 1184 0 27 8 'findTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1472 0 0 0 7 0 0 0 1472 914 576 8 #resource_Image_tools 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 63 51 1472 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1168 1184 0 27 8 'imageTools' 234 256 1168 202 208 1168 234 240 1168 0 1 0 738 33 33 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1169 101 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 98 4 1472 832 410 576 98 25 0 560 98 2 8 1140853580 131137 2032 0 482 512 0 519 0 0 0 2032 482 512 8 4294903529 234 256 1168 234 256 98 6 40305 853766 ##(Smalltalk.ToolbarButton) 40305 0 2032 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #acceptAllChanges 0 1 1 0 395334 3 ##(Smalltalk.Bitmap) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 7 738 161 33 7 40301 2194 40301 0 2032 1 2226 8 #removeChanges 8 'Remove Change(s)' 1 1 0 2274 0 16 2320 8 'EditBar.bmp' 2368 0 7 738 193 33 11 40303 2194 40303 0 2032 1 2226 8 #acceptChanges 8 'Accept Change(s)' 1 1 0 2288 5 98 4 2416 2528 2208 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 2032 3 0 1 234 240 98 4 2480 1 2288 13 0 1 0 738 33 33 738 45 45 0 0 962 202 208 98 2 1026 1056 98 2 738 1 51 738 155 51 2032 1026 1968 1168 2032 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 77 0 0 0 50 0 0 0] 98 0 1184 0 27 1216 1184 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 2880 0 482 512 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 0 2880 0 8 4294905391 234 256 98 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2880 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 202 208 98 1 3104 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2880 0 0 962 202 208 98 1 1026 1056 98 2 738 1 643 738 1169 41 2880 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 98 0 1184 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3424 0 482 8 4278190080 0 7 0 0 0 3424 1180166 ##(Smalltalk.ProportionalLayout) 202 8 ##(Smalltalk.Dictionary) 98 3 721414 ##(Smalltalk.Association) 410 8 ##(Smalltalk.ListView) 98 30 0 3424 98 2 8 1140920393 1 3648 590662 2 ##(Smalltalk.ListModel) 202 208 1168 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 512 0 15 265030 4 ##(Smalltalk.Menu) 0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 2226 2560 8 '&Accept <1?Change:Changes>' 1 1 0 0 0 3874 1 2226 8 #acceptClassChanges 8 'Accept &Class Changes' 1 1 0 0 0 3874 1 2226 8 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 0 0 0 3874 1 2226 2256 8 'Accept A&ll Changes' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3874 1 2226 2448 8 '&Remove <1?Change:Changes>' 1 1 0 0 0 3874 1 2226 8 #removeClassChanges 8 'R&emove Class Changes' 1 1 0 0 0 3874 1 2226 8 #removePackageChanges 8 'Re&move Package Changes' 1 1 0 0 0 4114 4097 3874 2097153 2226 8 #browseIt 8 '&Browse Method' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 2320 8 'ClassBrowserShell.ico' 2368 0 0 8 '&Change' 0 134217729 0 0 0 0 0 0 0 3648 0 8 4294909021 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] 8 #displayString 4496 7 257 0 3664 3168 0 0 0 738 65 65 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Class' 301 8 #left 3120 8 ##(Smalltalk.SortedCollection) 4482 0 0 4514 2 1 4544 8 'doIt' 8 '[:each | each displayClassName]' 8 #[30 105 17 158 106] 8 #displayClassName 4752 7 257 0 0 3648 3136 1 0 0 4674 8 'Selector' 401 4720 3120 4736 4482 0 0 4514 2 1 4544 8 'doIt' 8 '[:each | each selector]' 8 #[30 105 17 158 106] 8 #selector 4880 7 257 0 0 3648 3136 1 0 0 4674 8 'Package' 201 4720 4482 0 0 4514 2 1 4544 8 'doIt' 8 '[:each | each name]' 8 #[30 105 17 158 106] 8 #name 5008 7 257 0 4482 0 0 4514 2 1 4544 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 5088 5104 7 513 0 4482 0 0 4514 6 1 4544 8 'doIt' 8 '[:each |
((each changeClass compiledMethodAt: each selector ifAbsent:[])
	ifNil: [each changeClass]
	ifNotNil: [:method | method]) owningPackage]' 8 #[33 105 17 158 17 159 34 192 100 223 3 73 158 110 70 161 106] 8 #changeClass 4960 8 #compiledMethodAt:ifAbsent: 8 #owningPackage 5184 4482 0 0 4514 1 83886081 4544 8 'doIt' 98 2 8 '[]' 0 8 #[29 105 60 106] 5312 7 1 0 7 65793 0 0 3648 0 1 0 0 4674 8 'Change' 261 4720 459270 ##(Smalltalk.Message) 8 #yourself 98 0 5442 8 #<= 5488 5442 8 #changeString 5488 0 3648 0 3 0 0 8 #report 1168 0 131169 0 98 1 0 962 202 208 98 3 1026 1056 98 2 738 1 1 738 1169 213 3648 1026 8 #contextMenu: 98 1 3840 3648 1026 8 #text: 98 1 8 'Class' 3648 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 98 0 1184 0 27 5 3618 410 8 ##(Smalltalk.Splitter) 98 12 0 3424 98 2 8 1140850688 1 5888 0 482 512 0 519 0 0 0 5888 962 202 208 98 1 1026 1056 98 2 738 1 213 738 1169 11 5888 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 98 0 1184 0 27 1 3618 410 848 98 14 0 3424 98 2 8 1140850688 131073 6160 0 0 0 7 0 0 0 6160 914 8 ##(Smalltalk.DifferencesPresenter) 8 #resource_Default_view 0 962 202 208 98 1 1026 1056 98 2 738 1 223 738 1169 321 6160 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 1168 1184 0 27 7 16 234 256 98 2 3648 8 'changes' 0 962 202 208 98 1 1026 1056 98 2 738 1 101 738 1169 543 3424 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 98 3 3648 5888 6160 1184 0 27 234 256 98 4 2880 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 3826 0 16 98 3 3874 1 2226 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 4114 4097 3874 1 2226 8 #exit 8 '&Close' 17639 1 0 0 0 8 '&File' 0 134217729 0 0 40335 0 0 3826 0 16 98 6 3874 1 2226 8 #copySelection 8 '&Copy' 9351 1 0 0 0 3874 1 2226 8 #selectAll 8 'Select &All' 9347 1 0 0 0 4114 4097 3874 1 2226 8 #find 8 '&Find...' 9357 1 4402 0 16 2320 47 786694 ##(Smalltalk.ShellLibrary) 0 0 3874 1 2226 8 #findNext 8 'Find &Next' 1253 1 0 0 0 3874 1 2226 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 40347 0 0 3826 0 16 98 10 3874 1 2226 2560 8 '&Accept <1?Change:Changes>' 1 1 0 0 0 3874 1 2226 3968 8 'Accept &Class Changes' 1 1 0 0 0 3874 1 2226 4032 8 'Accept &Package Changes' 1 1 0 0 0 3874 1 2226 2256 8 'Accept A&ll Changes' 1 1 0 0 0 4114 4097 3874 1 2226 2448 8 '&Remove <1?Change:Changes>' 1 1 0 0 0 3874 1 2226 4224 8 'R&emove Class Changes' 1 1 0 0 0 3874 1 2226 4288 8 'Re&move Package Changes' 1 1 0 0 0 4114 4097 3874 2097153 2226 4368 8 '&Browse Method' 1 1 4416 0 0 8 '&Change' 0 134217729 0 0 40365 0 0 3826 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 40367 0 0 3826 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 40369 0 0 3826 0 16 98 15 3874 1 2226 8 #helpContents 8 '&Contents' 1025 1 4402 0 16 2320 49 7200 0 0 3874 1 2226 8 #help 8 'On this &Tool' 1249 1 0 0 0 3874 1 2226 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 4114 4097 3874 1 2226 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 4114 4097 3874 1 2226 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3874 1 2226 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3874 1 2226 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 4114 4097 3874 1 2226 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3874 1 2226 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3874 1 2226 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 4114 4097 3874 1 2226 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4402 0 16 2320 8 '!!APPLICATION' 2368 0 0 8 '&Help' 0 134217729 0 0 40393 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 738 3839 21 738 1201 801 416 1026 5776 98 1 8 'Rewrite Results Browser' 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 3 560 3424 2880 1184 0 27 )! !
!RewriteChangesBrowser class categoriesFor: #icon!constants!public! !
!RewriteChangesBrowser class categoriesFor: #resource_Default_view!public!resources-views! !


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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 528 917510 #{Graphics.Color} #default 8 1785452784 170 192 34 8 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 674 1 1 674 63 51 784 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'imageTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1104 nil nil nil 7 nil nil nil 1104 850 #{UI.Toolbar} #resource_Find_tools nil 882 34 1 930 #createAt:extent: 34 2 674 201 51 674 109 51 1104 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 25 0 0 0 154 0 0 0 50 0 0 0] 1056 1072 nil 27 8 'findTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1328 nil nil nil 7 nil nil nil 1328 850 #{UI.Toolbar} #resource_Smalltalk_tools nil 882 34 1 930 #createAt:extent: 34 2 674 63 1 674 553 51 1328 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1056 1072 nil 27 8 'smalltalkTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1552 nil nil nil 7 nil nil nil 1552 850 #{UI.Toolbar} #resource_Search_tools nil 882 34 1 930 #createAt:extent: 34 2 674 615 1 674 437 51 1552 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1056 1072 nil 27 8 'searchTools' nil nil nil 170 192 1056 138 144 1056 nil nil 1 nil 674 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 882 34 1 930 #createAt:extent: 34 2 674 1 1 674 1169 101 528 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 34 5 784 1328 1552 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1140853580 131137 2000 nil nil nil 519 nil nil nil 2000 nil 8 1785452784 170 192 1056 nil nil nil 170 192 34 8 59933 1311814 1 #{UI.ToolbarIconButton} 2000 1 1377606 4 #{UI.CommandDescription} #acceptAllChanges nil 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'FileSaveAll.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil 59933 59931 2130 2000 1 2162 #acceptChanges 8 'Accept Change(s)' 1 1 2194 nil true 2226 8 'FileSave.ico' 2288 65541 nil 59931 59929 2130 2000 1 2162 #removeChanges 8 'Remove Change(s)' 1 1 2194 nil true 2226 8 'EditClear.ico' 2288 65541 nil 59929 59935 2130 2000 1 2162 #refresh 8 'Refresh' 1 1 2194 nil true 2226 8 'Refresh.ico' 2288 65541 nil 59935 34 5 2416 2320 2144 2512 1245766 1 #{UI.ToolbarSeparator} 2000 1 nil nil 1 nil nil nil nil nil 882 34 1 930 #createAt:extent: 34 2 674 1 51 674 201 51 2000 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 100 0 0 0 50 0 0 0] 8 #() 1072 nil 29 1104 1072 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 2800 nil nil nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 2800 nil 8 1785006096 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 2800 nil 786950 #{Core.Message} #displayString 8 #() 3010 #iconImageIndex 3040 nil 8 'errors' nil nil nil 34 1 2992 1311814 1 #{UI.StatusBarNullItem} 8705 1 2800 nil nil 882 34 1 930 #createAt:extent: 34 2 674 1 643 674 1169 41 2800 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 1072 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 3280 nil nil nil 7 nil nil nil 3280 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 3 1049094 #{Core.Association} 410 #{UI.ListTreeView} 34 59 nil 3280 34 2 8 1140920649 1 3440 787270 2 #{UI.ListModel} 138 144 1056 nil 1769478 #{Kernel.IdentitySearchPolicy} 720 nil 15 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 1 2162 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3634 1 2162 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3634 1 2162 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3634 1 2162 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 3634 1 2162 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3634 1 2162 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3634 1 2162 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3842 4097 3634 2097153 2162 #browseIt 8 '&Browse Method' 1 1 2194 nil true 2226 8 'ClassBrowserShell.ico' 2288 65541 nil nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 3440 nil 8 1785427120 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 4176 7 257 nil 3056 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 4 1117254 5 #{UI.ListViewColumn} 8 'Change' 291 #left 3024 nil nil nil 3440 nil 3 nil nil 4338 8 'Class' 289 #left 3024 3010 #<= 8 #() 3010 #classReference 1056 nil 3440 3056 3 nil nil 4338 8 'Selector' 291 #left 3024 4162 0 nil 4194 3 83886081 4160 8 'doIt' 8 '[:a :b | a isNil or: [b notNil and: [a <= b]]]' 8 #[29 105 17 223 2 58 106 18 222 4 233 1 130 106 59 106] 4496 #or: #and: 7 513 nil 3010 #selector 8 #() nil 3440 3056 3 nil nil 4338 8 'Package' 301 #left 3024 4162 0 nil 4194 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 4640 7 513 nil 4162 0 nil 4194 7 1 4160 8 'doIt' 8 '[:each | 
each changeClass ifNotNil: [:changeClass |
	((changeClass compiledMethodAt: each selector ifAbsent: nil)
		ifNil: [changeClass]) owningPackage]]' 8 #[33 105 226 0 100 222 10 70 226 1 60 192 100 223 1 74 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 4720 #ifNotNil: #ifNil: 7 65793 nil nil 3440 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil 201 nil 1 nil nil nil nil nil nil nil nil nil nil false 1247046 3 #{UI.VirtualTreeModel} nil 3568 138 144 1056 4162 0 nil 1377574 #{Kernel.CompiledMethod} 2 3 4816 #defaultGetChildrenBlock 212361507 8 #[30 105 226 0 106] #children 4864 7 257 nil 4162 0 nil 4882 2 3 4816 #defaultGetParentBlock 212367203 8 #[30 105 226 0 106] #parent 4928 7 257 nil 4162 0 nil 4882 2 3 4816 #defaultHasChildrenBlock 212372739 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4832 4162 0 nil 4882 1 83886083 4816 #defaultFilterBlock 212355235 8 #[29 105 17 157 106] 5024 7 257 nil nil 138 #{Core.IdentitySet} 1056 138 #{Core.IdentitySet} 1056 45 1 nil nil nil nil nil nil nil 882 34 3 930 #createAt:extent: 34 2 674 1 1 674 1169 213 3440 930 #contextMenu: 34 1 3600 3440 930 #text: 34 1 8 'Change' 3440 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 8 #() 1072 nil 2029 5 3410 410 #{UI.Splitter} 34 12 nil 3280 34 2 8 1140850688 1 5344 nil nil nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 5344 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 5440 nil 882 34 1 930 #createAt:extent: 34 2 674 1 213 674 1169 11 5344 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 8 #() 1072 nil 27 1 3410 410 #{UI.ReferenceView} 34 14 nil 3280 34 2 8 1140850688 131073 5632 nil nil nil 7 nil nil nil 5632 850 #{UI.DifferencesPresenter} #resource_Default_view nil 882 34 1 930 #createAt:extent: 34 2 674 1 223 674 1169 321 5632 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 1056 1072 nil 27 7 true 170 192 34 2 3440 8 'changes' nil 882 34 1 930 #createAt:extent: 34 2 674 1 101 674 1169 543 3280 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 34 3 3440 5344 5632 1072 nil 27 170 192 34 4 528 8 'toolbar' 2800 8 'statusbar' nil 658246 4 #{UI.MenuBar} nil true 34 6 3586 nil true 34 3 3634 1 2162 #saveImage 8 'Sa&ve Image' 1 1 2194 nil true 2226 8 'Snapshot.ico' 2288 65541 nil nil nil 3842 4097 3634 1 2162 #exit 8 '&Close' 17639 1 1378630 2 #{Graphics.TextTileIcon} $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 59945 nil nil 3586 nil true 34 6 3634 1 2162 #copySelection 8 '&Copy' 9351 1 2194 nil true 2226 8 'EditCopy.ico' 2288 65541 nil nil nil 3634 1 2162 #selectAll 8 'Select &All' 9347 1 nil nil nil 3842 4097 3634 1 2162 #find 8 '&Find…' 9357 1 2194 nil true 2425862 #{Graphics.ImageFromResourceInitializer} 47 983302 #{OS.ShellLibrary} 65541 nil nil nil 3634 1 2162 #findNext 8 'Find &Next' 1253 1 2194 nil true 2226 8 'FindNext.ico' 2288 65541 nil nil nil 3634 1 2162 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 59957 nil nil 3586 nil true 34 10 3634 1 2162 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 3634 1 2162 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 3634 1 2162 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 3634 1 2162 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 3842 4097 3634 1 2162 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 3634 1 2162 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 3634 1 2162 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 3842 4097 3634 2097153 2162 #browseIt 8 '&Browse Method' 1 1 4080 nil nil 8 '&Change' nil 134217729 nil nil 59975 nil nil 3586 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 59977 nil nil 3586 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 59979 nil nil 3586 nil true 34 15 3634 1 2162 #helpContents 8 '&Contents' 1025 1 2194 nil true 2226 8 'Help.ico' 2288 65541 nil nil nil 3634 1 2162 #help 8 'On this &Tool' 1249 1 nil nil nil 3634 1 2162 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3842 4097 3634 1 2162 #learnSmalltalk 8 'Learn Smalltalk' 1 1 6338 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 3842 4097 3634 1 2162 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3634 1 2162 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3634 1 2162 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3842 4097 3634 1 2162 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2194 nil true 2226 8 '!!APPLICATION' 2288 65541 nil nil nil 3634 1 2162 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3634 1 2162 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3842 4097 3634 1 2162 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6338 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 60003 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 34 2 930 #createAt:extent: 34 2 674 12287 21 674 1201 801 416 930 #text: 34 1 8 'Rewrite Results Browser' 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 34 3 528 3280 2800 1072 nil 27)! !
!Tools.RewriteChangesBrowser class categoriesForMethods!
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!


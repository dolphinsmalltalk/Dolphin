"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #PoolDictionariesShell
	instanceVariableNames: 'dictionariesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolDictionariesShell guid: (GUID fromString: '{558cac4a-ac5c-43bf-8f8e-247bb36208f5}')!
PoolDictionariesShell comment: ''!
!PoolDictionariesShell categoriesForClass!MVP-Presenters! !
!PoolDictionariesShell methodsFor!

addEntry
	"Prompt for an entry to add to the selected pool"

	| entry value key newAssoc pool |
	entry := Association new.
	entry := (KeyValuePrompter 
				createOn: entry
				prompt: 'Enter key string and value expression:'
				caption: self caption) showModal.
	entry ifNil: [^self].
	key := entry key asString.
	value := entry value notNil ifTrue: [Compiler evaluate: entry value].
	pool := self selectionOrNil.
	newAssoc := pool newAssociation: key value: value.
	pool add: newAssoc.
	dictionariesPresenter inspectorPresenter refresh!

addPool
	| name newPool |
	name := Prompter prompt: 'Enter Name of PoolConstantsDictionary to Create: ' caption: self caption.
	name ifNil: [^self].
	name := name trimBlanks capitalized asSymbol.
	Smalltalk at: name
		ifPresent: 
			[:existingPool | 
			self selectionOrNil: existingPool.
			^MessageBox warning: 'There is already a global called ' , name , '.' caption: self caption].
	newPool := PoolConstantsDictionary named: name.
	Smalltalk at: name put: newPool.
	self model add: newPool.
	self selectionOrNil: newPool!

browseEntryReferences
	| methods |
	methods := self methodsReferencingSelectedEntry.
	self systemModel browseMethodsIn: (self systemModel systemEnvironment forMethods: methods)!

classesReferencingSelectedPool
	^self selectionOrNil classesReferencing!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	dictionariesPresenter := self add: TwinLevelInspector new name: 'dictionaries'.!

hasSelectedItemAccessor
	^self selectedItemAccessorOrNil notNil!

hasSelection
	^self selectionOrNil notNil!

methodsReferencingSelectedEntry
	| key |
	key := self selectedItemAccessorOrNil aspectDescriptor key.
	^self selectionOrNil referencesTo: key asString!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	dictionariesPresenter model: aListModelOfObjects!

poolPackage
	"Prompt for the user to repackage the selected pool."

	| pool newPkg oldPkg |
	pool := self selectionOrNil.
	oldPkg := pool owningPackage.
	newPkg := PackagePrompter 
				showModalOn: oldPkg asValue
				caption: ('Package of <1d>...' expandMacrosWith: pool)
				default: nil
				validationBlock: [:package | package notNil and: [pool environment includesKey: pool name]].
	(newPkg isNil or: [newPkg = oldPkg]) ifTrue: [^self].	
	Package manager addGlobalNamed: pool name to: newPkg!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into aCommandQuery"

	super queryCommand: aCommandQuery.
	(#(#removePool #poolPackage #addEntry) includes: aCommandQuery command) 
		ifTrue: [aCommandQuery isEnabled: self hasSelection].
	(#(#browseEntryReferences #removeEntry) includes: aCommandQuery command) 
		ifTrue: [aCommandQuery isEnabled: self hasSelectedItemAccessor]!

removeEntry
	| refs key confirmationMsg ok |
	refs := self methodsReferencingSelectedEntry.
	key := self selectedItemKey.
	confirmationMsg := refs notEmpty 
				ifTrue: ['''' , key , ''' has references.
Are you sure you wish to remove it?']
				ifFalse: ['Are you sure you wish to remove ''' , key , '''?'].
	ok := MessageBox confirm: confirmationMsg caption: self caption.
	ok ifFalse: [^self].
	self selectionOrNil removeKey: key.
	dictionariesPresenter inspectorPresenter refresh!

removePool
	| pool refs confirmationMsg ok |
	pool := self selectionOrNil.
	refs := self classesReferencingSelectedPool.
	confirmationMsg := refs notEmpty 
				ifTrue: [pool name , ' has references.
Are you sure you wish to remove it?']
				ifFalse: ['Are you sure you wish to remove ' , pool name , '?'].
	ok := MessageBox confirm: confirmationMsg caption: self caption.
	ok ifFalse: [^self].
	Smalltalk removeKey: pool name.
	self model remove: pool!

selectedItemAccessorOrNil
	^dictionariesPresenter aspectAccessor!

selectedItemKey
	^self selectedItemAccessorOrNil aspectDescriptor key.
!

selectionOrNil
	^dictionariesPresenter selectionOrNil!

selectionOrNil: aPoolConstantsDictionary
	dictionariesPresenter selectionOrNil: aPoolConstantsDictionary! !
!PoolDictionariesShell categoriesFor: #addEntry!public! !
!PoolDictionariesShell categoriesFor: #addPool!commands!public! !
!PoolDictionariesShell categoriesFor: #browseEntryReferences!commands!public! !
!PoolDictionariesShell categoriesFor: #classesReferencingSelectedPool!commands!private! !
!PoolDictionariesShell categoriesFor: #createComponents!private! !
!PoolDictionariesShell categoriesFor: #hasSelectedItemAccessor!public!selection! !
!PoolDictionariesShell categoriesFor: #hasSelection!public!selection! !
!PoolDictionariesShell categoriesFor: #methodsReferencingSelectedEntry!commands!private! !
!PoolDictionariesShell categoriesFor: #model:!public! !
!PoolDictionariesShell categoriesFor: #poolPackage!commands!public! !
!PoolDictionariesShell categoriesFor: #queryCommand:!commands!private! !
!PoolDictionariesShell categoriesFor: #removeEntry!public! !
!PoolDictionariesShell categoriesFor: #removePool!commands!public! !
!PoolDictionariesShell categoriesFor: #selectedItemAccessorOrNil!commands!private! !
!PoolDictionariesShell categoriesFor: #selectedItemKey!commands!private! !
!PoolDictionariesShell categoriesFor: #selectionOrNil!private!selection! !
!PoolDictionariesShell categoriesFor: #selectionOrNil:!private!selection! !

!PoolDictionariesShell class methodsFor!

defaultModel
	^ListModel 
		on: (SmalltalkSystem current availablePools asSortedCollection: [:x :y | x name <= y name])!

displayOn: aStream 
	aStream nextPutAll: 'Pool Dictionaries'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true.
	!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects add: (Aspect boolean: #reuseIfOpen).
	aspects add: (Aspect boolean: #canUseIdeaSpace).
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 37 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 640 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 21 21 786 1409 813 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 896 34 2 8 1140850945 1 976 nil 327686 ##(Smalltalk.Color) #silver nil 7 nil nil nil 976 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 699 39 976 738 #text: 34 1 8 'Available Pools' 976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 786 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 896 34 2 8 1409372236 1 1344 590662 2 ##(Smalltalk.ListModel) 138 144 640 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1042 #default nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #addPool 8 'Add New Pool...' 1 1 nil nil nil 1554 1 1586 #removePool 8 'Remove Pool...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1554 1 1586 #poolPackage 8 'Package...' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 78 97 114 114 111 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 786 193 193 nil 1344 nil 8 1903904528 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 786 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 1890 #displayString 1920 1890 #<= 8 #() nil nil 1344 nil 1 nil nil #thumbnails 640 786 193 193 131169 786 65 65 34 4 nil false 786 1 1 201 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 39 786 699 775 1344 738 #contextMenu: 34 1 1520 1344 738 #text: 34 1 8 'Column 1' 1344 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1328 nil 27 170 192 34 2 1344 8 'contents' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 699 813 896 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 976 1344 1328 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 2624 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2624 nil 1 #left nil nil nil 786 1 1 786 9 9 nil 2720 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 699 1 786 11 813 2624 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1328 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2912 nil nil nil 7 nil nil nil 2912 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 2912 34 2 8 1140850945 1 2992 nil 1056 nil 7 nil nil nil 2992 nil 8 1903849936 1090 nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 701 39 2992 738 #text: 34 1 8 'Entries' 2992 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1328 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2912 34 2 8 1409286144 131073 3296 nil nil nil 7 nil nil nil 3296 594 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 3296 34 2 8 1140850688 1 3440 nil nil nil 519 nil nil nil 2690 3440 nil 1 #left nil nil nil 2720 2736 nil 2720 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 85 786 731 11 3440 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1328 nil 27 1 true 170 192 640 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 39 786 701 775 3296 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 2 3440 410 ##(Smalltalk.CardContainer) 34 16 nil 3296 34 2 8 1409286144 131073 3856 nil nil nil 7 nil nil nil 3856 655878 ##(Smalltalk.CardLayout) 138 144 34 2 3410 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 3856 34 2 8 1140953421 1 4000 1410 138 144 640 nil 1472 1488 nil 15 1506 nil true 34 4 1554 1 1586 #addEntry 8 'Add Entry...' 1 1 nil nil nil 1554 1 1586 #removeEntry 8 'Remove Entry...' 1 1 nil nil nil 1682 4097 1554 1 1586 #browseEntryReferences 8 'Browse References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4000 nil 8 1903904528 1890 #valueText 8 #() nil 1952 nil nil nil nil nil nil 138 144 34 3 2018 8 'Key' 461 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 1888 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4432 7 257 nil 1890 #<= 8 #() nil nil 4000 nil 3 nil nil 2018 8 'Value' 171 #left 4418 0 nil 4450 2 1 4416 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4592 7 257 nil 1890 #<= 4544 nil nil 4000 nil 1 nil nil 2018 8 '' 41 #center nil 1890 #<= 8 #() nil nil 4000 4418 0 nil 4450 3 1 4416 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 4752 7 257 nil 1 nil nil #report 640 nil 355 786 129 129 34 4 nil false 786 1 1 201 false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1472 138 144 640 nil nil 4418 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 4880 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4896 4418 0 nil 4946 1 83886083 4880 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4992 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 640 138 ##(Smalltalk.PluggableSet) 640 1 1 nil nil nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 9 9 786 685 715 4000 738 #contextMenu: 34 1 4096 4000 738 #text: 34 1 8 'Key' 4000 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 2021 3410 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 3856 34 2 8 1411453252 1 5328 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 #smalltalkWorkspace nil 21 1506 nil true 34 17 1554 1 1586 #accept 8 '&Accept' 1 1 nil nil nil 1682 4097 1506 nil true 34 9 1554 1 1586 #undo 8 '&Undo' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditUndo.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1682 4097 1554 1 1586 #cutSelection 8 'Cu&t' 1 1 5650 nil true 5696 8 'EditCut.ico' 5744 nil nil 1554 1 1586 #copySelection 8 '&Copy' 1 1 5650 nil true 5696 8 'EditCopy.ico' 5744 nil nil 1554 1 1586 #pasteClipboard 8 '&Paste' 1 1 5650 nil true 5696 8 'EditPaste.ico' 5744 nil nil 1554 1 1586 #clearSelection 8 'De&lete' 1 1 5650 nil true 5696 8 'EditClear.ico' 5744 nil nil 1554 1 1586 #reformatSource 8 'Re&format' 1 1 nil nil nil 1682 4097 1554 1 1586 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1554 1 1586 #clear 8 'Clea&r' 1 1 nil nil nil 1682 4097 1554 1 1586 #browseIt 8 'Bro&wse It' 1 1 5650 nil true 5696 8 'ClassBrowserShell.ico' 5744 nil nil 1554 1 1586 #displayIt 8 '&Display It' 1 1 5650 nil true 5696 8 'DisplayIt.ico' 5744 nil nil 1554 1 1586 #evaluateIt 8 'E&valuate It' 1 1 5650 nil true 5696 8 'EvaluateIt.ico' 5744 nil nil 1554 1 1586 #inspectIt 8 '&Inspect It' 1 1 5650 nil true 5696 8 'InspectIt.ico' 5744 nil nil 1554 1 1586 #debugIt 8 'Deb&ug It' 1 1 5650 nil true 5696 8 'Debugger.ico' 5744 nil nil 1682 4097 1554 1 1586 #chooseEvaluationPools 8 '&Pools...' 1 1 5650 nil true 5696 8 'SystemDictionary.ico' 5744 nil nil 1554 1 1586 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 1682 4097 1506 nil true 34 2 1554 2097153 1586 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1554 1 1586 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 1682 4097 1506 nil true 34 9 1554 1 1586 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1554 1 1586 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1554 1 1586 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 1554 1 1586 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1554 1 1586 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1554 1 1586 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1554 1 1586 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 1682 4097 1506 nil true 34 2 1554 1 1586 1890 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 1554 1 1586 1890 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5328 nil 8 1349308863 1090 nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7714 77 1042 #gray 1042 #white 1 nil nil nil nil #callTip nil nil nil 34 256 7728 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 7744 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 640 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5328 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 640 nil 170 176 640 9215 nil nil nil nil 1056 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' 8 '' 3 170 192 34 2 #container 7680 nil nil nil nil 3 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 5328 1042 #blue 3 false #Warning nil nil nil nil nil nil #Error 8114 21 5328 1042 #red 3 false #Error nil nil nil nil nil nil #Notification 8114 17 5328 1042 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 7714 1027 1042 #darkGoldenrod 1042 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 7714 1031 1042 #firebrick 1042 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7714 1029 nil 1042 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 674 138 144 34 10 738 #createAt:extent: 34 2 786 9 9 786 685 715 5328 738 #contextMenu: 34 1 5472 5328 738 #textLimit: 8 #(1073741823) 5328 738 #hoverTime: 8 #(500) 5328 738 #caretPeriod: 8 #(530) 5328 738 #wordWrap: 8 #(true) 5328 738 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 5328 1 3 nil nil 5 nil 8706 3 5328 1 nil nil 67108863 5 nil 8706 5 5328 1 nil nil nil 5 nil 5328 738 #tabWidth: 8 #(4) 5328 738 #maxCompletionListHeight: 8 #(9) 5328 738 #edgeColumn: 8 #(1) 5328 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 29 4000 170 192 34 4 5328 8 'workspace' 4000 8 'aspects' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3856 34 2 8 1140916738 1 8976 1410 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1472 nil nil 1 nil nil nil 8976 nil 8 1904010400 4418 0 nil 4450 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 9104 7 257 nil 4418 0 nil 4946 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 9168 7 257 nil 1952 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 1 786 701 775 8976 738 #basicSelectionsByIndex: 34 1 8 #(1) 8976 738 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1328 nil 27 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 701 775 3856 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 4000 5328 8976 1328 nil 27 1328 nil 27 170 192 34 2 3296 8 'inspector' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 709 1 786 701 813 2912 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 2992 3296 1328 nil 27 1328 nil 27 170 192 34 2 528 8 'dictionaries' 590342 ##(Smalltalk.Rectangle) 786 21 21 786 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 3839 21 786 1481 931 416 738 #text: 34 1 8 'Pool Dictionaries' 416 738 #updateMenuBar 640 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 99 10 0 0 219 1 0 0] 34 1 528 1328 nil 27 )!

toolsFolderHelpId
	^10550! !
!PoolDictionariesShell class categoriesFor: #defaultModel!public! !
!PoolDictionariesShell class categoriesFor: #displayOn:!public! !
!PoolDictionariesShell class categoriesFor: #icon!constants!public! !
!PoolDictionariesShell class categoriesFor: #initialize!initializing!private! !
!PoolDictionariesShell class categoriesFor: #publishedAspects!public! !
!PoolDictionariesShell class categoriesFor: #resource_Default_view!public!resources-views! !
!PoolDictionariesShell class categoriesFor: #toolsFolderHelpId!private! !


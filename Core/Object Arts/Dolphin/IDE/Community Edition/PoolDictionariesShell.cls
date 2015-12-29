"Filed out from Dolphin Smalltalk X6.2"!

SmalltalkToolShell subclass: #PoolDictionariesShell
	instanceVariableNames: 'dictionariesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolDictionariesShell guid: (GUID fromString: '{558CAC4A-AC5C-43BF-8F8E-247BB36208F5}')!
PoolDictionariesShell comment: ''!
!PoolDictionariesShell categoriesForClass!Development! !
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
	value := entry value notNil ifTrue: [Compiler evaluate: entry value logged: false].
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

	^Dictionary icon!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 544 0 0 0 7 0 0 0 544 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 0 32 234 256 672 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  21 21 834 1409 815 544 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 161 1 0 0] 98 3 410 560 98 15 0 544 98 2 8 1140850688 131073 944 0 0 0 7 0 0 0 944 514 1 1 410 8 ##(Smalltalk.StaticText)  98 16 0 944 98 2 8 1140850945 1 1024 0 786694 ##(Smalltalk.IndexedColor)  33554447 0 7 0 0 0 1024 0 8 4294905555 852486 ##(Smalltalk.NullConverter)  0 0 0 706 202 208 98 2 770 800 98 2 834 1 1 834 699 39 1024 770 8 #text: 98 1 8 'Available Pools


' 1024 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 98 0 834 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 944 98 2 8 1409372236 1 1424 590662 2 ##(Smalltalk.ListModel)  202 208 672 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  0 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #addPool 8 'Add New Pool...' 1 1 0 0 0 1634 1 1666 8 #removePool 8 'Remove Pool...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1634 1 1666 8 #poolPackage 8 'Package...' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 78 97 114 114 111 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 834 193 193 0 1424 0 8 4294905475 459270 ##(Smalltalk.Message)  8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 834 129 129 787526 1 ##(Smalltalk.ImageManager)  234 240 672 234 240 672 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Column 1' 201 8 #left 2018 2048 2064 8 ##(Smalltalk.SortedCollection)  0 0 1424 0 1 0 0 8 #thumbnails 672 834 193 193 131169 834 65 65 98 4 0 32 834 1 1 201 706 202 208 98 3 770 800 98 2 834 1 39 834 699 777 1424 770 8 #contextMenu: 98 1 1600 1424 770 1312 98 1 8 'Column 1' 1424 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 151 1 0 0] 98 0 1408 0 27 234 256 98 2 1424 8 'contents' 0 706 202 208 98 1 770 800 98 2 834 1 1 834 699 815 944 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 151 1 0 0] 98 2 1024 1424 1408 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 544 98 2 8 1140850688 1 2928 0 2210 8 4278190080 0 519 0 0 0 2928 706 202 208 98 1 770 800 98 2 834 699 1 834 11 815 2928 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 151 1 0 0] 98 0 1408 0 27 410 560 98 15 0 544 98 2 8 1140850688 131073 3200 0 0 0 7 0 0 0 3200 514 1 1 410 1040 98 16 0 3200 98 2 8 1140850945 1 3280 0 1120 0 7 0 0 0 3280 0 8 4294905555 1154 0 0 0 706 202 208 98 2 770 800 98 2 834 1 1 834 701 39 3280 770 1312 98 1 8 'Entries' 3280 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 98 0 1408 0 27 0 0 0 410 560 98 15 0 3200 98 2 8 1409286144 131073 3584 0 2210 8 4278190080 0 7 0 0 0 3584 626 202 8 ##(Smalltalk.Dictionary)  98 1 721414 ##(Smalltalk.Association)  410 2944 98 12 0 3584 98 2 8 1140850688 1 3776 0 2210 8 4278190080 0 519 0 0 0 3776 706 202 208 98 1 770 800 98 2 834 1 85 834 731 11 3776 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 98 0 1408 0 27 1 16 234 256 672 0 706 202 208 98 1 770 800 98 2 834 1 39 834 701 777 3584 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 151 1 0 0] 98 2 3776 410 8 ##(Smalltalk.CardContainer)  98 16 0 3584 98 2 8 1409286144 131073 4208 0 0 0 7 0 0 0 4208 655878 ##(Smalltalk.CardLayout)  202 208 98 2 3746 8 ##(Smalltalk.PropertyInspector)  410 8 ##(Smalltalk.ListTreeView)  98 44 0 4208 98 2 8 1140953421 1 4384 1506 202 208 672 0 1568 0 0 15 1586 0 16 98 4 1634 1 1666 8 #addEntry 8 'Add Entry...' 1 1 0 0 0 1634 1 1666 8 #removeEntry 8 'Remove Entry...' 1 1 0 0 0 1794 4097 1634 1 1666 8 #browseEntryReferences 8 'Browse References' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 4384 0 8 4294905475 2018 8 #valueText 98 0 0 2112 0 0 0 0 0 0 202 208 98 3 2290 8 'Key' 319 2336 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 2016 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] 8 #aspectDescriptor 2048 4896 7 257 0 2018 8 #<= 98 0 0 0 4384 0 3 0 0 2290 8 'Value' 319 2336 4882 0 0 4914 2 1 4880 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] 8 #valueTextOnly 5088 7 257 0 2018 5024 5040 0 0 4384 4882 0 0 4914 2 1 4880 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] 8 #valueImage 5200 7 257 0 3 0 0 2290 8 '' 41 8 #center 2018 2048 98 0 2018 5024 5360 0 0 4384 4882 0 0 4914 3 1 4880 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] 4368 8 #editButtonImageIndexFor: 5392 7 257 0 1 0 0 8 #report 672 0 359 834 129 129 98 4 0 32 834 1 1 201 32 1050438 3 ##(Smalltalk.VirtualTreeModel)  0 1568 202 208 672 0 0 4882 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 5552 8 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] 8 #childrenOf: 8 #notEmpty 17 257 5568 4882 0 0 5618 1 83886083 5552 8 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 5712 7 257 0 0 202 8 ##(Smalltalk.PluggableSet)  672 202 5792 672 13 5 0 0 0 0 0 0 0 706 202 208 98 3 770 800 98 2 834 9 9 834 685 721 4384 770 2592 98 1 4496 4384 770 1312 98 1 8 'Key' 4384 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 108 1 0 0] 98 0 1408 0 2021 3746 8 ##(Smalltalk.ValueWorkspace)  410 8 ##(Smalltalk.ScintillaView)  98 50 0 4208 98 2 8 1411453252 1 6096 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 2210 8 4278190080 0 21 1586 0 16 98 17 1634 1 1666 8 #accept 8 '&Accept' 1 1 0 0 0 1794 4097 1586 0 16 98 9 1634 1 1666 8 #undo 8 '&Undo' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'EditUndo.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1794 4097 1634 1 1666 8 #cutSelection 8 'Cu&t' 1 1 6482 0 16 6528 8 'EditCut.ico' 6576 0 0 1634 1 1666 8 #copySelection 8 '&Copy' 1 1 6482 0 16 6528 8 'EditCopy.ico' 6576 0 0 1634 1 1666 8 #pasteClipboard 8 '&Paste' 1 1 6482 0 16 6528 8 'EditPaste.ico' 6576 0 0 1634 1 1666 8 #clearSelection 8 'De&lete' 1 1 6482 0 16 6528 8 'EditClear.ico' 6576 0 0 1634 1 1666 8 #reformatSource 8 'Re&format' 1 1 0 0 0 1794 4097 1634 1 1666 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 1634 1 1666 8 #clear 8 'Clea&r' 1 1 0 0 0 1794 4097 1634 1 1666 8 #browseIt 8 'Bro&wse It' 1 1 6482 0 16 6528 8 'ClassBrowserShell.ico' 6576 0 0 1634 1 1666 8 #displayIt 8 '&Display It' 1 1 6482 0 16 6528 8 'DisplayIt.ico' 6576 0 0 1634 1 1666 8 #evaluateIt 8 'E&valuate It' 1 1 6482 0 16 6528 8 'EvaluateIt.ico' 6576 0 0 1634 1 1666 8 #inspectIt 8 '&Inspect It' 1 1 6482 0 16 6528 8 'InspectIt.ico' 6576 0 0 1634 1 1666 8 #debugIt 8 'Deb&ug It' 1 1 6482 0 16 6528 8 'Debugger.ico' 6576 0 0 1794 4097 1634 1 1666 8 #chooseEvaluationPools 8 '&Pools...' 1 1 6482 0 16 6528 8 'SystemDictionary.ico' 6576 0 0 1634 1 1666 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 1794 4097 1586 0 16 98 2 1634 2097153 1666 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 1634 1 1666 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 1794 4097 1586 0 16 98 9 1634 1 1666 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 1634 1 1666 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 1634 1 1666 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 1634 1 1666 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 1634 1 1666 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 1634 1 1666 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 1634 1 1666 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 1794 4097 1586 0 16 98 2 1634 1 1666 2018 8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 1634 1 1666 2018 8688 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 0 0 0 8 '&Options' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 6096 0 8 4294905173 1154 0 0 9 0 234 256 98 4 8 #callTip 1182726 ##(Smalltalk.ScintillaTextStyle)  77 1106 33554457 1106 33554471 1 0 0 0 0 8960 0 0 0 8 #normal 8978 1 0 0 1 0 0 0 0 9040 0 0 0 98 40 9056 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler)  1 0 0 32 202 208 672 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 1106 33554433 9024 6096 8 #circle 202 208 672 0 63 9215 0 0 0 0 1120 0 0 65 0 0 234 256 98 6 8 #specialCharacter 8 '()[]<>' 8 #literalArray 8 '()' 8 #literalBytes 8 '[]' 8 '' 3 234 256 98 2 8720 8928 0 0 0 0 3 0 234 256 98 6 8 #Notification 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  17 6096 33554437 11 32 9472 0 8 #Error 9490 21 6096 33554459 3 32 9520 0 8 #Warning 9490 19 6096 33554465 3 32 9552 0 0 0 234 256 98 6 9472 8978 1029 0 196934 1 ##(Smalltalk.RGB)  31185883 1 0 0 0 0 9472 0 0 0 9520 8978 1031 9634 335 9634 31317503 1 0 0 0 0 9520 0 0 0 9552 8978 1027 9634 60239 9634 31326207 1 0 0 0 0 9552 0 0 0 0 706 202 208 98 14 770 800 98 2 834 9 9 834 685 721 6096 770 2592 98 1 6272 6096 770 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 6096 770 8 #isTextModified: 98 1 32 6096 770 8 #modificationEventMask: 98 1 9215 6096 770 8 #hoverTime: 98 1 1001 6096 770 8 #secondaryCaretForecolor: 98 1 9634 16711423 6096 770 8 #caretPeriod: 98 1 1061 6096 770 8 #wordWrap: 98 1 16 6096 770 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin)  1 6096 1 3 32 1 5 10354 3 6096 1 1 32 67108863 5 10354 5 6096 1 1 32 1 5 6096 770 8 #indentationGuides: 98 1 0 6096 770 8 #tabIndents: 98 1 16 6096 770 8 #tabWidth: 98 1 9 6096 770 8 #areAdditionalCaretsVisible: 98 1 16 6096 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 108 1 0 0] 98 0 1408 0 29 4384 234 256 98 4 4384 8 'aspects' 6096 8 'workspace' 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 4208 98 2 8 1140916738 1 10720 1506 202 208 98 2 4368 6080 0 1568 0 0 1 0 0 0 10720 0 8 4294904699 4882 0 0 4914 1 83886081 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | nil]' 1782343965 10864 7 257 0 4882 0 0 5618 2 3 2080 8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 10944 7 257 0 2112 0 0 0 0 0 8 #smallIcons 0 0 0 0 0 706 202 208 98 3 770 800 98 2 834 1 1 834 701 777 10720 770 8 #basicSelectionsByIndex: 98 1 98 1 3 10720 770 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 10720 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 132 1 0 0] 98 0 1408 0 27 706 202 208 98 1 770 800 98 2 834 1 1 834 701 777 4208 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 132 1 0 0] 98 3 4384 6096 10720 1408 0 27 1408 0 27 234 256 98 2 3584 8 'inspector' 0 706 202 208 98 1 770 800 98 2 834 709 1 834 701 815 3200 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 151 1 0 0] 98 2 3280 3584 1408 0 27 1408 0 27 234 256 98 2 544 8 'dictionaries' 590342 ##(Smalltalk.Rectangle)  834 21 21 834 21 21 0 0 0 0 1 0 0 0 0 1 0 0 706 202 208 98 3 770 800 98 2 834 3359 21 834 1481 931 416 770 1312 98 1 8 'Pool Dictionaries' 416 770 8 #updateMenuBar 672 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 115 9 0 0 219 1 0 0] 98 1 544 1408 0 27 )!

toolsFolderHelpId
	^10550!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!PoolDictionariesShell class categoriesFor: #defaultModel!public! !
!PoolDictionariesShell class categoriesFor: #displayOn:!public! !
!PoolDictionariesShell class categoriesFor: #icon!constants!public! !
!PoolDictionariesShell class categoriesFor: #initialize!initializing!private! !
!PoolDictionariesShell class categoriesFor: #publishedAspects!development!public! !
!PoolDictionariesShell class categoriesFor: #resource_Default_view!public!resources-views! !
!PoolDictionariesShell class categoriesFor: #toolsFolderHelpId!private! !
!PoolDictionariesShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !


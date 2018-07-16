"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #PoolDictionariesShell
	instanceVariableNames: 'dictionariesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolDictionariesShell guid: (GUID fromString: '{558cac4a-ac5c-43bf-8f8e-247bb36208f5}')!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13369344 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 39 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 640 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 21 21 786 1409 813 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 896 34 2 8 1140850945 1 976 nil 786694 ##(Smalltalk.IndexedColor) 33554447 nil 7 nil nil nil 976 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 699 39 976 738 #text: 34 1 8 'Available Pools' 976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 786 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 896 34 2 8 1409372236 1 1344 590662 2 ##(Smalltalk.ListModel) 138 144 640 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #addPool 8 'Add New Pool...' 1 1 nil nil nil 1586 1 1618 #removePool 8 'Remove Pool...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1586 1 1618 #poolPackage 8 'Package...' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 78 97 114 114 111 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 786 193 193 nil 1344 nil 8 1912800272 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1050182 1 ##(Smalltalk.IconImageManager) nil nil nil 786 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 1922 #displayString 1952 ##(Smalltalk.SortedCollection) nil nil 1344 nil 1 nil nil #thumbnails 640 786 193 193 131169 786 65 65 34 4 nil false 786 1 1 201 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 39 786 699 775 1344 738 #contextMenu: 34 1 1552 1344 738 #text: 34 1 8 'Column 1' 1344 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1328 nil 27 170 192 34 2 1344 8 'contents' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 699 813 896 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 976 1344 1328 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 2624 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2624 nil 1 #left nil nil nil 786 1 1 786 9 9 nil 2720 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 699 1 786 11 813 2624 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1328 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2912 nil nil nil 7 nil nil nil 2912 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 2912 34 2 8 1140850945 1 2992 nil 1056 nil 7 nil nil nil 2992 nil 8 1912674480 1090 nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 701 39 2992 738 #text: 34 1 8 'Entries' 2992 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1328 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2912 34 2 8 1409286144 131073 3296 nil nil nil 7 nil nil nil 3296 594 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 3296 34 2 8 1140850688 1 3440 nil nil nil 519 nil nil nil 2690 3440 nil 1 #left nil nil nil 786 1 1 2736 nil 3520 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 85 786 731 11 3440 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1328 nil 27 1 true 170 192 640 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 39 786 701 775 3296 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 2 3440 410 ##(Smalltalk.CardContainer) 34 16 nil 3296 34 2 8 1409286144 131073 3872 nil nil nil 7 nil nil nil 3872 655878 ##(Smalltalk.CardLayout) 138 144 34 2 3410 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 3872 34 2 8 1140953421 1 4016 1410 138 144 640 nil 1472 1490 1520 nil 15 1538 nil true 34 4 1586 1 1618 #addEntry 8 'Add Entry...' 1 1 nil nil nil 1586 1 1618 #removeEntry 8 'Remove Entry...' 1 1 nil nil nil 1714 4097 1586 1 1618 #browseEntryReferences 8 'Browse References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4016 nil 8 1912800272 1922 #valueText 8 #() nil 1984 nil nil nil nil nil nil 138 144 34 3 2050 8 'Key' 319 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 1920 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4464 7 257 nil 1922 #<= 8 #() nil nil 4016 nil 3 nil nil 2050 8 'Value' 319 #left 4450 0 nil 4482 2 1 4448 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4624 7 257 nil 1922 #<= 4576 nil nil 4016 4450 0 nil 4482 2 1 4448 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 4720 7 257 nil 3 nil nil 2050 8 '' 41 #center 1922 #displayString 8 #() 1922 #<= 4848 nil nil 4016 4450 0 nil 4482 3 1 4448 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 4880 7 257 nil 1 nil nil #report 640 nil 359 786 129 129 34 4 nil false 786 1 1 201 false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1472 138 144 640 nil nil 4450 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 5008 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 5024 4450 0 nil 5074 1 83886083 5008 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 5120 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 640 138 ##(Smalltalk.PluggableSet) 640 13 5 nil nil nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 9 9 786 685 715 4016 738 #contextMenu: 34 1 4128 4016 738 #text: 34 1 8 'Key' 4016 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 2021 3410 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 3872 34 2 8 1411453252 1 5456 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 #smalltalkWorkspace nil 21 1538 nil true 34 17 1586 1 1618 #accept 8 '&Accept' 1 1 nil nil nil 1714 4097 1538 nil true 34 9 1586 1 1618 #undo 8 '&Undo' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditUndo.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1714 4097 1586 1 1618 #cutSelection 8 'Cu&t' 1 1 5778 nil true 5824 8 'EditCut.ico' 5872 nil nil 1586 1 1618 #copySelection 8 '&Copy' 1 1 5778 nil true 5824 8 'EditCopy.ico' 5872 nil nil 1586 1 1618 #pasteClipboard 8 '&Paste' 1 1 5778 nil true 5824 8 'EditPaste.ico' 5872 nil nil 1586 1 1618 #clearSelection 8 'De&lete' 1 1 5778 nil true 5824 8 'EditClear.ico' 5872 nil nil 1586 1 1618 #reformatSource 8 'Re&format' 1 1 nil nil nil 1714 4097 1586 1 1618 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1586 1 1618 #clear 8 'Clea&r' 1 1 nil nil nil 1714 4097 1586 1 1618 #browseIt 8 'Bro&wse It' 1 1 5778 nil true 5824 8 'ClassBrowserShell.ico' 5872 nil nil 1586 1 1618 #displayIt 8 '&Display It' 1 1 5778 nil true 5824 8 'DisplayIt.ico' 5872 nil nil 1586 1 1618 #evaluateIt 8 'E&valuate It' 1 1 5778 nil true 5824 8 'EvaluateIt.ico' 5872 nil nil 1586 1 1618 #inspectIt 8 '&Inspect It' 1 1 5778 nil true 5824 8 'InspectIt.ico' 5872 nil nil 1586 1 1618 #debugIt 8 'Deb&ug It' 1 1 5778 nil true 5824 8 'Debugger.ico' 5872 nil nil 1714 4097 1586 1 1618 #chooseEvaluationPools 8 '&Pools...' 1 1 5778 nil true 5824 8 'SystemDictionary.ico' 5872 nil nil 1586 1 1618 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 1714 4097 1538 nil true 34 2 1586 2097153 1618 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1586 1 1618 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 1714 4097 1538 nil true 34 9 1586 1 1618 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1586 1 1618 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1586 1 1618 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 1586 1 1618 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1586 1 1618 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1586 1 1618 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1586 1 1618 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 1714 4097 1538 nil true 34 2 1586 1 1618 1922 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 1586 1 1618 1922 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5456 nil 8 1893518953 1090 nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7842 77 1042 33554457 1042 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 7856 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 640 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5456 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 640 nil 170 176 640 9215 nil nil nil nil 1056 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 7808 nil nil nil nil 3 nil 170 192 34 6 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 5456 33554465 3 false #Warning nil nil nil nil nil nil #Error 8242 21 5456 33554459 3 false #Error nil nil nil nil nil nil #Notification 8242 17 5456 33554437 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 7842 1027 196934 1 ##(Smalltalk.RGB) 60239 8354 31326207 1 nil nil nil nil #Warning nil nil nil #Error 7842 1031 8354 335 8354 31317503 1 nil nil nil nil #Error nil nil nil #Notification 7842 1029 nil 8354 31185883 1 nil nil nil nil #Notification nil nil nil nil 674 138 144 34 10 738 #createAt:extent: 34 2 786 9 9 786 685 715 5456 738 #contextMenu: 34 1 5600 5456 738 #textLimit: 8 #(1073741823) 5456 738 #modificationEventMask: 8 #(4607) 5456 738 #hoverTime: 8 #(500) 5456 738 #caretPeriod: 8 #(530) 5456 738 #wordWrap: 8 #(true) 5456 738 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5456 1 3 nil nil 5 nil 8834 3 5456 1 nil nil 67108863 5 nil 8834 5 5456 1 nil nil nil 5 nil 5456 738 #tabWidth: 8 #(4) 5456 738 #maxCompletionListHeight: 8 #(9) 5456 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 29 4016 170 192 34 4 4016 8 'aspects' 5456 8 'workspace' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3872 34 2 8 1140916738 1 9072 1410 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1472 nil nil 1 nil nil nil 9072 nil 8 1912616880 4450 0 nil 4482 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 9200 7 257 nil 4450 0 nil 5074 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 9264 7 257 nil 1984 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 1 786 701 775 9072 738 #basicSelectionsByIndex: 34 1 8 #(1) 9072 738 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9072 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1328 nil 27 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 701 775 3872 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 4016 5456 9072 1328 nil 27 1328 nil 27 170 192 34 2 3296 8 'inspector' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 709 1 786 701 813 2912 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 2992 3296 1328 nil 27 1328 nil 27 170 192 34 2 528 8 'dictionaries' 590342 ##(Smalltalk.Rectangle) 786 21 21 786 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 3839 21 786 1481 931 416 738 #text: 34 1 8 'Pool Dictionaries' 416 738 #updateMenuBar 640 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 99 10 0 0 219 1 0 0] 34 1 528 1328 nil 27 )!

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


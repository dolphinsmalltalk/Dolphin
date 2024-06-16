"Filed out from Dolphin Smalltalk"!

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
	self systemModel browseMethodsIn: self methodsReferencingSelectedEntry!

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
	refs := self methodsReferencingSelectedEntry allMethods.
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

!PoolDictionariesShell categoriesForMethods!
addEntry!public! !
addPool!commands!public! !
browseEntryReferences!commands!public! !
classesReferencingSelectedPool!commands!private! !
createComponents!private! !
hasSelectedItemAccessor!public!selection! !
hasSelection!public!selection! !
methodsReferencingSelectedEntry!commands!private! !
model:!public! !
poolPackage!commands!public! !
queryCommand:!commands!private! !
removeEntry!public! !
removePool!commands!public! !
selectedItemAccessorOrNil!commands!private! !
selectedItemKey!commands!private! !
selectionOrNil!private!selection! !
selectionOrNil:!private!selection! !
!

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

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 640 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 193 560 8 '' 528 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 896 34 2 8 1140850945 1 976 nil 327686 ##(Smalltalk.Color) #silver nil 5 nil nil nil 976 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 674 138 144 34 2 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 193 1008 nil 976 738 #text: 34 1 8 'Available Pools' 976 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 896 34 2 8 1409372236 1 1344 590662 2 ##(Smalltalk.ListModel) 138 144 640 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1042 #default nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #addPool 8 'Add New Pool...' 1 1 nil nil nil 1554 1 1586 #removePool 8 'Remove Pool...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1554 1 1586 #poolPackage 8 'Package...' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1344 nil 8 1759068368 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 1314 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 1874 #displayString 1904 1874 #<= 8 #() nil nil 1344 nil 1 nil nil #thumbnails 8 #() 1314 193 193 131169 1314 65 65 1 nil nil 201 nil nil nil nil nil nil nil nil nil nil nil nil 674 138 144 34 2 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 193 1376 8 'Column 1' 1344 738 #contextMenu: 34 1 1520 1344 3 8 #() 1314 193 193 nil 35 170 192 34 2 1344 8 'contents' nil 674 138 144 34 1 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 193 928 8 '' 896 3 34 2 976 1344 1314 193 193 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 2576 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2576 nil 1 #left nil nil nil 1314 1 1 1314 9 9 nil 2672 nil 674 138 144 34 1 738 #createWindow: 34 1 786 818 8 #[93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 193 2608 8 '' 2576 3 8 #() 1314 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2880 nil nil nil 5 nil nil nil 2880 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 2880 34 2 8 1140850945 1 2960 nil 1056 nil 5 nil nil nil 2960 nil 8 1759212608 1090 nil nil nil 674 138 144 34 2 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 193 2992 nil 2960 738 #text: 34 1 8 'Entries' 2960 3 8 #() 1314 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2880 34 2 8 1409286144 131073 3264 nil nil nil 5 nil nil nil 3264 594 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 3264 34 2 8 1140850688 1 3408 nil nil nil 517 nil nil nil 2642 3408 nil 1 #left nil nil nil 2672 2688 nil 2672 nil 674 138 144 34 1 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 193 3440 8 '' 3408 1 8 #() 1314 193 193 nil 27 1 true 170 192 640 nil 674 138 144 34 1 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 193 3296 8 '' 3264 3 34 2 3408 410 ##(Smalltalk.CardContainer) 34 16 nil 3264 34 2 8 1409286144 131073 3840 nil nil nil 5 nil nil nil 3840 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 3378 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 59 nil 3840 34 2 8 1140953421 1 3984 1410 138 144 640 nil 1472 1488 nil 13 1506 nil true 34 4 1554 1 1586 #addEntry 8 'Add Entry...' 1 1 nil nil nil 1554 1 1586 #removeEntry 8 'Remove Entry...' 1 1 nil nil nil 1682 4097 1554 1 1586 #browseEntryReferences 8 'Browse References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3984 nil 8 1759068368 1874 #valueText 8 #() nil 1936 nil nil nil nil nil nil 138 144 34 3 2002 8 'Key' 461 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 1872 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4416 7 257 nil 1874 #<= 8 #() nil nil 3984 nil 3 nil nil 2002 8 'Value' 171 #left 4402 0 nil 4434 2 1 4400 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4576 7 257 nil 1874 #<= 4528 nil nil 3984 nil 1 nil nil 2002 8 '' 41 #center nil 1874 #<= 8 #() nil nil 3984 4402 0 nil 4434 3 1 4400 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 4736 7 257 nil 1 nil nil #report 2096 nil 355 1314 129 129 1 nil nil 201 nil nil nil nil nil nil nil nil nil nil nil nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1472 138 144 640 nil nil 4402 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 4832 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4848 4402 0 nil 4898 1 83886083 4832 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4944 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 640 138 ##(Smalltalk.IdentitySet) 640 1 1 nil nil nil nil nil nil nil 674 138 144 34 2 738 #createWindow: 34 1 786 818 8 #[4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 193 4016 8 'Key' 3984 738 #contextMenu: 34 1 4080 3984 3 8 #() 1314 193 193 nil 2029 3378 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 65 nil 3840 34 2 8 1411453252 1 5248 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 #smalltalkWorkspace nil 21 1506 nil true 34 13 1554 1 1586 #accept 8 '&Accept' 1 1 nil nil nil 1682 4097 1506 nil true 34 10 1554 1 1586 #undo 8 '&Undo' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditUndo.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1682 4097 1554 1 1586 #cutSelection 8 'Cu&t' 1 1 5570 nil true 5616 8 'EditCut.ico' 5664 nil nil 1554 1 1586 #copySelection 8 '&Copy' 1 1 5570 nil true 5616 8 'EditCopy.ico' 5664 nil nil 1554 1 1586 #pasteClipboard 8 '&Paste' 1 1 5570 nil true 5616 8 'EditPaste.ico' 5664 nil nil 1554 1 1586 #clearSelection 8 'De&lete' 1 1 5570 nil true 5616 8 'EditClear.ico' 5664 nil nil 1682 4097 1554 1 1586 #reformatSource 8 'Re&format' 1 1 nil nil nil 1682 4097 1554 1 1586 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1506 nil true 34 10 1554 1 1586 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1554 1 1586 #cloneNew 8 '&Clone' 1 1 5570 nil true 5616 8 'SmalltalkWorkspace.ico' 5664 nil nil 1682 4097 1554 1 1586 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1554 1 1586 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1554 1 1586 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1554 1 1586 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1554 1 1586 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1554 1 1586 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1554 1 1586 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1682 4097 1554 1 1586 #browseIt 8 'Bro&wse It' 1 1 5570 nil true 5616 8 'ClassBrowserShell.ico' 5664 nil nil 1554 1 1586 #displayIt 8 '&Display It' 1 1 5570 nil true 5616 8 'DisplayIt.ico' 5664 nil nil 1554 1 1586 #printIt 8 '&Print It' 1 1 5570 nil true 5616 8 'PrintIt.ico' 5664 nil nil 1554 1 1586 #evaluateIt 8 'E&valuate It' 1 1 5570 nil true 5616 8 'EvaluateIt.ico' 5664 nil nil 1554 1 1586 #inspectIt 8 '&Inspect It' 1 1 5570 nil true 5616 8 'InspectIt.ico' 5664 nil nil 1554 1 1586 #debugIt 8 'Deb&ug It' 1 1 5570 nil true 5616 8 'Debugger.ico' 5664 nil nil 1682 4097 1506 nil true 34 2 1554 2097153 1586 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1554 1 1586 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5248 nil 8 1504001512 1090 nil nil 9 68802481 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 1042 #gray 1042 #white 1 nil nil nil nil #callTip nil nil nil #normal 7490 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 640 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5248 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 640 nil 170 176 640 9215 nil nil nil nil 1056 nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 7456 nil nil nil nil 16 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 5248 1042 #blue 3 false #Warning nil nil nil nil nil nil #Error 7874 21 5248 1042 #red 3 false #Error nil nil nil nil nil nil #Notification 7874 17 5248 1042 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 7490 1027 1042 #darkGoldenrod 1042 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 7490 1031 1042 #firebrick 1042 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7490 1029 nil 1042 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 674 138 144 34 10 738 #createWindow: 34 1 786 818 8 #[4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 193 5280 nil 5248 738 #contextMenu: 34 1 5392 5248 738 #hoverTime: 8 #(500) 5248 738 #caretPeriod: 8 #(530) 5248 738 #wordWrap: 8 #(true) 5248 738 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 5248 1 3 nil nil 5 nil 8450 3 5248 1 nil nil 67108863 5 nil 8450 5 5248 1 nil nil nil 5 nil 5248 738 #tabWidth: 8 #(4) 5248 738 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 5248 738 #maxCompletionListHeight: 8 #(9) 5248 738 #edgeColumn: 8 #(1) 5248 1 8 #() 1314 193 193 nil 33 3984 nil nil nil 170 192 34 4 3984 8 'aspects' 5248 8 'workspace' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3840 34 2 8 1140916738 1 8768 1410 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1472 nil nil 1 nil nil nil 8768 nil 8 1758664336 4402 0 nil 4434 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 8896 7 257 nil 4402 0 nil 4898 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 8960 7 257 nil 1936 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 138 144 34 3 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 193 8800 8 '' 8768 738 #setSingleSelection: 8 #(1) 8768 738 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8768 3 8 #() 1314 193 193 nil 27 674 138 144 34 1 738 #createWindow: 34 1 786 818 8 #[0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 193 3872 8 '' 3840 3 34 3 3984 5248 8768 1314 193 193 nil 27 1314 193 193 nil 27 170 192 34 2 3264 8 'inspector' nil 674 138 144 34 1 738 #createWindow: 34 1 786 818 8 #[98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 193 2912 8 '' 2880 3 34 2 2960 3264 1314 193 193 nil 27 1314 193 193 nil 27 170 192 34 2 528 8 'dictionaries' 590342 ##(Smalltalk.Rectangle) 1314 21 21 1314 21 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 674 138 144 34 1 738 #createWindow: 34 1 786 9730 1314 1 1 1314 1481 931 193 448 8 'Pool Dictionaries' 416 1 34 1 528 1314 193 193 nil 27 )!

toolsFolderHelpId
	^10550! !

!PoolDictionariesShell class categoriesForMethods!
defaultModel!public! !
displayOn:!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!private! !
!


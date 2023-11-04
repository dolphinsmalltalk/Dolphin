"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.NamespacesShell'
	instanceVariableNames: 'dictionariesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.NamespacesShell guid: (Core.GUID fromString: '{558cac4a-ac5c-43bf-8f8e-247bb36208f5}')!
Tools.NamespacesShell comment: ''!
!Tools.NamespacesShell categoriesForClass!MVP-Presenters! !
!Tools.NamespacesShell methodsFor!

addVariable
	"Prompt for a variable to add to the selected Namespace."

	| entry namespace |
	namespace := self selectionOrNil.
	entry := (KeyValuePrompter
				createOn: VariableBinding new
				prompt: 'Enter key string and value expression:'
				caption: 'Add Variable to <1p>...' << namespace) showModal.
	entry ifNil: [^self].
	entry key: entry key asString.
	entry value: (entry ifNotNil: [:value | Compiler evaluate: value]).
	entry isClassVariable: true.
	namespace add: entry.
	dictionariesPresenter inspectorPresenter refresh!

browseEntryReferences
	self developmentSystem browseMethodsIn: (self selectedBinding
				ifNil: [self searchEnvironment forMethods: #()]
				ifNotNil: [:var | self searchEnvironment referencesToVariable: var])!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	dictionariesPresenter := self add: TwinLevelInspector new name: 'dictionaries'!

hasSelectedItemAccessor
	^self selectedItemAccessorOrNil notNil!

hasSelection
	^self selectionOrNil notNil!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	dictionariesPresenter model: aListModelOfObjects!

namespacePackage
	"Prompt for the user to repackage the selected pool."

	| namespace newPkg oldPkg |
	namespace := self selectionOrNil.
	oldPkg := namespace owningPackage.
	newPkg := PackagePrompter
				showModalOn: oldPkg asValue
				caption: 'Package of <1p>…' << namespace
				default: nil
				validationBlock: [:package | package notNil and: [namespace environment includesKey: namespace name]].
	(newPkg isNil or: [newPkg = oldPkg]) ifTrue: [^self].
	Package manager addVariableNamed: namespace fullyQualifiedReference to: newPkg!

newClass
	| selection |
	selection := self selectionOrNil.
	(self developmentSystem createSubclassOf: selection ?? SharedPool
		inPackage: (selection ifNotNil: [selection owningPackage]))
			ifNotNil: [:newClass | self selectionOrNil: newClass]!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into aCommandQuery"

	| symbol selection |
	super queryCommand: aCommandQuery.
	symbol := aCommandQuery command.
	selection := self selectionOrNil.
	(#(#removeNamespace #namespacePackage #addVariable) identityIncludes: symbol)
		ifTrue: 
			[aCommandQuery isEnabled: selection notNil.
			^true].
	(#(#removeVariable #browseEntryReferences) identityIncludes: symbol)
		ifTrue: 
			[aCommandQuery isEnabled: self hasSelectedItemAccessor.
			^true].
	#toggleConstant == symbol
		ifTrue: 
			[self selectedBinding
				ifNil: 
					[aCommandQuery
						isEnabled: false;
						isChecked: false]
				ifNotNil: 
					[:var |
					aCommandQuery
						isEnabled: var isClassBinding not;
						isChecked: var isImmutable].
			^true].
	^false!

removeNamespace
	| pool |
	pool := self selectionOrNil.
	pool ifNil: [^self].
	self developmentSystem removeClasses: {pool}!

removeVariable
	| var |
	var := self selectedBinding.
	var ifNil: [^self].
	var isClassBinding
		ifTrue: [self developmentSystem removeClasses: {var value}]
		ifFalse: 
			[self developmentSystem removeStaticVariables: {var environment -> var key} within: self searchEnvironment].
	dictionariesPresenter inspectorPresenter refresh!

searchEnvironment
	^self developmentSystem browserEnvironment!

selectedBinding
	^self selectedItemAccessorOrNil
		ifNotNil: [:accessor | self selectionOrNil bindingFor: accessor aspectDescriptor key]!

selectedItemAccessorOrNil
	^dictionariesPresenter aspectAccessor!

selectedItemKey
	^self selectedItemAccessorOrNil aspectDescriptor key.
!

selectionOrNil
	^dictionariesPresenter selectionOrNil!

selectionOrNil: aPoolConstantsDictionary
	dictionariesPresenter selectionOrNil: aPoolConstantsDictionary!

toggleConstant
	self selectedBinding
		ifNotNil: 
			[:var |
			var isImmutable
				ifTrue: [var environment addClassVariable: var key value: var value]
				ifFalse: [var environment addClassConstant: var key value: var value]]! !
!Tools.NamespacesShell categoriesForMethods!
addVariable!public! !
browseEntryReferences!commands!public! !
createComponents!private! !
hasSelectedItemAccessor!public!selection! !
hasSelection!public!selection! !
model:!public! !
namespacePackage!commands!public! !
newClass!commands!public! !
queryCommand:!commands!private! !
removeNamespace!commands!public! !
removeVariable!public! !
searchEnvironment!commands!private! !
selectedBinding!private!selection! !
selectedItemAccessorOrNil!private!selection! !
selectedItemKey!private!selection! !
selectionOrNil!private!selection! !
selectionOrNil:!private!selection! !
toggleConstant!public! !
!

!Tools.NamespacesShell class methodsFor!

defaultModel
	^ListModel
		on: (SmalltalkSystem current availableNamespaces asSortedCollection: [:x :y | x name <= y name])!

defaultOptionFlags
	^##(ReuseIfOpenMask | CanUseIdeaSpaceMask)!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Namespaces'!

icon
	"Answers an Icon that can be used to represent this class"

	^Namespace icon!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 160 nil nil nil 5 nil nil nil 160 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 21 21 418 1409 813 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 130 1 1 18 #{UI.StaticText} 50 16 nil 528 50 2 8 1140850945 1 608 nil 6 #{Graphics.Color} #silver nil 5 nil nil nil 608 nil nil 518 #{UI.NullConverter} nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 1 418 699 39 608 370 #text: 50 1 8 'Namespace' 608 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 418 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 528 50 2 8 1409372236 1 944 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 674 #default nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #newClass 8 '&New…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1170 1 1202 #removeNamespace 8 'Re&move' 1 1 1250 nil true 1282 8 'ClassDelete.ico' 1344 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1170 1 1202 #namespacePackage 8 'Package…' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 418 193 193 nil 944 nil nil 518 #{Core.Message} #displayString 8 #() 1666 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 418 129 129 nil nil 1042 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 1666 #displayString 1696 1666 #<= 8 #() nil nil 944 nil 1 nil nil #thumbnails 8 #() 418 193 193 131169 418 65 65 1 nil nil 201 nil 1 nil nil nil nil nil nil nil nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 39 418 699 775 944 370 #text: 50 1 8 'Column 1' 944 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 928 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} 288 50 2 944 8 'contents' nil 322 50 1 370 #createAt:extent: 50 2 418 1 1 418 699 813 528 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 50 2 608 944 928 nil 27 18 #{UI.Splitter} 50 12 nil 160 50 2 8 1140850688 1 2352 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2352 nil 1 #left nil nil nil 418 1 1 418 9 9 nil 2448 nil 322 50 1 370 #createAt:extent: 50 2 418 699 1 418 11 813 2352 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 928 nil 27 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 2624 nil nil nil 5 nil nil nil 2624 130 1 1 18 #{UI.StaticText} 50 16 nil 2624 50 2 8 1140850945 1 2704 nil 688 nil 5 nil nil nil 2704 nil nil 706 nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 1 418 701 39 2704 370 #text: 50 1 8 'Entries' 2704 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 928 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 2624 50 2 8 1409286144 131073 2976 nil nil nil 5 nil nil nil 2976 226 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 2976 50 2 8 1140850688 1 3136 nil nil nil 517 nil nil nil 2418 3136 nil 1 #left nil nil nil 2448 2464 nil 2448 nil 322 50 1 370 #createAt:extent: 50 2 418 1 85 418 731 11 3136 466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 928 nil 27 1 true 290 0 nil 322 50 1 370 #createAt:extent: 50 2 418 1 39 418 701 775 2976 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 50 2 3136 18 #{UI.CardContainer} 50 16 nil 2976 50 2 8 1409286144 131073 3520 nil nil nil 5 nil nil nil 3520 1350 1 #{UI.CardLayout} 1042 2 3106 #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 3520 50 2 8 1140953421 1 3648 1010 1042 0 nil 1088 1104 nil 13 1122 nil true 50 6 1170 1 1202 #addVariable 8 '&Add…' 1 1 1250 nil true 1282 8 'NewThing.ico' 1344 65541 nil nil nil 1170 1 1202 #removeVariable 8 '&Remove' 1 1 1250 nil true 1282 8 'EditClear.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #toggleConstant 8 '&Constant' 1 1 nil nil nil 1474 4097 1170 1 1202 #browseEntryReferences 8 'Browse References' 1 9 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3648 nil nil 1666 #valueText 8 #() nil 1760 nil nil nil nil nil nil 1042 3 1810 8 'Key' 461 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 1664 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4208 7 257 nil 1666 #<= 8 #() nil nil 3648 nil 3 nil nil 1810 8 'Value' 171 #left 4194 0 nil 4226 2 1 4192 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4368 7 257 nil 1666 #<= 4320 nil nil 3648 nil 1 nil nil 1810 8 '' 41 #center nil 1666 #<= 8 #() nil nil 3648 4194 0 nil 4226 3 1 4192 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 4528 7 257 nil 1 nil nil #report 1904 nil 355 418 129 129 1 nil nil 201 nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 1088 1042 0 nil nil 4194 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4656 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4672 4194 0 nil 4722 1 83886083 4656 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4768 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 1 1 nil nil nil nil nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 9 9 418 685 715 3648 370 #text: 50 1 8 'Key' 3648 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 928 nil 2029 3106 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 3520 50 2 8 1411453252 1 5088 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 98 #smalltalkWorkspace nil 21 1122 nil true 50 13 1170 1 1202 #accept 8 '&Accept' 1 1 nil nil nil 1474 4097 1122 nil true 50 10 1170 1 1202 #undo 8 '&Undo' 1 1 1250 nil true 1282 8 'EditUndo.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #cutSelection 8 'Cu&t' 1 1 1250 nil true 1282 8 'EditCut.ico' 1344 65541 nil nil nil 1170 1 1202 #copySelection 8 '&Copy' 1 1 1250 nil true 1282 8 'EditCopy.ico' 1344 65541 nil nil nil 1170 1 1202 #pasteClipboard 8 '&Paste' 1 1 1250 nil true 1282 8 'EditPaste.ico' 1344 65541 nil nil nil 1170 1 1202 #clearSelection 8 'De&lete' 1 1 1250 nil true 1282 8 'EditClear.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #reformatSource 8 'Re&format' 1 1 nil nil nil 1474 4097 1170 1 1202 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1122 nil true 50 10 1170 1 1202 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1170 1 1202 #cloneNew 8 '&Clone' 1 1 1250 nil true 1282 8 'SmalltalkWorkspace.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1170 1 1202 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1170 1 1202 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1170 1 1202 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1170 1 1202 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1170 1 1202 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1170 1 1202 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1474 4097 1170 1 1202 #browseIt 8 'Bro&wse It' 1 1 1250 nil true 1282 8 'ClassBrowserShell.ico' 1344 65541 nil nil nil 1170 1 1202 #displayIt 8 '&Display It' 1 1 1250 nil true 1282 8 'DisplayIt.ico' 1344 65541 nil nil nil 1170 1 1202 #printIt 8 '&Print It' 1 1 1250 nil true 1282 8 'PrintIt.ico' 1344 65541 nil nil nil 1170 1 1202 #evaluateIt 8 'E&valuate It' 1 1 1250 nil true 1282 8 'EvaluateIt.ico' 1344 65541 nil nil nil 1170 1 1202 #inspectIt 8 '&Inspect It' 1 1 1250 nil true 1282 8 'InspectIt.ico' 1344 65541 nil nil nil 1170 1 1202 #debugIt 8 'Deb&ug It' 1 1 1250 nil true 1282 8 'Debugger.ico' 1344 65541 nil nil nil 1474 4097 1122 nil true 50 2 1170 2097153 1202 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1170 1 1202 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5088 nil nil 706 nil nil 9 #focusLost nil nil nil nil 290 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 674 #gray 674 #white 1 nil nil nil nil #callTip nil nil nil #normal 7394 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 1042 0 290 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 5088 #circle nil nil nil nil nil nil 4850 0 nil 258 0 9215 nil nil 258 1 81 674 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 290 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 290 1 #container 7376 nil nil nil nil #{Core.AnsiString} nil 290 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 5088 674 #red 3 3 #Error nil nil nil nil nil nil #Notification 7762 17 5088 674 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 7762 19 5088 674 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 290 3 #Error 7394 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7394 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7394 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 322 50 8 370 #createAt:extent: 50 2 418 9 9 418 685 715 5088 370 #sciSetMouseDwellTime: 8 #(500) 5088 370 #wordWrap: 8 #(true) 5088 370 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 5088 nil 3 nil nil 5 nil 8226 3 5088 nil nil nil 67108863 5 nil 8226 5 5088 nil nil nil nil 5 nil 5088 370 #tabWidth: 8 #(4) 5088 370 #maxCompletionListHeight: 8 #(9) 5088 370 #sciSetTechnology: 8 #(1) 5088 370 #sciSetSelectionLayer: 8 #(1) 5088 466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 928 nil 45 3648 nil nil nil 2146 288 50 4 3648 8 'aspects' 5088 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 3520 50 2 8 1140916738 1 8528 1010 1042 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 1088 nil nil 1 nil nil nil 8528 nil nil 4194 0 nil 4226 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 8624 7 257 nil 1712 1760 nil nil nil nil nil #smallIcons nil nil nil nil nil 322 50 3 370 #createAt:extent: 50 2 418 1 1 418 701 775 8528 370 #setSingleSelection: 8 #(1) 8528 370 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8528 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 928 nil 27 322 50 1 370 #createAt:extent: 50 2 418 1 1 418 701 775 3520 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 50 3 3648 5088 8528 928 nil 27 928 nil 27 2146 288 50 2 2976 8 'inspector' nil 322 50 1 370 #createAt:extent: 50 2 418 709 1 418 701 813 2624 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 50 2 2704 2976 928 nil 27 928 nil 27 2146 288 50 2 160 8 'dictionaries' 518 #{Graphics.Rectangle} 418 21 21 418 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 322 50 2 370 #createAt:extent: 50 2 418 6143 21 418 1481 931 32 370 #text: 50 1 8 'Namespaces' 32 466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 14 0 0 219 1 0 0] 50 1 160 928 nil 27)!

toolsFolderHelpId
	^10550! !
!Tools.NamespacesShell class categoriesForMethods!
defaultModel!public! !
defaultOptionFlags!constants!options!private! !
displayOn:!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!constants!private! !
!


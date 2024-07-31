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

	<commandQuery: #hasSelection>
	| entry namespace prompter |
	namespace := self selectionOrNil.
	prompter := KeyValuePrompter
				createOn: (VariableBinding key: '' value: nil)
				prompt: 'Enter key string and value expression:'
				caption: 'Add Variable to <p>...' << namespace.
	prompter validater: 
			[:var |
			| name result |
			name := var key.
			result := ValidationResult new.
			result
				caption: 'Invalid Name';
				presenter: prompter keyPresenter.
			(Scanner isStaticVariable: name)
				ifFalse: [result errorMessage: '<p> is not a valid static variable name' << name]
				ifTrue: 
					[(namespace hierarchyDefinesVariable: name)
						ifTrue: 
							[result errorMessage: '<d> or one of its subclasses already defines variable <p>'
										<< { namespace unqualifiedName. name }]
						ifFalse: 
							["Proposed name is valid, now check the expression"
							[(Parser parseExpression: var value in: namespace) analyze] on: CompilerErrorNotification
								do: 
									[:err |
									result
										errorMessage: err errorMessage;
										caption: 'Parse Error';
										presenter: prompter valuePresenter]]].
			result].
	entry := prompter showModal.
	entry ifNil: [^self].
	entry value: (entry value ifNotNil: [:value | Compiler evaluate: value]).
	entry isClassVariable: true.
	namespace add: entry.
	dictionariesPresenter inspectorPresenter refresh!

browseEntryReferences
	<commandQuery: #hasSelectedItemAccessor>
	self developmentSystem browseMethodsIn: (self selectedBinding
				ifNil: [self searchEnvironment forMethods: #()]
				ifNotNil: [:var | self searchEnvironment referencesToVariable: var])!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	dictionariesPresenter := self add: TwinLevelInspector new name: 'dictionaries'!

hasDefinedSelection
	| namespace |
	namespace := self selectionOrNil.
	^namespace notNil and: [namespace fullyQualifiedReference isDefined]!

hasSelectedItemAccessor
	^self selectedItemAccessorOrNil notNil!

hasSelection
	^self selectionOrNil notNil!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	dictionariesPresenter model: aListModelOfObjects!

namespacePackage
	"Prompt for the user to repackage the selected pool."

	<commandQuery: #hasDefinedSelection>
	| namespace newPkg oldPkg |
	namespace := self selectionOrNil.
	oldPkg := namespace owningPackage.
	newPkg := PackagePrompter
				showModalOn: oldPkg asValue
				caption: 'Package of <1p>…' << namespace
				default: nil.
	(newPkg isNil or: [newPkg = oldPkg]) ifTrue: [^self].
	Package manager addVariableNamed: namespace fullyQualifiedReference to: newPkg!

newClass
	| selection |
	selection := self selectionOrNil.
	(self developmentSystem createSubclassOf: selection ?? SharedPool
		inPackage: (selection ifNotNil: [selection owningPackage]))
			ifNotNil: [:newClass | self selectionOrNil: newClass]!

queryToggleConstant: aCommandQuery
	self selectedBinding
		ifNil: 
			[aCommandQuery
				beDisabled;
				isChecked: false]
		ifNotNil: 
			[:var |
			aCommandQuery
				isEnabled: var isClassBinding not;
				isChecked: var isImmutable]!

removeNamespace
	<commandQuery: #hasSelection>
	self developmentSystem removeClasses: { self selectionOrNil }!

removeVariable
	<commandQuery: #hasSelectedItemAccessor>
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
	<commandQuery: #queryToggleConstant:>
	self selectedBinding
		ifNotNil: 
			[:var |
			var isImmutable
				ifTrue: [var environment addClassVariable: var key value: var value]
				ifFalse: [var environment addClassConstant: var key value: var value]]! !

!Tools.NamespacesShell categoriesForMethods!
addVariable!public! !
browseEntryReferences!commands-actions!public! !
createComponents!private! !
hasDefinedSelection!public!selection! !
hasSelectedItemAccessor!public!selection! !
hasSelection!public!selection! !
model:!public! !
namespacePackage!commands-actions!public! !
newClass!commands-actions!public! !
queryToggleConstant:!commands-queries!private! !
removeNamespace!commands-actions!public! !
removeVariable!public! !
searchEnvironment!accessing!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 160 nil nil nil 5 nil nil nil 160 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 193 192 8 '' 160 3 50 3 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 130 1 1 18 #{UI.StaticText} 50 16 nil 528 50 2 8 1140850945 1 608 nil 6 #{Graphics.Color} #silver nil 5 nil nil nil 608 nil nil 518 #{UI.NullConverter} nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 193 640 nil 608 370 #text: 50 1 8 'Namespace' 608 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 528 50 2 8 1409372236 1 944 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 674 #default nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #newClass 8 '&New…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1170 1 1202 #removeNamespace 8 'Re&move' 1 1 1250 nil true 1282 8 'ClassDelete.ico' 1344 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1170 1 1202 #namespacePackage 8 'Package…' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 944 nil nil 518 #{Core.Message} #displayString 8 #() 1650 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 914 129 129 nil nil 1042 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 1650 #displayString 1680 1650 #<= 8 #() nil nil 944 nil 1 nil nil #thumbnails 8 #() 914 193 193 131169 914 65 65 1 nil nil 201 nil 1 262 #{UI.ListViewVirtualUpdateMode} 944 nil nil nil nil nil nil nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 193 976 8 'Column 1' 944 370 #contextMenu: 50 1 1136 944 3 8 #() 914 193 193 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} 288 50 2 944 8 'contents' nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 193 560 8 '' 528 3 50 2 608 944 914 193 193 nil 27 18 #{UI.Splitter} 50 12 nil 160 50 2 8 1140850688 1 2384 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2384 nil 1 #left nil nil nil 914 1 1 914 9 9 nil 2480 nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 193 2416 8 '' 2384 3 8 #() 914 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 2672 nil nil nil 5 nil nil nil 2672 130 1 1 18 #{UI.StaticText} 50 16 nil 2672 50 2 8 1140850945 1 2752 nil 688 nil 5 nil nil nil 2752 nil nil 706 nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 193 2784 nil 2752 370 #text: 50 1 8 'Entries' 2752 3 8 #() 914 193 193 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 2672 50 2 8 1409286144 131073 3024 nil nil nil 5 nil nil nil 3024 226 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 3024 50 2 8 1140850688 1 3184 nil nil nil 517 nil nil nil 2450 3184 nil 1 #left nil nil nil 2480 2496 nil 2480 nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 193 3216 8 '' 3184 1 8 #() 914 193 193 nil 27 1 true 290 0 nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 193 3056 8 '' 3024 3 50 2 3184 18 #{UI.CardContainer} 50 16 nil 3024 50 2 8 1409286144 131073 3584 nil nil nil 5 nil nil nil 3584 1350 1 #{UI.CardLayout} 1042 2 3154 #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 3584 50 2 8 1140953421 1 3712 1010 1042 0 nil 1088 1104 nil 13 1122 nil true 50 6 1170 1 1202 #addVariable 8 '&Add…' 1 1 1250 nil true 1282 8 'NewThing.ico' 1344 65541 nil nil nil 1170 1 1202 #removeVariable 8 '&Remove' 1 1 1250 nil true 1282 8 'EditClear.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #toggleConstant 8 '&Constant' 1 1 nil nil nil 1474 4097 1170 1 1202 #browseEntryReferences 8 'Browse References' 1 9 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3712 nil nil 1650 #valueText 8 #() nil 1744 nil nil nil nil nil nil 1042 3 1794 8 'Key' 475 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 1648 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4272 7 257 nil 1650 #<= 8 #() nil nil 3712 nil 3 nil nil 1794 8 'Value' 171 #left 4258 0 nil 4290 2 1 4256 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4432 7 257 nil 1650 #<= 4384 nil nil 3712 nil 1 nil nil 1794 8 '' 41 #center nil 1650 #<= 8 #() nil nil 3712 4258 0 nil 4290 3 1 4256 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 4592 7 257 nil 1 nil nil #report 1888 nil 355 914 129 129 1 nil nil 201 nil 1 1938 3712 nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 1088 1042 0 nil nil 4258 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4736 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4752 4258 0 nil 4802 1 83886083 4736 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4848 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 1 1 nil nil nil nil nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[4 0 0 0 4 0 0 0 90 1 0 0 107 1 0 0] 193 3744 8 'Key' 3712 370 #contextMenu: 50 1 3808 3712 3 8 #() 914 193 193 nil 2029 3154 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 3584 50 2 8 1411453252 1 5168 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 98 #smalltalkWorkspace nil 21 1122 nil true 50 13 1170 1 1202 #accept 8 '&Accept' 1 1 nil nil nil 1474 4097 1122 nil true 50 10 1170 1 1202 #undo 8 '&Undo' 1 1 1250 nil true 1282 8 'EditUndo.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #cutSelection 8 'Cu&t' 1 1 1250 nil true 1282 8 'EditCut.ico' 1344 65541 nil nil nil 1170 1 1202 #copySelection 8 '&Copy' 1 1 1250 nil true 1282 8 'EditCopy.ico' 1344 65541 nil nil nil 1170 1 1202 #pasteClipboard 8 '&Paste' 1 1 1250 nil true 1282 8 'EditPaste.ico' 1344 65541 nil nil nil 1170 1 1202 #clearSelection 8 'De&lete' 1 1 1250 nil true 1282 8 'EditClear.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #reformatSource 8 'Re&format' 1 1 nil nil nil 1474 4097 1170 1 1202 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1122 nil true 50 10 1170 1 1202 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1170 1 1202 #cloneNew 8 '&Clone' 1 1 1250 nil true 1282 8 'SmalltalkWorkspace.ico' 1344 65541 nil nil nil 1474 4097 1170 1 1202 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1170 1 1202 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1170 1 1202 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1170 1 1202 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1170 1 1202 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1170 1 1202 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1170 1 1202 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1474 4097 1170 1 1202 #browseIt 8 'Bro&wse It' 1 1 1250 nil true 1282 8 'ClassBrowserShell.ico' 1344 65541 nil nil nil 1170 1 1202 #displayIt 8 '&Display It' 1 1 1250 nil true 1282 8 'DisplayIt.ico' 1344 65541 nil nil nil 1170 1 1202 #printIt 8 '&Print It' 1 1 1250 nil true 1282 8 'PrintIt.ico' 1344 65541 nil nil nil 1170 1 1202 #evaluateIt 8 'E&valuate It' 1 1 1250 nil true 1282 8 'EvaluateIt.ico' 1344 65541 nil nil nil 1170 1 1202 #inspectIt 8 '&Inspect It' 1 1 1250 nil true 1282 8 'InspectIt.ico' 1344 65541 nil nil nil 1170 1 1202 #debugIt 8 'Deb&ug It' 1 1 1250 nil true 1282 8 'Debugger.ico' 1344 65541 nil nil nil 1474 4097 1122 nil true 50 2 1170 2097153 1202 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1170 1 1202 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5168 nil nil 706 nil nil 9 #focusLost nil nil nil nil 290 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 674 #gray 674 #white 1 nil nil nil nil #callTip nil nil nil #normal 7474 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 1042 0 290 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 5168 #circle nil nil nil nil nil nil 4930 0 nil 258 0 9215 nil nil 258 1 81 674 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 290 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 290 1 #container 7456 nil nil nil nil #{Core.AnsiString} nil 290 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 5168 674 #red 3 3 #Error nil nil nil nil nil nil #Notification 7842 17 5168 674 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 7842 19 5168 674 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 290 3 #Error 7474 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7474 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7474 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 322 50 9 370 #createWindow: 50 1 418 450 8 #[4 0 0 0 4 0 0 0 90 1 0 0 107 1 0 0] 193 5200 nil 5168 370 #contextMenu: 50 1 5312 5168 370 #sciSetMouseDwellTime: 8 #(500) 5168 370 #wordWrap: 8 #(true) 5168 370 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 5168 nil 3 nil nil 5 nil 8354 3 5168 nil nil nil 67108863 5 nil 8354 5 5168 nil nil nil nil 5 nil 5168 370 #tabWidth: 8 #(4) 5168 370 #maxCompletionListHeight: 8 #(9) 5168 370 #sciSetTechnology: 8 #(1) 5168 370 #sciSetSelectionLayer: 8 #(1) 5168 1 8 #() 914 193 193 nil 45 3712 nil nil nil 2162 288 50 4 3712 8 'aspects' 5168 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 3584 50 2 8 1140916738 1 8640 1010 1042 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 1088 nil nil 1 nil nil nil 8640 nil nil 4258 0 nil 4290 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 8736 7 257 nil 1696 1744 nil nil nil nil nil #smallIcons nil nil nil nil nil 322 50 3 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 193 8672 8 '' 8640 370 #setSingleSelection: 8 #(1) 8640 370 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8640 3 8 #() 914 193 193 nil 27 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 193 3616 8 '' 3584 3 50 3 3712 5168 8640 914 193 193 nil 27 914 193 193 nil 27 2162 288 50 2 3024 8 'inspector' nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 193 2704 8 '' 2672 3 50 2 2752 3024 914 193 193 nil 27 914 193 193 nil 27 2162 288 50 2 160 8 'dictionaries' 518 #{Graphics.Rectangle} 914 21 21 914 21 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 322 50 1 370 #createWindow: 50 1 418 9474 914 7679 21 914 9159 951 193 80 8 'Namespaces' 32 1 50 1 160 914 193 193 nil 27)!

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


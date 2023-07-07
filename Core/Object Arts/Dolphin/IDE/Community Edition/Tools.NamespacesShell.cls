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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 39 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376774 #{UI.ProportionalLayout} 170 176 8 #() false 170 192 640 nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 21 21 770 1409 813 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 880 nil nil nil 7 nil nil nil 880 498 1 1 410 #{UI.StaticText} 34 16 nil 880 34 2 8 1140850945 1 960 nil 917510 #{Graphics.Color} #silver nil 7 nil nil nil 960 nil 8 1831350160 1049094 #{UI.NullConverter} nil nil nil 674 34 2 722 #createAt:extent: 34 2 770 1 1 770 699 39 960 722 #text: 34 1 8 'Namespace' 960 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 770 193 193 nil 27 nil nil nil 410 #{UI.ListView} 34 45 nil 880 34 2 8 1409372236 1 1312 787270 2 #{UI.ListModel} 138 144 640 nil 1769478 #{Kernel.IdentitySearchPolicy} 1026 #default nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #newClass 8 '&New…' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'NewClass.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 1522 1 1554 #removeNamespace 8 'Re&move' 1 1 1602 nil true 1634 8 'ClassDelete.ico' 1696 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 1522 1 1554 #namespacePackage 8 'Package…' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 78 97 114 114 111 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 770 193 193 nil 1312 nil 8 1831221392 786950 #{Core.Message} #displayString 8 #() 2034 #iconImageIndex 8 #() 1639750 1 #{Graphics.IconImageManager} nil nil nil 770 129 129 nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 2034 #displayString 2064 2034 #<= 8 #() nil nil 1312 nil 1 nil nil #thumbnails 8 #() 770 193 193 131169 770 65 65 1 nil nil 201 nil 1 nil nil nil nil nil nil nil nil nil nil 674 34 3 722 #createAt:extent: 34 2 770 1 39 770 699 775 1312 722 #contextMenu: 34 1 1488 1312 722 #text: 34 1 8 'Column 1' 1312 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1296 nil 35 170 192 34 2 1312 8 'contents' nil 674 34 1 722 #createAt:extent: 34 2 770 1 1 770 699 813 880 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 960 1312 1296 nil 27 410 #{UI.Splitter} 34 12 nil 528 34 2 8 1140850688 1 2752 nil nil nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2752 nil 1 #left nil nil nil 770 1 1 770 9 9 nil 2848 nil 674 34 1 722 #createAt:extent: 34 2 770 699 1 770 11 813 2752 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1296 nil 27 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 3024 nil nil nil 7 nil nil nil 3024 498 1 1 410 #{UI.StaticText} 34 16 nil 3024 34 2 8 1140850945 1 3104 nil 1040 nil 7 nil nil nil 3104 nil 8 1831350160 1074 nil nil nil 674 34 2 722 #createAt:extent: 34 2 770 1 1 770 701 39 3104 722 #text: 34 1 8 'Entries' 3104 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1296 nil 27 nil nil nil 410 #{UI.ContainerView} 34 15 nil 3024 34 2 8 1409286144 131073 3392 nil nil nil 7 nil nil nil 3392 594 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.Splitter} 34 12 nil 3392 34 2 8 1140850688 1 3536 nil nil nil 519 nil nil nil 2818 3536 nil 1 #left nil nil nil 2848 2864 nil 2848 nil 674 34 1 722 #createAt:extent: 34 2 770 1 85 770 731 11 3536 818 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1296 nil 27 1 true 170 192 640 nil 674 34 1 722 #createAt:extent: 34 2 770 1 39 770 701 775 3392 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 2 3536 410 #{UI.CardContainer} 34 16 nil 3392 34 2 8 1409286144 131073 3920 nil nil nil 7 nil nil nil 3920 853318 1 #{UI.CardLayout} 138 144 34 2 3506 #{Tools.PropertyInspector} 410 #{UI.ListTreeView} 34 59 nil 3920 34 2 8 1140953421 1 4064 1378 138 144 640 nil 1440 1456 nil 15 1474 nil true 34 6 1522 1 1554 #addVariable 8 '&Add…' 1 1 1602 nil true 1634 8 'NewThing.ico' 1696 65541 nil nil nil 1522 1 1554 #removeVariable 8 '&Remove' 1 1 1602 nil true 1634 8 'EditClear.ico' 1696 65541 nil nil nil 1826 4097 1522 1 1554 #toggleConstant 8 '&Constant' 1 1 nil nil nil 1826 4097 1522 1 1554 #browseEntryReferences 8 'Browse References' 1 9 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4064 nil 8 1831221392 2034 #valueText 8 #() nil 2128 nil nil nil nil nil nil 138 144 34 3 2194 8 'Key' 461 #left 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 2032 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4656 7 257 nil 2034 #<= 8 #() nil nil 4064 nil 3 nil nil 2194 8 'Value' 171 #left 4642 0 nil 4674 2 1 4640 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4816 7 257 nil 2034 #<= 4768 nil nil 4064 nil 1 nil nil 2194 8 '' 41 #center nil 2034 #<= 8 #() nil nil 4064 4642 0 nil 4674 3 1 4640 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1442886 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 4976 7 257 nil 1 nil nil #report 2288 nil 355 770 129 129 1 nil nil 201 nil 1 nil nil nil nil nil nil nil nil nil nil false 1247046 3 #{UI.VirtualTreeModel} nil 1440 138 144 640 nil nil 4642 0 nil 1377574 #{Kernel.CompiledMethod} 2 3 5104 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 5120 4642 0 nil 5170 1 83886083 5104 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 5216 7 257 nil nil 138 #{Core.PluggableSet} 640 138 #{Core.IdentitySet} 640 1 1 nil nil nil nil nil nil nil 674 34 3 722 #createAt:extent: 34 2 770 9 9 770 685 715 4064 722 #contextMenu: 34 1 4160 4064 722 #text: 34 1 8 'Key' 4064 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1296 nil 2029 3506 #{Tools.ValueWorkspace} 410 #{UI.Scintilla.ScintillaView} 34 52 nil 3920 34 2 8 1411453252 1 5536 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 466 #smalltalkWorkspace nil 21 1474 nil true 34 13 1522 1 1554 #accept 8 '&Accept' 1 1 nil nil nil 1826 4097 1474 nil true 34 10 1522 1 1554 #undo 8 '&Undo' 1 1 1602 nil true 1634 8 'EditUndo.ico' 1696 65541 nil nil nil 1826 4097 1522 1 1554 #cutSelection 8 'Cu&t' 1 1 1602 nil true 1634 8 'EditCut.ico' 1696 65541 nil nil nil 1522 1 1554 #copySelection 8 '&Copy' 1 1 1602 nil true 1634 8 'EditCopy.ico' 1696 65541 nil nil nil 1522 1 1554 #pasteClipboard 8 '&Paste' 1 1 1602 nil true 1634 8 'EditPaste.ico' 1696 65541 nil nil nil 1522 1 1554 #clearSelection 8 'De&lete' 1 1 1602 nil true 1634 8 'EditClear.ico' 1696 65541 nil nil nil 1826 4097 1522 1 1554 #reformatSource 8 'Re&format' 1 1 nil nil nil 1826 4097 1522 1 1554 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1474 nil true 34 10 1522 1 1554 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1522 1 1554 #cloneNew 8 '&Clone' 1 1 1602 nil true 1634 8 'SmalltalkWorkspace.ico' 1696 65541 nil nil nil 1826 4097 1522 1 1554 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1522 1 1554 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1522 1 1554 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1522 1 1554 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1522 1 1554 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1522 1 1554 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1522 1 1554 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1826 4097 1522 1 1554 #browseIt 8 'Bro&wse It' 1 1 1602 nil true 1634 8 'ClassBrowserShell.ico' 1696 65541 nil nil nil 1522 1 1554 #displayIt 8 '&Display It' 1 1 1602 nil true 1634 8 'DisplayIt.ico' 1696 65541 nil nil nil 1522 1 1554 #printIt 8 '&Print It' 1 1 1602 nil true 1634 8 'PrintIt.ico' 1696 65541 nil nil nil 1522 1 1554 #evaluateIt 8 'E&valuate It' 1 1 1602 nil true 1634 8 'EvaluateIt.ico' 1696 65541 nil nil nil 1522 1 1554 #inspectIt 8 '&Inspect It' 1 1 1602 nil true 1634 8 'InspectIt.ico' 1696 65541 nil nil nil 1522 1 1554 #debugIt 8 'Deb&ug It' 1 1 1602 nil true 1634 8 'Debugger.ico' 1696 65541 nil nil nil 1826 4097 1474 nil true 34 2 1522 2097153 1554 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1522 1 1554 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5536 nil 8 1868899715 1074 nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7874 77 1026 #gray 1026 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 138 144 640 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 5536 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 640 nil 170 176 640 9215 nil nil 170 176 34 2 81 1026 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 7840 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 4 #{UI.Scintilla.IndicatorDefinition} 17 5536 1026 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 8338 19 5536 1026 #blue 3 3 #Warning nil nil nil nil nil nil #Error 8338 21 5536 1026 #red 3 3 #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7874 1029 nil 1026 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7874 1027 1026 #darkGoldenrod 1026 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 7874 1031 1026 #firebrick 1026 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 674 34 9 722 #createAt:extent: 34 2 770 9 9 770 685 715 5536 722 #contextMenu: 34 1 5680 5536 722 #sciSetMouseDwellTime: 8 #(500) 5536 722 #wordWrap: 8 #(true) 5536 722 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 5536 1 3 nil nil 5 nil 8850 3 5536 1 nil nil 67108863 5 nil 8850 5 5536 1 nil nil nil 5 nil 5536 722 #tabWidth: 8 #(4) 5536 722 #maxCompletionListHeight: 8 #(9) 5536 722 #sciSetTechnology: 8 #(1) 5536 722 #sciSetSelectionLayer: 8 #(1) 5536 818 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1296 nil 35 4064 nil nil nil 170 192 34 4 5536 8 'workspace' 4064 8 'aspects' nil 410 #{UI.TabViewXP} 34 28 nil 3920 34 2 8 1140916738 1 9152 1378 138 144 8 #(#{Tools.PropertyInspector} #{Tools.ValueWorkspace}) nil 1440 nil nil 1 nil nil nil 9152 nil 8 1830764192 4642 0 nil 4674 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 9280 7 257 nil 2080 2128 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 34 3 722 #createAt:extent: 34 2 770 1 1 770 701 775 9152 722 #setSingleSelection: 8 #(1) 9152 722 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9152 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1296 nil 27 674 34 1 722 #createAt:extent: 34 2 770 1 1 770 701 775 3920 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 4064 5536 9152 1296 nil 27 1296 nil 27 170 192 34 2 3392 8 'inspector' nil 674 34 1 722 #createAt:extent: 34 2 770 709 1 770 701 813 3024 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 3104 3392 1296 nil 27 1296 nil 27 170 192 34 2 528 8 'dictionaries' 1180166 #{Graphics.Rectangle} 770 21 21 770 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 34 2 722 #createAt:extent: 34 2 770 12287 21 770 1481 931 416 722 #text: 34 1 8 'Namespaces' 416 818 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 227 26 0 0 219 1 0 0] 34 1 528 1296 nil 27)!

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


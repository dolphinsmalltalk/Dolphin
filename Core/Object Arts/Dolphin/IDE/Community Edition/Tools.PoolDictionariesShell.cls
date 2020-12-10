"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.PoolDictionariesShell'
	instanceVariableNames: 'dictionariesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PoolDictionariesShell guid: (Core.GUID fromString: '{558cac4a-ac5c-43bf-8f8e-247bb36208f5}')!
Tools.PoolDictionariesShell comment: ''!
!Tools.PoolDictionariesShell categoriesForClass!MVP-Presenters! !
!Tools.PoolDictionariesShell methodsFor!

addEntry
	"Prompt for an entry to add to the selected pool"

	| entry |
	entry := (KeyValuePrompter
				createOn: VariableBinding new
				prompt: 'Enter key string and value expression:'
				caption: self caption) showModal.
	entry ifNil: [^self].
	entry key: entry key asString.
	entry value: (entry ifNotNil: [:value | Compiler evaluate: value]).
	entry isClassVariable: true.
	self selectionOrNil add: entry.
	dictionariesPresenter inspectorPresenter refresh!

addPool
	| name newPool |
	name := Prompter prompt: 'Enter name of SharedPool to create: ' caption: self caption.
	name ifNil: [^self].
	name := name trimBlanks capitalized asSymbol.
	name asQualifiedReference ifDefined: 
			[:existingPool |
			self selectionOrNil: existingPool.
			^MessageBox warning: 'The identifier is already in use: ' , name caption: self caption].
	newPool := SharedPool subclass: name.
	self model add: newPool.
	self selectionOrNil: newPool!

browseEntryReferences
	self systemModel browseMethodsIn: self methodsReferencingSelectedEntry!

classesReferencingSelectedPool
	^self selectionOrNil classesReferencing!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	dictionariesPresenter := self add: TwinLevelInspector new name: 'dictionaries'!

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
				caption: ('Package of <1p>...' expandMacrosWith: pool)
				default: nil
				validationBlock: [:package | package notNil and: [pool environment includesKey: pool name]].
	(newPkg isNil or: [newPkg = oldPkg]) ifTrue: [^self].
	Package manager addVariableNamed: pool fullyQualifiedReference to: newPkg!

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
	pool removeFromSystem.
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
!Tools.PoolDictionariesShell categoriesFor: #addEntry!public! !
!Tools.PoolDictionariesShell categoriesFor: #addPool!commands!public! !
!Tools.PoolDictionariesShell categoriesFor: #browseEntryReferences!commands!public! !
!Tools.PoolDictionariesShell categoriesFor: #classesReferencingSelectedPool!commands!private! !
!Tools.PoolDictionariesShell categoriesFor: #createComponents!private! !
!Tools.PoolDictionariesShell categoriesFor: #hasSelectedItemAccessor!public!selection! !
!Tools.PoolDictionariesShell categoriesFor: #hasSelection!public!selection! !
!Tools.PoolDictionariesShell categoriesFor: #methodsReferencingSelectedEntry!commands!private! !
!Tools.PoolDictionariesShell categoriesFor: #model:!public! !
!Tools.PoolDictionariesShell categoriesFor: #poolPackage!commands!public! !
!Tools.PoolDictionariesShell categoriesFor: #queryCommand:!commands!private! !
!Tools.PoolDictionariesShell categoriesFor: #removeEntry!public! !
!Tools.PoolDictionariesShell categoriesFor: #removePool!commands!public! !
!Tools.PoolDictionariesShell categoriesFor: #selectedItemAccessorOrNil!commands!private! !
!Tools.PoolDictionariesShell categoriesFor: #selectedItemKey!commands!private! !
!Tools.PoolDictionariesShell categoriesFor: #selectionOrNil!private!selection! !
!Tools.PoolDictionariesShell categoriesFor: #selectionOrNil:!private!selection! !

!Tools.PoolDictionariesShell class methodsFor!

defaultModel
	^ListModel
		on: (SmalltalkSystem current availablePools asSortedCollection: [:x :y | x name <= y name])!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Pool Dictionaries'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376774 ##(UI.ProportionalLayout) 170 176 8 #() false 170 192 640 nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 21 21 786 1409 813 528 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 498 1 1 410 ##(UI.StaticText) 34 16 nil 896 34 2 8 1140850945 1 976 nil 917510 ##(Graphics.Color) #silver nil 7 nil nil nil 976 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 699 39 976 738 #text: 34 1 8 'Available Pools' 976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 786 193 193 nil 27 nil nil nil 410 ##(UI.ListView) 34 45 nil 896 34 2 8 1409372236 1 1344 787270 2 ##(UI.ListModel) 138 144 640 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1042 #default nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #addPool 8 'Add New Pool...' 1 1 nil nil nil 1554 1 1586 #removePool 8 'Remove Pool...' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1554 1 1586 #poolPackage 8 'Package...' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 78 97 114 114 111 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 786 193 193 nil 1344 nil 8 1801282304 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil 786 129 129 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Column 1' 201 #left 1890 #displayString 1920 1890 #<= 8 #() nil nil 1344 nil 1 nil nil #thumbnails 8 #() 786 193 193 131169 786 65 65 1 nil nil 201 nil nil nil nil nil nil nil nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 39 786 699 775 1344 738 #contextMenu: 34 1 1520 1344 738 #text: 34 1 8 'Column 1' 1344 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1328 nil 35 170 192 34 2 1344 8 'contents' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 699 813 896 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 976 1344 1328 nil 27 410 ##(UI.Splitter) 34 12 nil 528 34 2 8 1140850688 1 2608 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 2608 nil 1 #left nil nil nil 786 1 1 786 9 9 nil 2704 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 699 1 786 11 813 2608 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1328 nil 27 410 ##(UI.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2896 nil nil nil 7 nil nil nil 2896 498 1 1 410 ##(UI.StaticText) 34 16 nil 2896 34 2 8 1140850945 1 2976 nil 1056 nil 7 nil nil nil 2976 nil 8 1801195232 1090 nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 701 39 2976 738 #text: 34 1 8 'Entries' 2976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1328 nil 27 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 2896 34 2 8 1409286144 131073 3280 nil nil nil 7 nil nil nil 3280 594 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 3280 34 2 8 1140850688 1 3424 nil nil nil 519 nil nil nil 2674 3424 nil 1 #left nil nil nil 2704 2720 nil 2704 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 85 786 731 11 3424 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1328 nil 27 1 true 170 192 640 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 39 786 701 775 3280 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 2 3424 410 ##(UI.CardContainer) 34 16 nil 3280 34 2 8 1409286144 131073 3840 nil nil nil 7 nil nil nil 3840 853318 1 ##(UI.CardLayout) 138 144 34 2 3394 ##(Tools.PropertyInspector) 410 ##(UI.ListTreeView) 34 59 nil 3840 34 2 8 1140953421 1 3984 1410 138 144 640 nil 1472 1488 nil 15 1506 nil true 34 4 1554 1 1586 #addEntry 8 'Add Entry...' 1 1 nil nil nil 1554 1 1586 #removeEntry 8 'Remove Entry...' 1 1 nil nil nil 1682 4097 1554 1 1586 #browseEntryReferences 8 'Browse References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3984 nil 8 1801282304 1890 #valueText 8 #() nil 1952 nil nil nil nil nil nil 138 144 34 3 2018 8 'Key' 461 #left 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 1888 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4416 7 257 nil 1890 #<= 8 #() nil nil 3984 nil 3 nil nil 2018 8 'Value' 171 #left 4402 0 nil 4434 2 1 4400 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4576 7 257 nil 1890 #<= 4528 nil nil 3984 nil 1 nil nil 2018 8 '' 41 #center nil 1890 #<= 8 #() nil nil 3984 4402 0 nil 4434 3 1 4400 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 4736 7 257 nil 1 nil nil #report 2112 nil 355 786 129 129 1 nil nil 201 nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 1472 138 144 640 nil nil 4402 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 4832 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4848 4402 0 nil 4898 1 83886083 4832 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4944 7 257 nil nil 138 ##(Core.PluggableSet) 640 138 ##(Core.IdentitySet) 640 1 1 nil nil nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 9 9 786 685 715 3984 738 #contextMenu: 34 1 4080 3984 738 #text: 34 1 8 'Key' 3984 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 2029 3394 ##(Tools.ValueWorkspace) 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 3840 34 2 8 1411453252 1 5280 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 466 #smalltalkWorkspace nil 21 1506 nil true 34 13 1554 1 1586 #accept 8 '&Accept' 1 1 nil nil nil 1682 4097 1506 nil true 34 10 1554 1 1586 #undo 8 '&Undo' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'EditUndo.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1682 4097 1554 1 1586 #cutSelection 8 'Cu&t' 1 1 5602 nil true 5648 8 'EditCut.ico' 5696 nil nil 1554 1 1586 #copySelection 8 '&Copy' 1 1 5602 nil true 5648 8 'EditCopy.ico' 5696 nil nil 1554 1 1586 #pasteClipboard 8 '&Paste' 1 1 5602 nil true 5648 8 'EditPaste.ico' 5696 nil nil 1554 1 1586 #clearSelection 8 'De&lete' 1 1 5602 nil true 5648 8 'EditClear.ico' 5696 nil nil 1682 4097 1554 1 1586 #reformatSource 8 'Re&format' 1 1 nil nil nil 1682 4097 1554 1 1586 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1506 nil true 34 10 1554 1 1586 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1554 1 1586 #cloneNew 8 '&Clone' 1 1 5602 nil true 5648 8 'SmalltalkWorkspace.ico' 5696 nil nil 1682 4097 1554 1 1586 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1554 1 1586 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1554 1 1586 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1554 1 1586 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1554 1 1586 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1554 1 1586 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1554 1 1586 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1682 4097 1554 1 1586 #browseIt 8 'Bro&wse It' 1 1 5602 nil true 5648 8 'ClassBrowserShell.ico' 5696 nil nil 1554 1 1586 #displayIt 8 '&Display It' 1 1 5602 nil true 5648 8 'DisplayIt.ico' 5696 nil nil 1554 1 1586 #printIt 8 '&Print It' 1 1 5602 nil true 5648 8 'PrintIt.ico' 5696 nil nil 1554 1 1586 #evaluateIt 8 'E&valuate It' 1 1 5602 nil true 5648 8 'EvaluateIt.ico' 5696 nil nil 1554 1 1586 #inspectIt 8 '&Inspect It' 1 1 5602 nil true 5648 8 'InspectIt.ico' 5696 nil nil 1554 1 1586 #debugIt 8 'Deb&ug It' 1 1 5602 nil true 5648 8 'Debugger.ico' 5696 nil nil 1682 4097 1506 nil true 34 2 1554 2097153 1586 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1554 1 1586 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5280 nil 8 2031697384 1090 nil nil 9 1848893265 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7522 77 1042 #gray 1042 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 640 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 5280 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 640 nil 170 176 640 9215 nil nil nil nil 1056 nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 7488 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 5280 1042 #commonGreen 11 false #Notification nil nil nil nil nil nil #Warning 7906 19 5280 1042 #blue 3 false #Warning nil nil nil nil nil nil #Error 7906 21 5280 1042 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7522 1029 nil 1042 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7522 1027 1042 #darkGoldenrod 1042 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 7522 1031 1042 #firebrick 1042 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 674 138 144 34 10 738 #createAt:extent: 34 2 786 9 9 786 685 715 5280 738 #contextMenu: 34 1 5424 5280 738 #hoverTime: 8 #(500) 5280 738 #caretPeriod: 8 #(530) 5280 738 #wordWrap: 8 #(true) 5280 738 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 5280 1 3 nil nil 5 nil 8466 3 5280 1 nil nil 67108863 5 nil 8466 5 5280 1 nil nil nil 5 nil 5280 738 #tabWidth: 8 #(4) 5280 738 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 5280 738 #maxCompletionListHeight: 8 #(9) 5280 738 #edgeColumn: 8 #(1) 5280 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 31 3984 nil nil nil 170 192 34 4 5280 8 'workspace' 3984 8 'aspects' nil 410 ##(UI.TabViewXP) 34 28 nil 3840 34 2 8 1140916738 1 8800 1410 138 144 8 #(##(Tools.PropertyInspector) ##(Tools.ValueWorkspace)) nil 1472 nil nil 1 nil nil nil 8800 nil 8 1801049728 4402 0 nil 4434 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 8928 7 257 nil 4402 0 nil 4898 2 3 ##(UI.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 8992 7 257 nil 1952 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 1 786 701 775 8800 738 #setSingleSelection: 8 #(1) 8800 738 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8800 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1328 nil 27 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 701 775 3840 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 3984 5280 8800 1328 nil 27 1328 nil 27 170 192 34 2 3280 8 'inspector' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 709 1 786 701 813 2896 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 2976 3280 1328 nil 27 1328 nil 27 170 192 34 2 528 8 'dictionaries' 1180166 ##(Graphics.Rectangle) 786 21 21 786 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 6143 21 786 1481 931 416 738 #text: 34 1 8 'Pool Dictionaries' 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 14 0 0 219 1 0 0] 34 1 528 1328 nil 27 )!

toolsFolderHelpId
	^10550! !
!Tools.PoolDictionariesShell class categoriesFor: #defaultModel!public! !
!Tools.PoolDictionariesShell class categoriesFor: #displayOn:!public! !
!Tools.PoolDictionariesShell class categoriesFor: #icon!constants!public! !
!Tools.PoolDictionariesShell class categoriesFor: #initialize!initializing!private! !
!Tools.PoolDictionariesShell class categoriesFor: #publishedAspects!public! !
!Tools.PoolDictionariesShell class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.PoolDictionariesShell class categoriesFor: #toolsFolderHelpId!private! !


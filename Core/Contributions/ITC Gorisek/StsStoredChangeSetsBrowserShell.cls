"Filed out from Dolphin Smalltalk X6.2"!

SmalltalkToolShell subclass: #StsStoredChangeSetsBrowserShell
	instanceVariableNames: 'toDoChangeSets'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsStoredChangeSetsBrowserShell guid: (GUID fromString: '{DEDCEFC0-0509-429F-926B-8A932F9795DA}')!
StsStoredChangeSetsBrowserShell comment: ''!
!StsStoredChangeSetsBrowserShell categoriesForClass!Unclassified! !
!StsStoredChangeSetsBrowserShell methodsFor!

changeSetsOnKeyPressed: aKeyEvent 
	| str |
	str := Keyboard keyNameFromLParam: aKeyEvent lParam.
	str = 'Delete' ifTrue: [^self menuRemoveChangeSet].
	str = 'Space' ifTrue: [^self menuOpenInChangesBrowser]!

createComponents
	super createComponents.
	toDoChangeSets := self add: ListPresenter new name: 'toDoChangeSets'!

createSchematicWiring
	super createSchematicWiring.
	toDoChangeSets
		when: #keyPressed:
			send: #changeSetsOnKeyPressed:
			to: self;
		when: #actionPerformed
			send: #menuOpenInChangesBrowser
			to: self!

menuChangeBlessingLevel
	| selectedItem newBlessing |
	(selectedItem := self selectedItem) isNil ifTrue: [^nil].
	(newBlessing := ChoicePrompter 
				on: (selectedItem blessing ifNil: [#development])
				choices: StsEdition possibleBlessingLevels
				caption: 'Select change set blessing level') isNil 
		ifTrue: [^nil].
	selectedItem blessing == newBlessing ifTrue: [^nil].
	self sourceControl setChangeSetBlessingLevelFor: selectedItem newBlessing: newBlessing.
	self menuUpdateList!

menuImportFromSqueakFileOut
	self sourceControl importFromSqueakFileOut.
	self menuUpdateList!

menuOpenInChangesBrowser
	| selectedItem |
	selectedItem := self selectedItem.
	selectedItem isNil 
		ifFalse: 
			[(StsComparisonBrowser create)
				setChanges: selectedItem changeNodes;
				caption: selectedItem browserTitle;
				showShell]!

menuRemoveChangeSet
	| selection |
	(selection := self selectedItems) isNil 
		ifFalse: 
			[(MessageBox 
				confirm: 'Are you sure you want to remove ' , selection size printString , ' Change Set(s) ?'
				caption: 'About to remove Change Set(s) from repository') == true 
				ifTrue: 
					[self sourceControl removeStoredChangeSets: selection.
					self menuUpdateList]]!

menuUpdateList
	| coll |
	coll := self sourceControl getStoredChangeSets.
	toDoChangeSets model: (ListModel on: (coll copyFrom: 1 to: (200 min: coll size)) reverse)!

onDeferredStartup
	self menuUpdateList!

onStartup
	SessionManager current inputState queueDeferredAction: [self onDeferredStartup]!

onViewOpened
	super onViewOpened.
	self menuUpdateList!

queryCommand: query 
	(#(#menuRemoveChangeSet #menuOpenInChangesBrowser #menuExportChangeSetToServer #menuChangeBlessingLevel) 
		includes: query commandSymbol) 
			ifTrue: 
				[(query commandSymbol == #menuExportChangeSetToServer 
					and: [(self respondsTo: #menuExportChangeSetToServer) not]) 
						ifTrue: 
							[query isEnabled: false.
							^true].
				query isEnabled: self selectedItem notNil.
				^true].
	^super queryCommand: query!

selectedItem
	| selection |
	^((selection := toDoChangeSets selectionOrNil) notNil and: [selection notEmpty]) 
		ifTrue: [selection first]!

selectedItems
	| selection |
	^((selection := toDoChangeSets selectionOrNil) notNil and: [selection notEmpty]) 
		ifTrue: [selection]! !
!StsStoredChangeSetsBrowserShell categoriesFor: #changeSetsOnKeyPressed:!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #createComponents!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #createSchematicWiring!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #menuChangeBlessingLevel!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #menuImportFromSqueakFileOut!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #menuOpenInChangesBrowser!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #menuRemoveChangeSet!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #menuUpdateList!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #onDeferredStartup!event handling!private! !
!StsStoredChangeSetsBrowserShell categoriesFor: #onStartup!event handling!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #onViewOpened!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #queryCommand:!private! !
!StsStoredChangeSetsBrowserShell categoriesFor: #selectedItem!public! !
!StsStoredChangeSetsBrowserShell categoriesFor: #selectedItems!public! !

!StsStoredChangeSetsBrowserShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'STS Repository Change Set Browser'!

icon
	^Icon fromId: 'SOURCETRACKINGTOOLSHELL.ICO'!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon to: Smalltalk developmentSystem sourceTrackingToolsFolder;
		registerTool: self.
	self reuseIfOpen: true.
	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

onStartup
	self primAllSubinstances do: [:i | i onStartup]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.MultipleSelectionListView)  98 30 0 416 98 2 8 1140920393 1025 560 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #menuOpenInChangesBrowser 8 'Open change set in Changes Browser' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 818 1 850 8 #menuChangeBlessingLevel 8 'Change blessing level' 1 1 0 0 0 914 4097 818 1 850 8 #menuExportChangeSetToServer 8 'Export Change Set to server...' 1 1 0 0 0 818 1 850 8 #menuImportChangeSetFromServer 8 'Import Change Set from server...' 1 1 0 0 0 914 4097 770 0 16 98 3 818 1 850 8 #menuImportFromDolphinFileOut 8 'from Dolphin File Out' 1 1 0 0 0 818 1 850 8 #menuImportFromVisualWorkFileOut 8 'from VisualWorks File out' 1 1 0 0 0 818 1 850 8 #menuImportFromSqueakFileOut 8 'from Squeak File Out' 1 1 0 0 0 8 'Import Change Set from file ...' 0 134217729 0 0 0 0 0 914 4097 818 1 850 8 #menuRemoveChangeSet 8 'Remove change set' 1 1 0 0 0 914 4097 818 1 850 8 #menuUpdateList 8 'Update list' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 560 0 8 4294903199 459270 ##(Smalltalk.Message)  8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 5 920646 5 ##(Smalltalk.ListViewColumn)  8 'Comparison' 501 8 #left 1602 1632 98 0 8 ##(Smalltalk.SortedCollection)  787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 1856 8 'doIt' 8 '[:each | each browserTitle displayString]' 8 #[31 105 226 0 159 106] 8 #browserTitle 1632 1872 7 257 0 0 560 0 1 0 0 1746 8 'Comment/description' 501 1792 1602 1632 98 0 1840 1858 0 0 1890 3 1 1856 8 'doIt' 8 '[:each | each comment displayString]' 8 #[31 105 226 0 159 106] 8 #comment 1632 2048 7 257 0 0 560 0 1 0 0 1746 8 'Developer' 201 1792 1602 1632 1824 1840 1858 0 0 1890 3 1 1856 8 'doIt' 8 '[:each | each developer displayString]' 8 #[31 105 226 0 159 106] 8 #developer 1632 2192 7 257 0 0 560 0 1 0 0 1746 8 'Timestamp' 241 1792 1602 1632 1824 1840 1858 0 0 1890 3 1 1856 8 'doIt' 8 '[:each | each timestamp displayString]' 8 #[31 105 226 0 159 106] 8 #timestamp 1632 2336 7 257 0 0 560 0 1 0 0 1746 8 'Blessing' 191 1792 1602 1632 98 0 1840 1602 8 #blessingString 2480 0 560 0 1 0 0 8 #report 688 0 131169 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 2674 1639 1039 560 2610 8 #contextMenu: 98 1 784 560 2610 8 #text: 98 1 8 'Comparison' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 51 3 0 0 7 2 0 0] 98 0 2674 193 193 0 27 234 256 98 2 560 8 'toDoChangeSets' 0 0 0 0 0 1 0 0 0 0 1 0 0 2546 202 208 98 3 2610 2640 98 2 2674 2559 21 2674 1671 1111 416 2610 2784 98 1 8 'Stored Change Sets Browser' 416 2610 8 #updateMenuBar 688 416 2834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 10 0 0 0 66 8 0 0 53 2 0 0] 98 1 560 2896 0 27 )!

show
	StsManager current isConnected ifFalse: [StsManager install].
	StsManager current isConnected ifFalse: [^self].
	super show!

toolsFolderHelpId
	^10902!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	Note: As in all Development classes, this method must be stripped to prevent
	it generating an error when this class is removed."

	(Smalltalk developmentSystem)
		removeSystemFolderIcon: self toolsFolderIcon;
		unregisterTool: self.
	SessionManager current removeEventsTriggeredFor: self! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #icon!public! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #initialize!initializing!private! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #onStartup!event handling!private! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #show!public! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!StsStoredChangeSetsBrowserShell class categoriesFor: #uninitialize!initializing!must strip!private! !


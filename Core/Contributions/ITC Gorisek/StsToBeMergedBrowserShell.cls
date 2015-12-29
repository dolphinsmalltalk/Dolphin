"Filed out from Dolphin Smalltalk X6.1"!

SmalltalkToolShell subclass: #StsToBeMergedBrowserShell
	instanceVariableNames: 'toDoChangeSets'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsToBeMergedBrowserShell guid: (GUID fromString: '{D4AF8E8F-9170-4796-9DC1-E51F56C68874}')!
StsToBeMergedBrowserShell comment: ''!
!StsToBeMergedBrowserShell categoriesForClass!Development! !
!StsToBeMergedBrowserShell methodsFor!

createComponents
	super createComponents.
	toDoChangeSets := self add: ListPresenter new name: 'toDoChangeSets'!

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
				confirm: 'Are you sure you want to remove ' , selection size printString , ' change set(s) ?'
				caption: 'About to remove change sets marked TO BE MERGED') = true 
				ifTrue: 
					[self sourceControl removeToBeMergedChangeSets: selection.
					self menuUpdateList]]!

menuUpdateList
	| coll |
	coll := self sourceControl getToBeMergedChangeSets.
	toDoChangeSets model: (ListModel on: (coll copyFrom: 1 to: (200 min: coll size)) reverse)!

onDeferredStartup
	self menuUpdateList!

onStartup
	SessionManager current inputState queueDeferredAction: [self onDeferredStartup]!

onViewOpened
	super onViewOpened.
	self menuUpdateList!

queryCommand: query 
	| selector selectedItem |
	(super queryCommand: query) == true ifTrue: [^true].
	selector := query commandSymbol.
	selectedItem := self selectedItem.
	(#(#menuRemoveChangeSet #menuOpenInChangesBrowser) includes: selector) 
		ifTrue: 
			[query isEnabled: selectedItem notNil.
			^true]!

selectedItem
	| selection |
	^((selection := toDoChangeSets selectionOrNil) notNil and: [selection notEmpty]) 
		ifTrue: [selection first]!

selectedItems
	| selection |
	^((selection := toDoChangeSets selectionOrNil) notNil and: [selection notEmpty]) 
		ifTrue: [selection]! !
!StsToBeMergedBrowserShell categoriesFor: #createComponents!public! !
!StsToBeMergedBrowserShell categoriesFor: #menuOpenInChangesBrowser!public! !
!StsToBeMergedBrowserShell categoriesFor: #menuRemoveChangeSet!public! !
!StsToBeMergedBrowserShell categoriesFor: #menuUpdateList!public! !
!StsToBeMergedBrowserShell categoriesFor: #onDeferredStartup!event handling!private! !
!StsToBeMergedBrowserShell categoriesFor: #onStartup!event handling!public! !
!StsToBeMergedBrowserShell categoriesFor: #onViewOpened!public! !
!StsToBeMergedBrowserShell categoriesFor: #queryCommand:!private! !
!StsToBeMergedBrowserShell categoriesFor: #selectedItem!public! !
!StsToBeMergedBrowserShell categoriesFor: #selectedItems!public! !

!StsToBeMergedBrowserShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Browse Change Sets marked TO BE MERGED'!

icon

	^Icon fromId: 'SOURCETRACKINGTOOLSHELL.ICO'
!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.MultipleSelectionListView)  98 30 0 416 98 2 8 1140920393 1025 560 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 482 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #menuOpenInChangesBrowser 8 'Open change set in Changes Browser' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 850 1 882 8 #menuRemoveChangeSet 8 'Remove change set' 1 1 0 0 0 946 4097 850 1 882 8 #menuUpdateList 8 'Update list' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 560 0 8 4294902797 459270 ##(Smalltalk.Message)  8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract)  714 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn)  8 'Comparison' 401 8 #left 1154 8 #browserTitle 98 0 8 ##(Smalltalk.SortedCollection)  0 0 560 0 1 0 0 1314 8 'Comment/description' 601 1360 1154 8 #comment 1408 1154 8 #<= 1408 0 0 560 0 1 0 0 1314 8 'Developer' 241 1360 1154 8 #developer 1408 1154 1520 1408 0 0 560 0 1 0 0 1314 8 'Timestamp' 401 1360 1154 8 #timestamp 1408 1154 1520 1408 0 0 560 0 1 0 0 8 #report 688 0 131169 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1842 1185 747 560 1778 8 #contextMenu: 98 1 816 560 1778 8 #text: 98 1 8 'Comparison' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 117 1 0 0] 98 0 1842 193 193 0 27 234 256 98 2 560 8 'toDoChangeSets' 0 0 0 0 0 1 0 0 0 0 1 0 0 1714 202 208 98 3 1778 1808 98 2 1842 3199 21 1842 1201 801 416 1778 1952 98 1 8 'Changes marked as TO BE MERGED' 416 1778 8 #updateMenuBar 688 416 2002 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 5 0 0 10 0 0 0 245 7 0 0 154 1 0 0] 98 1 560 2064 0 27 )!

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

	Smalltalk developmentSystem
		removeSystemFolderIcon: self toolsFolderIcon;
		unregisterTool: self.
	SessionManager current removeEventsTriggeredFor: self ! !
!StsToBeMergedBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!StsToBeMergedBrowserShell class categoriesFor: #icon!public! !
!StsToBeMergedBrowserShell class categoriesFor: #initialize!initializing!private! !
!StsToBeMergedBrowserShell class categoriesFor: #onStartup!event handling!private! !
!StsToBeMergedBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!StsToBeMergedBrowserShell class categoriesFor: #show!public! !
!StsToBeMergedBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!StsToBeMergedBrowserShell class categoriesFor: #uninitialize!initializing!must strip!private! !


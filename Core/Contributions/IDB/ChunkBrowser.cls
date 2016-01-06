"Filed out from Dolphin Smalltalk X6.1"!

IdbToolShell subclass: #ChunkBrowser
	instanceVariableNames: 'chunkList chunkText pathname filter'
	classVariableNames: 'ChunkTypeSelection CompareMethodsUsingParser'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowser guid: (GUID fromString: '{625FA0D2-FFC4-4926-9AE7-06FB0998EC4E}')!
ChunkBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowser categoriesForClass!IDB Goodies! !
!ChunkBrowser methodsFor!

browseChunk
	chunkList selection browse!

canBrowse
	^chunkList selections size = 1 and: [chunkList selection canBrowse]!

canPrint
	^[super canPrint] on: MessageNotUnderstood do: [:e | false]!

canShowDifferences
	^(chunkList selections size = 1 and: [chunkList selection canShowDifferences])
		or: [chunkList selections size = 2]!

chunkSelectAll
	"Leave all other settings alone"

	filter chunkSelectAll.
	self updateChunkList!

chunkSelectDefault
	"Leave all other settings alone"

	filter chunkSelectDefault.
	self updateChunkList!

chunkSelectNone
	"Leave all other settings alone"

	filter chunkSelectNone.
	self updateChunkList!

clearStatusReport
	(self presenterNamed: 'statusReport') value: String new!

clipboardOpen
	Cursor wait
		showWhile:
			[model loadFromText: Clipboard current getText.
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: 'ChunkBrowser - Clipboard'!

copyText
	Clipboard current
		setText:
			(chunkText hasSelection ifTrue: [chunkText view selection] ifFalse: [chunkText view text])
		format: #String!

createComponents
	super createComponents.
	chunkList := self add: ListPresenter new name: 'chunkList'.
	chunkText := self add: SmalltalkWorkspace new name: 'chunkText'.
	self add: TextPresenter new name: 'statusCount'.
	self add: TextPresenter new name: 'statusRange'.
	self add: TextPresenter new name: 'statusRestrict'.
	self add: TextPresenter new name: 'statusReport'!

createSchematicWiring
	super createSchematicWiring.
	chunkList
		when: #selectionChanged
			send: #onSelectionChanged
			to: self;
		when: #actionPerformed
			send: #onActionPerformed
			to: self!

fileOpen
	| dialog |
	pathname ifNil: [pathname := SourceManager default changesFileName].
	(dialog := FileOpenDialog on: pathname)
		fileTypes: self class fileTypes;
		defaultExtension: (File splitExtensionFrom: pathname);
		showModal.
	dialog answer ifNil: [^self] ifNotNil: [:arg | pathname := arg].
	Cursor wait
		showWhile:
			[model loadFromFile: pathname.
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: ('ChunkBrowser - <1s>' expandMacrosWith: (File splitFilenameFrom: pathname))!

fileOpenPatch
	| dialog |
	(dialog := FileOpenDialog on: '*.st')
		fileTypes: self class stFileTypes;
		defaultExtension: 'st';
		showModal.
	dialog answer ifNil: [^self] ifNotNil: [:arg | pathname := arg].
	Cursor wait
		showWhile:
			[model loadFromPatchFile: pathname.
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: ('ChunkBrowser - <1s>' expandMacrosWith: (File splitFilenameFrom: pathname))!

idbAbout
	"Display the about view"

	self
		idbAbout:
			'<n>Chunk Browser<n>for<n>Dolphin Smalltalk 6.x<n><n>Version 6b<n>© 2005 Ian Bartholomew<n>http://www.idb.me.uk'
				expandMacros!

idbHelp
	self idbHelp: 'idbchunkbrowser'!

onActionPerformed
	chunkList selections do: [:each | each picked: each picked not].
	self onRefreshNeeded!

onRefreshNeeded
	chunkList view updateAll.
	chunkList selections size = 1 ifTrue: [chunkList selection showIn: chunkText]!

onSelectionChanged
	chunkList selections size = 1
		ifTrue: [chunkList selection showIn: chunkText]
		ifFalse: [chunkText text: String new].
	self clearStatusReport!

onViewClosed
	super onViewClosed.
	SmalltalkSystem current removeEventsTriggeredFor: self.
	SessionManager current resourceManager removeEventsTriggeredFor: self!

onViewOpened
	super onViewOpened.
	filter := ChunkBrowserFilter new.
	SmalltalkSystem publishedEventsOfInstances
		do:
			[:each | 
			SmalltalkSystem current
				when: each
				send: #onRefreshNeeded
				to: self]!

pickSelection
	chunkList selections do: [:each | each picked: true].
	self onRefreshNeeded!

printableView
	^chunkText view!

queryCommand: aCommandQuery
	aCommandQuery commandSymbol == #toggleChunkType:
		ifTrue:
			[| argument |
			aCommandQuery isEnabled: true.
			argument := aCommandQuery commandDescription command arguments first.
			aCommandQuery isChecked: (filter isChunkTypeSelected: argument).
			^true].
	aCommandQuery commandSymbol == #toggleComparisonType:
		ifTrue:
			[| argument |
			aCommandQuery isEnabled: true.
			argument := aCommandQuery commandDescription command arguments first.
			aCommandQuery isChecked: (filter isComparisonTypeSelected: argument).
			^true].
	aCommandQuery commandSymbol == #restrictionRange
		ifTrue:
			[aCommandQuery isEnabled: chunkList hasSelection.
			^true].
	aCommandQuery commandSymbol == #restrictionSave
		ifTrue:
			[aCommandQuery isEnabled: model hasChunks.
			^true].
	aCommandQuery commandSymbol == #restrictionClear
		ifTrue:
			[aCommandQuery isEnabled: filter isRestrictingRange.
			^true].
	aCommandQuery commandSymbol == #restrictionClass
		ifTrue:
			[aCommandQuery
				isEnabled:
					filter isRestrictingClass
						| (chunkList selections size = 1 and: [chunkList selection chunkClass notNil]).
			aCommandQuery isChecked: filter isRestrictingClass.
			^true].
	aCommandQuery commandSymbol == #toggleRestrictingMostRecent
		ifTrue:
			[aCommandQuery isEnabled: true.
			aCommandQuery isChecked: filter isRestrictingMostRecent.
			^true].
	aCommandQuery commandSymbol == #toggleRestrictingPicked
		ifTrue:
			[aCommandQuery isEnabled: true.
			aCommandQuery isChecked: filter isRestrictingPicked.
			^true].
	aCommandQuery commandSymbol == #showDifferences
		ifTrue:
			[aCommandQuery isEnabled: self canShowDifferences.
			^true].
	aCommandQuery commandSymbol == #copyText
		ifTrue:
			[aCommandQuery isEnabled: chunkList selections size = 1.
			^true].
	aCommandQuery commandSymbol == #browseChunk
		ifTrue:
			[aCommandQuery isEnabled: self canBrowse.
			^true].
	(#(#print #printPreview) identityIncludes: aCommandQuery command)
		ifTrue:
			[aCommandQuery isEnabled: self canPrint.
			^true].
	(#(#pickSelection #unpickSelection #restoreSelection) identityIncludes: aCommandQuery command)
		ifTrue:
			[aCommandQuery isEnabled: chunkList hasSelection.
			^true].
	aCommandQuery commandSymbol == #restorePicked
		ifTrue:
			[aCommandQuery isEnabled: model hasAnyChunksPicked.
			^true].
	aCommandQuery commandSymbol == #clipboardOpen
		ifTrue:
			[aCommandQuery isEnabled: (Clipboard current isFormatIdAvailable: CF_TEXT).
			^true].
	^super queryCommand: aCommandQuery!

restore: aCollection
	| failures stream |
	failures := OrderedCollection new.
	aCollection do: [:each | each restore ifNotNil: [:arg | failures add: arg]].
	stream := String writeStream.
	(self presenterNamed: 'statusReport')
		value: (failures isEmpty ifTrue: ['  Restore suceeded'] ifFalse: ['  Restore may have failed']).
	failures isEmpty ifTrue: [^self].
	stream nextPutAll: 'The following chunks may have failed to restore:<n><n>' expandMacros.
	(failures copyFrom: 1 to: (10 min: failures size))
		do: [:each | stream nextPutAll: ('<1p> <2p><n>' expandMacrosWith: each key with: each value)].
	failures size > 10
		ifTrue: [stream nextPutAll: ('... and <1d> more' expandMacrosWith: failures size - 10)].
	MessageBox notify: stream contents caption: 'Restore may have failed'!

restorePicked
	self restore: model pickedChunks!

restoreSelection
	self restore: chunkList selections!

restrictionClass
	filter isRestrictingClass
		ifTrue: [filter restrictionClass: nil]
		ifFalse:
			[chunkList selections size = 1 ifTrue: [filter restrictionClass: chunkList selection chunkClass]].
	self updateChunkList!

restrictionClear
	filter restrictionRange: nil.
	self updateChunkList!

restrictionRange
	| first last |
	chunkList hasSelection ifFalse: [^self].
	first := chunkList selections inject: 99999999 into: [:min :each | min min: each index].
	last := chunkList selections inject: 0 into: [:max :each | max max: each index].
	filter
		restrictionRange:
			(first to: (chunkList selections size = 1 ifTrue: [model chunkCount] ifFalse: [last])).
	self updateChunkList!

restrictionSave
	filter restrictionRange: (model indexOfLastImageSave to: model chunkCount).
	self updateChunkList!

showDifferences
	| differencesPresenter |
	differencesPresenter := DifferencesPresenter show.
	chunkList selections size = 1
		ifTrue:
			[differencesPresenter topShell
				caption:
					('Differences between chunk #<1d> and the current image' expandMacrosWith: chunkList selection index).
			differencesPresenter
				beforeText: chunkList selection rawText;
				beforeTitle: ('Chunk #<1d>' expandMacrosWith: chunkList selection index);
				afterText: chunkList selection sourceFromImage;
				afterTitle: 'Current image';
				refresh]
		ifFalse:
			[differencesPresenter topShell
				caption:
					('Differences between chunk #<1d> and chunk #<2d>'
						expandMacrosWith: chunkList selections first index
						with: chunkList selections last index).
			differencesPresenter
				beforeText: chunkList selections first rawText;
				beforeTitle: ('Chunk #<1d>' expandMacrosWith: chunkList selections first index);
				afterText: chunkList selections last rawText;
				afterTitle: ('Chunk #<1d>' expandMacrosWith: chunkList selections last index);
				refresh]!

toggleChunkType: aSymbol
	filter toggleChunkType: aSymbol.
	self updateChunkList!

toggleComparisonType: aSymbol
	filter toggleComparisonType: aSymbol.
	self updateChunkList!

toggleRestrictingMostRecent
	filter toggleRestrictingMostRecent.
	self updateChunkList!

toggleRestrictingPicked
	filter toggleRestrictingPicked.
	self updateChunkList!

unpickAll
	chunkList list do: [:each | each picked: false].
	self onRefreshNeeded!

unpickSelection
	chunkList selections do: [:each | each picked: false].
	self onRefreshNeeded!

updateChunkList
	| currentSelections |
	currentSelections := chunkList selections.
	chunkList list: (model filteredUsing: filter).
	chunkList selections: currentSelections ifAbsent: [].
	chunkList view ensureSelectionVisible.
	self onSelectionChanged.
	self updateStatus!

updateStatus
	(self presenterNamed: 'statusCount')
		value:
			('  Showing: <1d> of <2d>'
				expandMacrosWith: chunkList list size
				with:
					(filter isRestrictingRange ifTrue: [filter restrictionRangeSize] ifFalse: [model chunkCount])).
	(self presenterNamed: 'statusRange')
		value:
			(filter isRestrictingRange
				ifTrue:
					['  Range: <1d> to <2d>'
						expandMacrosWith: filter restrictionRangeFirst
						with: filter restrictionRangeLast]).
	(self presenterNamed: 'statusRestrict')
		value:
			('<1s><2s><3s>'
				expandMacrosWith: (filter isRestrictingClass ifTrue: [' Cl'] ifFalse: [String new])
				with: (filter isRestrictingMostRecent ifTrue: [' Re'] ifFalse: [String new])
				with: (filter isRestrictingPicked ifTrue: [' Pi'] ifFalse: [String new])).
	self clearStatusReport! !
!ChunkBrowser categoriesFor: #browseChunk!commands!public!testing! !
!ChunkBrowser categoriesFor: #canBrowse!public!testing! !
!ChunkBrowser categoriesFor: #canPrint!printing!public!testing! !
!ChunkBrowser categoriesFor: #canShowDifferences!public!testing! !
!ChunkBrowser categoriesFor: #chunkSelectAll!commands!public! !
!ChunkBrowser categoriesFor: #chunkSelectDefault!commands!public! !
!ChunkBrowser categoriesFor: #chunkSelectNone!commands!public! !
!ChunkBrowser categoriesFor: #clearStatusReport!helpers!public! !
!ChunkBrowser categoriesFor: #clipboardOpen!commands!public! !
!ChunkBrowser categoriesFor: #copyText!commands!public! !
!ChunkBrowser categoriesFor: #createComponents!initializing!public! !
!ChunkBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!ChunkBrowser categoriesFor: #fileOpen!commands!public! !
!ChunkBrowser categoriesFor: #fileOpenPatch!commands!public! !
!ChunkBrowser categoriesFor: #idbAbout!commands!enquiries!public! !
!ChunkBrowser categoriesFor: #idbHelp!commands!enquiries!public! !
!ChunkBrowser categoriesFor: #onActionPerformed!event handling!public! !
!ChunkBrowser categoriesFor: #onRefreshNeeded!event handling!public! !
!ChunkBrowser categoriesFor: #onSelectionChanged!event handling!public! !
!ChunkBrowser categoriesFor: #onViewClosed!event handling!public! !
!ChunkBrowser categoriesFor: #onViewOpened!event handling!public! !
!ChunkBrowser categoriesFor: #pickSelection!commands!public! !
!ChunkBrowser categoriesFor: #printableView!accessing!printing!public! !
!ChunkBrowser categoriesFor: #queryCommand:!commands!public! !
!ChunkBrowser categoriesFor: #restore:!commands!public! !
!ChunkBrowser categoriesFor: #restorePicked!commands!public! !
!ChunkBrowser categoriesFor: #restoreSelection!commands!public! !
!ChunkBrowser categoriesFor: #restrictionClass!commands!public! !
!ChunkBrowser categoriesFor: #restrictionClear!commands!public! !
!ChunkBrowser categoriesFor: #restrictionRange!commands!public! !
!ChunkBrowser categoriesFor: #restrictionSave!commands!public! !
!ChunkBrowser categoriesFor: #showDifferences!commands!public! !
!ChunkBrowser categoriesFor: #toggleChunkType:!commands!public! !
!ChunkBrowser categoriesFor: #toggleComparisonType:!commands!public! !
!ChunkBrowser categoriesFor: #toggleRestrictingMostRecent!commands!public! !
!ChunkBrowser categoriesFor: #toggleRestrictingPicked!commands!public! !
!ChunkBrowser categoriesFor: #unpickAll!commands!public! !
!ChunkBrowser categoriesFor: #unpickSelection!commands!public! !
!ChunkBrowser categoriesFor: #updateChunkList!operations!public! !
!ChunkBrowser categoriesFor: #updateStatus!helpers!public! !

!ChunkBrowser class methodsFor!

chunkTypeSelection
	^ChunkTypeSelection ifNil: [self defaultChunkTypeSelection]!

chunkTypeSelection: aLookupTable
	ChunkTypeSelection := aLookupTable!

compareMethodsUsingParser
	^CompareMethodsUsingParser ifNil: [self defaultCompareMethodsUsingParser]!

compareMethodsUsingParser: aBoolean
	CompareMethodsUsingParser := aBoolean!

defaultChunkTypeSelection
	^(LookupTable new)
		at: #'Class Category' put: false;
		at: #'Class Define' put: true;
		at: #'Class Delete' put: true;
		at: #'Class Comment' put: false;
		at: #'Class GUID' put: false;
		at: #'Class Protocol' put: false;
		at: #'Class Resource' put: true;
		at: #'Method Category' put: false;
		at: #'Method Define' put: true;
		at: #'Method Delete' put: true;
		at: #System put: true;
		at: #Other put: false;
		yourself!

defaultCompareMethodsUsingParser
	^true!

defaultModel
	^ChunkBrowserModel new!

displayOn: aStream
	aStream nextPutAll: 'Chunk Browser'!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^(OrderedCollection new)
		add: #('Change Files (*.chg)' '*.chg');
		add: #('Class Files (*.cls)' '*.cls');
		add: #('Smalltalk Files (*.st)' '*.st');
		add: #('Package Files (*.pac)' '*.pac');
		add: #('Multi-File Package Files (*.pax)' '*.pax');
		add: #('Image Source Files (*.sml)' '*.sml');
		add: #('All Files (*.*)' '*.*');
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

publishedAspects
	"ss"

	^(super publishedAspects)
		add: (Aspect dictionary: #chunkTypeSelection);
		add: (Aspect boolean: #compareMethodsUsingParser);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1361 1001 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140853580 131137 576 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 0 576 658 688 8 4294903242 234 256 98 0 234 256 98 30 27095 1246982 ##(Smalltalk.ToolbarSystemButton) 27095 0 576 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #fileOpen 8 'Open Chunk File' 1 1 0 1 15 27097 898 27097 0 576 1 930 8 #copyText 8 'Copy Text' 1 1 0 1 3 27099 853766 ##(Smalltalk.ToolbarButton) 27099 0 576 1 930 8 #showDifferences 8 'Open Differences Browser' 1 1 0 657990 3 ##(Smalltalk.DIBSection) 0 16 1114638 ##(Smalltalk.STBSingletonProxy) 8 ##(Smalltalk.ImageRelativeFileLocator) 8 #current 8 'Idb\Resources\ChunkBrowser.bmp' 0 0 7 514 769 33 9 0 47 27101 898 27101 0 576 1 930 8 #restoreSelection 8 'Restore Selected Chunk' 1 1 0 1 9 27103 1058 27103 0 576 5 930 459270 ##(Smalltalk.Message) 8 #toggleChunkType: 98 1 8 #'Class Category' 8 'Class Category' 1 1 0 1152 1 27105 1058 27105 0 576 5 930 1362 1392 98 1 8 #'Class Define' 8 'Class Define' 1 1 0 1152 3 27107 1058 27107 0 576 5 930 1362 1392 98 1 8 #'Class Delete' 8 'Class Delete' 1 1 0 1152 5 27109 1058 27109 0 576 1 930 1362 1392 98 1 8 #'Class Comment' 8 'Class Comment' 1 1 0 1152 7 27111 1058 27111 0 576 5 930 1362 1392 98 1 8 #'Class GUID' 8 'Class GUID' 1 1 0 1152 9 27113 1058 27113 0 576 1 930 1362 1392 98 1 8 #'Class Protocol' 8 'Class Protocol' 1 1 0 1152 39 27115 1058 27115 0 576 5 930 1362 1392 98 1 8 #'Method Category' 8 'Method Category' 1 1 0 1152 13 27117 1058 27117 0 576 5 930 1362 1392 98 1 8 #'Method Define' 8 'Method Define' 1 1 0 1152 15 27119 1058 27119 0 576 5 930 1362 1392 98 1 8 #'Method Delete' 8 'Method Delete' 1 1 0 1152 17 27121 1058 27121 0 576 1 930 1362 1392 98 1 8 #System 8 'System' 1 1 0 1152 41 27123 1058 27123 0 576 5 930 1362 1392 98 1 8 #Other 8 'Other' 1 1 0 1152 19 98 17 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 576 3 0 1 912 992 1072 1264 2434 0 0 576 3 0 1 1328 1456 1552 1648 1744 1840 1936 2032 2128 2224 2320 234 240 98 4 1 1 1152 31 0 1 0 514 33 33 514 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 514 1 1 514 1345 51 576 2642 8 #updateSize 848 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 2 0 0 25 0 0 0] 98 0 514 193 193 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140853004 1 2848 0 482 31 0 7 0 706 0 16 738 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 514 193 193 0 2848 0 8 4294904118 234 256 98 12 853766 ##(Smalltalk.StatusBarItem) 1 321 2848 0 8 ##(Smalltalk.BasicListAbstract) 0 1178 8 ##(Smalltalk.IconImageManager) 1216 8 'statusCount' 3058 1 161 2848 0 3088 0 0 8 'statusRestrict' 3058 1 321 2848 0 3088 0 0 8 'statusRange' 3058 1 221 2848 0 3088 0 0 8 'statusLast' 3058 1 -1 2848 0 3088 0 0 8 'statusReport' 3058 1 181 2848 0 3088 0 0 8 'statusClass' 98 4 3072 3184 3152 3248 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2848 0 0 2578 202 208 98 1 2642 2672 98 2 514 1 849 514 1345 45 2848 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 1 0 0 160 2 0 0 190 1 0 0] 98 0 2832 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3520 0 482 31 0 7 0 0 0 3520 1180166 ##(Smalltalk.ProportionalLayout) 234 240 848 16 234 256 848 590342 ##(Smalltalk.Rectangle) 514 1 1 514 1 1 2578 202 208 98 1 2642 2672 98 2 514 1 51 514 1345 799 3520 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 2 0 0 168 1 0 0] 98 3 410 3536 98 15 0 3520 98 2 8 1140850688 131073 3904 0 482 31 0 7 0 0 0 3904 546 1 1 0 0 0 0 410 8 ##(Smalltalk.ListView) 98 30 0 3904 98 2 8 1140920649 1025 4000 590662 2 ##(Smalltalk.ListModel) 202 208 848 0 1178 8 ##(Smalltalk.SearchPolicy) 8 #identity 658 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 930 8 #pickSelection 8 'Pick selection' 1 1 0 0 0 4258 1 930 8 #unpickSelection 8 'Unpick selection' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4258 1 930 8 #restorePicked 8 'Restore picked' 1 1 0 0 0 4258 1 930 1296 8 'Restore selection' 1 1 0 0 0 4402 4097 4258 1 930 1024 8 'Copy' 1 1 0 0 0 4258 1 930 8 #browseChunk 8 'Browse' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4000 0 8 4294903704 3088 0 3104 0 0 0 514 65 65 0 0 202 208 98 5 920646 5 ##(Smalltalk.ListViewColumn) 8 'Index' 141 8 #left 787814 3 ##(Smalltalk.BlockClosure) 0 459302 ##(Smalltalk.Context) 1 1 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 9 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 98 2 8 '[:o | o index printString]' 98 1 202 8 ##(Smalltalk.PoolDictionary) 848 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 8 #index 8 #printString 17 257 0 8 ##(Smalltalk.SortedCollection) 0 0 4000 1362 8 #chunkIconIndex 98 0 1 0 0 4754 8 'P' 49 4800 4818 0 4850 1 1 0 0 4882 1 9 4912 8 'doIt' 98 2 8 '[:o | String new]' 98 1 202 5008 848 8 #[252 1 0 1 1 6 0 17 230 32 45 146 106 100 105] 721414 ##(Smalltalk.Association) 8 #String 80 17 257 0 4818 0 4850 2 1 0 0 0 4882 2 13 4912 8 'doIt' 98 2 8 '[:a :b | 
	a pickedIconIndex = b pickedIconIndex
		ifTrue: [a index <= b index]
		ifFalse: [a pickedIconIndex > b pickedIconIndex]]' 98 1 202 5008 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 129 106 100 105] 8 #pickedIconIndex 5040 17 513 0 0 0 4000 1362 5504 98 0 1 0 0 4754 8 'Type' 301 4800 1362 8 #chunkType 98 0 4818 0 4850 2 1 0 0 0 4882 2 13 4912 8 'doIt' 98 2 8 '[:a :b | 
 a chunkType = b chunkType
    ifTrue: [a index <= b index]
    ifFalse: [a chunkType <= b chunkType]]' 98 1 202 5008 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] 5600 5040 17 513 0 0 0 4000 0 1 0 0 4754 8 'Identity1' 301 4800 1362 8 #identity1 98 0 4818 0 4850 2 1 0 0 0 4882 2 13 4912 8 'doIt' 98 2 8 '[:a :b | 
 a identity1 = b identity1
	 ifTrue: [a index <= b index]
    	ifFalse: [a identity1 <= b identity1]]' 98 1 202 5008 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] 5824 5040 17 513 0 0 0 4000 0 1 0 0 4754 8 'Identity2' 533 4800 1362 8 #identity2 5840 4818 0 4850 2 1 0 0 0 4882 2 13 4912 8 'doIt' 98 2 8 '[:a :b | 
 a identity2 = b identity2
	ifTrue: [a index <= b index]
    	ifFalse: [a identity2 <= b identity2]]' 98 1 202 5008 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] 6048 5040 17 513 0 0 0 4000 0 3 0 0 8 #report 848 0 131173 0 0 2578 202 208 98 3 2642 2672 98 2 514 9 9 514 1329 387 4000 2642 8 #contextMenu: 98 1 4224 4000 2642 8 #text: 98 1 8 'Index' 4000 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 156 2 0 0 197 0 0 0] 98 0 2832 0 27 234 256 98 2 4000 8 'chunkList' 3682 514 9 9 514 9 1 2578 202 208 98 1 2642 2672 98 2 514 1 1 514 1345 395 3904 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 2 0 0 197 0 0 0] 98 1 4000 2832 0 27 410 8 ##(Smalltalk.Splitter) 98 12 0 3520 98 2 8 1140850688 1 6752 0 658 688 0 519 0 0 0 6752 2578 202 208 98 1 2642 2672 98 2 514 1 395 514 1345 11 6752 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 197 0 0 0 160 2 0 0 202 0 0 0] 98 0 2832 0 27 410 3536 98 15 0 3520 98 2 8 1140850688 131073 7008 0 482 31 0 7 0 0 0 7008 546 1 1 0 0 0 0 410 8 ##(Smalltalk.ScintillaView) 98 46 0 7008 98 2 8 1174475012 1025 7104 721990 2 ##(Smalltalk.ValueHolder) 0 32 1178 4144 8 #equality 0 196934 1 ##(Smalltalk.RGB) 30277631 0 7 4210 0 16 98 3 4258 1 930 1024 8 'Copy' 1 1 0 0 0 4258 1 930 4464 8 'Restore picked' 1 1 0 0 0 4258 1 930 1296 8 'Restore selection' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 7104 0 460018459 852486 ##(Smalltalk.NullConverter) 0 0 11 0 234 256 98 6 8 #indentGuide 1182726 ##(Smalltalk.ScintillaTextStyle) 75 0 0 1 0 0 0 0 7536 0 0 0 8 #normal 7554 1 0 0 1 0 0 0 0 7584 0 0 0 8 #lineNumber 7554 67 0 0 1 0 0 0 0 7616 0 0 0 98 40 7600 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7632 0 0 0 7568 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 0 0 32 202 208 848 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition) 0 1 786694 ##(Smalltalk.IndexedColor) 33554433 7794 33554471 7104 8 #circle 202 208 848 0 63 0 0 0 0 0 7794 33554447 0 0 0 0 0 234 256 98 6 8 #specialCharacter 8 '()[]<>' 8 #literalArray 8 '()' 8 #literalBytes 8 '[]' 8 '' 1 234 256 848 0 0 0 0 3 0 0 2578 202 208 98 9 2642 2672 98 2 514 9 1 514 1329 395 7104 2642 6352 98 1 7280 7104 2642 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 7104 2642 8 #isTextModified: 98 1 32 7104 2642 8 #modificationEventMask: 98 1 9215 7104 2642 8 #indicatorDefinitions: 98 1 98 2 1836038 ##(Smalltalk.ScintillaIndicatorDefinition) 1 7104 65025 3 8434 3 7104 33423361 5 7104 2642 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin) 1 7104 1 3 32 1 8546 3 7104 1 1 32 67108863 8546 5 7104 1 1 32 1 7104 2642 8 #markers: 98 1 7856 7104 2642 8 #tabIndents: 98 1 16 7104 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 156 2 0 0 197 0 0 0] 98 0 2832 0 27 234 256 98 2 7104 8 'chunkText' 3682 514 9 1 514 9 1 2578 202 208 98 1 2642 2672 98 2 514 1 405 514 1345 395 7008 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 202 0 0 0 160 2 0 0 143 1 0 0] 98 1 7104 2832 0 27 2832 0 27 234 256 98 2 576 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 7 4210 0 16 98 9 4258 1 930 960 8 '&Open' 8351 1 0 0 0 4258 1 930 8 #fileOpenPatch 8 'Open Patch File' 1 1 0 0 0 4258 1 930 8 #clipboardOpen 8 'Open On Clipboard' 1 1 0 0 0 4402 4097 4258 1 930 8 #pageSetup 8 'Page se&tup...' 1 1 0 0 0 4258 1 930 8 #printPreview 8 'Print preview...' 1 1 0 0 0 4258 1 930 8 #print 8 '&Print...' 1 1 0 0 0 4402 4097 4258 1 930 8 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 27181 0 0 4210 0 16 98 7 4258 1 930 1024 8 '&Copy' 8327 1 0 0 0 4258 1 930 4640 8 '&Browse' 1 1 0 0 0 4402 4097 4258 1 930 4464 8 'Restore &picked' 1 1 0 0 0 4258 1 930 1296 8 'Restore &selected' 9383 1 0 0 0 4402 4097 4258 1 930 1104 8 'Show &differences' 8355 1 0 0 0 8 '&Edit' 0 1 0 0 27193 0 0 4210 0 16 98 4 4258 1 930 4304 8 '&Pick selected' 1 1 0 0 0 4258 1 930 4368 8 '&Unpick selected' 1 1 0 0 0 4402 4097 4258 1 930 8 #unpickAll 8 'Unpick &all' 1 1 0 0 0 8 '&Pick' 0 1 0 0 27201 0 0 4210 0 16 98 17 4258 1 930 1362 1392 98 1 1424 8 'Class Category' 1 1 0 0 0 4258 1 930 1362 1392 98 1 1712 8 'Class Comment' 1 1 0 0 0 4258 1 930 1362 1392 98 1 1520 8 'Class Define' 1 1 0 0 0 4258 1 930 1362 1392 98 1 1616 8 'Class Delete' 1 1 0 0 0 4258 1 930 1362 1392 98 1 1808 8 'Class GUID' 1 1 0 0 0 4258 1 930 1362 1392 98 1 1904 8 'Class Protocol' 1 1 0 0 0 4402 4097 4258 1 930 1362 1392 98 1 2000 8 'Method Category' 1 1 0 0 0 4258 1 930 1362 1392 98 1 2096 8 'Method Define' 1 1 0 0 0 4258 1 930 1362 1392 98 1 2192 8 'Method Delete' 1 1 0 0 0 4402 4097 4258 1 930 1362 1392 98 1 2384 8 'Other' 1 1 0 0 0 4258 1 930 1362 1392 98 1 2288 8 'System' 1 1 0 0 0 4402 4097 4258 1 930 8 #chunkSelectAll 8 'Select All' 1 1 0 0 0 4258 1 930 8 #chunkSelectNone 8 'Select None' 1 1 0 0 0 4258 1 930 8 #chunkSelectDefault 8 'Select Default' 1 1 0 0 0 8 'Chunks' 0 1 0 0 27231 0 0 4210 0 16 98 11 4258 1 930 1362 8 #toggleComparisonType: 98 1 8 #Match 8 'Show Matching' 1 1 0 0 0 4258 1 930 1362 11408 98 1 8 #Differ 8 'Show Differing' 1 1 0 0 0 4258 1 930 1362 11408 98 1 8 #Missing 8 'Show Missing' 1 1 0 0 0 4402 4097 4258 1 930 8 #toggleRestrictingMostRecent 8 'Restrict To Most Recent Only' 1 1 0 0 0 4258 1 930 8 #restrictionClass 8 'Restrict To Selected Class' 1 1 0 0 0 4258 1 930 8 #toggleRestrictingPicked 8 'Restrict To Picked' 1 1 0 0 0 4402 4097 4258 1 930 8 #restrictionRange 8 'Restrict Range - Selection' 1 1 0 0 0 4258 1 930 8 #restrictionSave 8 'Restrict Range - Since Last Save' 1 1 0 0 0 4258 1 930 8 #restrictionClear 8 'Clear Range Restricition' 1 1 0 0 0 8 'Filter' 0 1 0 0 27251 0 0 4210 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 27253 0 0 4210 0 16 98 2 4258 1 930 8 #idbHelp 8 '&Help' 1 1 0 0 0 4258 1 930 8 #idbAbout 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 27259 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 2578 202 208 98 3 2642 2672 98 2 514 2047 21 514 1361 1001 416 2642 6400 98 1 8 'ChunkBrowser' 416 2642 8 #updateMenuBar 848 416 2770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 167 6 0 0 254 1 0 0] 98 3 576 3520 2848 2832 0 27)!

stFileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^(OrderedCollection new)
		add: #('Smalltalk Files (*.st)' '*.st');
		add: #('All Files (*.*)' '*.*');
		yourself! !
!ChunkBrowser class categoriesFor: #chunkTypeSelection!accessing!public! !
!ChunkBrowser class categoriesFor: #chunkTypeSelection:!accessing!public! !
!ChunkBrowser class categoriesFor: #compareMethodsUsingParser!accessing!public! !
!ChunkBrowser class categoriesFor: #compareMethodsUsingParser:!accessing!public! !
!ChunkBrowser class categoriesFor: #defaultChunkTypeSelection!constants!public! !
!ChunkBrowser class categoriesFor: #defaultCompareMethodsUsingParser!constants!public! !
!ChunkBrowser class categoriesFor: #defaultModel!constants!public! !
!ChunkBrowser class categoriesFor: #displayOn:!operations!public! !
!ChunkBrowser class categoriesFor: #fileTypes!constants!public! !
!ChunkBrowser class categoriesFor: #icon!constants!public! !
!ChunkBrowser class categoriesFor: #publishedAspects!constants!public! !
!ChunkBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!ChunkBrowser class categoriesFor: #stFileTypes!constants!public! !


﻿"Filed out from Dolphin Smalltalk"!

IdbToolShell subclass: #ChunkBrowser
	instanceVariableNames: 'chunkList chunkText pathname filter'
	classVariableNames: 'ChunkTypeSelection CompareMethodsUsingParser'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowser guid: (GUID fromString: '{625fa0d2-ffc4-4926-9ae7-06fb0998ec4e}')!

ChunkBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowser categoriesForClass!IDB Goodies! !

!ChunkBrowser methodsFor!

browseChunk
	<commandQuery: #canBrowse>
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
	<commandQuery: #hasClipboardTextAvailable>
	Cursor wait showWhile: 
			[model loadFromText: Clipboard current getText.
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: 'ChunkBrowser - Clipboard'!

copyText
	<commandQuery: #hasChunkSelected>
	Clipboard current
		setText: (chunkText hasSelection ifTrue: [chunkText view selection] ifFalse: [chunkText view text])!

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
	Cursor wait showWhile: 
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
	Cursor wait showWhile: 
			[model loadFromPatchFile: pathname.
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: ('ChunkBrowser - <1s>' expandMacrosWith: (File splitFilenameFrom: pathname))!

hasAnyChunksPicked
	^model hasAnyChunksPicked!

hasChunks
	^model hasChunks!

hasChunkSelected
	^chunkList hasSingleSelection!

hasChunksSelected
	^chunkList hasSelection!

hasClipboardTextAvailable
	^Clipboard current isTextAvailable!

helpFileStem
	^'idbchunkbrowser'!

idbAbout
	"Display the about view"

	self
		idbAbout:
			'<n>Chunk Browser<n>for<n>Dolphin Smalltalk 7<n><n>Version 7c<n>© 2005 Ian Bartholomew<n>http://www.idb.me.uk'
				expandMacros!

idbHelp
	<commandQuery: #queryIdbHelp:>
	self idbHelp: self helpFileStem!

isFilteringChunks
	^filter isRestrictingRange!

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
	<commandQuery: #hasChunksSelected>
	chunkList selections do: [:each | each picked: true].
	self onRefreshNeeded!

printableView
	^chunkText view!

queryIdbHelp: aCommandQuery
	aCommandQuery
		isEnabled: (File exists: (File
						composePath: SessionManager current idbDocumentationFolder
						stem: self helpFileStem
						extension: 'html'))!

queryRestrictionClass: aCommandQuery
	aCommandQuery isEnabled: filter isRestrictingClass
				| (chunkList selections size = 1 and: [chunkList selection chunkClass notNil]).
	aCommandQuery isChecked: filter isRestrictingClass!

queryToggleChunkType: aCommandQuery
	| argument |
	aCommandQuery beEnabled.
	argument := aCommandQuery commandDescription command arguments first.
	aCommandQuery isChecked: (filter isChunkTypeSelected: argument)!

queryToggleComparisonType: aCommandQuery
	| argument |
	aCommandQuery beEnabled.
	argument := aCommandQuery commandDescription command arguments first.
	aCommandQuery isChecked: (filter isComparisonTypeSelected: argument)!

queryToggleRestrictingMostRecent: aCommandQuery
	aCommandQuery beEnabled.
	aCommandQuery isChecked: filter isRestrictingMostRecent!

queryToggleRestrictingPicked: aCommandQuery
	aCommandQuery beEnabled.
	aCommandQuery isChecked: filter isRestrictingPicked!

release
	super release.
	SmalltalkSystem current removeEventsTriggeredFor: self.
	SessionManager current resourceManager removeEventsTriggeredFor: self!

restore: aCollection
	| failures stream |
	failures := OrderedCollection new.
	aCollection do: [:each | each restore ifNotNil: [:arg | failures add: arg]].
	stream := String smalltalkWriteStream.
	(self presenterNamed: 'statusReport')
		value: (failures isEmpty ifTrue: ['  Restore suceeded'] ifFalse: ['  Restore may have failed']).
	failures isEmpty ifTrue: [^self].
	'The following chunks may have failed to restore:<n><n>' expandMacrosWithArguments: #() on: stream.
	(failures copyFrom: 1 to: (10 min: failures size))
		do: [:each | '<1p> <2p><n>' expandMacrosWithArguments: {each key. each value} on: stream].
	failures size > 10
		ifTrue: ['... and <d> more' expandMacrosWithArguments: {failures size - 10} on: stream].
	MessageBox notify: stream contents caption: 'Restore may have failed'!

restorePicked
	<commandQuery: #hasAnyChunksPicked>
	self restore: model pickedChunks!

restoreSelection
	<commandQuery: #hasChunksSelected>
	self restore: chunkList selections!

restrictionClass
	<commandQuery: #queryRestrictionClass:>
	filter isRestrictingClass
		ifTrue: [filter restrictionClass: nil]
		ifFalse: 
			[chunkList selections size = 1 ifTrue: [filter restrictionClass: chunkList selection chunkClass]].
	self updateChunkList!

restrictionClear
	<commandQuery: #isFilteringChunks>
	filter restrictionRange: nil.
	self updateChunkList!

restrictionRange
	<commandQuery: #hasChunksSelected>
	| first last |
	chunkList hasSelection ifFalse: [^self].
	first := chunkList selections inject: 99999999 into: [:min :each | min min: each index].
	last := chunkList selections inject: 0 into: [:max :each | max max: each index].
	filter restrictionRange: (first
				to: (chunkList selections size = 1 ifTrue: [model chunkCount] ifFalse: [last])).
	self updateChunkList!

restrictionSave
	<commandQuery: #hasChunks>
	filter restrictionRange: (model indexOfLastImageSave to: model chunkCount).
	self updateChunkList!

showDifferences
	<commandQuery: #canShowDifferences>
	| differencesPresenter |
	differencesPresenter := DifferencesPresenter show.
	chunkList selections size = 1
		ifTrue: 
			[differencesPresenter topShell caption: ('Differences between chunk #<1d> and the current image'
						expandMacrosWith: chunkList selection index).
			differencesPresenter
				beforeText: chunkList selection rawText;
				beforeTitle: ('Chunk #<1d>' expandMacrosWith: chunkList selection index);
				afterText: chunkList selection sourceFromImage;
				afterTitle: 'Current image';
				refresh]
		ifFalse: 
			[differencesPresenter topShell caption: ('Differences between chunk #<1d> and chunk #<2d>'
						expandMacrosWith: chunkList selections first index
						with: chunkList selections last index).
			differencesPresenter
				beforeText: chunkList selections first rawText;
				beforeTitle: ('Chunk #<1d>' expandMacrosWith: chunkList selections first index);
				afterText: chunkList selections last rawText;
				afterTitle: ('Chunk #<1d>' expandMacrosWith: chunkList selections last index);
				refresh]!

toggleChunkType: aSymbol
	<commandQuery: #queryToggleChunkType:>
	filter toggleChunkType: aSymbol.
	self updateChunkList!

toggleComparisonType: aSymbol
	<commandQuery: #queryToggleComparisonType:>
	filter toggleComparisonType: aSymbol.
	self updateChunkList!

toggleRestrictingMostRecent
	<commandQuery: #queryToggleRestrictingMostRecent:>
	filter toggleRestrictingMostRecent.
	self updateChunkList!

toggleRestrictingPicked
	<commandQuery: #queryToggleRestrictingPicked:>
	filter toggleRestrictingPicked.
	self updateChunkList!

unpickAll
	chunkList list do: [:each | each picked: false].
	self onRefreshNeeded!

unpickSelection
	<commandQuery: #hasChunksSelected>
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
		value: ('  Showing: <1d> of <2d>' expandMacrosWith: chunkList list size
				with: (filter isRestrictingRange ifTrue: [filter restrictionRangeSize] ifFalse: [model chunkCount])).
	(self presenterNamed: 'statusRange') value: (filter isRestrictingRange
				ifTrue: 
					['  Range: <1d> to <2d>' expandMacrosWith: filter restrictionRangeFirst
						with: filter restrictionRangeLast]).
	(self presenterNamed: 'statusRestrict') value: ('<1s><2s><3s>'
				expandMacrosWith: (filter isRestrictingClass ifTrue: [' Cl'] ifFalse: [String new])
				with: (filter isRestrictingMostRecent ifTrue: [' Re'] ifFalse: [String new])
				with: (filter isRestrictingPicked ifTrue: [' Pi'] ifFalse: [String new])).
	self clearStatusReport! !

!ChunkBrowser categoriesForMethods!
browseChunk!commands!commands-actions!public!testing! !
canBrowse!public!testing! !
canPrint!printing!public!testing! !
canShowDifferences!public!testing! !
chunkSelectAll!commands!commands-actions!public! !
chunkSelectDefault!commands!commands-actions!public! !
chunkSelectNone!commands!commands-actions!public! !
clearStatusReport!helpers!public! !
clipboardOpen!commands!commands-actions!public! !
copyText!commands!commands-actions!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
fileOpen!commands!commands-actions!public! !
fileOpenPatch!commands!commands-actions!public! !
hasAnyChunksPicked!commands!commands-actions!commands-queries!public! !
hasChunks!commands!commands-actions!commands-queries!public! !
hasChunkSelected!commands-queries!public! !
hasChunksSelected!commands-queries!public! !
hasClipboardTextAvailable!commands-queries!public! !
helpFileStem!constants!private! !
idbAbout!commands!commands-actions!enquiries!public! !
idbHelp!commands!commands-actions!enquiries!public! !
isFilteringChunks!commands!commands-actions!commands-queries!public! !
onActionPerformed!event handling!public! !
onRefreshNeeded!event handling!public! !
onSelectionChanged!event handling!public! !
onViewOpened!event handling!public! !
pickSelection!commands!commands-actions!public! !
printableView!accessing!printing!public! !
queryIdbHelp:!commands!commands-queries!public! !
queryRestrictionClass:!commands!commands-queries!public! !
queryToggleChunkType:!commands!commands-queries!public! !
queryToggleComparisonType:!commands!commands-queries!public! !
queryToggleRestrictingMostRecent:!commands!commands-queries!public! !
queryToggleRestrictingPicked:!commands!commands-queries!public! !
release!event handling!public! !
restore:!commands!commands-actions!public! !
restorePicked!commands!commands-actions!public! !
restoreSelection!commands!commands-actions!public! !
restrictionClass!commands!commands-actions!public! !
restrictionClear!commands!commands-actions!public! !
restrictionRange!commands!commands-actions!public! !
restrictionSave!commands!commands-actions!public! !
showDifferences!commands!commands-actions!public! !
toggleChunkType:!commands!commands-actions!public! !
toggleComparisonType:!commands!commands-actions!public! !
toggleRestrictingMostRecent!commands!commands-actions!public! !
toggleRestrictingPicked!commands!commands-actions!public! !
unpickAll!commands!commands-actions!public! !
unpickSelection!commands!commands-actions!public! !
updateChunkList!operations!public! !
updateStatus!helpers!public! !
!

!ChunkBrowser class methodsFor!

chunkTypeSelection
	self ensureOptionsLoaded.
	^ChunkTypeSelection!

chunkTypeSelection: aLookupTable
	ChunkTypeSelection := aLookupTable!

compareMethodsUsingParser
	self ensureOptionsLoaded.
	^CompareMethodsUsingParser!

compareMethodsUsingParser: aBoolean
	CompareMethodsUsingParser := aBoolean!

defaultChunkTypeSelection
	^(IdentityDictionary new)
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Chunk Browser'!

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

	^##((TextTileIcon
		text: $\xE90F
		fontName: 'Segoe Fluent Icons'
		color: (Color
				r: 0
				g: 105
				b: 175))
		margin: 1;
		yourself)!

publishedAspects
	"ss"

	| aspects |
	aspects := super publishedAspects.
	(aspects at: #reuseIfOpen) defaultValue: true.
	^aspects
		add: ((Aspect dictionary: #chunkTypeSelection)
					defaultValue: [self defaultChunkTypeSelection];
					yourself);
		add: ((Aspect boolean: #compareMethodsUsingParser)
					defaultValue: self defaultCompareMethodsUsingParser;
					yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Smalltalk.ThemeColor) #toolBackground 918022 ##(Smalltalk.Point) 1361 1001 551 nil nil nil 416 984838 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1409289036 131073 560 nil nil nil 519 nil nil nil 560 917510 ##(Smalltalk.Color) #default 8 1932375312 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 704 nil nil nil 7 nil nil nil 704 1376838 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Chunk_Browser_Chunk_tools nil 1310982 ##(Smalltalk.MessageSequence) 138 144 34 1 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 217 1 498 523 51 704 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 0 0 0 0 113 1 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'chunks' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 770 ##(Smalltalk.Toolbar) #resource_Chunk_Browser_Tools nil 802 138 144 34 1 866 #createAt:extent: 34 2 498 1 1 498 217 51 1040 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 108 0 0 0 25 0 0 0] 992 1008 nil 27 8 'tools' 170 192 992 138 144 992 nil nil 1 nil 498 33 33 nil nil 852806 1 ##(Smalltalk.FlowLayout) 1 1 1 802 138 144 34 1 866 #createAt:extent: 34 2 498 1 1 498 1329 51 560 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 34 2 1040 704 1008 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 1520 nil 626 #face3d nil 7 nil 852998 ##(Smalltalk.Font) nil true 655622 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 498 193 193 nil 1520 nil 8 1932074864 170 192 34 12 1050374 ##(Smalltalk.StatusBarItem) 1 -1 1520 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusReport' 1746 1 181 1520 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusClass' 1746 1 321 1520 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusCount' 1746 1 161 1520 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusRestrict' 1746 1 321 1520 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusRange' 1746 1 221 1520 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusLast' 34 4 1824 1888 1856 1760 1311750 ##(Smalltalk.StatusBarNullItem) 513 1 1520 nil nil 802 138 144 34 1 866 #createAt:extent: 34 2 498 1 839 498 1329 45 1520 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 1 0 0 152 2 0 0 185 1 0 0] 8 #() 1008 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2160 nil 1584 nil 7 nil nil nil 2160 1376774 ##(Smalltalk.ProportionalLayout) 170 176 992 true 170 192 34 4 410 ##(Smalltalk.ListView) 34 45 nil 2160 34 2 8 1140920649 1 2304 787270 2 ##(Smalltalk.ListModel) 138 144 992 nil 1769478 ##(Smalltalk.IdentitySearchPolicy) 640 nil 7 461638 4 ##(Smalltalk.Menu) nil true 34 8 1180742 2 ##(Smalltalk.CommandMenuItem) 1 1377606 4 ##(Smalltalk.CommandDescription) #pickSelection 8 'Pick selection' 1 1 nil nil nil 2498 1 2530 #unpickSelection 8 'Unpick selection' 1 1 nil nil nil 1179974 1 ##(Smalltalk.DividerMenuItem) 4097 2498 1 2530 #restorePicked 8 'Restore picked' 1 1 nil nil nil 2498 1 2530 #restoreSelection 8 'Restore selection' 1 1 nil nil nil 2626 4097 2498 1 2530 #copyText 8 'Copy' 1 1 nil nil nil 2498 1 2530 #browseChunk 8 'Browse' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2304 nil 8 1932351584 ##(Smalltalk.BasicListAbstract) nil 1639750 1 ##(Smalltalk.IconImageManager) nil nil nil 498 65 65 nil nil 138 144 34 5 1117254 5 ##(Smalltalk.ListViewColumn) 8 'Index' 141 #left 1246566 3 ##(Smalltalk.BlockClosure) 0 918054 ##(Smalltalk.Context) 1 1 nil nil 1639718 ##(Smalltalk.CompiledExpression) 2 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | o index printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 992 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #index #printString 17 257 nil 786950 ##(Smalltalk.Message) #<= 8 #() nil nil 2304 3218 #chunkIconIndex 8 #() 1 nil nil 2978 8 'P' 49 #left 3026 0 3058 1 1 nil nil 3090 1 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | String new]' 34 1 138 ##(Smalltalk.PoolDictionary) 992 8 #[252 1 0 1 1 6 0 17 230 32 45 146 106 100 105] 1049094 ##(Smalltalk.Association) #String 16 17 257 nil 3026 0 3058 2 1 nil nil nil 3090 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
	a pickedIconIndex = b pickedIconIndex
		ifTrue: [a index <= b index]
		ifFalse: [a pickedIconIndex > b pickedIconIndex]]' 34 1 138 ##(Smalltalk.PoolDictionary) 992 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 129 106 100 105] #pickedIconIndex #index 17 513 nil nil nil 2304 3218 #pickedIconIndex 8 #() 1 nil nil 2978 8 'Type' 301 #left 3218 #chunkType 8 #() 3026 0 3058 2 1 nil nil nil 3090 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a chunkType = b chunkType
    ifTrue: [a index <= b index]
    ifFalse: [a chunkType <= b chunkType]]' 34 1 138 ##(Smalltalk.PoolDictionary) 992 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #chunkType #index 17 513 nil nil nil 2304 nil 1 nil nil 2978 8 'Identity1' 301 #left 3218 #identity1 8 #() 3026 0 3058 2 1 nil nil nil 3090 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity1 = b identity1
	 ifTrue: [a index <= b index]
    	ifFalse: [a identity1 <= b identity1]]' 34 1 138 ##(Smalltalk.PoolDictionary) 992 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity1 #index 17 513 nil nil nil 2304 nil 1 nil nil 2978 8 'Identity2' 525 #left 3218 #identity2 3936 3026 0 3058 2 1 nil nil nil 3090 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity2 = b identity2
	ifTrue: [a index <= b index]
    	ifFalse: [a identity2 <= b identity2]]' 34 1 138 ##(Smalltalk.PoolDictionary) 992 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity2 #index 17 513 nil nil nil 2304 nil 3 nil nil #report 8 #() nil 131173 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 802 138 144 34 3 866 #createAt:extent: 34 2 498 5 1 498 1321 389 2304 866 #contextMenu: 34 1 2464 2304 866 #text: 34 1 8 'Index' 2304 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 0 0 0 0 150 2 0 0 194 0 0 0] 8 #() 1008 nil 35 8 'chunkList' 410 ##(Smalltalk.ScintillaView) 34 65 nil 2160 34 2 8 1174475012 1 4560 918598 2 ##(Smalltalk.ValueHolder) nil false 1769478 ##(Smalltalk.EqualitySearchPolicy) nil 626 #ivory nil 7 2450 nil true 34 3 2498 1 2530 #copyText 8 'Copy' 1 1 nil nil nil 2498 1 2530 #restorePicked 8 'Restore picked' 1 1 nil nil nil 2498 1 2530 #restoreSelection 8 'Restore selection' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4560 nil 8 2075213288 1049094 ##(Smalltalk.NullConverter) nil nil 11 2003778673 170 192 34 8 #lineNumber 1444934 1 ##(Smalltalk.ScintillaTextStyle) 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 4978 77 626 #gray 626 #white 1 nil nil nil nil #callTip nil nil nil #normal 4978 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 4978 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1770758 ##(Smalltalk.SmalltalkMethodStyler) 1 nil nil false 138 144 992 170 192 34 2 #default 1903686 2 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 4560 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 992 nil 170 176 992 9215 nil nil nil nil 626 #silver nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 1 170 192 992 nil nil nil nil 208 nil 170 192 34 4 8 'indicator1' 1772614 3 ##(Smalltalk.ScintillaIndicatorStyle) 3 4560 626 #blue 5 false nil 61 nil nil nil nil nil 8 'indicator0' 5410 1 4560 626 #commonGreen 3 false nil 61 nil nil nil nil nil nil nil 170 192 34 6 #Warning 4978 1027 626 #darkGoldenrod 4688 1 nil nil nil nil #Warning nil nil nil #Error 4978 1031 626 #firebrick 626 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 4978 1029 nil 626 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 802 138 144 34 7 866 #createAt:extent: 34 2 498 5 399 498 1321 391 4560 866 #contextMenu: 34 1 4704 4560 866 #caretPeriod: 8 #(530) 4560 866 #margins: 34 1 34 3 1247302 3 ##(Smalltalk.ScintillaMargin) 1 4560 1 3 nil nil 5 nil 5874 3 4560 1 nil nil 67108863 5 nil 5874 5 4560 1 nil nil nil 5 nil 4560 866 #targetRange: 34 1 852742 ##(Smalltalk.Interval) 1 -1 3 4560 866 #maxCompletionListHeight: 8 #(9) 4560 866 #edgeColumn: 8 #(1) 4560 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 199 0 0 0 150 2 0 0 138 1 0 0] 8 #() 1008 nil 33 8 'chunkText' 1180166 ##(Smalltalk.Rectangle) 498 5 1 498 5 1 802 138 144 34 1 866 #createAt:extent: 34 2 498 1 51 498 1329 789 2160 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 152 2 0 0 163 1 0 0] 34 3 2304 410 ##(Smalltalk.Splitter) 34 12 nil 2160 34 2 8 1140850688 1 6352 nil 640 nil 519 nil nil nil 1707078 1 ##(Smalltalk.DraggableViewInteractor) 6352 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 6448 nil 802 138 144 34 1 866 #createAt:extent: 34 2 498 5 389 498 1321 11 6352 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 194 0 0 0 150 2 0 0 199 0 0 0] 8 #() 1008 nil 27 4560 1008 nil 27 170 192 34 2 560 8 'toolbar' nil 658246 4 ##(Smalltalk.MenuBar) nil true 34 7 2450 nil true 34 9 2498 1 2530 #fileOpen 8 '&Open' 8351 1 nil nil nil 2498 1 2530 #fileOpenPatch 8 'Open Patch File' 1 1 nil nil nil 2498 1 2530 #clipboardOpen 8 'Open On Clipboard' 1 1 nil nil nil 2626 4097 2498 1 2530 #pageSetup 8 'Page se&tup...' 1 1 nil nil nil 2498 1 2530 #printPreview 8 'Print preview...' 1 1 nil nil nil 2498 1 2530 #print 8 '&Print...' 1 1 nil nil nil 2626 4097 2498 1 2530 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 27733 nil nil 2450 nil true 34 7 2498 1 2530 #copyText 8 '&Copy' 8327 1 nil nil nil 2498 1 2530 #browseChunk 8 '&Browse' 1 1 nil nil nil 2626 4097 2498 1 2530 #restorePicked 8 'Restore &picked' 1 1 nil nil nil 2498 1 2530 #restoreSelection 8 'Restore &selected' 9383 1 nil nil nil 2626 4097 2498 1 2530 #showDifferences 8 'Show &differences' 8355 1 nil nil nil 8 '&Edit' nil 1 nil nil 27745 nil nil 2450 nil true 34 4 2498 1 2530 #pickSelection 8 '&Pick selected' 1 1 nil nil nil 2498 1 2530 #unpickSelection 8 '&Unpick selected' 1 1 nil nil nil 2626 4097 2498 1 2530 #unpickAll 8 'Unpick &all' 1 1 nil nil nil 8 '&Pick' nil 1 nil nil 27753 nil nil 2450 nil true 34 17 2498 1 2530 3218 #toggleChunkType: 8 #(#'Class Category') 8 'Class Category' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#'Class Comment') 8 'Class Comment' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#'Class Define') 8 'Class Define' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#'Class Delete') 8 'Class Delete' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#'Class GUID') 8 'Class GUID' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#'Class Protocol') 8 'Class Protocol' 1 1 nil nil nil 2626 4097 2498 1 2530 3218 #toggleChunkType: 8 #(#'Method Category') 8 'Method Category' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#'Method Define') 8 'Method Define' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#'Method Delete') 8 'Method Delete' 1 1 nil nil nil 2626 4097 2498 1 2530 3218 #toggleChunkType: 8 #(#Other) 8 'Other' 1 1 nil nil nil 2498 1 2530 3218 #toggleChunkType: 8 #(#System) 8 'System' 1 1 nil nil nil 2626 4097 2498 1 2530 #chunkSelectAll 8 'Select All' 1 1 nil nil nil 2498 1 2530 #chunkSelectNone 8 'Select None' 1 1 nil nil nil 2498 1 2530 #chunkSelectDefault 8 'Select Default' 1 1 nil nil nil 8 'Chunks' nil 1 nil nil 27783 nil nil 2450 nil true 34 11 2498 1 2530 3218 #toggleComparisonType: 8 #(#Match) 8 'Show Matching' 1 1 nil nil nil 2498 1 2530 3218 #toggleComparisonType: 8 #(#Differ) 8 'Show Differing' 1 1 nil nil nil 2498 1 2530 3218 #toggleComparisonType: 8 #(#Missing) 8 'Show Missing' 1 1 nil nil nil 2626 4097 2498 1 2530 #toggleRestrictingMostRecent 8 'Restrict To Most Recent Only' 1 1 nil nil nil 2498 1 2530 #restrictionClass 8 'Restrict To Selected Class' 1 1 nil nil nil 2498 1 2530 #toggleRestrictingPicked 8 'Restrict To Picked' 1 1 nil nil nil 2626 4097 2498 1 2530 #restrictionRange 8 'Restrict Range - Selection' 1 1 nil nil nil 2498 1 2530 #restrictionSave 8 'Restrict Range - Since Last Save' 1 1 nil nil nil 2498 1 2530 #restrictionClear 8 'Clear Range Restricition' 1 1 nil nil nil 8 'Filter' nil 1 nil nil 27803 nil nil 2450 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 27805 nil nil 2450 nil true 34 15 2498 1 2530 #helpContents 8 '&Contents' 1025 1 853318 3 ##(Smalltalk.Icon) nil true 2031622 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2490894 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2498 1 2530 #help 8 'On this &Tool' 1249 1 nil nil nil 2498 1 2530 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2626 4097 2498 1 2530 #learnSmalltalk 8 'Learn Smalltalk' 1 1 1378630 2 ##(Smalltalk.TextTileIcon) $\x1F393 nil 626 #orchid 5040 nil nil 1 nil nil nil nil 2626 4097 2498 1 2530 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2498 1 2530 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2498 1 2530 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2626 4097 2498 1 2530 #dolphinHomePage 8 'Dolphin Homepage' 1 1 9538 nil true 9584 8 '!!APPLICATION' 9632 nil nil 2498 1 2530 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2498 1 2530 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2626 4097 2498 1 2530 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 9826 $\x1F42C nil nil 626 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 27829 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 498 6143 21 498 1361 1001 416 866 #text: 34 1 8 'ChunkBrowser' 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 167 14 0 0 254 1 0 0] 34 3 560 2160 1520 1008 nil 27 )!

stFileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^(OrderedCollection new)
		add: #('Smalltalk Files (*.st)' '*.st');
		add: #('All Files (*.*)' '*.*');
		yourself! !

!ChunkBrowser class categoriesForMethods!
chunkTypeSelection!accessing!public! !
chunkTypeSelection:!accessing!public! !
compareMethodsUsingParser!accessing!public! !
compareMethodsUsingParser:!accessing!public! !
defaultChunkTypeSelection!constants!public! !
defaultCompareMethodsUsingParser!constants!public! !
defaultModel!constants!public! !
displayOn:!operations!public! !
fileTypes!constants!public! !
icon!constants!public! !
publishedAspects!constants!public! !
resource_Default_view!public!resources-views! !
stFileTypes!constants!public! !
!


"Filed out from Dolphin Smalltalk 7"!

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
			'<n>Chunk Browser<n>for<n>Dolphin Smalltalk 7<n><n>Version 7c<n>© 2005 Ian Bartholomew<n>http://www.idb.me.uk'
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

	"Generated from:
	self createIconMethod: #icon ofSize: 48@48 fromFile: 'C:\Users\bower\Documents\Dolphin\Core\Contributions\IDB\Resources\IDB Chunk Brower.png'.
	"
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 2 66 73 68 65 84 104 67 237 151 59 72 28 81 20 134 77 153 202 198 74 8 90 105 19 68 144 136 144 42 118 146 58 101 42 43 33 133 69 240 81 8 70 132 144 20 42 88 6 196 34 32 81 113 9 130 73 150 213 136 15 12 138 68 130 129 96 16 159 136 196 39 110 92 215 7 28 231 92 24 153 157 253 207 44 51 238 174 123 22 15 124 236 221 111 238 220 195 153 189 115 184 91 80 208 16 34 213 64 169 9 40 53 1 165 38 160 212 4 148 154 128 82 19 80 106 2 74 77 64 169 9 40 5 202 218 194 148 206 64 57 124 3 165 192 227 55 145 180 36 78 215 58 6 40 5 156 137 57 202 91 191 38 205 241 98 231 40 70 189 225 149 251 2 18 128 82 192 153 120 105 227 136 74 155 198 204 248 129 197 139 15 243 244 228 237 119 79 246 78 226 244 233 199 6 189 236 91 48 235 160 57 252 158 57 115 166 4 74 1 233 201 237 71 227 198 167 43 220 235 123 2 165 128 123 11 85 119 140 83 52 126 73 39 103 151 230 187 123 190 95 2 109 45 40 5 220 5 112 244 207 174 39 249 172 190 27 80 10 216 9 134 230 183 204 231 211 206 137 4 207 99 142 156 45 160 194 218 50 118 12 47 108 211 251 111 43 134 143 115 155 198 241 156 246 208 111 42 106 28 165 218 174 169 155 235 94 240 61 175 7 150 232 121 247 116 230 11 120 100 61 217 237 195 152 233 64 78 254 238 70 111 18 115 39 121 248 234 51 213 247 47 38 205 67 240 61 149 157 227 84 98 173 157 241 2 36 212 108 33 137 188 42 224 54 220 255 2 65 201 171 2 184 179 240 25 169 184 249 75 210 57 7 193 247 68 150 119 169 101 240 87 110 20 96 211 58 178 108 92 170 112 222 147 241 2 158 117 77 155 4 82 240 28 142 156 221 66 118 130 227 211 11 138 157 95 81 205 187 201 4 207 99 142 156 47 128 199 118 108 30 196 130 37 6 100 189 128 170 246 8 45 174 29 154 49 7 58 235 248 161 111 102 221 172 227 206 235 9 148 2 206 2 236 110 195 227 186 158 25 120 70 146 88 253 247 223 172 131 174 77 253 217 75 200 153 18 40 5 238 116 171 72 64 41 224 222 66 89 125 89 37 160 20 200 171 2 110 195 157 23 128 58 136 31 2 117 27 9 40 5 10 173 191 138 63 65 231 8 130 239 110 35 1 165 38 160 212 4 148 154 128 82 19 80 106 2 74 77 64 169 9 40 53 1 165 26 66 116 13 161 204 174 165 3 179 88 124 0 0 0 0 73 69 78 68 174 66 96 130]!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1361 1001 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 0 416 34 2 8 1140853580 131137 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 0 560 626 656 8 4294906655 170 192 8 #() 170 192 34 30 39703 1246982 ##(Smalltalk.ToolbarSystemButton) 39703 0 560 1 1180998 4 ##(Smalltalk.CommandDescription) #fileOpen 8 'Open Chunk File' 1 1 0 1 15 39705 866 39705 0 560 1 898 #copyText 8 'Copy Text' 1 1 0 1 3 39707 853766 ##(Smalltalk.ToolbarButton) 39707 0 560 1 898 #showDifferences 8 'Open Differences Browser' 1 1 0 657990 3 ##(Smalltalk.DIBSection) 1 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Idb\Resources\ChunkBrowser.bmp' 0 0 7 498 1 1 1 0 47 39709 866 39709 0 560 1 898 #restoreSelection 8 'Restore Selected Chunk' 1 1 0 1 9 39711 994 39711 0 560 5 898 459270 ##(Smalltalk.Message) #toggleChunkType: 8 #(#'Class Category') 8 'Class Category' 1 1 0 1058 0 true 1104 8 'Core\Contributions\IDB\Resources\ChunkBrowser.bmp' 0 0 7 498 769 33 9 0 1 39713 994 39713 0 560 5 898 1234 #toggleChunkType: 8 #(#'Class Define') 8 'Class Define' 1 1 0 1072 3 39715 994 39715 0 560 5 898 1234 #toggleChunkType: 8 #(#'Class Delete') 8 'Class Delete' 1 1 0 1072 5 39717 994 39717 0 560 1 898 1234 #toggleChunkType: 8 #(#'Class Comment') 8 'Class Comment' 1 1 0 1072 7 39719 994 39719 0 560 5 898 1234 #toggleChunkType: 8 #(#'Class GUID') 8 'Class GUID' 1 1 0 1072 9 39721 994 39721 0 560 1 898 1234 #toggleChunkType: 8 #(#'Class Protocol') 8 'Class Protocol' 1 1 0 1072 39 39723 994 39723 0 560 5 898 1234 #toggleChunkType: 8 #(#'Method Category') 8 'Method Category' 1 1 0 1072 13 39725 994 39725 0 560 5 898 1234 #toggleChunkType: 8 #(#'Method Define') 8 'Method Define' 1 1 0 1072 15 39727 994 39727 0 560 5 898 1234 #toggleChunkType: 8 #(#'Method Delete') 8 'Method Delete' 1 1 0 1072 17 39729 994 39729 0 560 1 898 1234 #toggleChunkType: 8 #(#System) 8 'System' 1 1 0 1072 41 39731 994 39731 0 560 5 898 1234 #toggleChunkType: 8 #(#Other) 8 'Other' 1 1 0 1072 19 34 17 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 560 3 0 1 880 944 1008 1152 2162 0 0 560 3 0 1 1200 1344 1424 1504 1584 1664 1744 1824 1904 1984 2064 170 176 34 6 1 1 1072 31 1296 31 0 1 0 498 33 33 498 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 1329 51 560 2370 #updateSizePosted 816 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 8 #() 498 193 193 0 27 410 ##(Smalltalk.StatusBar) 34 18 0 416 34 2 8 1140853004 1 2544 0 466 31 0 7 0 674 0 true 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 498 193 193 0 2544 0 8 4294903691 170 192 34 12 853766 ##(Smalltalk.StatusBarItem) 1 321 2544 0 ##(Smalltalk.BasicListAbstract) 0 1049926 1 ##(Smalltalk.IconImageManager) 8 'statusCount' 2738 1 -1 2544 0 ##(Smalltalk.BasicListAbstract) 0 0 8 'statusReport' 2738 1 221 2544 0 ##(Smalltalk.BasicListAbstract) 0 0 8 'statusLast' 2738 1 321 2544 0 ##(Smalltalk.BasicListAbstract) 0 0 8 'statusRange' 2738 1 161 2544 0 ##(Smalltalk.BasicListAbstract) 0 0 8 'statusRestrict' 2738 1 181 2544 0 ##(Smalltalk.BasicListAbstract) 0 0 8 'statusClass' 34 4 2752 2880 2912 2816 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2544 0 0 2306 138 144 34 1 2370 #createAt:extent: 34 2 498 1 839 498 1329 45 2544 2466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 1 0 0 152 2 0 0 185 1 0 0] 8 #() 2528 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 3184 0 466 31 0 7 0 0 0 3184 1180166 ##(Smalltalk.ProportionalLayout) 170 176 816 true 170 192 816 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 2306 138 144 34 1 2370 #createAt:extent: 34 2 498 1 51 498 1329 789 3184 2466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 152 2 0 0 163 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 0 3184 34 2 8 1140850688 131073 3552 0 466 31 0 7 0 0 0 3552 530 1 1 0 0 0 0 410 ##(Smalltalk.ListView) 34 30 0 3552 34 2 8 1140920649 1025 3648 590662 2 ##(Smalltalk.ListModel) 138 144 816 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 626 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 898 #pickSelection 8 'Pick selection' 1 1 0 0 0 3874 1 898 #unpickSelection 8 'Unpick selection' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3874 1 898 #restorePicked 8 'Restore picked' 1 1 0 0 0 3874 1 898 #restoreSelection 8 'Restore selection' 1 1 0 0 0 3986 4097 3874 1 898 #copyText 8 'Copy' 1 1 0 0 0 3874 1 898 #browseChunk 8 'Browse' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3648 0 8 4294905883 ##(Smalltalk.BasicListAbstract) 0 2784 0 0 0 498 65 65 0 0 138 144 34 5 920646 5 ##(Smalltalk.ListViewColumn) 8 'Index' 141 #left 787814 3 ##(Smalltalk.BlockClosure) 0 459302 ##(Smalltalk.Context) 1 1 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | o index printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #index #printString 17 257 0 ##(Smalltalk.SortedCollection) 0 0 3648 1234 #chunkIconIndex 8 #() 1 0 0 4306 8 'P' 49 #left 4354 0 4386 1 1 0 0 4418 1 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | String new]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 1 0 1 1 6 0 17 230 32 45 146 106 100 105] 721414 ##(Smalltalk.Association) #String 16 17 257 0 4354 0 4386 2 1 0 0 0 4418 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
	a pickedIconIndex = b pickedIconIndex
		ifTrue: [a index <= b index]
		ifFalse: [a pickedIconIndex > b pickedIconIndex]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 129 106 100 105] #pickedIconIndex #index 17 513 0 0 0 3648 1234 #pickedIconIndex 8 #() 1 0 0 4306 8 'Type' 301 #left 1234 #chunkType 8 #() 4354 0 4386 2 1 0 0 0 4418 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a chunkType = b chunkType
    ifTrue: [a index <= b index]
    ifFalse: [a chunkType <= b chunkType]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #chunkType #index 17 513 0 0 0 3648 0 1 0 0 4306 8 'Identity1' 301 #left 1234 #identity1 8 #() 4354 0 4386 2 1 0 0 0 4418 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity1 = b identity1
	 ifTrue: [a index <= b index]
    	ifFalse: [a identity1 <= b identity1]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity1 #index 17 513 0 0 0 3648 0 1 0 0 4306 8 'Identity2' 517 #left 1234 #identity2 5216 4354 0 4386 2 1 0 0 0 4418 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity2 = b identity2
	ifTrue: [a index <= b index]
    	ifFalse: [a identity2 <= b identity2]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity2 #index 17 513 0 0 0 3648 0 3 0 0 #report 816 0 131173 0 8 #(nil) 2306 138 144 34 3 2370 #createAt:extent: 34 2 498 9 9 498 1313 381 3648 2370 #contextMenu: 34 1 3840 3648 2370 #text: 34 1 8 'Index' 3648 2466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 148 2 0 0 194 0 0 0] 8 #() 2528 0 27 170 192 34 2 3648 8 'chunkList' 3330 498 9 9 498 9 1 2306 138 144 34 1 2370 #createAt:extent: 34 2 498 1 1 498 1329 389 3552 2466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 152 2 0 0 194 0 0 0] 34 1 3648 2528 0 27 410 ##(Smalltalk.Splitter) 34 12 0 3184 34 2 8 1140850688 1 6080 0 626 656 0 519 0 0 0 6080 2306 138 144 34 1 2370 #createAt:extent: 34 2 498 1 389 498 1329 11 6080 2466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 194 0 0 0 152 2 0 0 199 0 0 0] 8 #() 2528 0 27 410 ##(Smalltalk.ContainerView) 34 15 0 3184 34 2 8 1140850688 131073 6320 0 466 31 0 7 0 0 0 6320 530 1 1 0 0 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 6320 34 2 8 1174475012 1025 6416 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 196934 1 ##(Smalltalk.RGB) 30277631 0 7 3826 0 true 34 3 3874 1 898 #copyText 8 'Copy' 1 1 0 0 0 3874 1 898 #restorePicked 8 'Restore picked' 1 1 0 0 0 3874 1 898 #restoreSelection 8 'Restore selection' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 6416 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 11 0 170 192 34 8 #indentGuide 1182790 1 ##(Smalltalk.ScintillaTextStyle) 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 #callTip 6850 77 786694 ##(Smalltalk.IndexedColor) 33554457 6898 33554471 1 0 0 0 0 #callTip 0 0 0 #lineNumber 6850 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #normal 6850 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 6960 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6944 0 0 0 6864 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 0 0 false 138 144 816 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 0 0 0 0 6416 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 816 0 170 176 816 9215 0 0 0 0 6898 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 1 170 192 816 0 0 0 0 3 0 170 192 34 4 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 6416 33423361 5 false 0 61 0 0 0 0 0 8 'indicator0' 7314 1 6416 65025 3 false 0 61 0 0 0 0 0 0 0 170 192 34 6 #Notification 6850 1029 0 6546 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 6850 1027 6546 60239 6546 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 6850 1031 6546 335 6546 31317503 1 0 0 0 0 #Error 0 0 0 0 2306 138 144 34 5 2370 #createAt:extent: 34 2 498 9 1 498 1313 391 6416 2370 #contextMenu: 34 1 6576 6416 2370 #modificationEventMask: 8 #(4607) 6416 2370 #caretPeriod: 8 #(530) 6416 2370 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 6416 1 3 0 0 5 0 7794 3 6416 1 0 0 67108863 5 0 7794 5 6416 1 0 0 0 5 0 6416 2466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 148 2 0 0 195 0 0 0] 8 #() 2528 0 29 170 192 34 2 6416 8 'chunkText' 3330 498 9 1 498 9 1 2306 138 144 34 1 2370 #createAt:extent: 34 2 498 1 399 498 1329 391 6320 2466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 199 0 0 0 152 2 0 0 138 1 0 0] 34 1 6416 2528 0 27 2528 0 27 170 192 34 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 7 3826 0 true 34 9 3874 1 898 #fileOpen 8 '&Open' 8351 1 0 0 0 3874 1 898 #fileOpenPatch 8 'Open Patch File' 1 1 0 0 0 3874 1 898 #clipboardOpen 8 'Open On Clipboard' 1 1 0 0 0 3986 4097 3874 1 898 #pageSetup 8 'Page se&tup...' 1 1 0 0 0 3874 1 898 #printPreview 8 'Print preview...' 1 1 0 0 0 3874 1 898 #print 8 '&Print...' 1 1 0 0 0 3986 4097 3874 1 898 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 39623 0 0 3826 0 true 34 7 3874 1 898 #copyText 8 '&Copy' 8327 1 0 0 0 3874 1 898 #browseChunk 8 '&Browse' 1 1 0 0 0 3986 4097 3874 1 898 #restorePicked 8 'Restore &picked' 1 1 0 0 0 3874 1 898 #restoreSelection 8 'Restore &selected' 9383 1 0 0 0 3986 4097 3874 1 898 #showDifferences 8 'Show &differences' 8355 1 0 0 0 8 '&Edit' 0 1 0 0 39635 0 0 3826 0 true 34 4 3874 1 898 #pickSelection 8 '&Pick selected' 1 1 0 0 0 3874 1 898 #unpickSelection 8 '&Unpick selected' 1 1 0 0 0 3986 4097 3874 1 898 #unpickAll 8 'Unpick &all' 1 1 0 0 0 8 '&Pick' 0 1 0 0 39643 0 0 3826 0 true 34 17 3874 1 898 1234 #toggleChunkType: 8 #(#'Class Category') 8 'Class Category' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#'Class Comment') 8 'Class Comment' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#'Class Define') 8 'Class Define' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#'Class Delete') 8 'Class Delete' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#'Class GUID') 8 'Class GUID' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#'Class Protocol') 8 'Class Protocol' 1 1 0 0 0 3986 4097 3874 1 898 1234 #toggleChunkType: 8 #(#'Method Category') 8 'Method Category' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#'Method Define') 8 'Method Define' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#'Method Delete') 8 'Method Delete' 1 1 0 0 0 3986 4097 3874 1 898 1234 #toggleChunkType: 8 #(#Other) 8 'Other' 1 1 0 0 0 3874 1 898 1234 #toggleChunkType: 8 #(#System) 8 'System' 1 1 0 0 0 3986 4097 3874 1 898 #chunkSelectAll 8 'Select All' 1 1 0 0 0 3874 1 898 #chunkSelectNone 8 'Select None' 1 1 0 0 0 3874 1 898 #chunkSelectDefault 8 'Select Default' 1 1 0 0 0 8 'Chunks' 0 1 0 0 39673 0 0 3826 0 true 34 11 3874 1 898 1234 #toggleComparisonType: 8 #(#Match) 8 'Show Matching' 1 1 0 0 0 3874 1 898 1234 #toggleComparisonType: 8 #(#Differ) 8 'Show Differing' 1 1 0 0 0 3874 1 898 1234 #toggleComparisonType: 8 #(#Missing) 8 'Show Missing' 1 1 0 0 0 3986 4097 3874 1 898 #toggleRestrictingMostRecent 8 'Restrict To Most Recent Only' 1 1 0 0 0 3874 1 898 #restrictionClass 8 'Restrict To Selected Class' 1 1 0 0 0 3874 1 898 #toggleRestrictingPicked 8 'Restrict To Picked' 1 1 0 0 0 3986 4097 3874 1 898 #restrictionRange 8 'Restrict Range - Selection' 1 1 0 0 0 3874 1 898 #restrictionSave 8 'Restrict Range - Since Last Save' 1 1 0 0 0 3874 1 898 #restrictionClear 8 'Clear Range Restricition' 1 1 0 0 0 8 'Filter' 0 1 0 0 39693 0 0 3826 0 true 8 #() 8 '&Tools' #toolsMenu 1 0 0 39695 0 0 3826 0 true 34 2 3874 1 898 #idbHelp 8 '&Help' 1 1 0 0 0 3874 1 898 #idbAbout 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 39701 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 2306 138 144 34 3 2370 #createAt:extent: 34 2 498 3839 21 498 1361 1001 416 2370 #text: 34 1 8 'ChunkBrowser' 416 2370 #updateMenuBar 816 416 2466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 39 10 0 0 254 1 0 0] 34 3 560 3184 2544 2528 0 27 )!

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


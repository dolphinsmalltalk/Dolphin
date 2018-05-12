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

bitmap
	"Answer the chunk browser toolbar bitmap. This is provided for development convenience only - the bitmap is saved directly in the view resource.
		self bitmap
	"

	^(InternalBitmap
		fromFile: (File composePath: self owningPackage path subPath: 'Resources\ChunkBrowserToolbar.png'))
			internalize!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1361 1001 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131137 560 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 560 626 656 8 1888943872 170 192 8 #() 170 192 34 30 37675 853766 ##(Smalltalk.ToolbarButton) 37675 nil 560 5 1180998 4 ##(Smalltalk.CommandDescription) 459270 ##(Smalltalk.Message) #toggleChunkType: 8 #(#'Class Define') 8 'Class Define' 1 1 nil 917766 ##(Smalltalk.InternalBitmap) 852742 ##(Smalltalk.GdiplusBitmap) nil true 2097670 ##(Smalltalk.GdiplusImageFromBytesInitializer) nil 8 #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 1 128 0 0 0 16 8 6 0 0 0 31 214 168 72 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 5 189 73 68 65 84 120 94 237 152 1 114 235 56 12 67 255 209 123 180 222 172 43 200 134 141 160 144 162 200 238 54 78 195 63 175 17 9 80 182 25 143 50 187 255 190 190 190 254 28 159 159 159 111 158 132 18 95 127 153 52 147 55 215 165 124 165 229 123 29 231 104 191 190 75 83 164 3 242 74 248 0 223 92 11 188 132 136 143 143 143 175 127 31 229 133 28 0 94 4 95 98 4 107 35 209 234 79 215 74 156 121 253 52 147 171 195 185 36 237 213 89 95 135 161 128 119 168 31 197 32 44 229 212 48 22 245 123 194 231 118 129 71 41 127 127 179 159 67 75 218 8 231 245 111 79 242 16 236 15 91 15 241 52 253 229 97 102 254 45 215 46 27 149 152 61 64 175 222 207 25 62 2 126 132 188 86 54 171 95 138 215 157 81 223 12 156 135 147 188 74 121 21 202 61 61 206 222 95 146 9 216 143 27 152 249 199 126 5 91 143 6 188 221 126 36 137 53 150 116 205 85 103 141 81 114 126 23 122 129 154 227 19 134 41 202 223 223 236 231 208 146 54 194 121 253 219 147 60 4 251 195 214 67 60 77 127 121 152 153 127 203 181 203 70 37 112 40 234 222 61 206 60 128 127 251 250 156 225 40 252 175 16 175 111 55 215 217 115 196 51 11 103 193 121 32 180 150 122 72 121 21 138 249 113 246 254 146 76 192 126 220 192 204 63 246 43 216 122 52 224 109 246 99 65 24 86 91 150 162 63 24 245 187 193 231 85 241 225 189 185 30 124 129 103 15 208 171 247 167 153 244 104 253 0 128 178 33 54 173 60 162 157 129 206 66 131 245 212 243 138 96 4 124 230 251 12 252 0 120 72 125 89 114 189 236 73 109 11 214 130 86 123 240 121 101 124 128 111 174 5 95 224 122 40 234 139 218 225 204 3 248 183 175 159 102 210 162 119 248 19 222 35 232 213 206 68 231 144 130 122 234 125 53 48 6 62 239 125 26 63 0 248 83 23 107 52 242 229 67 234 15 70 189 7 124 146 229 166 22 180 78 90 117 192 62 210 211 128 234 201 227 154 230 45 216 11 110 135 122 187 183 106 142 234 244 19 245 57 61 175 107 64 245 228 107 233 169 14 216 71 122 26 80 61 121 92 211 188 5 123 73 171 14 84 67 204 30 160 103 245 115 61 138 246 32 102 175 207 57 140 48 242 3 0 202 198 216 252 27 201 123 6 58 135 20 212 83 47 161 39 121 61 79 176 143 140 106 74 203 115 47 87 138 116 115 173 62 79 244 3 176 110 212 205 151 27 188 173 19 234 251 131 236 62 93 183 128 231 104 191 231 220 71 247 109 213 136 106 238 243 92 233 121 93 75 184 167 149 123 157 120 93 115 215 18 238 209 220 181 68 242 120 173 229 65 224 80 228 1 119 143 116 128 207 30 192 236 175 235 112 173 136 246 172 235 217 235 151 25 220 157 45 224 181 147 150 40 155 227 2 27 201 67 204 58 204 237 30 251 44 52 88 87 111 194 61 154 187 150 112 143 230 61 173 85 211 188 167 57 69 218 158 249 62 231 252 47 160 67 96 159 186 87 73 184 78 64 95 110 16 105 91 223 31 100 247 233 186 5 60 71 251 189 198 125 116 223 86 141 168 230 62 207 149 158 215 181 196 61 15 245 150 207 235 154 187 150 112 143 230 174 37 146 199 107 45 15 226 232 1 126 180 159 235 81 180 7 49 123 125 159 71 139 171 252 0 212 205 214 208 154 122 19 238 209 220 181 132 123 52 239 105 189 154 66 253 190 111 125 248 129 128 183 217 143 5 97 88 109 89 238 51 158 2 251 212 189 74 194 181 3 237 246 38 81 30 247 96 237 80 83 79 175 159 235 22 238 209 125 116 223 86 141 168 230 62 207 149 158 23 107 71 189 244 120 141 184 150 188 61 15 214 142 122 233 105 229 174 37 146 199 107 45 15 2 135 34 150 35 164 3 124 246 0 102 255 178 222 175 209 167 252 217 122 150 245 236 253 111 115 232 28 240 71 15 127 146 188 103 194 121 36 240 204 169 135 192 211 202 93 75 192 163 140 106 202 61 79 171 174 20 203 112 192 219 237 71 146 88 99 73 247 252 209 64 47 186 43 235 70 91 174 84 163 145 60 183 15 178 123 116 221 2 158 51 251 117 159 145 26 81 205 125 158 43 61 175 107 137 158 7 154 147 60 173 220 181 132 123 52 119 45 145 60 94 107 121 16 71 15 240 163 253 92 143 162 61 136 217 235 111 115 88 15 249 116 208 63 242 3 80 54 197 198 149 94 237 39 225 92 152 227 121 189 230 184 166 185 107 137 158 71 181 158 79 73 190 145 222 98 25 14 120 135 250 81 12 194 82 94 235 229 19 107 135 218 55 106 185 120 240 185 172 107 49 230 61 77 107 183 15 178 123 116 221 2 158 179 251 245 51 105 9 213 220 231 185 210 243 186 150 112 143 230 61 173 85 211 220 181 132 123 52 119 45 145 60 94 107 121 16 245 80 196 122 128 116 128 207 30 192 236 175 159 131 104 15 215 179 247 127 51 139 240 35 112 244 240 31 209 254 15 56 43 60 123 75 111 229 174 37 122 30 213 90 62 175 39 95 174 237 135 56 214 51 28 235 47 127 38 3 189 232 222 168 133 21 173 113 173 120 29 185 210 211 128 234 201 211 211 128 234 96 25 224 174 115 168 94 119 205 81 157 126 162 62 167 231 117 13 168 158 124 90 83 79 171 142 92 233 105 64 245 228 233 105 64 245 150 47 233 169 134 56 122 128 31 237 231 122 20 237 65 204 94 255 219 60 228 71 64 113 159 83 54 195 134 149 164 131 17 207 79 130 231 230 204 92 99 61 233 174 1 213 233 241 26 113 173 229 69 157 180 244 239 181 109 164 27 238 233 113 188 191 52 76 6 122 209 253 18 164 225 188 121 126 248 2 215 195 33 28 124 137 116 128 207 30 192 103 94 63 121 19 218 31 103 98 254 228 113 202 102 216 240 174 119 212 247 83 112 102 152 65 210 175 198 58 206 141 228 233 113 188 191 52 45 47 211 119 106 121 153 55 97 29 81 107 248 124 21 210 128 222 60 55 245 165 44 193 67 113 36 90 7 240 104 60 83 127 154 9 120 228 240 191 26 120 254 222 179 95 9 124 253 74 242 244 56 222 95 154 38 3 189 232 126 105 210 208 222 60 15 245 37 252 195 164 153 188 185 14 229 43 44 223 227 45 201 215 226 120 127 126 175 198 248 247 245 31 155 10 148 217 161 169 239 34 0 0 0 0 73 69 78 68 174 66 96 130] 3 37677 866 37677 nil 560 5 898 930 #toggleChunkType: 8 #(#'Class Delete') 8 'Class Delete' 1 1 nil 1008 5 37679 866 37679 nil 560 1 898 930 #toggleChunkType: 8 #(#'Class Comment') 8 'Class Comment' 1 1 nil 1008 7 37681 866 37681 nil 560 5 898 930 #toggleChunkType: 8 #(#'Class GUID') 8 'Class GUID' 1 1 nil 1008 9 37683 866 37683 nil 560 1 898 930 #toggleChunkType: 8 #(#'Class Protocol') 8 'Class Protocol' 1 1 nil 1008 39 37685 866 37685 nil 560 5 898 930 #toggleChunkType: 8 #(#'Method Category') 8 'Method Category' 1 1 nil 1008 13 37687 866 37687 nil 560 5 898 930 #toggleChunkType: 8 #(#'Method Define') 8 'Method Define' 1 1 nil 1008 15 37689 866 37689 nil 560 5 898 930 #toggleChunkType: 8 #(#'Method Delete') 8 'Method Delete' 1 1 nil 1008 17 37691 866 37691 nil 560 1 898 930 #toggleChunkType: 8 #(#System) 8 'System' 1 1 nil 1008 41 37693 866 37693 nil 560 5 898 930 #toggleChunkType: 8 #(#Other) 8 'Other' 1 1 nil 1008 19 37665 1246982 ##(Smalltalk.ToolbarSystemButton) 37665 nil 560 1 898 #fileOpen 8 'Open Chunk File' 1 1 nil 1 15 37667 1826 37667 nil 560 1 898 #copyText 8 'Copy Text' 1 1 nil 1 3 37669 866 37669 nil 560 1 898 #showDifferences 8 'Open Differences Browser' 1 1 nil 1008 47 37671 1826 37671 nil 560 1 898 #restoreSelection 8 'Restore Selected Chunk' 1 1 nil 1 9 37673 866 37673 nil 560 5 898 930 #toggleChunkType: 8 #(#'Class Category') 8 'Class Category' 1 1 nil 1008 1 34 17 1050118 ##(Smalltalk.ToolbarSeparator) nil nil 560 3 nil 1 1840 1888 1936 1984 2130 nil nil 560 3 nil 1 2032 880 1104 1184 1264 1344 1424 1504 1584 1664 1744 170 176 34 4 1 1 1008 31 nil 1 nil 498 33 33 498 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 1329 51 560 2338 #updateSizePosted 816 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2512 nil 466 31 nil 7 nil 674 nil true 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 498 193 193 nil 2512 nil 8 1888806592 170 192 34 12 853766 ##(Smalltalk.StatusBarItem) 1 -1 2512 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusReport' 2706 1 321 2512 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusRange' 2706 1 221 2512 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusLast' 2706 1 181 2512 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusClass' 2706 1 321 2512 nil ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) 8 'statusCount' 2706 1 161 2512 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusRestrict' 34 4 2848 2752 2912 2720 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2512 nil nil 2274 138 144 34 1 2338 #createAt:extent: 34 2 498 1 839 498 1329 45 2512 2434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 1 0 0 152 2 0 0 185 1 0 0] 8 #() 2496 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3152 nil 466 31 nil 7 nil nil nil 3152 1180166 ##(Smalltalk.ProportionalLayout) 170 176 816 true 170 192 816 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 2274 138 144 34 1 2338 #createAt:extent: 34 2 498 1 51 498 1329 789 3152 2434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 152 2 0 0 163 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3152 34 2 8 1140850688 131073 3520 nil 466 31 nil 7 nil nil nil 3520 530 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 3520 34 2 8 1140920649 1025 3616 590662 2 ##(Smalltalk.ListModel) 138 144 816 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 626 8 4278190080 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 898 #pickSelection 8 'Pick selection' 1 1 nil nil nil 3842 1 898 #unpickSelection 8 'Unpick selection' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3842 1 898 #restorePicked 8 'Restore picked' 1 1 nil nil nil 3842 1 898 #restoreSelection 8 'Restore selection' 1 1 nil nil nil 3954 4097 3842 1 898 #copyText 8 'Copy' 1 1 nil nil nil 3842 1 898 #browseChunk 8 'Browse' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3616 nil 8 1889021040 ##(Smalltalk.BasicListAbstract) nil 2880 nil nil nil 498 65 65 nil nil 138 144 34 5 920646 5 ##(Smalltalk.ListViewColumn) 8 'Index' 141 #left 787814 3 ##(Smalltalk.BlockClosure) 0 459302 ##(Smalltalk.Context) 1 1 nil nil 1180966 ##(Smalltalk.CompiledExpression) 2 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | o index printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #index #printString 17 257 nil ##(Smalltalk.SortedCollection) nil nil 3616 930 #chunkIconIndex 8 #() 1 nil nil 4274 8 'P' 49 #left 4322 0 4354 1 1 nil nil 4386 1 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | String new]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 1 0 1 1 6 0 17 230 32 45 146 106 100 105] 721414 ##(Smalltalk.Association) #String 16 17 257 nil 4322 0 4354 2 1 nil nil nil 4386 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
	a pickedIconIndex = b pickedIconIndex
		ifTrue: [a index <= b index]
		ifFalse: [a pickedIconIndex > b pickedIconIndex]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 129 106 100 105] #pickedIconIndex #index 17 513 nil nil nil 3616 930 #pickedIconIndex 8 #() 1 nil nil 4274 8 'Type' 301 #left 930 #chunkType 8 #() 4322 0 4354 2 1 nil nil nil 4386 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a chunkType = b chunkType
    ifTrue: [a index <= b index]
    ifFalse: [a chunkType <= b chunkType]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #chunkType #index 17 513 nil nil nil 3616 nil 1 nil nil 4274 8 'Identity1' 301 #left 930 #identity1 8 #() 4322 0 4354 2 1 nil nil nil 4386 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity1 = b identity1
	 ifTrue: [a index <= b index]
    	ifFalse: [a identity1 <= b identity1]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity1 #index 17 513 nil nil nil 3616 nil 1 nil nil 4274 8 'Identity2' 517 #left 930 #identity2 5184 4322 0 4354 2 1 nil nil nil 4386 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity2 = b identity2
	ifTrue: [a index <= b index]
    	ifFalse: [a identity2 <= b identity2]]' 34 1 138 ##(Smalltalk.PoolDictionary) 816 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity2 #index 17 513 nil nil nil 3616 nil 3 nil nil #report 816 nil 131173 nil 8 #(nil) 2274 138 144 34 3 2338 #createAt:extent: 34 2 498 9 9 498 1313 381 3616 2338 #contextMenu: 34 1 3808 3616 2338 #text: 34 1 8 'Index' 3616 2434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 148 2 0 0 194 0 0 0] 8 #() 2496 nil 27 170 192 34 2 3616 8 'chunkList' 3298 498 9 9 498 9 1 2274 138 144 34 1 2338 #createAt:extent: 34 2 498 1 1 498 1329 389 3520 2434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 152 2 0 0 194 0 0 0] 34 1 3616 2496 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3152 34 2 8 1140850688 1 6048 nil 626 656 nil 519 nil nil nil 6048 2274 138 144 34 1 2338 #createAt:extent: 34 2 498 1 389 498 1329 11 6048 2434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 194 0 0 0 152 2 0 0 199 0 0 0] 8 #() 2496 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 3152 34 2 8 1140850688 131073 6288 nil 466 31 nil 7 nil nil nil 6288 530 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 6288 34 2 8 1174475012 1025 6384 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 196934 1 ##(Smalltalk.RGB) 30277631 nil 7 3794 nil true 34 3 3842 1 898 #copyText 8 'Copy' 1 1 nil nil nil 3842 1 898 #restorePicked 8 'Restore picked' 1 1 nil nil nil 3842 1 898 #restoreSelection 8 'Restore selection' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 6384 nil 8 1392098748 852486 ##(Smalltalk.NullConverter) nil nil 11 nil 170 192 34 8 #indentGuide 1182790 1 ##(Smalltalk.ScintillaTextStyle) 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 6818 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 6818 77 786694 ##(Smalltalk.IndexedColor) 33554457 6882 33554471 1 nil nil nil nil #callTip nil nil nil #normal 6818 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 40 6928 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 6848 nil nil nil 6832 nil nil 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 nil nil false 138 144 816 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 6384 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 816 nil 170 176 816 9215 nil nil nil nil 6882 33554447 nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 1 170 192 816 nil nil nil nil 3 nil 170 192 34 4 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 6384 65025 3 false nil 61 nil nil nil nil nil 8 'indicator1' 7282 3 6384 33423361 5 false nil 61 nil nil nil nil nil nil nil 170 192 34 6 #Notification 6818 1029 nil 6514 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 6818 1027 6514 60239 6514 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6818 1031 6514 335 6514 31317503 1 nil nil nil nil #Error nil nil nil nil 2274 138 144 34 8 2338 #createAt:extent: 34 2 498 9 1 498 1313 391 6384 2338 #contextMenu: 34 1 6544 6384 2338 #textLimit: 8 #(1073741823) 6384 2338 #modificationEventMask: 8 #(4607) 6384 2338 #caretPeriod: 8 #(530) 6384 2338 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 6384 1 3 nil nil 5 nil 7794 3 6384 1 nil nil 67108863 5 nil 7794 5 6384 1 nil nil nil 5 nil 6384 2338 #maxCompletionListHeight: 8 #(9) 6384 2338 #sciSetCodePage: 8 #(65001) 6384 2434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 148 2 0 0 195 0 0 0] 8 #() 2496 nil 29 170 192 34 2 6384 8 'chunkText' 3298 498 9 1 498 9 1 2274 138 144 34 1 2338 #createAt:extent: 34 2 498 1 399 498 1329 391 6288 2434 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 199 0 0 0 152 2 0 0 138 1 0 0] 34 1 6384 2496 nil 27 2496 nil 27 170 192 34 2 560 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 7 3794 nil true 34 9 3842 1 898 #fileOpen 8 '&Open' 8351 1 nil nil nil 3842 1 898 #fileOpenPatch 8 'Open Patch File' 1 1 nil nil nil 3842 1 898 #clipboardOpen 8 'Open On Clipboard' 1 1 nil nil nil 3954 4097 3842 1 898 #pageSetup 8 'Page se&tup...' 1 1 nil nil nil 3842 1 898 #printPreview 8 'Print preview...' 1 1 nil nil nil 3842 1 898 #print 8 '&Print...' 1 1 nil nil nil 3954 4097 3842 1 898 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 37585 nil nil 3794 nil true 34 7 3842 1 898 #copyText 8 '&Copy' 8327 1 nil nil nil 3842 1 898 #browseChunk 8 '&Browse' 1 1 nil nil nil 3954 4097 3842 1 898 #restorePicked 8 'Restore &picked' 1 1 nil nil nil 3842 1 898 #restoreSelection 8 'Restore &selected' 9383 1 nil nil nil 3954 4097 3842 1 898 #showDifferences 8 'Show &differences' 8355 1 nil nil nil 8 '&Edit' nil 1 nil nil 37597 nil nil 3794 nil true 34 4 3842 1 898 #pickSelection 8 '&Pick selected' 1 1 nil nil nil 3842 1 898 #unpickSelection 8 '&Unpick selected' 1 1 nil nil nil 3954 4097 3842 1 898 #unpickAll 8 'Unpick &all' 1 1 nil nil nil 8 '&Pick' nil 1 nil nil 37605 nil nil 3794 nil true 34 17 3842 1 898 930 #toggleChunkType: 8 #(#'Class Category') 8 'Class Category' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#'Class Comment') 8 'Class Comment' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#'Class Define') 8 'Class Define' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#'Class Delete') 8 'Class Delete' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#'Class GUID') 8 'Class GUID' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#'Class Protocol') 8 'Class Protocol' 1 1 nil nil nil 3954 4097 3842 1 898 930 #toggleChunkType: 8 #(#'Method Category') 8 'Method Category' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#'Method Define') 8 'Method Define' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#'Method Delete') 8 'Method Delete' 1 1 nil nil nil 3954 4097 3842 1 898 930 #toggleChunkType: 8 #(#Other) 8 'Other' 1 1 nil nil nil 3842 1 898 930 #toggleChunkType: 8 #(#System) 8 'System' 1 1 nil nil nil 3954 4097 3842 1 898 #chunkSelectAll 8 'Select All' 1 1 nil nil nil 3842 1 898 #chunkSelectNone 8 'Select None' 1 1 nil nil nil 3842 1 898 #chunkSelectDefault 8 'Select Default' 1 1 nil nil nil 8 'Chunks' nil 1 nil nil 37635 nil nil 3794 nil true 34 11 3842 1 898 930 #toggleComparisonType: 8 #(#Match) 8 'Show Matching' 1 1 nil nil nil 3842 1 898 930 #toggleComparisonType: 8 #(#Differ) 8 'Show Differing' 1 1 nil nil nil 3842 1 898 930 #toggleComparisonType: 8 #(#Missing) 8 'Show Missing' 1 1 nil nil nil 3954 4097 3842 1 898 #toggleRestrictingMostRecent 8 'Restrict To Most Recent Only' 1 1 nil nil nil 3842 1 898 #restrictionClass 8 'Restrict To Selected Class' 1 1 nil nil nil 3842 1 898 #toggleRestrictingPicked 8 'Restrict To Picked' 1 1 nil nil nil 3954 4097 3842 1 898 #restrictionRange 8 'Restrict Range - Selection' 1 1 nil nil nil 3842 1 898 #restrictionSave 8 'Restrict Range - Since Last Save' 1 1 nil nil nil 3842 1 898 #restrictionClear 8 'Clear Range Restricition' 1 1 nil nil nil 8 'Filter' nil 1 nil nil 37655 nil nil 3794 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 37657 nil nil 3794 nil true 34 2 3842 1 898 #idbHelp 8 '&Help' 1 1 nil nil nil 3842 1 898 #idbAbout 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 37663 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 2274 138 144 34 3 2338 #createAt:extent: 34 2 498 3839 21 498 1361 1001 416 2338 #text: 34 1 8 'ChunkBrowser' 416 2338 #updateMenuBar 816 416 2434 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 39 10 0 0 254 1 0 0] 34 3 560 3152 2512 2496 nil 27 )!

stFileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^(OrderedCollection new)
		add: #('Smalltalk Files (*.st)' '*.st');
		add: #('All Files (*.*)' '*.*');
		yourself! !
!ChunkBrowser class categoriesFor: #bitmap!constants!development!public! !
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


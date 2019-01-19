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

helpFileStem
	^'idbchunkbrowser'!

idbAbout
	"Display the about view"

	self
		idbAbout:
			'<n>Chunk Browser<n>for<n>Dolphin Smalltalk 7<n><n>Version 7c<n>© 2005 Ian Bartholomew<n>http://www.idb.me.uk'
				expandMacros!

idbHelp
	self idbHelp: self helpFileStem!

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
			[aCommandQuery isEnabled: filter isRestrictingClass
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
	#idbHelp == aCommandQuery command
		ifTrue: 
			[aCommandQuery
				isEnabled: (File exists: (File
								composePath: SessionManager current idbDocumentationFolder
								stem: self helpFileStem
								extension: 'html')).
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
!ChunkBrowser categoriesFor: #helpFileStem!constants!private! !
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
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon
		text: $\x203C
		fontName: 'Georgia'
		color: (Color
				r: 0
				g: 105
				b: 175))!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1361 1001 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131137 560 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 519 nil nil nil 560 640 8 1915204752 170 192 8 #() 170 192 34 30 48117 1246790 1 ##(Smalltalk.ToolbarSystemButton) 560 1 1180998 4 ##(Smalltalk.CommandDescription) #copyText 8 'Copy Text' 1 1 nil 48117 1 3 48119 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 560 1 786 #showDifferences 8 'Open Differences Browser' 1 1 nil 48119 917766 ##(Smalltalk.InternalBitmap) 852742 ##(Smalltalk.GdiplusBitmap) nil true 2097670 ##(Smalltalk.GdiplusImageFromBytesInitializer) nil 8 #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 1 128 0 0 0 16 8 6 0 0 0 31 214 168 72 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 5 189 73 68 65 84 120 94 237 152 1 114 235 56 12 67 255 209 123 180 222 172 43 200 134 141 160 144 162 200 238 54 78 195 63 175 17 9 80 182 25 143 50 187 255 190 190 190 254 28 159 159 159 111 158 132 18 95 127 153 52 147 55 215 165 124 165 229 123 29 231 104 191 190 75 83 164 3 242 74 248 0 223 92 11 188 132 136 143 143 143 175 127 31 229 133 28 0 94 4 95 98 4 107 35 209 234 79 215 74 156 121 253 52 147 171 195 185 36 237 213 89 95 135 161 128 119 168 31 197 32 44 229 212 48 22 245 123 194 231 118 129 71 41 127 127 179 159 67 75 218 8 231 245 111 79 242 16 236 15 91 15 241 52 253 229 97 102 254 45 215 46 27 149 152 61 64 175 222 207 25 62 2 126 132 188 86 54 171 95 138 215 157 81 223 12 156 135 147 188 74 121 21 202 61 61 206 222 95 146 9 216 143 27 152 249 199 126 5 91 143 6 188 221 126 36 137 53 150 116 205 85 103 141 81 114 126 23 122 129 154 227 19 134 41 202 223 223 236 231 208 146 54 194 121 253 219 147 60 4 251 195 214 67 60 77 127 121 152 153 127 203 181 203 70 37 112 40 234 222 61 206 60 128 127 251 250 156 225 40 252 175 16 175 111 55 215 217 115 196 51 11 103 193 121 32 180 150 122 72 121 21 138 249 113 246 254 146 76 192 126 220 192 204 63 246 43 216 122 52 224 109 246 99 65 24 86 91 150 162 63 24 245 187 193 231 85 241 225 189 185 30 124 129 103 15 208 171 247 167 153 244 104 253 0 128 178 33 54 173 60 162 157 129 206 66 131 245 212 243 138 96 4 124 230 251 12 252 0 120 72 125 89 114 189 236 73 109 11 214 130 86 123 240 121 101 124 128 111 174 5 95 224 122 40 234 139 218 225 204 3 248 183 175 159 102 210 162 119 248 19 222 35 232 213 206 68 231 144 130 122 234 125 53 48 6 62 239 125 26 63 0 248 83 23 107 52 242 229 67 234 15 70 189 7 124 146 229 166 22 180 78 90 117 192 62 210 211 128 234 201 227 154 230 45 216 11 110 135 122 187 183 106 142 234 244 19 245 57 61 175 107 64 245 228 107 233 169 14 216 71 122 26 80 61 121 92 211 188 5 123 73 171 14 84 67 204 30 160 103 245 115 61 138 246 32 102 175 207 57 140 48 242 3 0 202 198 216 252 27 201 123 6 58 135 20 212 83 47 161 39 121 61 79 176 143 140 106 74 203 115 47 87 138 116 115 173 62 79 244 3 176 110 212 205 151 27 188 173 19 234 251 131 236 62 93 183 128 231 104 191 231 220 71 247 109 213 136 106 238 243 92 233 121 93 75 184 167 149 123 157 120 93 115 215 18 238 209 220 181 68 242 120 173 229 65 224 80 228 1 119 143 116 128 207 30 192 236 175 235 112 173 136 246 172 235 217 235 151 25 220 157 45 224 181 147 150 40 155 227 2 27 201 67 204 58 204 237 30 251 44 52 88 87 111 194 61 154 187 150 112 143 230 61 173 85 211 188 167 57 69 218 158 249 62 231 252 47 160 67 96 159 186 87 73 184 78 64 95 110 16 105 91 223 31 100 247 233 186 5 60 71 251 189 198 125 116 223 86 141 168 230 62 207 149 158 215 181 196 61 15 245 150 207 235 154 187 150 112 143 230 174 37 146 199 107 45 15 226 232 1 126 180 159 235 81 180 7 49 123 125 159 71 139 171 252 0 212 205 214 208 154 122 19 238 209 220 181 132 123 52 239 105 189 154 66 253 190 111 125 248 129 128 183 217 143 5 97 88 109 89 238 51 158 2 251 212 189 74 194 181 3 237 246 38 81 30 247 96 237 80 83 79 175 159 235 22 238 209 125 116 223 86 141 168 230 62 207 149 158 23 107 71 189 244 120 141 184 150 188 61 15 214 142 122 233 105 229 174 37 146 199 107 45 15 2 135 34 150 35 164 3 124 246 0 102 255 178 222 175 209 167 252 217 122 150 245 236 253 111 115 232 28 240 71 15 127 146 188 103 194 121 36 240 204 169 135 192 211 202 93 75 192 163 140 106 202 61 79 171 174 20 203 112 192 219 237 71 146 88 99 73 247 252 209 64 47 186 43 235 70 91 174 84 163 145 60 183 15 178 123 116 221 2 158 51 251 117 159 145 26 81 205 125 158 43 61 175 107 137 158 7 154 147 60 173 220 181 132 123 52 119 45 145 60 94 107 121 16 71 15 240 163 253 92 143 162 61 136 217 235 111 115 88 15 249 116 208 63 242 3 80 54 197 198 149 94 237 39 225 92 152 227 121 189 230 184 166 185 107 137 158 71 181 158 79 73 190 145 222 98 25 14 120 135 250 81 12 194 82 94 235 229 19 107 135 218 55 106 185 120 240 185 172 107 49 230 61 77 107 183 15 178 123 116 221 2 158 179 251 245 51 105 9 213 220 231 185 210 243 186 150 112 143 230 61 173 85 211 220 181 132 123 52 119 45 145 60 94 107 121 16 245 80 196 122 128 116 128 207 30 192 236 175 159 131 104 15 215 179 247 127 51 139 240 35 112 244 240 31 209 254 15 56 43 60 123 75 111 229 174 37 122 30 213 90 62 175 39 95 174 237 135 56 214 51 28 235 47 127 38 3 189 232 222 168 133 21 173 113 173 120 29 185 210 211 128 234 201 211 211 128 234 96 25 224 174 115 168 94 119 205 81 157 126 162 62 167 231 117 13 168 158 124 90 83 79 171 142 92 233 105 64 245 228 233 105 64 245 150 47 233 169 134 56 122 128 31 237 231 122 20 237 65 204 94 255 219 60 228 71 64 113 159 83 54 195 134 149 164 131 17 207 79 130 231 230 204 92 99 61 233 174 1 213 233 241 26 113 173 229 69 157 180 244 239 181 109 164 27 238 233 113 188 191 52 76 6 122 209 253 18 164 225 188 121 126 248 2 215 195 33 28 124 137 116 128 207 30 192 103 94 63 121 19 218 31 103 98 254 228 113 202 102 216 240 174 119 212 247 83 112 102 152 65 210 175 198 58 206 141 228 233 113 188 191 52 45 47 211 119 106 121 153 55 97 29 81 107 248 124 21 210 128 222 60 55 245 165 44 193 67 113 36 90 7 240 104 60 83 127 154 9 120 228 240 191 26 120 254 222 179 95 9 124 253 74 242 244 56 222 95 154 38 3 189 232 126 105 210 208 222 60 15 245 37 252 195 164 153 188 185 14 229 43 44 223 227 45 201 215 226 120 127 126 175 198 248 247 245 31 155 10 148 217 161 169 239 34 0 0 0 0 73 69 78 68 174 66 96 130] 47 48121 754 560 1 786 #restoreSelection 8 'Restore Selected Chunk' 1 1 nil 48121 1 9 48123 834 560 5 786 459270 ##(Smalltalk.Message) #toggleChunkType: 8 #(#'Class Category') 8 'Class Category' 1 1 nil 48123 912 1 48125 834 560 5 786 1090 #toggleChunkType: 8 #(#'Class Define') 8 'Class Define' 1 1 nil 48125 912 3 48127 834 560 5 786 1090 #toggleChunkType: 8 #(#'Class Delete') 8 'Class Delete' 1 1 nil 48127 912 5 48129 834 560 1 786 1090 #toggleChunkType: 8 #(#'Class Comment') 8 'Class Comment' 1 1 nil 48129 912 7 48131 834 560 5 786 1090 #toggleChunkType: 8 #(#'Class GUID') 8 'Class GUID' 1 1 nil 48131 912 9 48133 834 560 1 786 1090 #toggleChunkType: 8 #(#'Class Protocol') 8 'Class Protocol' 1 1 nil 48133 912 39 48135 834 560 5 786 1090 #toggleChunkType: 8 #(#'Method Category') 8 'Method Category' 1 1 nil 48135 912 13 48137 834 560 5 786 1090 #toggleChunkType: 8 #(#'Method Define') 8 'Method Define' 1 1 nil 48137 912 15 48139 834 560 5 786 1090 #toggleChunkType: 8 #(#'Method Delete') 8 'Method Delete' 1 1 nil 48139 912 17 48141 834 560 1 786 1090 #toggleChunkType: 8 #(#System) 8 'System' 1 1 nil 48141 912 41 48143 834 560 5 786 1090 #toggleChunkType: 8 #(#Other) 8 'Other' 1 1 nil 48143 912 19 48115 754 560 1 786 #fileOpen 8 'Open Chunk File' 1 1 nil 48115 1 15 34 17 1049158 1 ##(Smalltalk.ToolbarSeparator) 560 1 1952 768 848 1008 2018 560 1 1056 1152 1232 1312 1392 1472 1552 1632 1712 1792 1872 nil nil 1 nil 498 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 1329 51 560 2178 #updateSizePosted 704 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2352 nil 480 nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 498 193 193 nil 2352 nil 8 1914952576 170 192 34 12 853766 ##(Smalltalk.StatusBarItem) 1 321 2352 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusRange' 2562 1 161 2352 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusRestrict' 2562 1 221 2352 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusLast' 2562 1 321 2352 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusCount' 2562 1 -1 2352 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusReport' 2562 1 181 2352 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusClass' 34 4 2672 2576 2608 2704 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2352 nil nil 2114 138 144 34 1 2178 #createAt:extent: 34 2 498 1 839 498 1329 45 2352 2274 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 1 0 0 152 2 0 0 185 1 0 0] 8 #() 2336 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2976 nil 480 nil 7 nil nil nil 2976 1180166 ##(Smalltalk.ProportionalLayout) 170 176 704 true 170 192 704 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 2114 138 144 34 1 2178 #createAt:extent: 34 2 498 1 51 498 1329 789 2976 2274 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 152 2 0 0 163 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2976 34 2 8 1140850688 131073 3328 nil 480 nil 7 nil nil nil 3328 530 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 3328 34 2 8 1140920649 1025 3408 590662 2 ##(Smalltalk.ListModel) 138 144 704 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 640 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 786 #pickSelection 8 'Pick selection' 1 1 nil nil nil 3602 1 786 #unpickSelection 8 'Unpick selection' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3602 1 786 #restorePicked 8 'Restore picked' 1 1 nil nil nil 3602 1 786 #restoreSelection 8 'Restore selection' 1 1 nil nil nil 3714 4097 3602 1 786 #copyText 8 'Copy' 1 1 nil nil nil 3602 1 786 #browseChunk 8 'Browse' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3408 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 498 65 65 nil nil 138 144 34 5 920646 5 ##(Smalltalk.ListViewColumn) 8 'Index' 141 #left 787814 3 ##(Smalltalk.BlockClosure) 0 459302 ##(Smalltalk.Context) 1 1 nil nil 1180966 ##(Smalltalk.CompiledExpression) 2 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | o index printString]' 34 1 138 ##(Smalltalk.PoolDictionary) 704 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] #index #printString 17 257 nil 1090 #<= 8 #() nil nil 3408 1090 #chunkIconIndex 8 #() 1 nil nil 4066 8 'P' 49 #left 4114 0 4146 1 1 nil nil 4178 1 9 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:o | String new]' 34 1 138 ##(Smalltalk.PoolDictionary) 704 8 #[252 1 0 1 1 6 0 17 230 32 45 146 106 100 105] 721414 ##(Smalltalk.Association) #String 16 17 257 nil 4114 0 4146 2 1 nil nil nil 4178 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
	a pickedIconIndex = b pickedIconIndex
		ifTrue: [a index <= b index]
		ifFalse: [a pickedIconIndex > b pickedIconIndex]]' 34 1 138 ##(Smalltalk.PoolDictionary) 704 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 129 106 100 105] #pickedIconIndex #index 17 513 nil nil nil 3408 1090 #pickedIconIndex 8 #() 1 nil nil 4066 8 'Type' 301 #left 1090 #chunkType 8 #() 4114 0 4146 2 1 nil nil nil 4178 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a chunkType = b chunkType
    ifTrue: [a index <= b index]
    ifFalse: [a chunkType <= b chunkType]]' 34 1 138 ##(Smalltalk.PoolDictionary) 704 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #chunkType #index 17 513 nil nil nil 3408 nil 1 nil nil 4066 8 'Identity1' 301 #left 1090 #identity1 8 #() 4114 0 4146 2 1 nil nil nil 4178 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity1 = b identity1
	 ifTrue: [a index <= b index]
    	ifFalse: [a identity1 <= b identity1]]' 34 1 138 ##(Smalltalk.PoolDictionary) 704 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity1 #index 17 513 nil nil nil 3408 nil 1 nil nil 4066 8 'Identity2' 517 #left 1090 #identity2 5008 4114 0 4146 2 1 nil nil nil 4178 2 13 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[:a :b | 
 a identity2 = b identity2
	ifTrue: [a index <= b index]
    	ifFalse: [a identity2 <= b identity2]]' 34 1 138 ##(Smalltalk.PoolDictionary) 704 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] #identity2 #index 17 513 nil nil nil 3408 nil 3 nil nil #report 704 nil 131173 nil 34 4 nil nil 498 1 1 nil 2114 138 144 34 3 2178 #createAt:extent: 34 2 498 9 9 498 1313 381 3408 2178 #contextMenu: 34 1 3568 3408 2178 #text: 34 1 8 'Index' 3408 2274 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 148 2 0 0 194 0 0 0] 8 #() 2336 nil 27 170 192 34 2 3408 8 'chunkList' 3106 498 9 9 498 9 1 2114 138 144 34 1 2178 #createAt:extent: 34 2 498 1 1 498 1329 389 3328 2274 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 152 2 0 0 194 0 0 0] 34 1 3408 2336 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 2976 34 2 8 1140850688 1 5888 nil 640 nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 5888 nil 1 #left nil nil nil 5376 498 9 9 nil 5376 nil 2114 138 144 34 1 2178 #createAt:extent: 34 2 498 1 389 498 1329 11 5888 2274 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 194 0 0 0 152 2 0 0 199 0 0 0] 8 #() 2336 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2976 34 2 8 1140850688 131073 6160 nil 480 nil 7 nil nil nil 6160 530 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 6160 34 2 8 1174475012 1025 6240 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 196934 1 ##(Smalltalk.RGB) 30277631 nil 7 3554 nil true 34 3 3602 1 786 #copyText 8 'Copy' 1 1 nil nil nil 3602 1 786 #restorePicked 8 'Restore picked' 1 1 nil nil nil 3602 1 786 #restoreSelection 8 'Restore selection' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 6240 nil 523476179 852486 ##(Smalltalk.NullConverter) nil nil 11 nil 170 192 34 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6658 77 786694 ##(Smalltalk.IndexedColor) 33554457 6706 33554471 1 nil nil nil nil #callTip nil nil nil #indentGuide 6658 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 6658 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil 34 40 6672 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 6768 nil nil nil 6752 nil nil 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 nil nil false 138 144 704 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 6240 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 704 nil 170 176 704 9215 nil nil nil nil 6706 33554447 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' 8 '' 1 170 192 704 nil nil nil nil 130003 nil 170 192 34 4 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 6240 33423361 5 false nil 61 nil nil nil nil nil 8 'indicator0' 7122 1 6240 65025 3 false nil 61 nil nil nil nil nil nil nil 170 192 34 6 #Notification 6658 1029 nil 6370 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 6658 1027 6370 60239 6370 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6658 1031 6370 335 6370 31317503 1 nil nil nil nil #Error nil nil nil nil 2114 138 144 34 7 2178 #createAt:extent: 34 2 498 9 1 498 1313 391 6240 2178 #contextMenu: 34 1 6400 6240 2178 #textLimit: 8 #(1073741823) 6240 2178 #modificationEventMask: 8 #(4607) 6240 2178 #caretPeriod: 8 #(530) 6240 2178 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 6240 1 3 nil nil 5 nil 7634 3 6240 1 nil nil 67108863 5 nil 7634 5 6240 1 nil nil nil 5 nil 6240 2178 #maxCompletionListHeight: 8 #(9) 6240 2274 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 148 2 0 0 195 0 0 0] 8 #() 2336 nil 29 170 192 34 2 6240 8 'chunkText' 3106 498 9 1 498 9 1 2114 138 144 34 1 2178 #createAt:extent: 34 2 498 1 399 498 1329 391 6160 2274 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 199 0 0 0 152 2 0 0 138 1 0 0] 34 1 6240 2336 nil 27 2336 nil 27 170 192 704 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 7 3554 nil true 34 9 3602 1 786 #fileOpen 8 '&Open' 8351 1 nil nil nil 3602 1 786 #fileOpenPatch 8 'Open Patch File' 1 1 nil nil nil 3602 1 786 #clipboardOpen 8 'Open On Clipboard' 1 1 nil nil nil 3714 4097 3602 1 786 #pageSetup 8 'Page se&tup...' 1 1 nil nil nil 3602 1 786 #printPreview 8 'Print preview...' 1 1 nil nil nil 3602 1 786 #print 8 '&Print...' 1 1 nil nil nil 3714 4097 3602 1 786 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 48035 nil nil 3554 nil true 34 7 3602 1 786 #copyText 8 '&Copy' 8327 1 nil nil nil 3602 1 786 #browseChunk 8 '&Browse' 1 1 nil nil nil 3714 4097 3602 1 786 #restorePicked 8 'Restore &picked' 1 1 nil nil nil 3602 1 786 #restoreSelection 8 'Restore &selected' 9383 1 nil nil nil 3714 4097 3602 1 786 #showDifferences 8 'Show &differences' 8355 1 nil nil nil 8 '&Edit' nil 1 nil nil 48047 nil nil 3554 nil true 34 4 3602 1 786 #pickSelection 8 '&Pick selected' 1 1 nil nil nil 3602 1 786 #unpickSelection 8 '&Unpick selected' 1 1 nil nil nil 3714 4097 3602 1 786 #unpickAll 8 'Unpick &all' 1 1 nil nil nil 8 '&Pick' nil 1 nil nil 48055 nil nil 3554 nil true 34 17 3602 1 786 1090 #toggleChunkType: 8 #(#'Class Category') 8 'Class Category' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#'Class Comment') 8 'Class Comment' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#'Class Define') 8 'Class Define' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#'Class Delete') 8 'Class Delete' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#'Class GUID') 8 'Class GUID' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#'Class Protocol') 8 'Class Protocol' 1 1 nil nil nil 3714 4097 3602 1 786 1090 #toggleChunkType: 8 #(#'Method Category') 8 'Method Category' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#'Method Define') 8 'Method Define' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#'Method Delete') 8 'Method Delete' 1 1 nil nil nil 3714 4097 3602 1 786 1090 #toggleChunkType: 8 #(#Other) 8 'Other' 1 1 nil nil nil 3602 1 786 1090 #toggleChunkType: 8 #(#System) 8 'System' 1 1 nil nil nil 3714 4097 3602 1 786 #chunkSelectAll 8 'Select All' 1 1 nil nil nil 3602 1 786 #chunkSelectNone 8 'Select None' 1 1 nil nil nil 3602 1 786 #chunkSelectDefault 8 'Select Default' 1 1 nil nil nil 8 'Chunks' nil 1 nil nil 48085 nil nil 3554 nil true 34 11 3602 1 786 1090 #toggleComparisonType: 8 #(#Match) 8 'Show Matching' 1 1 nil nil nil 3602 1 786 1090 #toggleComparisonType: 8 #(#Differ) 8 'Show Differing' 1 1 nil nil nil 3602 1 786 1090 #toggleComparisonType: 8 #(#Missing) 8 'Show Missing' 1 1 nil nil nil 3714 4097 3602 1 786 #toggleRestrictingMostRecent 8 'Restrict To Most Recent Only' 1 1 nil nil nil 3602 1 786 #restrictionClass 8 'Restrict To Selected Class' 1 1 nil nil nil 3602 1 786 #toggleRestrictingPicked 8 'Restrict To Picked' 1 1 nil nil nil 3714 4097 3602 1 786 #restrictionRange 8 'Restrict Range - Selection' 1 1 nil nil nil 3602 1 786 #restrictionSave 8 'Restrict Range - Since Last Save' 1 1 nil nil nil 3602 1 786 #restrictionClear 8 'Clear Range Restricition' 1 1 nil nil nil 8 'Filter' nil 1 nil nil 48105 nil nil 3554 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 48107 nil nil 3554 nil true 34 2 3602 1 786 #idbHelp 8 '&Help' 1 1 nil nil nil 3602 1 786 #idbAbout 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 48113 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 2114 138 144 34 3 2178 #createAt:extent: 34 2 498 3839 21 498 1361 1001 416 2178 #text: 34 1 8 'ChunkBrowser' 416 2178 #updateMenuBar 704 416 2274 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 39 10 0 0 254 1 0 0] 34 3 560 2976 2352 2336 nil 27 )!

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


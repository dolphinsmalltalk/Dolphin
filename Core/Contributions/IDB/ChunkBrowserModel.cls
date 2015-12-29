"Filed out from Dolphin Smalltalk X6"!

Model subclass: #ChunkBrowserModel
	instanceVariableNames: 'chunks'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserModel guid: (GUID fromString: '{806C497C-FE7E-440D-A6EB-4E4AE9D6ACED}')!
ChunkBrowserModel comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserModel categoriesForClass!IDB Goodies! !
!ChunkBrowserModel methodsFor!

chunkCount
	^chunks size!

decodeChunkFromText: aString 
	| chunkClass |
	chunkClass := ChunkBrowserChunk chunkClasses detect: [:each | each isChunkClassFor: aString]
				ifNone: [ChunkBrowserOtherChunk].
	^chunkClass fromText: aString!

fileInChunkSeriesFrom: aChunkSourceFiler after: aChunk 
	| chunk chunkSeries |
	chunkSeries := OrderedCollection new.
	chunk := aChunkSourceFiler nextChunk.
	[chunk isEmpty] whileFalse: 
			[chunkSeries add: (aChunk seriesChunk: chunk).
			chunk := aChunkSourceFiler nextChunk].
	^chunkSeries!

fileInChunksFrom: aStream 
	| chunksLoaded sourceFiler |
	chunksLoaded := OrderedCollection new.
	sourceFiler := ChunkSourceFiler on: aStream.
	[aStream atEnd] whileFalse: 
			[| chunkSource |
			chunkSource := sourceFiler nextChunk.
			chunkSource isEmpty 
				ifFalse: 
					[| chunk |
					chunk := self decodeChunkFromText: chunkSource.
					chunk isChunkSeriesStart 
						ifTrue: [chunksLoaded addAll: (self fileInChunkSeriesFrom: sourceFiler after: chunk)]
						ifFalse: [chunksLoaded add: chunk]]].
	chunksLoaded keysAndValuesDo: [:index :each | each index: index].
	^chunksLoaded!

fileOpen: aString 
	| stream |
	stream := FileStream read: aString.
	[self fromStream: stream] ensure: [stream close]!

fileOpenPatch: aString 
	"Dolphin LiveUpdate file.
	Assumes 6 chunks, the first 5 contain information about the patch and
	the sixth contains all the new sorce code"

	| stream |
	stream := FileStream read: aString.
	
	[| loadedChunks sourceChunks |
	loadedChunks := self fileInChunksFrom: stream.
	self assert: [loadedChunks size = 6].
	sourceChunks := self fileInChunksFrom: (loadedChunks at: 6) rawText readStream.
	sourceChunks do: [:each | each index: each index + 5].
	chunks := (loadedChunks copyFrom: 1 to: 5) , sourceChunks] 
			ensure: [stream close]!

filteredChunksUsing: aChunkBrowserFilter 
	| filtered mostRecent |
	filtered := OrderedCollection new.
	mostRecent := Set new.
	chunks do: 
			[:each | 
			(each filterUsing: aChunkBrowserFilter) 
				ifTrue: 
					[filtered add: each.
					aChunkBrowserFilter isRestrictingMostRecent 
						ifTrue: 
							[(mostRecent includes: each) ifTrue: [mostRecent remove: each].
							mostRecent add: each]]].
	^(aChunkBrowserFilter isRestrictingMostRecent ifTrue: [mostRecent] ifFalse: [filtered]) 
		asSortedCollection!

filterUsing: aChunkBrowserFilter 
	| filtered mostRecent |
	filtered := OrderedCollection new.
	mostRecent := Set new.
	chunks do: 
			[:each | 
			(each filterUsing: aChunkBrowserFilter) 
				ifTrue: 
					[filtered add: each.
					aChunkBrowserFilter isRestrictingMostRecent 
						ifTrue: 
							[(mostRecent includes: each) ifTrue: [mostRecent remove: each].
							mostRecent add: each]]].
	^(aChunkBrowserFilter isRestrictingMostRecent ifTrue: [mostRecent] ifFalse: [filtered]) 
		asSortedCollection!

fromStream: aStream 
	chunks := self fileInChunksFrom: aStream!

hasAnyChunksPicked
	^chunks anySatisfy: [:each | each picked]!

hasChunks
	^chunks isEmpty not!

indexOfLastImageSave
	| imageSaveChunks |
	imageSaveChunks := chunks select: [:each | each isImageSave].
	imageSaveChunks isEmpty ifTrue: [^1].
	^imageSaveChunks inject: 1 into: [:max :each | each index max: max]!

initialize
	super initialize.
	chunks := OrderedCollection new!

pickedChunks
	^chunks select: [:each | each picked]!

unpickAll
	chunks do: [:each | each picked: false]! !
!ChunkBrowserModel categoriesFor: #chunkCount!helpers!public! !
!ChunkBrowserModel categoriesFor: #decodeChunkFromText:!operations!public! !
!ChunkBrowserModel categoriesFor: #fileInChunkSeriesFrom:after:!operations!public! !
!ChunkBrowserModel categoriesFor: #fileInChunksFrom:!operations!public! !
!ChunkBrowserModel categoriesFor: #fileOpen:!operations!public! !
!ChunkBrowserModel categoriesFor: #fileOpenPatch:!operations!public! !
!ChunkBrowserModel categoriesFor: #filteredChunksUsing:!operations!public! !
!ChunkBrowserModel categoriesFor: #filterUsing:!operations!public! !
!ChunkBrowserModel categoriesFor: #fromStream:!operations!public! !
!ChunkBrowserModel categoriesFor: #hasAnyChunksPicked!public!testing! !
!ChunkBrowserModel categoriesFor: #hasChunks!public!testing! !
!ChunkBrowserModel categoriesFor: #indexOfLastImageSave!helpers!public! !
!ChunkBrowserModel categoriesFor: #initialize!initializing!public! !
!ChunkBrowserModel categoriesFor: #pickedChunks!accessing!public! !
!ChunkBrowserModel categoriesFor: #unpickAll!operations!public! !


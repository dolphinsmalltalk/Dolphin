"Filed out from Dolphin Smalltalk"!

Model subclass: #ChunkBrowserModel
	instanceVariableNames: 'chunks'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserModel guid: (GUID fromString: '{806c497c-fe7e-440d-a6eb-4e4ae9d6aced}')!

ChunkBrowserModel comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserModel categoriesForClass!IDB Goodies! !

!ChunkBrowserModel methodsFor!

chunkClass
	^ChunkBrowserChunk!

chunkCount
	^chunks size!

filteredUsing: aChunkBrowserFilter
	| filtered mostRecent |
	filtered := chunks select: [:each | each isFilteredUsing: aChunkBrowserFilter].
	aChunkBrowserFilter isRestrictingMostRecent ifFalse: [^filtered asSortedCollection].
	mostRecent := Set new.
	filtered reverseDo: [:each | (mostRecent includes: each) ifFalse: [mostRecent add: each]].
	^mostRecent asSortedCollection!

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

loadFromFile: aString
	| stream |
	stream := FileStream
				read: aString
				type: #text
				share: #readWrite.
	chunks := [self chunkClass chunksFromStream: stream] ensure: [stream close]!

loadFromPatchFile: aString
	"Dolphin LiveUpdate file.
	Assumes 6 chunks, the first 5 contain information about the patch and
	the sixth contains all the new source code"

	self loadFromFile: aString.
	chunks size = 6 ifFalse: [^MessageBox notify: 'Not a patch file'].
	chunks addAll: (self chunkClass chunksFromText: chunks removeLast rawText).
	chunks keysAndValuesDo: [:index :each | each index: index]!

loadFromText: aString
	chunks := self chunkClass chunksFromText: aString!

pickedChunks
	^chunks select: [:each | each picked]!

unpickAll
	chunks do: [:each | each picked: false]! !

!ChunkBrowserModel categoriesForMethods!
chunkClass!accessing!public! !
chunkCount!helpers!public! !
filteredUsing:!operations!public! !
hasAnyChunksPicked!public!testing! !
hasChunks!public!testing! !
indexOfLastImageSave!helpers!public! !
initialize!initializing!public! !
loadFromFile:!operations!public! !
loadFromPatchFile:!operations!public! !
loadFromText:!operations!public! !
pickedChunks!accessing!public! !
unpickAll!operations!public! !
!


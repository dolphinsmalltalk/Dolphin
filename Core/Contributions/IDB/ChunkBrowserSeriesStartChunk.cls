"Filed out from Dolphin Smalltalk"!

ChunkBrowserChunk subclass: #ChunkBrowserSeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserSeriesStartChunk guid: (GUID fromString: '{24f42e2c-7a1f-4252-bdfe-4584ed820429}')!

ChunkBrowserSeriesStartChunk isAbstract: true!

ChunkBrowserSeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserSeriesStartChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserSeriesStartChunk methodsFor!

addChunksFrom: aChunkSourceFiler to: anOrderedCollection
	| seriesChunkText |
	
	[seriesChunkText := aChunkSourceFiler nextChunk.
	seriesChunkText isEmpty] whileFalse: 
				[(self seriesClass newFor: seriesChunkText start: self) addChunksFrom: aChunkSourceFiler
					to: anOrderedCollection]!

browseTarget
	self shouldNotImplement!

initialize: aString tokens: anArray
	super initialize: aString tokens: anArray.
	identity1 := self classIdentityFromTokenStream: (ReadStream on: anArray)!

isMatch
	self shouldNotImplement!

restore
	self shouldNotImplement!

seriesClass
	self subclassResponsibility! !

!ChunkBrowserSeriesStartChunk categoriesForMethods!
addChunksFrom:to:!operations!public! !
browseTarget!operations!public! !
initialize:tokens:!initializing!private! !
isMatch!public!testing! !
restore!operations!public! !
seriesClass!constants!public! !
!

!ChunkBrowserSeriesStartChunk class methodsFor!

chunkType
	self shouldNotImplement! !

!ChunkBrowserSeriesStartChunk class categoriesForMethods!
chunkType!constants!public! !
!


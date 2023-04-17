"Filed out from Dolphin Smalltalk"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserMethodsCategoriesSeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserMethodsCategoriesSeriesStartChunk guid: (GUID fromString: '{f8439b0f-caec-4c70-81ac-875f0941e0d9}')!
ChunkBrowserMethodsCategoriesSeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodsCategoriesSeriesStartChunk categoriesForClass!Unclassified! !
!ChunkBrowserMethodsCategoriesSeriesStartChunk methodsFor!

addChunksFrom: aChunkSourceFiler to: anOrderedCollection
	[(identity2 := aChunkSourceFiler nextChunk) isEmpty]
		whileFalse: [super addChunksFrom: aChunkSourceFiler to: anOrderedCollection]!

seriesClass
	^ChunkBrowserMethodCategoryChunk! !
!ChunkBrowserMethodsCategoriesSeriesStartChunk categoriesForMethods!
addChunksFrom:to:!operations!public! !
seriesClass!constants!public! !
!

!ChunkBrowserMethodsCategoriesSeriesStartChunk class methodsFor!

isChunkClassFor: aString tokens: anArray
	"'Abc categoriesForMethods or 'Abc class categoriesForMethods'"

	^(anArray size between: 2 and: 3) and: 
			[(self isToken: anArray last identifier: 'categoriesForMethods')
				and: [self isTokenClassIdentifier: anArray first]]! !
!ChunkBrowserMethodsCategoriesSeriesStartChunk class categoriesForMethods!
isChunkClassFor:tokens:!public!testing! !
!


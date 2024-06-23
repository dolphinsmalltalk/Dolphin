"Filed out from Dolphin Smalltalk"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserClassCategorySeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserClassCategorySeriesStartChunk guid: (GUID fromString: '{515a3ffc-2d8e-45d5-bac9-8a44eea67142}')!

ChunkBrowserClassCategorySeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserClassCategorySeriesStartChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserClassCategorySeriesStartChunk methodsFor!

seriesClass
	^ChunkBrowserClassCategoryChunk! !

!ChunkBrowserClassCategorySeriesStartChunk categoriesForMethods!
seriesClass!constants!public! !
!

!ChunkBrowserClassCategorySeriesStartChunk class methodsFor!

isChunkClassFor: aString tokens: anArray
	"Abc categoriesForClass"

	^anArray size == 2 and: 
			[(self isToken: anArray second identifier: 'categoriesForClass')
				and: [self isTokenClassIdentifier: anArray first]]! !

!ChunkBrowserClassCategorySeriesStartChunk class categoriesForMethods!
isChunkClassFor:tokens:!public!testing! !
!


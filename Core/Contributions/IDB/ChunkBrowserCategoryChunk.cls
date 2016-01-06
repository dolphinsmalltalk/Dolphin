"Filed out from Dolphin Smalltalk X6.1"!

ChunkBrowserSeriesChunk subclass: #ChunkBrowserCategoryChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserCategoryChunk guid: (GUID fromString: '{C46E27D3-0EF6-4845-9235-CE75B56481F0}')!
ChunkBrowserCategoryChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserCategoryChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserCategoryChunk methodsFor!

initializeFromSeriesStart: aChunkBrowserSeriesStartChunk
	super initializeFromSeriesStart: aChunkBrowserSeriesStartChunk.
	identity2 := aChunkBrowserSeriesStartChunk identity2! !
!ChunkBrowserCategoryChunk categoriesFor: #initializeFromSeriesStart:!initializing!public! !


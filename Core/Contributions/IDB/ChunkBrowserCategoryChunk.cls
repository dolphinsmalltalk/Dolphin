"Filed out from Dolphin Smalltalk 7"!

ChunkBrowserSeriesChunk subclass: #ChunkBrowserCategoryChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserCategoryChunk guid: (GUID fromString: '{c46e27d3-0ef6-4845-9235-ce75b56481f0}')!
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


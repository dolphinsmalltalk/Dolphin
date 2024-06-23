"Filed out from Dolphin Smalltalk"!

ChunkBrowserSeriesChunk subclass: #ChunkBrowserCategoryChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserCategoryChunk guid: (GUID fromString: '{c46e27d3-0ef6-4845-9235-ce75b56481f0}')!

ChunkBrowserCategoryChunk isAbstract: true!

ChunkBrowserCategoryChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserCategoryChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserCategoryChunk methodsFor!

category
	^self categoryClass name: rawText!

categoryClass
	^self subclassResponsibility!

initialize: aString start: aChunkBrowserSeriesStartChunk
	super initialize: aString start: aChunkBrowserSeriesStartChunk.
	identity2 := aString! !

!ChunkBrowserCategoryChunk categoriesForMethods!
category!accessing!public! !
categoryClass!accessing!constants!public! !
initialize:start:!initializing!public! !
!


"Filed out from Dolphin Smalltalk"!

ChunkBrowserChunk subclass: #ChunkBrowserSeriesChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserSeriesChunk guid: (GUID fromString: '{5fc81bcc-8654-4219-898e-4f08511dd311}')!
ChunkBrowserSeriesChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserSeriesChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserSeriesChunk methodsFor!

initializeFromSeriesStart: aChunkBrowserSeriesStartChunk
	identity1 := aChunkBrowserSeriesStartChunk identity1! !
!ChunkBrowserSeriesChunk categoriesForMethods!
initializeFromSeriesStart:!initializing!public! !
!

!ChunkBrowserSeriesChunk class methodsFor!

isChunkClassFor: aString
	self shouldNotImplement! !
!ChunkBrowserSeriesChunk class categoriesForMethods!
isChunkClassFor:!public!testing! !
!


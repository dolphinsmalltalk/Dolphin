"Filed out from Dolphin Smalltalk X6.1"!

ChunkBrowserChunk subclass: #ChunkBrowserSeriesChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserSeriesChunk guid: (GUID fromString: '{5FC81BCC-8654-4219-898E-4F08511DD311}')!
ChunkBrowserSeriesChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserSeriesChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserSeriesChunk methodsFor!

initializeFromSeriesStart: aChunkBrowserSeriesStartChunk
	identity1 := aChunkBrowserSeriesStartChunk identity1! !
!ChunkBrowserSeriesChunk categoriesFor: #initializeFromSeriesStart:!initializing!public! !

!ChunkBrowserSeriesChunk class methodsFor!

isChunkClassFor: aString
	self shouldNotImplement! !
!ChunkBrowserSeriesChunk class categoriesFor: #isChunkClassFor:!public!testing! !


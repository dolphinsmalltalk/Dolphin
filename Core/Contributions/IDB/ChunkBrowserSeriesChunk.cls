"Filed out from Dolphin Smalltalk"!

ChunkBrowserChunk subclass: #ChunkBrowserSeriesChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserSeriesChunk guid: (GUID fromString: '{5fc81bcc-8654-4219-898e-4f08511dd311}')!
ChunkBrowserSeriesChunk isAbstract: true!
ChunkBrowserSeriesChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserSeriesChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserSeriesChunk methodsFor!

initialize: aString start: aChunkBrowserSeriesStartChunk
	self initialize: aString.
	identity1 := aChunkBrowserSeriesStartChunk identity1! !
!ChunkBrowserSeriesChunk categoriesForMethods!
initialize:start:!initializing!public! !
!

!ChunkBrowserSeriesChunk class methodsFor!

isChunkClassFor: aString tokens: anArrayOfStToken
	self shouldNotImplement!

newFor: aString start: aChunkBrowserSeriesStartChunk
	"Answer an initialized instance of the receiving chunk series class"

	^self new initialize: aString start: aChunkBrowserSeriesStartChunk! !
!ChunkBrowserSeriesChunk class categoriesForMethods!
isChunkClassFor:tokens:!public!testing! !
newFor:start:!instance creation!public! !
!


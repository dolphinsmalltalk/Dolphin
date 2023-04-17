"Filed out from Dolphin Smalltalk"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserMethodDefineSeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserMethodDefineSeriesStartChunk guid: (GUID fromString: '{d788a393-1fe6-4b1b-ae26-cfbac04db82a}')!
ChunkBrowserMethodDefineSeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodDefineSeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodDefineSeriesStartChunk methodsFor!

seriesClass
	^ChunkBrowserMethodDefineChunk! !
!ChunkBrowserMethodDefineSeriesStartChunk categoriesForMethods!
seriesClass!constants!public! !
!

!ChunkBrowserMethodDefineSeriesStartChunk class methodsFor!

isChunkClassFor: aString tokens: anArray
	"'Abc methodsFor' or 'Abc class methodsFor'"

	^(anArray size between: 2 and: 3) and: 
			[(self isToken: anArray last identifier: 'methodsFor')
				and: [self isTokenClassIdentifier: anArray first]]! !
!ChunkBrowserMethodDefineSeriesStartChunk class categoriesForMethods!
isChunkClassFor:tokens:!public!testing! !
!


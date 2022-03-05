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

isChunkClassFor: aString
	"'Abc methodsFor' or 'Abc class methodsFor'"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) = 0
		ifTrue: [false]
		ifFalse:
			[(aString indexOfSubCollection: ' methodsFor') = firstSpaceIndex
				or: [(aString indexOfSubCollection: ' class methodsFor') = firstSpaceIndex]]! !
!ChunkBrowserMethodDefineSeriesStartChunk class categoriesForMethods!
isChunkClassFor:!public!testing! !
!


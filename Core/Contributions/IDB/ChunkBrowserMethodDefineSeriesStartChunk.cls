"Filed out from Dolphin Smalltalk X6.1"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserMethodDefineSeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserMethodDefineSeriesStartChunk guid: (GUID fromString: '{D788A393-1FE6-4B1B-AE26-CFBAC04DB82A}')!
ChunkBrowserMethodDefineSeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodDefineSeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodDefineSeriesStartChunk methodsFor!

seriesClass
	^ChunkBrowserMethodDefineChunk! !
!ChunkBrowserMethodDefineSeriesStartChunk categoriesFor: #seriesClass!constants!public! !

!ChunkBrowserMethodDefineSeriesStartChunk class methodsFor!

isChunkClassFor: aString
	"'Abc methodsFor' or 'Abc class methodsFor'"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) = 0
		ifTrue: [false]
		ifFalse:
			[(aString indexOfSubCollection: ' methodsFor') = firstSpaceIndex
				or: [(aString indexOfSubCollection: ' class methodsFor') = firstSpaceIndex]]! !
!ChunkBrowserMethodDefineSeriesStartChunk class categoriesFor: #isChunkClassFor:!public!testing! !


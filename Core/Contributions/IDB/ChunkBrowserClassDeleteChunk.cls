"Filed out from Dolphin Smalltalk"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserClassDeleteChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserClassDeleteChunk guid: (GUID fromString: '{36c693ce-1906-4999-9626-62d3460757fb}')!

ChunkBrowserClassDeleteChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserClassDeleteChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserClassDeleteChunk methodsFor!

browseTarget
	^self identity1AsClass!

initialize: aString
	"Abcd removeFromSystem"

	super initialize: aString.
	identity1 := rawText copyFrom: 1 to: (rawText indexOf: $ )!

isMatch
	^self identity1AsClass isNil! !

!ChunkBrowserClassDeleteChunk categoriesForMethods!
browseTarget!operations!public! !
initialize:!initializing!public! !
isMatch!public!testing! !
!

!ChunkBrowserClassDeleteChunk class methodsFor!

chunkType
	^#'Class Delete'!

isChunkClassFor: aString
	"Abcd removeFromSystem"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) ~= 0
		and: [(aString indexOfSubCollection: ' removeFromSystem') = firstSpaceIndex]! !

!ChunkBrowserClassDeleteChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:!public!testing! !
!


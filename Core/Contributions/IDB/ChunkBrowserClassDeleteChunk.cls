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

initialize: aString tokens: anArray
	"Private - Abcd removeFromSystem"

	super initialize: aString tokens: anArray.
	identity1 := anArray first value!

isMatch
	^self identity1AsClass isNil! !

!ChunkBrowserClassDeleteChunk categoriesForMethods!
initialize:tokens:!initializing!private! !
isMatch!public!testing! !
!

!ChunkBrowserClassDeleteChunk class methodsFor!

chunkType
	^#'Class Delete'!

isChunkClassFor: aString tokens: anArray
	"Abcd removeFromSystem"

	^anArray size == 2 and: 
			[(self isToken: anArray second identifier: 'removeFromSystem')
				and: [self isTokenClassIdentifier: anArray first]]! !

!ChunkBrowserClassDeleteChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!


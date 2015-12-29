"Filed out from Dolphin Smalltalk X6"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserClassGUIDChunk
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserClassGUIDChunk guid: (GUID fromString: '{9B98323B-E586-4209-A7BC-11EAF78617B6}')!
ChunkBrowserClassGUIDChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserClassGUIDChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserClassGUIDChunk methodsFor!

browseTarget
	^self identity1AsClass!

initialize: aString 
	"Abc guid: (GUID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}'
	Abc guid: (IID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}'
	Abc guid: (CLSID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}'"

	super initialize: aString.
	identity1 := rawText copyFrom: 1 to: (rawText indexOf: $ ).
	identity2 := String new.
	id := rawText copyFrom: (rawText findFirst: [:each | each = $']) + 1
				to: (rawText findLast: [:each | each = $']) - 1!

isMatch
	^self identity1AsClass ifNotNil: [:arg | arg instanceClass guid asString = id]! !
!ChunkBrowserClassGUIDChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserClassGUIDChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserClassGUIDChunk categoriesFor: #isMatch!public!testing! !

!ChunkBrowserClassGUIDChunk class methodsFor!

chunkType
	^#'Class GUID'!

isChunkClassFor: aString 
	"Abc guid: (GUID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}'
	Abc guid: (IID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}'
	Abc guid: (CLSID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}'"

	| firstSpaceIndex |
	(firstSpaceIndex := aString indexOf: Character space) = 0 ifTrue: [^false].
	^(aString indexOfSubCollection: ' guid: (GUID fromString: ''{') = firstSpaceIndex or: 
			[(aString indexOfSubCollection: ' guid: (IID fromString: ''{') = firstSpaceIndex 
				or: [(aString indexOfSubCollection: ' guid: (CLSID fromString: ''{') = firstSpaceIndex]]! !
!ChunkBrowserClassGUIDChunk class categoriesFor: #chunkType!constants!public! !
!ChunkBrowserClassGUIDChunk class categoriesFor: #isChunkClassFor:!public!testing! !


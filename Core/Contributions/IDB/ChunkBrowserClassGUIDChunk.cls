"Filed out from Dolphin Smalltalk"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserClassGUIDChunk
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserClassGUIDChunk guid: (GUID fromString: '{9b98323b-e586-4209-a7bc-11eaf78617b6}')!

ChunkBrowserClassGUIDChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserClassGUIDChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserClassGUIDChunk methodsFor!

initialize: aString tokens: anArray
	"Private - Abc guid: (GUID fromString: '{6AA41459-4B33-412A-95A7-261C78522521})'
	Abc guid: (IID fromString: '{6AA41459-4B33-412A-95A7-261C78522521})'
	Abc guid: (CLSID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}')"

	super initialize: aString tokens: anArray.
	identity1 := anArray first value.
	id := (anArray at: anArray size - 1) value!

isMatch
	^self identity1AsClass ifNotNil: [:class | class instanceClass guid asString = id]! !

!ChunkBrowserClassGUIDChunk categoriesForMethods!
initialize:tokens:!initializing!private! !
isMatch!public!testing! !
!

!ChunkBrowserClassGUIDChunk class methodsFor!

chunkType
	^#'Class GUID'!

isChunkClassFor: aString tokens: anArray
	"Abc guid: (GUID fromString: '{6AA41459-4B33-412A-95A7-261C78522521})'
	Abc guid: (IID fromString: '{6AA41459-4B33-412A-95A7-261C78522521})'
	Abc guid: (CLSID fromString: '{6AA41459-4B33-412A-95A7-261C78522521}')"

	^anArray size == 7 and: 
			[(self isToken: anArray second keyword: 'guid:') and: 
					[(self isTokenClassIdentifier: anArray first) and: 
							[
							[GUID fromString: (anArray at: anArray size - 1) value.
							true] on: RPCError do: [:ex | false]]]]! !

!ChunkBrowserClassGUIDChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!


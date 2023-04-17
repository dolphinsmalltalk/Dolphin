"Filed out from Dolphin Smalltalk"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserClassCommentChunk
	instanceVariableNames: 'comment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserClassCommentChunk guid: (GUID fromString: '{58b6be85-0cf0-46ab-954b-b01e2d5b1c24}')!
ChunkBrowserClassCommentChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserClassCommentChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserClassCommentChunk methodsFor!

initialize: aString tokens: anArray
	"Private - Abc comment: ''"

	super initialize: aString tokens: anArray.
	identity1 := anArray first value.
	comment := anArray third value!

isMatch
	^self identity1AsClass ifNotNil: [:arg | arg instanceClass comment = comment]! !
!ChunkBrowserClassCommentChunk categoriesForMethods!
initialize:tokens:!initializing!private! !
isMatch!public!testing! !
!

!ChunkBrowserClassCommentChunk class methodsFor!

chunkType
	^#'Class Comment'!

isChunkClassFor: aString tokens: anArray
	"Abc comment:'"

	^anArray size == 3 and: 
			[(self isToken: anArray second keyword: 'comment:') and: 
					[(self isTokenString: anArray third)
						and: [self isTokenClassIdentifier: anArray first]]]! !
!ChunkBrowserClassCommentChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!


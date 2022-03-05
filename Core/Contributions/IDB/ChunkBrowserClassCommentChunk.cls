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

browseTarget
	^self identity1AsClass!

initialize: aString
	"Abc comment: ''"

	super initialize: aString.
	identity1 := rawText copyFrom: 1 to: (rawText indexOf: $ ).
	comment := rawText
		copyFrom: (rawText findFirst: [:each | each = $'])
		to: (rawText findLast: [:each | each = $'])!

isMatch
	^self identity1AsClass ifNotNil: [:arg | arg instanceClass comment printString = comment]! !
!ChunkBrowserClassCommentChunk categoriesForMethods!
browseTarget!operations!public! !
initialize:!initializing!public! !
isMatch!public!testing! !
!

!ChunkBrowserClassCommentChunk class methodsFor!

chunkType
	^#'Class Comment'!

isChunkClassFor: aString
	"Abc comment: ''''
	Don't check for trailing space in aString as the change log adds multiple entries for class
	comments - some delimited with a space but some with a crlf"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) ~= 0
		and: [(aString indexOfSubCollection: ' comment: ''') = firstSpaceIndex]! !
!ChunkBrowserClassCommentChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:!public!testing! !
!


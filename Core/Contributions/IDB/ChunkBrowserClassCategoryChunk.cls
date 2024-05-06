"Filed out from Dolphin Smalltalk"!

ChunkBrowserCategoryChunk subclass: #ChunkBrowserClassCategoryChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserClassCategoryChunk guid: (GUID fromString: '{d294e534-488e-4bcd-91d7-4f3217ae5669}')!

ChunkBrowserClassCategoryChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserClassCategoryChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserClassCategoryChunk methodsFor!

= aChunk
	^super = aChunk and: [rawText = aChunk rawText]!

browseTarget
	^self identity1AsClass!

hash
	^super hash bitXor: rawText hash!

isMatch
	^self identity1AsClass
		ifNotNil:
			[:arg | 
			| categories |
			categories := arg instanceClass categories collect: [:each | each name].
			categories anySatisfy: [:each | each = rawText]]!

restore
	"Answers nil or the error information"

	^self identity1AsClass
		ifNil: [index -> 'Target class missing']
		ifNotNil:
			[:arg | 
			(ClassCategory name: rawText) addClass: arg.
			nil]! !

!ChunkBrowserClassCategoryChunk categoriesForMethods!
=!comparing!public! !
browseTarget!operations!public! !
hash!comparing!public! !
isMatch!public!testing! !
restore!operations!public! !
!

!ChunkBrowserClassCategoryChunk class methodsFor!

chunkType
	^#'Class Category'! !

!ChunkBrowserClassCategoryChunk class categoriesForMethods!
chunkType!constants!public! !
!


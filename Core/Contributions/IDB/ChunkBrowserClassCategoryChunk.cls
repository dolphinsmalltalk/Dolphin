"Filed out from Dolphin Smalltalk X6.1"!

ChunkBrowserCategoryChunk subclass: #ChunkBrowserClassCategoryChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserClassCategoryChunk guid: (GUID fromString: '{D294E534-488E-4BCD-91D7-4F3217AE5669}')!
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
!ChunkBrowserClassCategoryChunk categoriesFor: #=!comparing!public! !
!ChunkBrowserClassCategoryChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserClassCategoryChunk categoriesFor: #hash!comparing!public! !
!ChunkBrowserClassCategoryChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserClassCategoryChunk categoriesFor: #restore!operations!public! !

!ChunkBrowserClassCategoryChunk class methodsFor!

chunkType
	^#'Class Category'! !
!ChunkBrowserClassCategoryChunk class categoriesFor: #chunkType!constants!public! !


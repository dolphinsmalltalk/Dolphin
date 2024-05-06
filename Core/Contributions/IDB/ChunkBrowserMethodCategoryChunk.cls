"Filed out from Dolphin Smalltalk"!

ChunkBrowserCategoryChunk subclass: #ChunkBrowserMethodCategoryChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserMethodCategoryChunk guid: (GUID fromString: '{9d242f9c-c429-483d-848b-80fbc1b52db7}')!

ChunkBrowserMethodCategoryChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserMethodCategoryChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserMethodCategoryChunk methodsFor!

browseTarget
	^self identity1AndIdentity2AsCompiledMethod!

isMatch
	^self identity1AndIdentity2AsCompiledMethod
		ifNotNil:
			[:arg | 
			| categories |
			categories := arg categories collect: [:each | each name].
			categories anySatisfy: [:each | each = rawText]]!

restore
	"Answers nil or the error information"

	^self identity1AndIdentity2AsCompiledMethod
		ifNil: [index -> 'Target class or method missing']
		ifNotNil:
			[:arg | 
			rawText asMethodCategory addMethod: arg.
			nil]! !

!ChunkBrowserMethodCategoryChunk categoriesForMethods!
browseTarget!operations!public! !
isMatch!public!testing! !
restore!operations!public! !
!

!ChunkBrowserMethodCategoryChunk class methodsFor!

chunkType
	^#'Method Category'! !

!ChunkBrowserMethodCategoryChunk class categoriesForMethods!
chunkType!constants!public! !
!


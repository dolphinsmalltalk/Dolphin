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

categoryClass
	^MethodCategory!

initialize: aString start: aChunkBrowserSeriesStartChunk
	super initialize: aString start: aChunkBrowserSeriesStartChunk.
	identity2 := aChunkBrowserSeriesStartChunk identity2!

isMatch
	^self identity1AndIdentity2AsCompiledMethod ifNotNil: [:method | self category includesMethod: method]!

restore
	"Answers nil or the error information"

	^self identity1AndIdentity2AsCompiledMethod
		ifNil: [index -> 'Target class or method missing']
		ifNotNil:
			[:method | 
			rawText asMethodCategory addMethod: method.
			nil]! !

!ChunkBrowserMethodCategoryChunk categoriesForMethods!
browseTarget!operations!public! !
categoryClass!accessing!constants!public! !
initialize:start:!initializing!public! !
isMatch!public!testing! !
restore!operations!public! !
!

!ChunkBrowserMethodCategoryChunk class methodsFor!

chunkType
	^#'Method Category'! !

!ChunkBrowserMethodCategoryChunk class categoriesForMethods!
chunkType!constants!public! !
!


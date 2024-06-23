"Filed out from Dolphin Smalltalk"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserMethodCategorySeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserMethodCategorySeriesStartChunk guid: (GUID fromString: '{f8439b0f-caec-4c70-81ac-875f0941e0d9}')!

ChunkBrowserMethodCategorySeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserMethodCategorySeriesStartChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserMethodCategorySeriesStartChunk methodsFor!

initialize: aString tokens: anArray
	"Private - 'Abc categoriesFor: #abc' or 'Abc class categoriesFor: #abc'"

	super initialize: aString tokens: anArray.
	identity2 := anArray last value!

seriesClass
	^ChunkBrowserMethodCategoryChunk! !

!ChunkBrowserMethodCategorySeriesStartChunk categoriesForMethods!
initialize:tokens:!initializing!private! !
seriesClass!constants!public! !
!

!ChunkBrowserMethodCategorySeriesStartChunk class methodsFor!

isChunkClassFor: aString tokens: anArray
	"'Abc categoriesFor: #abc' or 'Abc class categoriesFor: #abc'"

	| tokens token |
	(anArray size between: 3 and: 4) ifFalse: [^false].
	tokens := ReadStream on: anArray.
	self isTokenClassIdentifier: tokens next.
	token := tokens next.
	(self isToken: token identifier: 'class') ifTrue: [token := tokens next].
	(self isToken: token keyword: 'categoriesFor:') ifFalse: [^false].
	token := tokens nextAvailable.
	^token notNil and: [token isLiteralSymbolToken and: [tokens atEnd]]! !

!ChunkBrowserMethodCategorySeriesStartChunk class categoriesForMethods!
isChunkClassFor:tokens:!public!testing! !
!


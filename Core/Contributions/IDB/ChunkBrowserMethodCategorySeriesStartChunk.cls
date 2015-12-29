"Filed out from Dolphin Smalltalk X6"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserMethodCategorySeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserMethodCategorySeriesStartChunk guid: (GUID fromString: '{F8439B0F-CAEC-4C70-81AC-875F0941E0D9}')!
ChunkBrowserMethodCategorySeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodCategorySeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodCategorySeriesStartChunk methodsFor!

initialize: aString 
	"'Abc categoriesFor: #abc' or 'Abc class categoriesFor: #abc'"

	super initialize: aString.
	identity2 := aString copyFrom: (aString indexOf: $#) + 1!

seriesChunkClass
	^ChunkBrowserMethodCategoryChunk! !
!ChunkBrowserMethodCategorySeriesStartChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserMethodCategorySeriesStartChunk categoriesFor: #seriesChunkClass!constants!public! !

!ChunkBrowserMethodCategorySeriesStartChunk class methodsFor!

isChunkClassFor: aString 
	"'Abc categoriesFor: #abc' or 'Abc class categoriesFor: #abc'"

	| firstSpaceIndex |
	(firstSpaceIndex := aString indexOf: Character space) = 0 ifTrue: [^false].
	^(aString indexOfSubCollection: ' categoriesFor: #') = firstSpaceIndex 
		or: [(aString indexOfSubCollection: ' class categoriesFor: #') = firstSpaceIndex]! !
!ChunkBrowserMethodCategorySeriesStartChunk class categoriesFor: #isChunkClassFor:!public!testing! !


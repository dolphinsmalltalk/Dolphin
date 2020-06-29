"Filed out from Dolphin Smalltalk 7"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserMethodCategorySeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserMethodCategorySeriesStartChunk guid: (GUID fromString: '{f8439b0f-caec-4c70-81ac-875f0941e0d9}')!
ChunkBrowserMethodCategorySeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodCategorySeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodCategorySeriesStartChunk methodsFor!

initialize: aString
	"'Abc categoriesFor: #abc' or 'Abc class categoriesFor: #abc'"

	super initialize: aString.
	identity2 := aString copyFrom: (aString indexOf: $#) + 1!

seriesClass
	^ChunkBrowserMethodCategoryChunk! !
!ChunkBrowserMethodCategorySeriesStartChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserMethodCategorySeriesStartChunk categoriesFor: #seriesClass!constants!public! !

!ChunkBrowserMethodCategorySeriesStartChunk class methodsFor!

isChunkClassFor: aString
	"'Abc categoriesFor: #abc' or 'Abc class categoriesFor: #abc'"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) = 0
		ifTrue: [false]
		ifFalse:
			[(aString indexOfSubCollection: ' categoriesFor: #') = firstSpaceIndex
				or: [(aString indexOfSubCollection: ' class categoriesFor: #') = firstSpaceIndex]]! !
!ChunkBrowserMethodCategorySeriesStartChunk class categoriesFor: #isChunkClassFor:!public!testing! !


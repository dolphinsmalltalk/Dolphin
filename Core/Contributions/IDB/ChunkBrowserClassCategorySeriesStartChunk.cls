"Filed out from Dolphin Smalltalk X6.1"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserClassCategorySeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserClassCategorySeriesStartChunk guid: (GUID fromString: '{515A3FFC-2D8E-45D5-BAC9-8A44EEA67142}')!
ChunkBrowserClassCategorySeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserClassCategorySeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserClassCategorySeriesStartChunk methodsFor!

seriesClass
	^ChunkBrowserClassCategoryChunk! !
!ChunkBrowserClassCategorySeriesStartChunk categoriesFor: #seriesClass!constants!public! !

!ChunkBrowserClassCategorySeriesStartChunk class methodsFor!

isChunkClassFor: aString
	"Abc categoriesForClass"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) = 0
		ifTrue: [false]
		ifFalse: [(aString indexOfSubCollection: ' categoriesForClass') = firstSpaceIndex]! !
!ChunkBrowserClassCategorySeriesStartChunk class categoriesFor: #isChunkClassFor:!public!testing! !


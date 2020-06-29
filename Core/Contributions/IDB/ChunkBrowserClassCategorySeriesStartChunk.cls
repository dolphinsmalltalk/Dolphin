"Filed out from Dolphin Smalltalk 7"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserClassCategorySeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserClassCategorySeriesStartChunk guid: (GUID fromString: '{515a3ffc-2d8e-45d5-bac9-8a44eea67142}')!
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


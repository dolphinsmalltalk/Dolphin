"Filed out from Dolphin Smalltalk X6"!

ChunkBrowserChunk subclass: #ChunkBrowserSeriesStartChunk
	instanceVariableNames: 'owningClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserSeriesStartChunk guid: (GUID fromString: '{24F42E2C-7A1F-4252-BDFE-4584ED820429}')!
ChunkBrowserSeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserSeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserSeriesStartChunk methodsFor!

initialize: aString 
	super initialize: aString.
	identity1 := self classNameFromRawText!

isChunkSeriesStart
	^true!

seriesChunk: aString 
	| chunk |
	chunk := self seriesChunkClass fromText: aString.
	chunk initializeFrom: self.
	^chunk! !
!ChunkBrowserSeriesStartChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserSeriesStartChunk categoriesFor: #isChunkSeriesStart!public!testing! !
!ChunkBrowserSeriesStartChunk categoriesFor: #seriesChunk:!initializing!public! !


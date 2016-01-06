"Filed out from Dolphin Smalltalk X6.1"!

ChunkBrowserChunk subclass: #ChunkBrowserSeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserSeriesStartChunk guid: (GUID fromString: '{24F42E2C-7A1F-4252-BDFE-4584ED820429}')!
ChunkBrowserSeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserSeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserSeriesStartChunk methodsFor!

browseTarget
	self shouldNotImplement!

initialize: aString
	super initialize: aString.
	identity1 := self classNameFromRawText!

isMatch
	self shouldNotImplement!

isSeriesStart
	^true!

restore
	self shouldNotImplement!

seriesClass
	self subclassResponsibility!

seriesInstanceFor: aString
	^(self seriesClass newFor: aString)
		initializeFromSeriesStart: self;
		yourself! !
!ChunkBrowserSeriesStartChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserSeriesStartChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserSeriesStartChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserSeriesStartChunk categoriesFor: #isSeriesStart!public!testing! !
!ChunkBrowserSeriesStartChunk categoriesFor: #restore!operations!public! !
!ChunkBrowserSeriesStartChunk categoriesFor: #seriesClass!constants!public! !
!ChunkBrowserSeriesStartChunk categoriesFor: #seriesInstanceFor:!initializing!public! !

!ChunkBrowserSeriesStartChunk class methodsFor!

chunkType
	self shouldNotImplement! !
!ChunkBrowserSeriesStartChunk class categoriesFor: #chunkType!constants!public! !


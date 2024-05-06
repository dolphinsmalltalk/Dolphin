"Filed out from Dolphin Smalltalk"!

ChunkBrowserChunk subclass: #ChunkBrowserSeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserSeriesStartChunk guid: (GUID fromString: '{24f42e2c-7a1f-4252-bdfe-4584ed820429}')!

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

!ChunkBrowserSeriesStartChunk categoriesForMethods!
browseTarget!operations!public! !
initialize:!initializing!public! !
isMatch!public!testing! !
isSeriesStart!public!testing! !
restore!operations!public! !
seriesClass!constants!public! !
seriesInstanceFor:!initializing!public! !
!

!ChunkBrowserSeriesStartChunk class methodsFor!

chunkType
	self shouldNotImplement! !

!ChunkBrowserSeriesStartChunk class categoriesForMethods!
chunkType!constants!public! !
!


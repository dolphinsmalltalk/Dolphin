"Filed out from Dolphin Smalltalk 7"!

Model subclass: #ChunkBrowserFilter
	instanceVariableNames: 'selectedChunkTypes selectedComparisonTypes restrictionRange restrictionClass restrictingMostRecent restrictingPicked'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserFilter guid: (GUID fromString: '{cca89e53-eee3-495a-915f-463f69c7009a}')!
ChunkBrowserFilter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserFilter categoriesForClass!IDB Goodies! !
!ChunkBrowserFilter methodsFor!

chunkSelectAll
	selectedChunkTypes := #(#'Class Category' #'Class Comment' #'Class Define' #'Class Delete' #'Class GUID' #'Class Protocol' #'Method Category' #'Method Define' #'Method Delete' #System #Other)
		asSet!

chunkSelectDefault
	selectedChunkTypes := Set new.
	ChunkBrowser chunkTypeSelection
		keysAndValuesDo: [:key :value | value ifTrue: [selectedChunkTypes add: key]]!

chunkSelectNone
	selectedChunkTypes := Set new!

initialize
	super initialize.
	self chunkSelectDefault.
	selectedComparisonTypes := #(#Match #Differ #Missing) asSet.
	restrictionRange := restrictionClass := nil.
	restrictingMostRecent := restrictingPicked := false!

isChunkTypeSelected: aSymbol
	^selectedChunkTypes includes: aSymbol!

isCompareNeeded
	^selectedComparisonTypes size ~= 3!

isComparisonTypeSelected: aSymbol
	^selectedComparisonTypes includes: aSymbol!

isInRestrictionClass: aSymbol
	^self isRestrictingClass not or: [restrictionClass == aSymbol]!

isInRestrictionRange: anInteger
	^self isRestrictingRange not or: [restrictionRange includes: anInteger]!

isRestrictingClass
	^restrictionClass notNil!

isRestrictingMostRecent
	^restrictingMostRecent!

isRestrictingPicked
	^restrictingPicked!

isRestrictingRange
	^restrictionRange notNil!

restrictionClass: aSymbolOrNil
	restrictionClass := aSymbolOrNil!

restrictionRange: aRangeOrNil
	restrictionRange := aRangeOrNil!

restrictionRangeFirst
	^restrictionRange first!

restrictionRangeLast
	^restrictionRange last!

restrictionRangeSize
	^restrictionRange size!

toggleChunkType: aSymbol
	(self isChunkTypeSelected: aSymbol)
		ifTrue: [selectedChunkTypes remove: aSymbol]
		ifFalse: [selectedChunkTypes add: aSymbol]!

toggleComparisonType: aSymbol
	(self isComparisonTypeSelected: aSymbol)
		ifTrue: [selectedComparisonTypes remove: aSymbol]
		ifFalse: [selectedComparisonTypes add: aSymbol]!

toggleRestrictingMostRecent
	restrictingMostRecent := restrictingMostRecent not!

toggleRestrictingPicked
	restrictingPicked := restrictingPicked not! !
!ChunkBrowserFilter categoriesFor: #chunkSelectAll!operations!public! !
!ChunkBrowserFilter categoriesFor: #chunkSelectDefault!operations!public! !
!ChunkBrowserFilter categoriesFor: #chunkSelectNone!operations!public! !
!ChunkBrowserFilter categoriesFor: #initialize!initializing!public! !
!ChunkBrowserFilter categoriesFor: #isChunkTypeSelected:!public!testing! !
!ChunkBrowserFilter categoriesFor: #isCompareNeeded!public!testing! !
!ChunkBrowserFilter categoriesFor: #isComparisonTypeSelected:!public!testing! !
!ChunkBrowserFilter categoriesFor: #isInRestrictionClass:!public!testing! !
!ChunkBrowserFilter categoriesFor: #isInRestrictionRange:!public!testing! !
!ChunkBrowserFilter categoriesFor: #isRestrictingClass!public!testing! !
!ChunkBrowserFilter categoriesFor: #isRestrictingMostRecent!public!testing! !
!ChunkBrowserFilter categoriesFor: #isRestrictingPicked!public!testing! !
!ChunkBrowserFilter categoriesFor: #isRestrictingRange!public!testing! !
!ChunkBrowserFilter categoriesFor: #restrictionClass:!accessing!public! !
!ChunkBrowserFilter categoriesFor: #restrictionRange:!accessing!public! !
!ChunkBrowserFilter categoriesFor: #restrictionRangeFirst!accessing!public! !
!ChunkBrowserFilter categoriesFor: #restrictionRangeLast!accessing!public! !
!ChunkBrowserFilter categoriesFor: #restrictionRangeSize!accessing!public! !
!ChunkBrowserFilter categoriesFor: #toggleChunkType:!operations!public! !
!ChunkBrowserFilter categoriesFor: #toggleComparisonType:!operations!public! !
!ChunkBrowserFilter categoriesFor: #toggleRestrictingMostRecent!operations!public! !
!ChunkBrowserFilter categoriesFor: #toggleRestrictingPicked!operations!public! !


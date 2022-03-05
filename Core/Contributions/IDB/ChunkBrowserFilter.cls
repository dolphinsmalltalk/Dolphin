"Filed out from Dolphin Smalltalk"!

Model subclass: #ChunkBrowserFilter
	instanceVariableNames: 'selectedChunkTypes selectedComparisonTypes restrictionRange restrictionClass restrictingMostRecent restrictingPicked'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!ChunkBrowserFilter categoriesForMethods!
chunkSelectAll!operations!public! !
chunkSelectDefault!operations!public! !
chunkSelectNone!operations!public! !
initialize!initializing!public! !
isChunkTypeSelected:!public!testing! !
isCompareNeeded!public!testing! !
isComparisonTypeSelected:!public!testing! !
isInRestrictionClass:!public!testing! !
isInRestrictionRange:!public!testing! !
isRestrictingClass!public!testing! !
isRestrictingMostRecent!public!testing! !
isRestrictingPicked!public!testing! !
isRestrictingRange!public!testing! !
restrictionClass:!accessing!public! !
restrictionRange:!accessing!public! !
restrictionRangeFirst!accessing!public! !
restrictionRangeLast!accessing!public! !
restrictionRangeSize!accessing!public! !
toggleChunkType:!operations!public! !
toggleComparisonType:!operations!public! !
toggleRestrictingMostRecent!operations!public! !
toggleRestrictingPicked!operations!public! !
!


"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ChunkBrowserChunk
	instanceVariableNames: 'rawText index identity1 identity2 picked'
	classVariableNames: 'ChunkClasses'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserChunk guid: (GUID fromString: '{81a73b99-1ef4-4578-b810-1fdb663e27f2}')!
ChunkBrowserChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserChunk methodsFor!

<= aChunkBrowserChunk
	^index <= aChunkBrowserChunk index!

= aChunk
	^self class == aChunk class and: [identity1 = aChunk identity1 and: [identity2 = aChunk identity2]]!

browse
	"Open a broser on the receiver"

	self browseTarget browse!

browseTarget
	self subclassResponsibility!

canBrowse
	"Answer true if a class browser can be opened on the receiver"

	^self browseTarget notNil!

canCompare
	"Override if the receiver chunk cannot be compared with another"

	^true!

canShowDifferences
	"Override if the receiver chunk can be compared with another using a DifferencesPresenter"

	^false!

chunkClass
	"Answer the name of the class represented by the receiver or nil if it either does not have
	one or does not exist"

	^self identity1AsClass ifNotNil: [:arg | arg instanceClass name]!

chunkIconIndex
	"Answer the imageIndex for the icon that represents the match state of the receiver with the
	current image"

	^(self isMatch
		ifNil: [self missingIcon]
		ifNotNil: [:arg | arg ifTrue: [self matchIcon] ifFalse: [self mismatchIcon]]) icon
		imageIndex!

chunkType
	^self class chunkType!

classNameFromRawText
	| firstSpaceIndex |
	firstSpaceIndex := rawText indexOf: Character space.
	^(rawText indexOfSubCollection: ' class') = firstSpaceIndex
		ifTrue: [rawText copyFrom: 1 to: firstSpaceIndex + 5]
		ifFalse: [rawText copyFrom: 1 to: firstSpaceIndex - 1]!

hash
	^(self class hash bitXor: identity1 hash) bitXor: identity2 hash!

identity1
	^identity1!

identity1AndIdentity2AsCompiledMethod
	^self identity1AsClass
		ifNotNil:
			[:arg | (arg includesSelector: identity2 asSymbol) ifTrue: [arg compiledMethodAt: identity2 asSymbol]]!

identity1AsClass
	| className metaclass class |
	className := identity1.
	className := (identity1 includes: Character space)
				ifTrue: 
					[(identity1 copyFrom: 1 to: (identity1 indexOf: Character space) - 1) asQualifiedReference meta]
				ifFalse: [identity1 asQualifiedReference].
	^className valueOrNil!

identity2
	^identity2!

index
	^index!

index: anInteger
	index := anInteger!

initialize: aString
	rawText := aString.
	picked := false.
	identity1 := String new.
	identity2 := String new!

isFilteredUsing: aChunkBrowserFilter
	"Answers true if the receiver passes all the tests in aChunkBrowserFilter"

	| match |
	(aChunkBrowserFilter isChunkTypeSelected: self chunkType) ifFalse: [^false].
	(aChunkBrowserFilter isInRestrictionRange: self index) ifFalse: [^false].
	(aChunkBrowserFilter isInRestrictionClass: self chunkClass) ifFalse: [^false].
	(aChunkBrowserFilter isRestrictingPicked and: [picked not]) ifTrue: [^false].
	self canCompare ifFalse: [^true].
	aChunkBrowserFilter isCompareNeeded ifFalse: [^true].
	match := self isMatch.
	match ifNil: [^aChunkBrowserFilter isComparisonTypeSelected: #Missing].
	match ifTrue: [^aChunkBrowserFilter isComparisonTypeSelected: #Match].
	^aChunkBrowserFilter isComparisonTypeSelected: #Differ!

isImageSave
	"Override if the receiver represents an image save"

	^false!

isMatch
	self subclassResponsibility!

isSeriesStart
	"Override if the receiver is a chunk representing the start of a series"

	^false!

matchIcon
	^true icon!

mismatchIcon
	^false icon!

missingIcon
	^##(TextTileIcon text: $\x2610 fontName: 'Cambria')!

picked
	^picked!

picked: aBoolean
	picked := aBoolean!

pickedIconIndex
	^picked ifTrue: [^Exception icon imageIndex] ifFalse: [0]!

rawText
	^rawText!

restore
	self subclassResponsibility!

showIn: aTextPresenter
	aTextPresenter text: rawText! !
!ChunkBrowserChunk categoriesFor: #<=!comparing!public! !
!ChunkBrowserChunk categoriesFor: #=!comparing!public! !
!ChunkBrowserChunk categoriesFor: #browse!operations!public! !
!ChunkBrowserChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserChunk categoriesFor: #canBrowse!public!testing! !
!ChunkBrowserChunk categoriesFor: #canCompare!public!testing! !
!ChunkBrowserChunk categoriesFor: #canShowDifferences!public!testing! !
!ChunkBrowserChunk categoriesFor: #chunkClass!accessing!public! !
!ChunkBrowserChunk categoriesFor: #chunkIconIndex!accessing!public! !
!ChunkBrowserChunk categoriesFor: #chunkType!accessing!constants!public! !
!ChunkBrowserChunk categoriesFor: #classNameFromRawText!helpers!public! !
!ChunkBrowserChunk categoriesFor: #hash!comparing!public! !
!ChunkBrowserChunk categoriesFor: #identity1!accessing!public! !
!ChunkBrowserChunk categoriesFor: #identity1AndIdentity2AsCompiledMethod!helpers!public! !
!ChunkBrowserChunk categoriesFor: #identity1AsClass!helpers!public! !
!ChunkBrowserChunk categoriesFor: #identity2!accessing!public! !
!ChunkBrowserChunk categoriesFor: #index!accessing!public! !
!ChunkBrowserChunk categoriesFor: #index:!accessing!public! !
!ChunkBrowserChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserChunk categoriesFor: #isFilteredUsing:!operations!public! !
!ChunkBrowserChunk categoriesFor: #isImageSave!public!testing! !
!ChunkBrowserChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserChunk categoriesFor: #isSeriesStart!public!testing! !
!ChunkBrowserChunk categoriesFor: #matchIcon!accessing!constants!public! !
!ChunkBrowserChunk categoriesFor: #mismatchIcon!accessing!constants!public! !
!ChunkBrowserChunk categoriesFor: #missingIcon!constants!public! !
!ChunkBrowserChunk categoriesFor: #picked!accessing!public! !
!ChunkBrowserChunk categoriesFor: #picked:!accessing!public! !
!ChunkBrowserChunk categoriesFor: #pickedIconIndex!accessing!public! !
!ChunkBrowserChunk categoriesFor: #rawText!accessing!public! !
!ChunkBrowserChunk categoriesFor: #restore!operations!public! !
!ChunkBrowserChunk categoriesFor: #showIn:!displaying!public! !

!ChunkBrowserChunk class methodsFor!

chunkClasses
	"A collection of classes that should be tested to decide the type of a chunk"

	ChunkClasses
		ifNil:
			[ChunkClasses := (OrderedCollection new)
				add: ChunkBrowserMethodCategorySeriesStartChunk;
				add: ChunkBrowserMethodDefineSeriesStartChunk;
				add: ChunkBrowserClassDefineChunk;
				add: ChunkBrowserClassDeleteChunk;
				add: ChunkBrowserMethodDeleteChunk;
				add: ChunkBrowserClassCommentChunk;
				add: ChunkBrowserClassGUIDChunk;
				add: ChunkBrowserClassProtocolChunk;
				add: ChunkBrowserClassCategorySeriesStartChunk;
				add: ChunkBrowserSystemChunk;
				yourself].
	^ChunkClasses!

chunksFromStream: aStream
	"Answer a collection of subclasses representing the chunks found in aStream"

	| chunks sourceFiler |
	chunks := OrderedCollection new.
	sourceFiler := ChunkSourceFiler on: aStream.
	[aStream atEnd]
		whileFalse:
			[| chunkText |
			chunkText := sourceFiler nextChunk.
			chunkText isEmpty
				ifFalse:
					[| chunkInstance |
					chunkInstance := self instanceFor: chunkText.
					chunkInstance isSeriesStart
						ifTrue:
							[| seriesChunkText |
							seriesChunkText := sourceFiler nextChunk.
							[seriesChunkText isEmpty]
								whileFalse:
									[chunks add: (chunkInstance seriesInstanceFor: seriesChunkText).
									seriesChunkText := sourceFiler nextChunk]]
						ifFalse: [chunks add: chunkInstance]]].
	chunks keysAndValuesDo: [:index :each | each index: index].
	^chunks!

chunksFromText: aString
	"Answer a collection of subclasses representing the chunks found in aString"

	^self chunksFromStream: aString readStream!

chunkType
	self subclassResponsibility!

instanceFor: aString
	"Detect the correct class for the chunk in aString and answer an instance of it"

	^(self chunkClasses
		detect: [:each | each isChunkClassFor: aString]
		ifNone: [ChunkBrowserOtherChunk]) newFor: aString!

isChunkClassFor: aString
	self subclassResponsibility!

newFor: aString
	"Answer an initialized instance of the receiving chunk class"

	^self new initialize: aString! !
!ChunkBrowserChunk class categoriesFor: #chunkClasses!constants!public! !
!ChunkBrowserChunk class categoriesFor: #chunksFromStream:!helpers!public! !
!ChunkBrowserChunk class categoriesFor: #chunksFromText:!helpers!public! !
!ChunkBrowserChunk class categoriesFor: #chunkType!accessing!constants!public! !
!ChunkBrowserChunk class categoriesFor: #instanceFor:!instance creation!public! !
!ChunkBrowserChunk class categoriesFor: #isChunkClassFor:!public!testing! !
!ChunkBrowserChunk class categoriesFor: #newFor:!instance creation!public! !


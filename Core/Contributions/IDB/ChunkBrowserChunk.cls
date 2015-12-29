"Filed out from Dolphin Smalltalk X6"!

Object subclass: #ChunkBrowserChunk
	instanceVariableNames: 'rawText index identity1 identity2 picked'
	classVariableNames: 'ChunkClasses IconIndices'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserChunk guid: (GUID fromString: '{81A73B99-1EF4-4578-B810-1FDB663E27F2}')!
ChunkBrowserChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserChunk methodsFor!

<= aChunkBrowserChunk 
	^index <= aChunkBrowserChunk index!

= aChunk 
	^self class == aChunk class and: [identity1 = aChunk identity1 and: [identity2 = aChunk identity2]]!

browse
	self browseTarget browse!

canBrowse
	^self browseTarget notNil!

canCompare
	^true!

canShowDifferences
	^false!

chunkClass
	^self identity1AsClass ifNotNil: [:arg | arg instanceClass name]!

chunkIconIndex
	^(self isMatch ifNil: [Object] ifNotNil: [:arg | arg ifTrue: [Presenter] ifFalse: [Model]]) icon 
		imageIndex!

chunkType
	^self class chunkType!

classNameFromRawText
	| firstSpaceIndex |
	firstSpaceIndex := rawText indexOf: Character space.
	^(rawText indexOfSubCollection: ' class') = firstSpaceIndex 
		ifTrue: [rawText copyFrom: 1 to: firstSpaceIndex + 5]
		ifFalse: [rawText copyFrom: 1 to: firstSpaceIndex - 1]!

displayTextUsing: aColor 
	^(RichText rtfConverter)
		font: SmalltalkWorkspace actualFont;
		forecolor: aColor;
		readTextFrom: rawText readStream;
		richText!

filterUsing: aChunkBrowserFilter 
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

hash
	^(self class hash bitXor: identity1 hash) bitXor: identity2 hash!

identity1
	^identity1!

identity1AndIdentity2AsCompiledMethod
	^self identity1AsClass 
		ifNotNil: 
			[:arg | 
			(arg includesSelector: identity2 asSymbol) ifTrue: [arg compiledMethodAt: identity2 asSymbol]]!

identity1AndIdentity2AsResourceIdentifier
	^self identity1AsClass 
		ifNotNil: 
			[:arg | 
			| resourceIdentifier |
			resourceIdentifier := ResourceIdentifier class: arg name: identity2.
			(SessionManager current resourceManager resourceAt: resourceIdentifier ifAbsent: []) 
				ifNotNil: [resourceIdentifier]]!

identity1AsClass
	| className metaclass class |
	className := identity1.
	metaclass := false.
	(className includes: Character space) 
		ifTrue: 
			[className := className copyFrom: 1 to: (className indexOf: Character space) - 1.
			metaclass := true].
	(self class environment includesKey: className) ifFalse: [^nil].
	class := self class environment at: className.
	metaclass ifFalse: [^class].
	^class class!

identity2
	^identity2!

index
	^index!

index: anInteger 
	index := anInteger!

initialize: aString 
	rawText := aString.
	picked := false!

isChunkSeriesStart
	^false!

isImageSave
	^false!

isMatch
	self subclassResponsibility!

picked
	^picked!

picked: aBoolean 
	picked := aBoolean!

pickedIconIndex
	^picked ifTrue: [View icon imageIndex] ifFalse: [0]!

rawText
	^rawText!

restore
	self subclassResponsibility!

showIn: aTextPresenter 
	aTextPresenter text: rawText! !
!ChunkBrowserChunk categoriesFor: #<=!comparing!public! !
!ChunkBrowserChunk categoriesFor: #=!comparing!public! !
!ChunkBrowserChunk categoriesFor: #browse!operations!public! !
!ChunkBrowserChunk categoriesFor: #canBrowse!public!testing! !
!ChunkBrowserChunk categoriesFor: #canCompare!public!testing! !
!ChunkBrowserChunk categoriesFor: #canShowDifferences!public!testing! !
!ChunkBrowserChunk categoriesFor: #chunkClass!accessing!public! !
!ChunkBrowserChunk categoriesFor: #chunkIconIndex!accessing!public! !
!ChunkBrowserChunk categoriesFor: #chunkType!accessing!constants!public! !
!ChunkBrowserChunk categoriesFor: #classNameFromRawText!helpers!public! !
!ChunkBrowserChunk categoriesFor: #displayTextUsing:!operations!public! !
!ChunkBrowserChunk categoriesFor: #filterUsing:!operations!public! !
!ChunkBrowserChunk categoriesFor: #hash!comparing!public! !
!ChunkBrowserChunk categoriesFor: #identity1!accessing!public! !
!ChunkBrowserChunk categoriesFor: #identity1AndIdentity2AsCompiledMethod!helpers!public! !
!ChunkBrowserChunk categoriesFor: #identity1AndIdentity2AsResourceIdentifier!helpers!public! !
!ChunkBrowserChunk categoriesFor: #identity1AsClass!helpers!public! !
!ChunkBrowserChunk categoriesFor: #identity2!accessing!public! !
!ChunkBrowserChunk categoriesFor: #index!accessing!public! !
!ChunkBrowserChunk categoriesFor: #index:!accessing!public! !
!ChunkBrowserChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserChunk categoriesFor: #isChunkSeriesStart!public!testing! !
!ChunkBrowserChunk categoriesFor: #isImageSave!public!testing! !
!ChunkBrowserChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserChunk categoriesFor: #picked!accessing!public! !
!ChunkBrowserChunk categoriesFor: #picked:!accessing!public! !
!ChunkBrowserChunk categoriesFor: #pickedIconIndex!accessing!public! !
!ChunkBrowserChunk categoriesFor: #rawText!accessing!public! !
!ChunkBrowserChunk categoriesFor: #restore!operations!public! !
!ChunkBrowserChunk categoriesFor: #showIn:!displaying!public! !

!ChunkBrowserChunk class methodsFor!

chunkClasses
	"A collection of classes that should be tested to decide the type of a chunk"

	ChunkClasses := nil.
	ChunkClasses 
		ifNil: 
			[ChunkClasses := OrderedCollection new.
			ChunkClasses
				add: ChunkBrowserClassDefineChunk;
				add: ChunkBrowserClassDeleteChunk;
				add: ChunkBrowserClassCommentChunk;
				add: ChunkBrowserClassGUIDChunk;
				add: ChunkBrowserClassProtocolChunk;
				add: ChunkBrowserClassCategorySeriesStartChunk;
				add: ChunkBrowserMethodCategorySeriesStartChunk;
				add: ChunkBrowserMethodDefineSeriesStartChunk;
				add: ChunkBrowserMethodDeleteChunk;
				add: ChunkBrowserSystemChunk].
	^ChunkClasses!

chunkType
	self subclassResponsibility!

fromText: aString 
	^self new initialize: aString!

isChunkClassFor: aString 
	self subclassResponsibility! !
!ChunkBrowserChunk class categoriesFor: #chunkClasses!constants!public! !
!ChunkBrowserChunk class categoriesFor: #chunkType!accessing!constants!public! !
!ChunkBrowserChunk class categoriesFor: #fromText:!instance creation!public! !
!ChunkBrowserChunk class categoriesFor: #isChunkClassFor:!public!testing! !


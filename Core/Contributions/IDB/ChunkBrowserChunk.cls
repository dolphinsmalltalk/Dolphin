"Filed out from Dolphin Smalltalk"!

Object subclass: #ChunkBrowserChunk
	instanceVariableNames: 'rawText index identity1 identity2 picked'
	classVariableNames: 'ChunkClasses'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserChunk guid: (GUID fromString: '{81a73b99-1ef4-4578-b810-1fdb663e27f2}')!
ChunkBrowserChunk addClassConstant: 'ChunkClasses' value: {Smalltalk.ChunkBrowserMethodCategorySeriesStartChunk. Smalltalk.ChunkBrowserMethodDefineSeriesStartChunk. Smalltalk.ChunkBrowserMethodsCategoriesSeriesStartChunk. Smalltalk.ChunkBrowserClassDefineChunk. Smalltalk.ChunkBrowserClassDeleteChunk. Smalltalk.ChunkBrowserMethodDeleteChunk. Smalltalk.ChunkBrowserClassCommentChunk. Smalltalk.ChunkBrowserClassGUIDChunk. Smalltalk.ChunkBrowserClassProtocolChunk. Smalltalk.ChunkBrowserClassCategorySeriesStartChunk. Smalltalk.ChunkBrowserSystemChunk}!
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

addChunksFrom: sourceFiler to: chunks
	chunks addLast: self.
	index := chunks size!

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

classIdentityFromTokenStream: aReadStream
	| className |
	className := aReadStream next value.
	(self class isToken: aReadStream next identifier: 'class')
		ifTrue: [className := className , ' class']
		ifFalse: [aReadStream skip: -1].
	^className!

hash
	^(self class hash bitXor: identity1 hash) bitXor: identity2 hash!

identity1
	^identity1!

identity1AndIdentity2AsCompiledMethod
	^self identity1AsClass
		ifNotNil: [:class | class compiledMethodAt: identity2 asSymbol ifAbsent: nil]!

identity1AsClass
	^identity1 asQualifiedReference valueOrNil!

identity2
	^identity2!

index
	^index!

index: anInteger
	index := anInteger!

initialize: aString
	rawText := aString.
	picked := false.
	identity1 := identity2 := ''!

initialize: aString tokens: anArray
	self initialize: aString!

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
!ChunkBrowserChunk categoriesForMethods!
<=!comparing!public! !
=!comparing!public! !
addChunksFrom:to:!operations!public! !
browse!operations!public! !
browseTarget!operations!public! !
canBrowse!public!testing! !
canCompare!public!testing! !
canShowDifferences!public!testing! !
chunkClass!accessing!public! !
chunkIconIndex!accessing!public! !
chunkType!accessing!constants!public! !
classIdentityFromTokenStream:!initializing!private! !
hash!comparing!public! !
identity1!accessing!public! !
identity1AndIdentity2AsCompiledMethod!helpers!public! !
identity1AsClass!helpers!public! !
identity2!accessing!public! !
index!accessing!public! !
index:!accessing!public! !
initialize:!initializing!private! !
initialize:tokens:!initializing!private! !
isFilteredUsing:!operations!public! !
isImageSave!public!testing! !
isMatch!public!testing! !
matchIcon!accessing!constants!public! !
mismatchIcon!accessing!constants!public! !
missingIcon!constants!public! !
picked!accessing!public! !
picked:!accessing!public! !
pickedIconIndex!accessing!public! !
rawText!accessing!public! !
restore!operations!public! !
showIn:!displaying!public! !
!

!ChunkBrowserChunk class methodsFor!

chunksFromStream: aStream
	"Answer a collection of subclasses representing the chunks found in aStream"

	| chunks sourceFiler |
	chunks := OrderedCollection new: 128.
	sourceFiler := ChunkSourceFiler on: aStream.
	[aStream atEnd] whileFalse: 
			[| chunkText |
			chunkText := sourceFiler nextChunk.
			chunkText isEmpty ifFalse: [(self instanceFor: chunkText) addChunksFrom: sourceFiler to: chunks]].
	^chunks!

chunksFromText: aString
	"Answer a collection of subclasses representing the chunks found in aString"

	^self chunksFromStream: aString readStream!

chunkType
	self subclassResponsibility!

initialize
	"A collection of classes that should be tested to decide the type of a chunk"

	self addClassConstant: 'ChunkClasses'
		value: {
				ChunkBrowserMethodCategorySeriesStartChunk.
				ChunkBrowserMethodDefineSeriesStartChunk.
				ChunkBrowserMethodsCategoriesSeriesStartChunk.
				ChunkBrowserClassDefineChunk.
				ChunkBrowserClassDeleteChunk.
				ChunkBrowserMethodDeleteChunk.
				ChunkBrowserClassCommentChunk.
				ChunkBrowserClassGUIDChunk.
				ChunkBrowserClassProtocolChunk.
				ChunkBrowserClassCategorySeriesStartChunk.
				ChunkBrowserSystemChunk
			}!

instanceFor: aString
	"Detect the correct class for the chunk in aString and answer an instance of it"

	| tokens |
	tokens := (Scanner on: (ReadStream on: aString)) upToEnd.
	1 to: ChunkClasses size
		do: 
			[:i |
			| each |
			each := ChunkClasses at: i.
			(each isChunkClassFor: aString tokens: tokens) ifTrue: [^each newFor: aString tokens: tokens]].
	^ChunkBrowserOtherChunk newFor: aString tokens: tokens!

isChunkClassFor: aString tokens: anArrayOfStToken
	self subclassResponsibility!

isToken: aStToken amongKeywords: aCollectionOfStrings
	^aStToken isKeyword and: [aCollectionOfStrings includes: aStToken value]!

isToken: token identifier: aString
	^token isIdentifier and: [token value = aString]!

isToken: aStToken keyword: aString
	^aStToken isKeyword and: [aStToken value = aString]!

isTokenClassIdentifier: aStToken
	"The scanner will identify syntactically valid identifiers, qualified or not. We don't impose any additional restriction on the class names here as this is just used for matching purposes, and the chunks targeting classes are identifiable more reliably by other means."

	^aStToken isIdentifier!

isTokenString: aStToken
	^aStToken isLiteralToken and: [aStToken value isString]!

newFor: aString tokens: anArray
	"Answer an initialized instance of the receiving chunk class"

	^self new initialize: aString tokens: anArray! !
!ChunkBrowserChunk class categoriesForMethods!
chunksFromStream:!helpers!public! !
chunksFromText:!helpers!public! !
chunkType!accessing!constants!public! !
initialize!constants!public! !
instanceFor:!instance creation!public! !
isChunkClassFor:tokens:!public!testing! !
isToken:amongKeywords:!private!testing! !
isToken:identifier:!private!testing! !
isToken:keyword:!private!testing! !
isTokenClassIdentifier:!private!testing! !
isTokenString:!private!testing! !
newFor:tokens:!instance creation!public! !
!


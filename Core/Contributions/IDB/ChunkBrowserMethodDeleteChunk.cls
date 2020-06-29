"Filed out from Dolphin Smalltalk 7"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserMethodDeleteChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserMethodDeleteChunk guid: (GUID fromString: '{deb9428a-51f1-4a3f-a73f-d6cb2c444d99}')!
ChunkBrowserMethodDeleteChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodDeleteChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodDeleteChunk methodsFor!

browseTarget
	^self identity1AndIdentity2AsCompiledMethod!

identity1AndIdentity2AsCompiledMethod
	"Overridden for browse"

	^self identity1AsClass
		ifNotNil:
			[:arg | 
			| selectors |
			selectors := identity2 subStrings.
			(selectors notEmpty and: [arg includesSelector: selectors first asSymbol])
				ifTrue: [arg compiledMethodAt: selectors first asSymbol]]!

initialize: aString
	"	ClassName removeSelector: #SelectorSymbol
		ClassName class removeSelector: #SelectorSymbol
		ClassName removeSelector: #SelectorSymbol ifAbsent: []
		ClassName class removeSelector: #SelectorSymbol ifAbsent: []
		ClassName removeSelectors: #(SelectorSymbols)
		ClassName class removeSelectors: #(SelectorSymbols)"

	| hashIndex |
	super initialize: aString.
	identity1 := self classNameFromRawText.
	hashIndex := aString indexOf: $#.
	identity2 := (aString indexOfSubCollection: #removeSelectors:) == 0
		ifTrue:
			[| stop |
			stop := aString
				nextIndexOf: Character space
				from: hashIndex
				to: aString size.
			aString copyFrom: hashIndex + 1 to: (stop == 0 ifTrue: [aString size] ifFalse: [stop])]
		ifFalse:
			[(aString
				copyFrom: hashIndex + 1
				to:
					(aString
						nextIndexOf: $)
						from: hashIndex
						to: aString size)) copyWithoutAll: '#()'].
	identity2 := identity2 trimBlanks	"PE/27/05/2004: remove trailing blank (thanks Pieter)"!

isMatch
	"Answer true if class missing as the method must be deleted?"

	^self identity1AsClass
		ifNil: [true]
		ifNotNil:
			[:arg | (identity2 subStrings anySatisfy: [:each | arg includesSelector: each asSymbol]) not]! !
!ChunkBrowserMethodDeleteChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserMethodDeleteChunk categoriesFor: #identity1AndIdentity2AsCompiledMethod!helpers!public! !
!ChunkBrowserMethodDeleteChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserMethodDeleteChunk categoriesFor: #isMatch!public!testing! !

!ChunkBrowserMethodDeleteChunk class methodsFor!

chunkType
	^#'Method Delete'!

isChunkClassFor: aString
	"	ClassName removeSelector: #SelectorSymbol
		ClassName class removeSelector: #SelectorSymbol
		ClassName removeSelector: #SelectorSymbol ifAbsent: []
		ClassName class removeSelector: #SelectorSymbol ifAbsent: []
		ClassName removeSelectors: #(SelectorSymbols)
		ClassName class removeSelectors: #(SelectorSymbols)"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) ~= 0
		and:
			[#(' removeSelector: #' ' class removeSelector: #' ' removeSelectors: #(' ' class removeSelectors: #(')
				anySatisfy: [:each | (aString indexOfSubCollection: each) = firstSpaceIndex]]! !
!ChunkBrowserMethodDeleteChunk class categoriesFor: #chunkType!constants!public! !
!ChunkBrowserMethodDeleteChunk class categoriesFor: #isChunkClassFor:!public!testing! !


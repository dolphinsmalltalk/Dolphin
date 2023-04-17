"Filed out from Dolphin Smalltalk"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserMethodDeleteChunk
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserMethodDeleteChunk guid: (GUID fromString: '{deb9428a-51f1-4a3f-a73f-d6cb2c444d99}')!
ChunkBrowserMethodDeleteChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodDeleteChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodDeleteChunk methodsFor!

browseTarget
	^self identity1AsClass
		ifNotNil: 
			[:class |
			(selectors detect: [:each | class includesSelector: each] ifNone: nil)
				ifNil: [class]
				ifNotNil: [:selector | class compiledMethodAt: selector]]!

identity1AndIdentity2AsCompiledMethod
	"Overridden for browse"

	^self identity1AsClass
		ifNotNil: 
			[:class |
			(selectors detect: [:each | class includesSelector: each] ifNone: nil)
				ifNotNil: [:selector | class compiledMethodAt: selector]]!

initialize: aString tokens: anArray
	"Private - 	ClassName removeSelector: #SelectorSymbol
		ClassName class removeSelector: #SelectorSymbol
		ClassName removeSelector: #SelectorSymbol ifAbsent: []
		ClassName class removeSelector: #SelectorSymbol ifAbsent: []
		ClassName removeSelectors: #(SelectorSymbols)
		ClassName class removeSelectors: #(SelectorSymbols)"

	| tokens token |
	super initialize: aString tokens: anArray.
	tokens := ReadStream on: anArray.
	identity1 := self classIdentityFromTokenStream: tokens.
	tokens next value = 'removeSelectors:'
		ifTrue: 
			[self assert: [tokens next isLiteralArrayToken].
			selectors := Array writeStream.
			[(token := tokens next) isSpecial: $)] whileFalse: [selectors nextPut: token value].
			selectors := selectors contents.
			identity2 := selectors displayString.
			identity2 := identity2 copyFrom: 3 to: identity2 size - 1]
		ifFalse: 
			[identity2 := tokens next value.
			selectors := { identity2 }]!

isMatch
	"Answer true if class missing as the method must be deleted?"

	^self identity1AsClass
		ifNil: [true]
		ifNotNil: [:class | (selectors anySatisfy: [:each | class includesSelector: each]) not]! !
!ChunkBrowserMethodDeleteChunk categoriesForMethods!
browseTarget!operations!public! !
identity1AndIdentity2AsCompiledMethod!helpers!public! !
initialize:tokens:!initializing!private! !
isMatch!public!testing! !
!

!ChunkBrowserMethodDeleteChunk class methodsFor!

chunkType
	^#'Method Delete'!

isChunkClassFor: aString tokens: anArrayOfStToken
	"	ClassName removeSelector: #SelectorSymbol
		ClassName class removeSelector: #SelectorSymbol
		ClassName removeSelector: #SelectorSymbol ifAbsent: []
		ClassName class removeSelector: #SelectorSymbol ifAbsent: []
		ClassName removeSelectors: #(SelectorSymbols)
		ClassName class removeSelectors: #(SelectorSymbols)"

	| tokens token |
	anArrayOfStToken size >= 3 ifFalse: [^false].
	tokens := ReadStream on: anArrayOfStToken.
	(self isTokenClassIdentifier: tokens next) ifFalse: [^false].
	token := tokens next.
	(token isIdentifier and: [token value = 'class']) ifTrue: [token := tokens next].
	token isKeyword ifFalse: [^false].
	token value = 'removeSelector:'
		ifTrue: 
			["Don't bother to check for the optional trailing ifAbsent: argument"
			^tokens next isLiteralSymbolToken].
	token value = 'removeSelectors:' ifFalse: [^false].
	token := tokens nextAvailable.
	(token notNil and: [token isLiteralArrayToken]) ifFalse: [^false].
	
	[token := tokens nextAvailable.
	token isNil ifTrue: [^false].
	token isSpecial: $)]
			whileFalse: [token isLiteralSymbolToken ifFalse: [^false]].
	^tokens atEnd! !
!ChunkBrowserMethodDeleteChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!


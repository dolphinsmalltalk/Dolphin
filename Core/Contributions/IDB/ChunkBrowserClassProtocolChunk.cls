"Filed out from Dolphin Smalltalk"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserClassProtocolChunk
	instanceVariableNames: 'attributes selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserClassProtocolChunk guid: (GUID fromString: '{c8986897-7417-46b9-a404-28a5ab21ea14}')!
ChunkBrowserClassProtocolChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserClassProtocolChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserClassProtocolChunk methodsFor!

initialize: aString tokens: anArray
	"Private - Abc methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols
	Abc class methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols"

	| tokens token symbols |
	super initialize: aString tokens: anArray.
	tokens := ReadStream on: anArray.
	identity1 := self classIdentityFromTokenStream: tokens.
	"methodProtocol:"
	tokens next.
	identity2 := tokens next value.
	"attributes: #(#a #b)"
	tokens
		next;
		next.
	symbols := Array writeStream.
	
	[token := tokens next.
	token isSpecial: $)] whileFalse: [symbols nextPut: token value].
	attributes := symbols contents.
	"selectors: #(#foo #bar)"
	tokens
		next;
		next.
	symbols reset.
	
	[token := tokens next.
	token isSpecial: $)] whileFalse: [symbols nextPut: token value].
	selectors := symbols contents!

isMatch
	^self identity1AsClass
		ifNotNil: 
			[:class |
			(class conformsToProtocol: identity2) and: 
					[| protocol |
					protocol := self methodProtocol.
					protocol notNil
						and: [(protocol selectors noDifference: selectors) and: [protocol attributes noDifference: attributes]]]]!

methodProtocol
	^(MethodProtocol exists: identity2) ifTrue: [MethodProtocol name: identity2]! !
!ChunkBrowserClassProtocolChunk categoriesForMethods!
initialize:tokens:!initializing!private! !
isMatch!public!testing! !
methodProtocol!accessing!private! !
!

!ChunkBrowserClassProtocolChunk class methodsFor!

chunkType
	^#'Class Protocol'!

isChunkClassFor: aString tokens: anArrayOfStToken
	"Abc methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols
	Abc class methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols"

	| tokens token |
	anArrayOfStToken size >= 9 ifFalse: [^false].
	tokens := ReadStream on: anArrayOfStToken.
	self isTokenClassIdentifier: tokens next.
	token := tokens next.
	(self isToken: token identifier: 'class') ifTrue: [token := tokens next].
	(self isToken: token keyword: 'methodProtocol:') ifFalse: [^false].
	token := tokens next.
	token isLiteralSymbolToken ifFalse: [^false].
	token := tokens next.
	(self isToken: token keyword: 'attributes:') ifFalse: [^false].
	token := tokens next.
	token isLiteralArrayToken ifFalse: [^false].
	
	[token := tokens nextAvailable.
	token isNil ifTrue: [^false].
	token isSpecial: $)]
			whileFalse: [token isLiteralSymbolToken ifFalse: [^false]].
	token := tokens nextAvailable.
	(token notNil and: [self isToken: token keyword: 'selectors:']) ifFalse: [^false].
	token := tokens nextAvailable.
	(token notNil and: [token isLiteralArrayToken]) ifFalse: [^false].
	
	[token := tokens nextAvailable.
	token isNil ifTrue: [^false].
	token isSpecial: $)]
			whileFalse: [token isLiteralSymbolToken ifFalse: [^false]].
	^tokens atEnd! !
!ChunkBrowserClassProtocolChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!


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

browseTarget
	^self identity1AsClass!

initialize: aString
	"Abc methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols
	Abc class methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols"

	| target1 target2 target3 |
	super initialize: aString.
	identity1 := self classNameFromRawText.
	target1 := aString indexOf: $#.
	target2 := aString indexOfSubCollection: 'attributes:'.
	target3 := aString indexOfSubCollection: 'selectors:'.
	identity2 := ((aString copyFrom: target1 to: target2 - 1) copyWithoutAll: '#''') trimBlanks.
	attributes := ((aString copyFrom: target2 + 'attributes:' size to: target3 - 1)
		copyWithoutAll: '#()') trimBlanks subStrings collect: [:each | each asSymbol].
	selectors := ((aString copyFrom: target3 + 'selectors:' size to: aString size)
		copyWithoutAll: '#()') trimBlanks subStrings collect: [:each | each asSymbol]!

isMatch
	^self identity1AsClass
		ifNotNil:
			[(MethodProtocol exists: identity2)
				and:
					[| protocol |
					protocol := MethodProtocol name: identity2.
					(protocol selectors symmetricDifference: selectors) isEmpty
						and: [(protocol attributes symmetricDifference: attributes) isEmpty]]]! !
!ChunkBrowserClassProtocolChunk categoriesForMethods!
browseTarget!operations!public! !
initialize:!initializing!public! !
isMatch!public!testing! !
!

!ChunkBrowserClassProtocolChunk class methodsFor!

chunkType
	^#'Class Protocol'!

isChunkClassFor: aString
	"Abc methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols
	Abc class methodProtocol: aSymbol attributes: anArrayOfSymbols selectors: anArrayOfSymbols"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) ~= 0
		and:
			[#(' methodProtocol: #' ' class methodProtocol: #')
				anySatisfy: [:each | (aString indexOfSubCollection: each) = firstSpaceIndex]]! !
!ChunkBrowserClassProtocolChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:!public!testing! !
!


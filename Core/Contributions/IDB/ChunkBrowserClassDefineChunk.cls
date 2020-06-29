"Filed out from Dolphin Smalltalk 7"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserClassDefineChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserClassDefineChunk guid: (GUID fromString: '{9a18662b-ed08-4733-bf8b-c22ede8994e8}')!
ChunkBrowserClassDefineChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserClassDefineChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserClassDefineChunk methodsFor!

browseTarget
	^self identity1AsClass!

canShowDifferences
	^self identity1AsClass notNil!

initialize: aString
	"Abd subclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableByteSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''"

	| space1 space2 eol |
	super initialize: aString.
	space1 := rawText indexOf: $ .
	space2 := rawText
		nextIndexOf: $ 
		from: space1 + 1
		to: rawText size.
	eol := rawText
		nextIndexOf: String lineDelimiter first
		from: space2 + 1
		to: rawText size.
	identity1 := rawText copyFrom: space2 + 2 to: eol - 1.
	identity2 := rawText copyFrom: 1 to: space1 - 1!

isMatch
	^self identity1AsClass ifNotNil: [:arg | arg instanceClass definition = rawText]!

restore
	^self restoreAndLog: true!

sourceFromImage
	^self identity1AsClass instanceClass definition! !
!ChunkBrowserClassDefineChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserClassDefineChunk categoriesFor: #canShowDifferences!public!testing! !
!ChunkBrowserClassDefineChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserClassDefineChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserClassDefineChunk categoriesFor: #restore!operations!public! !
!ChunkBrowserClassDefineChunk categoriesFor: #sourceFromImage!accessing!public! !

!ChunkBrowserClassDefineChunk class methodsFor!

chunkType
	^#'Class Define'!

isChunkClassFor: aString
	"Abd subclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableByteSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: Character space) ~= 0
		and:
			[(#(' subclass: ' ' variableSubclass: ' ' variableByteSubclass: ')
				anySatisfy: [:each | (aString indexOfSubCollection: each) = firstSpaceIndex])
				and:
					[#('instanceVariableNames: ' 'classVariableNames: ' 'poolDictionaries: ' 'classInstanceVariableNames: ')
						allSatisfy: [:each | (aString indexOfSubCollection: each) ~= 0]]]! !
!ChunkBrowserClassDefineChunk class categoriesFor: #chunkType!constants!public! !
!ChunkBrowserClassDefineChunk class categoriesFor: #isChunkClassFor:!public!testing! !


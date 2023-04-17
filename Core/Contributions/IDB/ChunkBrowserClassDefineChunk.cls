"Filed out from Dolphin Smalltalk"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserClassDefineChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserClassDefineChunk guid: (GUID fromString: '{9a18662b-ed08-4733-bf8b-c22ede8994e8}')!
ChunkBrowserClassDefineChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserClassDefineChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserClassDefineChunk methodsFor!

canShowDifferences
	^self identity1AsClass notNil!

initialize: aString tokens: anArray
	"Private - Abd subclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableByteSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''"

	super initialize: aString tokens: anArray.
	identity2 := anArray first value.
	identity1 := anArray third value!

isMatch
	^self identity1AsClass ifNotNil: [:arg | arg instanceClass definition = rawText]!

restore
	^self restoreAndLog: true!

sourceFromImage
	^self identity1AsClass instanceClass definition! !
!ChunkBrowserClassDefineChunk categoriesForMethods!
canShowDifferences!public!testing! !
initialize:tokens:!initializing!private! !
isMatch!public!testing! !
restore!operations!public! !
sourceFromImage!accessing!public! !
!

!ChunkBrowserClassDefineChunk class methodsFor!

chunkType
	^#'Class Define'!

isChunkClassFor: aString tokens: anArrayOfStToken
	"Abd subclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''
	Abd variableByteSubclass: #Def instanceVariableNames: ''	classVariableNames: '' poolDictionaries: '' classInstanceVariableNames: ''"

	| token |
	anArrayOfStToken size < 11 ifTrue: [^false].
	(self isToken: (anArrayOfStToken at: 4) keyword: 'instanceVariableNames:') ifFalse: [^false].
	(self isToken: anArrayOfStToken second
		amongKeywords: ##(Set withAll: #('subclass:' 'variableSubclass:' 'variableByteSubclass:')))
			ifFalse: [^false].
	token := anArrayOfStToken first.
	((self isTokenClassIdentifier: token) or: [token isLiteralToken and: [token value isNil]])
		ifFalse: [^false].
	^anArrayOfStToken third isLiteralSymbolToken! !
!ChunkBrowserClassDefineChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!


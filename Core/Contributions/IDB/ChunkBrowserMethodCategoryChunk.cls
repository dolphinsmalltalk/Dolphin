"Filed out from Dolphin Smalltalk X6.1"!

ChunkBrowserCategoryChunk subclass: #ChunkBrowserMethodCategoryChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserMethodCategoryChunk guid: (GUID fromString: '{9D242F9C-C429-483D-848B-80FBC1B52DB7}')!
ChunkBrowserMethodCategoryChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodCategoryChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodCategoryChunk methodsFor!

browseTarget
	^self identity1AndIdentity2AsCompiledMethod!

isMatch
	^self identity1AndIdentity2AsCompiledMethod
		ifNotNil:
			[:arg | 
			| categories |
			categories := arg categories collect: [:each | each name].
			categories anySatisfy: [:each | each = rawText]]!

restore
	"Answers nil or the error information"

	^self identity1AndIdentity2AsCompiledMethod
		ifNil: [index -> 'Target class or method missing']
		ifNotNil:
			[:arg | 
			(MethodCategory name: rawText) addMethod: arg.
			nil]! !
!ChunkBrowserMethodCategoryChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserMethodCategoryChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserMethodCategoryChunk categoriesFor: #restore!operations!public! !

!ChunkBrowserMethodCategoryChunk class methodsFor!

chunkType
	^#'Method Category'! !
!ChunkBrowserMethodCategoryChunk class categoriesFor: #chunkType!constants!public! !


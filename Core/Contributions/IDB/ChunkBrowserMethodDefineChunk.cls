"Filed out from Dolphin Smalltalk X6"!

ChunkBrowserSeriesChunk subclass: #ChunkBrowserMethodDefineChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserMethodDefineChunk guid: (GUID fromString: '{1F404FDA-A397-4D69-B6AF-F3BC30E06DF4}')!
ChunkBrowserMethodDefineChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodDefineChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodDefineChunk methodsFor!

browseTarget
	^self identity1AndIdentity2AsCompiledMethod!

canShowDifferences
	^self identity1AndIdentity2AsCompiledMethod notNil!

initializeFrom: aChunkBrowserSeriesStartChunk 
	super initializeFrom: aChunkBrowserSeriesStartChunk.
	identity2 := SelectorParser parse: rawText!

isMatch
	^self identity1AndIdentity2AsCompiledMethod 
		ifNotNil: 
			[:arg | 
			arg getSource = rawText or: 
					[ChunkBrowser compareMethodsUsingParser and: 
							[arg parseTree = (SmalltalkParser 
										parseMethod: rawText
										in: self identity1AsClass
										onError: [:aString :pos | ^nil])]]]!

restore
	| answer |
	self identity1AsClass 
		ifNil: [answer := index -> 'Target class missing']
		ifNotNil: 
			[:arg | 
			[arg compile: self rawText] on: CompilerNotification
				do: 
					[:e | 
					answer := index -> e errorMessage.
					e resume]].
	^answer!

sourceText
	^self identity1AndIdentity2AsCompiledMethod getSource! !
!ChunkBrowserMethodDefineChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserMethodDefineChunk categoriesFor: #canShowDifferences!public!testing! !
!ChunkBrowserMethodDefineChunk categoriesFor: #initializeFrom:!initializing!public! !
!ChunkBrowserMethodDefineChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserMethodDefineChunk categoriesFor: #restore!operations!public! !
!ChunkBrowserMethodDefineChunk categoriesFor: #sourceText!accessing!public! !

!ChunkBrowserMethodDefineChunk class methodsFor!

chunkType
	^#'Method Define'! !
!ChunkBrowserMethodDefineChunk class categoriesFor: #chunkType!constants!public! !


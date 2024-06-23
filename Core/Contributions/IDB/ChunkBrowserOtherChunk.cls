"Filed out from Dolphin Smalltalk"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserOtherChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ChunkBrowserOtherChunk guid: (GUID fromString: '{593d449b-5b54-4990-9db8-1925ea103e40}')!

ChunkBrowserOtherChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ChunkBrowserOtherChunk categoriesForClass!IDB Goodies! !

!ChunkBrowserOtherChunk methodsFor!

= aChunk
	^super = aChunk and: [rawText = aChunk rawText]!

browseTarget
	self shouldNotImplement!

canBrowse
	^false!

canCompare
	^false!

chunkClass
	^nil!

chunkIconIndex
	"Override for no icon at all"

	^0!

hash
	^super hash bitXor: rawText hash!

initialize: aString tokens: anArray
	super initialize: aString tokens: anArray.
	self initializeIdentity!

initializeIdentity
	identity1 := (rawText first = $" and: [rawText last = $"])
				ifTrue: ['comment']
				ifFalse: ['evaluation'].
	identity2 := self summaryFromText!

isMatch
	^nil!

restore
	^nil!

summaryFromText
	| text summary ch |
	text := ReadStream on: rawText.
	summary := String writeStream: 102.
	
	[(ch := text nextAvailable) isNil
		or: [summary position == 99 and: 
					[summary nextPut: $\x2026.
					true]]]
			whileFalse: 
				[ch == $\r ifTrue: [summary nextPutAll: '\n'] ifFalse: [ch == $\n ifFalse: [summary nextPut: ch]]].
	^summary grabContents! !

!ChunkBrowserOtherChunk categoriesForMethods!
=!comparing!public! !
browseTarget!operations!public! !
canBrowse!public!testing! !
canCompare!public!testing! !
chunkClass!accessing!public! !
chunkIconIndex!accessing!public! !
hash!comparing!public! !
initialize:tokens:!initializing!private! !
initializeIdentity!initializing!public! !
isMatch!public!testing! !
restore!operations!public! !
summaryFromText!initializing!private! !
!

!ChunkBrowserOtherChunk class methodsFor!

chunkType
	^#Other!

isChunkClassFor: aString tokens: anArray
	^true! !

!ChunkBrowserOtherChunk class categoriesForMethods!
chunkType!constants!public! !
isChunkClassFor:tokens:!public!testing! !
!


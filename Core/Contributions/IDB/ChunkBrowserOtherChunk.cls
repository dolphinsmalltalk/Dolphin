"Filed out from Dolphin Smalltalk 7"!

ChunkBrowserExpressionChunk subclass: #ChunkBrowserOtherChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

initialize: aString
	super initialize: aString.
	identity1 := String new.
	self initializeIdentity!

initializeIdentity
	| tidy |
	identity1 := (rawText first = $" and: [rawText last = $"])
		ifTrue: ['comment']
		ifFalse: ['evaluation'].
	tidy := rawText copyReplacing: Character cr withObject: $_.
	tidy := tidy copyWithout: Character lf.
	identity2 := tidy copyFrom: 1 to: (tidy size min: 100)!

isMatch
	^nil!

restore
	^nil! !
!ChunkBrowserOtherChunk categoriesFor: #=!comparing!public! !
!ChunkBrowserOtherChunk categoriesFor: #browseTarget!operations!public! !
!ChunkBrowserOtherChunk categoriesFor: #canBrowse!public!testing! !
!ChunkBrowserOtherChunk categoriesFor: #canCompare!public!testing! !
!ChunkBrowserOtherChunk categoriesFor: #chunkClass!accessing!public! !
!ChunkBrowserOtherChunk categoriesFor: #chunkIconIndex!accessing!public! !
!ChunkBrowserOtherChunk categoriesFor: #hash!comparing!public! !
!ChunkBrowserOtherChunk categoriesFor: #initialize:!initializing!public! !
!ChunkBrowserOtherChunk categoriesFor: #initializeIdentity!initializing!public! !
!ChunkBrowserOtherChunk categoriesFor: #isMatch!public!testing! !
!ChunkBrowserOtherChunk categoriesFor: #restore!operations!public! !

!ChunkBrowserOtherChunk class methodsFor!

chunkType
	^#Other! !
!ChunkBrowserOtherChunk class categoriesFor: #chunkType!constants!public! !


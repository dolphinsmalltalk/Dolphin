"Filed out from Dolphin Smalltalk"!

ChunkBrowserChunk subclass: #ChunkBrowserExpressionChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserExpressionChunk guid: (GUID fromString: '{0f9c053e-f249-49b6-9da5-fcece45be89f}')!
ChunkBrowserExpressionChunk isAbstract: true!
ChunkBrowserExpressionChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserExpressionChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserExpressionChunk methodsFor!

browseTarget
	^self identity1AsClass!

restore
	"Override for evaluations that don't automatically log"

	^self restoreAndLog: false!

restoreAndLog: aBoolean
	"Answers nil or the error information"

	| answer |
	[Compiler evaluate: self rawText logged: aBoolean]
		on: CompilerNotification
		do:
			[:e | 
			answer := index -> e errorMessage.
			e resume].
	^answer! !
!ChunkBrowserExpressionChunk categoriesForMethods!
browseTarget!operations!public! !
restore!operations!public! !
restoreAndLog:!operations!public! !
!


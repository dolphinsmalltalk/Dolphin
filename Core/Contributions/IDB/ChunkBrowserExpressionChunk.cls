"Filed out from Dolphin Smalltalk X6"!

ChunkBrowserChunk subclass: #ChunkBrowserExpressionChunk
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowserExpressionChunk guid: (GUID fromString: '{0F9C053E-F249-49B6-9DA5-FCECE45BE89F}')!
ChunkBrowserExpressionChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserExpressionChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserExpressionChunk methodsFor!

restore
	"Override for evaluations that don't automatically log"

	^self restoreAndLog: false!

restoreAndLog: aBoolean 
	| answer |
	[Compiler evaluate: self rawText logged: aBoolean] on: CompilerNotification
		do: 
			[:e | 
			answer := index -> e errorMessage.
			e resume].
	^answer! !
!ChunkBrowserExpressionChunk categoriesFor: #restore!operations!public! !
!ChunkBrowserExpressionChunk categoriesFor: #restoreAndLog:!operations!public! !


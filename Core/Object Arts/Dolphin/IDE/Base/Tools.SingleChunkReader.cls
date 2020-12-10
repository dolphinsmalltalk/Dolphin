"Filed out from Dolphin Smalltalk 7"!

ChunkReader subclass: #SingleChunkReader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SingleChunkReader guid: (GUID fromString: '{daff2a96-8e7c-400e-9fb0-df8d523f7136}')!
SingleChunkReader comment: ''!
!SingleChunkReader categoriesForClass!Unclassified! !
!SingleChunkReader methodsFor!

fileInFrom: aSourceFiler
	"Private - File in the next chunk (if any) from the <ChunkSourceFiler> argument, 
	aChunkSourceFiler, then evaluate the final action and answer its result."

	| chunk |
	(aSourceFiler atEnd or: [(chunk := aSourceFiler nextChunk) isEmpty]) 
		ifFalse: [self chunk: chunk].
	^endAction value! !
!SingleChunkReader categoriesFor: #fileInFrom:!private!source filing! !


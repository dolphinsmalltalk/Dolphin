"Filed out from Dolphin Smalltalk X6"!

ChunkReader subclass: #SingleChunkReader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SingleChunkReader guid: (GUID fromString: '{DAFF2A96-8E7C-400E-9FB0-DF8D523F7136}')!
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


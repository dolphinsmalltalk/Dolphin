"Filed out from Dolphin Smalltalk"!

Kernel.ChunkReader
	subclass: #'Tools.SingleChunkReader'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.SingleChunkReader guid: (Core.GUID fromString: '{daff2a96-8e7c-400e-9fb0-df8d523f7136}')!

Tools.SingleChunkReader comment: ''!

!Tools.SingleChunkReader categoriesForClass!Kernel-Support! !

!Tools.SingleChunkReader methodsFor!

fileInFrom: aSourceFiler
	"Private - File in the next chunk (if any) from the <ChunkSourceFiler> argument, 
	aChunkSourceFiler, then evaluate the final action and answer its result."

	| chunk |
	(aSourceFiler atEnd or: [(chunk := aSourceFiler nextChunk) isEmpty]) 
		ifFalse: [chunkBlock cull: chunk cull: aSourceFiler].
	^endAction value! !

!Tools.SingleChunkReader categoriesForMethods!
fileInFrom:!private!source filing! !
!


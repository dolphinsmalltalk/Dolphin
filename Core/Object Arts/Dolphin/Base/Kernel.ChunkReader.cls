"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.ChunkReader'
	instanceVariableNames: 'chunkBlock endAction context'
	classVariableNames: 'Null'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ChunkReader guid: (Core.GUID fromString: '{87b4c460-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.ChunkReader comment: '
	The source reader is delegated the task of reading chunks
	from the input stream, and so can impose its own format.'!
!Kernel.ChunkReader categoriesForClass!Kernel-Support! !
!Kernel.ChunkReader methodsFor!

chunkBlock
	"Answer the receiver's chunkBlock. This is a <dyadicValuable> which is evaluated for each chunk of text read from a stream."

	^chunkBlock!

context
	"Answer the context <Object> associated with the receiver when it was created (usually the class
	into which methods are to be compiled)."

	^context!

fileInFrom: aSourceFiler
	"Private - File in the next chunk from the `ChunkSourceFiler` argument. Continue reading chunks until the end of the file or an empty chunk is reached, at which point the final action is evaluated. Answer the result of the final action."

	| chunk |
	[aSourceFiler atEnd or: [(chunk := aSourceFiler nextChunk) isEmpty]]
		whileFalse: [chunkBlock cull: chunk cull: aSourceFiler].
	^endAction value!

setChunkBlock: perChunk context: contextObject endAction: finalOperation 
	"Private - Initialize the receiver's instance variables."

	chunkBlock := perChunk.
	endAction := finalOperation.
	context := contextObject! !
!Kernel.ChunkReader categoriesForMethods!
chunkBlock!accessing!public! !
context!accessing!public! !
fileInFrom:!private!source filing! !
setChunkBlock:context:endAction:!accessing!private! !
!

!Kernel.ChunkReader class methodsFor!

do: operation 
	"Answer a new instance of the reciever which will evaluate
	the monadic valuable, operation, for every chunk string read
	via the source manager, aSourceManager."

	^self do: operation atEnd: []!

do: operation atEnd: finalOperation 
	"Answer a new instance of the reciever which will evaluate
	the <monadicValuable>, operation, for every chunk string read
	via the source manager, aSourceManager. At the end
	of the batch of chunks (i.e. when an empty chunk is reach),
	the <niladicValuable>, finalOperation, is evaluated."

	^self 
		do: operation
		inContext: nil
		atEnd: finalOperation!

do: operation inContext: contextObject atEnd: finalOperation 
	"Answer a new instance of the reciever which will evaluate
	the <monadicValuable>, operation, for every chunk string read
	via the source manager, aSourceManager. At the end
	of the batch of chunks (i.e. when an empty chunk is reach),
	the <niladicValuable>, finalOperation, is evaluated."

	^(self new)
		setChunkBlock: operation
			context: contextObject
			endAction: finalOperation;
		yourself!

null
	"Answer a null instance of the receiver which consumes and discards input without
	processing it in any way."

	Null isNil ifTrue: [Null := self do: [:chunk :filer | ]].
	^Null!

onPreStripImage
	"Private - The image is about to be deployed as an executable/DLL. Clean away
	any lazily initialized class variables in order to assist the stripping process."

	Null := nil! !
!Kernel.ChunkReader class categoriesForMethods!
do:!instance creation!public! !
do:atEnd:!instance creation!public! !
do:inContext:atEnd:!instance creation!public! !
null!instance creation!public! !
onPreStripImage!initializing!private! !
!


"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ChunkReader
	instanceVariableNames: 'chunkBlock endAction context'
	classVariableNames: 'Null'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkReader guid: (GUID fromString: '{87b4c460-026e-11d3-9fd7-00a0cc3e4a32}')!
ChunkReader comment: '
	The source reader is delegated the task of reading chunks
	from the input stream, and so can impose its own format.'!
!ChunkReader categoriesForClass!Kernel-Support! !
!ChunkReader methodsFor!

chunk: chunkString
	"Private - Evaluate the receivers chunkBlock with chunkString."

	self chunkBlock value: chunkString!

chunkBlock
	"Answer the receivers chunkBlock. This is a <monadicValuable> 
	which is evaluated for each chunk of text read from a stream."

	^chunkBlock!

context
	"Answer the context <Object> associated with the receiver when it was created (usually the class
	into which methods are to be compiled)."

	^context!

fileInFrom: aSourceFiler
	"Private - File in the next chunk from the <ChunkSourceFiler> argument, 
	aChunkSourceFiler. Continue reading chunks until the end of the file or an 
	empty chunk is reached, at which point the final action is evaluated. Answer 
	the result of the final action."

	| chunk |
	[aSourceFiler atEnd or: [(chunk := aSourceFiler nextChunk) isEmpty]]
		whileFalse: [self chunk: chunk].
	^endAction value!

setChunkBlock: perChunk context: contextObject endAction: finalOperation 
	"Private - Initialize the receiver's instance variables."

	chunkBlock := perChunk.
	endAction := finalOperation.
	context := contextObject! !
!ChunkReader categoriesFor: #chunk:!operations!private! !
!ChunkReader categoriesFor: #chunkBlock!accessing!public! !
!ChunkReader categoriesFor: #context!accessing!public! !
!ChunkReader categoriesFor: #fileInFrom:!private!source filing! !
!ChunkReader categoriesFor: #setChunkBlock:context:endAction:!accessing!private! !

!ChunkReader class methodsFor!

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

	Null isNil ifTrue: [Null := self do: [:chunk |]].
	^Null!

onPreStripImage
	"Private - The image is about to be deployed as an executable/DLL. Clean away
	any lazily initialized class variables in order to assist the stripping process."

	Null := nil! !
!ChunkReader class categoriesFor: #do:!instance creation!public! !
!ChunkReader class categoriesFor: #do:atEnd:!instance creation!public! !
!ChunkReader class categoriesFor: #do:inContext:atEnd:!instance creation!public! !
!ChunkReader class categoriesFor: #null!instance creation!public! !
!ChunkReader class categoriesFor: #onPreStripImage!initializing!private! !


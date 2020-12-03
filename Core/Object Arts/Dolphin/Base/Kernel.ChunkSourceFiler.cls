"Filed out from Dolphin Smalltalk 7"!

Kernel.SourceFiler subclass: #'Kernel.ChunkSourceFiler'
	instanceVariableNames: 'sourceFileIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'NormalizeEolsMask' -> 16r2
	}!
Kernel.ChunkSourceFiler guid: (Core.GUID fromString: '{558b318a-9ff3-4346-a445-76ee18d5458b}')!
Kernel.ChunkSourceFiler comment: ''!
!Kernel.ChunkSourceFiler categoriesForClass!Development!System-Support! !
!Kernel.ChunkSourceFiler methodsFor!

emitChunk: aString
	"Private - Output the specified text with a trailing end of chunk marker to the argument,
	aWriteStream."

	self
		nextChunkPut: aString;
		cr!

emitClassName: aClass
	aClass environment == aClass baseEnvironment
		ifTrue: [stream nextPutAll: aClass name]
		ifFalse: [aClass printFullNameOn: stream]!

emitFooterForMethodsOf: aClass 
	"Private - Ends the method definition chunks for aClass onto
	the source stream."

	self endChunk!

emitGUIDOfClass: aClass
	"Private - Emit a GUID definition chunk for the <Class>, aClass, onto the <puttableStream>, aWriteStream."

	| guid |
	guid := aClass guid.
	self emitClassName: aClass.
	stream
		space;
		nextPutAll: #guid:;
		nextPutAll: ' ('.
	self emitClassName: guid class.
	stream
		space;
		nextPutAll: #fromString:;
		space;
		print: guid asString;
		nextPutAll: ')!!';
		cr!

emitHeaderForMethodsOf: aClass
	"Private - Emits a category header for the class, aClass, to the source stream."

	stream nextPut: $!!.
	self emitClassName: aClass.
	stream
		space;
		nextPutAll: #methodsFor;
		nextPut: $!!!

emitString: aString 
	"Private - Print the <readableString>, aString, to the source stream, quoting any 
	embedded meta-characters so that it can be re-read as the exact same string when filed-in. 
	Answer aString.
	In this case we need only double embedded chunk markers, there being no other meta-characters."

	"Source will very rarely include the chunk terminator character so perform a fast search first...."

	(aString identityIncludes: $!!) 
		ifTrue: 
			[aString do: 
					[:character | 
					stream nextPut: character.
					"Double up embedded chunk markers"
					character == $!! ifTrue: [stream nextPut: $!!]]]
		ifFalse: [stream nextPutAll: aString].
	^aString!

endChunk
	"Private - Output an end of chunk marker to the argument, aStream."

	stream
		nextPutAll: ' !!';
		cr!

fileIn
	"File in the expressions/definitions from receiver's source stream, which is
	expected to be in the receiver's chunk format. Any methods that fail to compile are stubbed 
	with instances of <CompileFailedMethod> and errors are logged to the Transcript."

	
	[[stream atEnd] whileFalse: 
			[stream skipSeparators.
			(stream peekFor: $!!)
				ifTrue: 
					[| chunk reader |
					"#methodsFor: expression (we hope) - don't log evaluation"
					chunk := self nextChunk.
					reader := Compiler evaluate: chunk for: self evaluationContext.
					reader isNil
						ifTrue: 
							["The above evaluation failed to compile and the error will have
					been logged to the Transcript. Use the null ChunkReader to skip
					over the chunks in the source file."
							reader := ChunkReader null].
					reader fileInFrom: self]
				ifFalse: 
					[| chunk |
					"Normal expression evaluation - log it"
					chunk := self nextChunk.
					Compiler
						evaluate: chunk
						for: self evaluationContext
						logged: true]]]
			on: MethodCompileFailed
			do: 
				[:n |
				"If we get a method compilation error then we install a stub method so we'll be able 
			to see the source. For evaluations this does nothing, unfortunately"
				n
					beep;
					resumeWithStubMethod]!

fileOutExpression: aString
	"Append an immediate expression evaluation to the the source stream."

	self emitChunk: aString; cr!

getSourceFromDescriptor: sourceDescriptor 
	"Answer the <readableString> source corresponding to the specified <integer> 
	descriptor, sourceDescriptor, from the receiver's source stream."

	sourceDescriptor isNil ifTrue: [^''].
	stream position: (self sourcePositionFromDescriptor: sourceDescriptor).
	^self nextChunk!

nextChunk
	"Private - Answer a <String> containing the text up to the next chunk marker in the receiver's source stream,
	undoubling embedded chunk markers. Leading white space is skipped. 
	Implementation Note: String concatenation is more efficient here in the loop body because most 
	chunks do not include embedded chunk markers."

	| chunk |
	stream skipSeparators.
	^self normalizeLineEndings
		ifTrue: 
			[| next |
			chunk := String writeStream: 512.
			[(next := stream nextAvailable) isNil or: [next == $!! and: [(stream peekFor: $!!) not]]] whileFalse: 
					[((next == $\r and: 
							[stream peekFor: $\n.
							true]) or: [next == $\n])
						ifTrue: [chunk nextPutAll: String.LineDelimiter]
						ifFalse: [chunk nextPut: next]].
			chunk contents]
		ifFalse: 
			["Much faster, as we don't need to read and compare each character individually"
			chunk := stream upTo: $!!.
			[stream atEnd or: [(stream peekFor: $!!) not]] whileFalse: [chunk := chunk , '!!' , (stream upTo: $!!)].
			chunk]!

nextChunkPut: aString 
	"Private - Print the string, aString, to the <puttableStream> aWriteStream as a chunk. 
	This means doubling any chunk marker characters in the string and terminating 
	it with another chunk marker. Answer aString."

	self emitString: aString.
	stream nextPut: $!!.
	^aString!

normalizeLineEndings
	^flags anyMask: NormalizeEolsMask!

normalizeLineEndings: aBoolean
	flags := flags mask: NormalizeEolsMask set: aBoolean!

sourceDescriptorForIndex: indexInteger position: positionInteger 
	"Private - Answer an <integer> source descriptor which encodes the <integer> source file
	index, indexInteger, and the <integer> source file position, positionInteger. The source
	file index must be in the range 0..15, and the position >= 0."

	^(indexInteger bitAnd: 16rF) bitOr: (positionInteger bitShift: 4)!

sourceFileIndex: anInteger
	"Private - Set the <integer> source file index associated with the receiver."

	sourceFileIndex := anInteger!

storeSourceString: aString forMethod: aCompiledMethod 
	"Private - Save the <readableString>, aString, as the source text for the 
	<CompiledMethod>, aCompiledMethod, to the receiver's source stream
	encoding the position and index into the methods source descriptor so that 
	the source may be retrieved later."

	| methodClass |
	methodClass := aCompiledMethod methodClass.
	self 
		emitHeaderForMethodsOf: methodClass; 
		cr;
		storeSource: aString for: aCompiledMethod;
		emitFooterForMethodsOf: methodClass;
		flush
! !
!Kernel.ChunkSourceFiler categoriesFor: #emitChunk:!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #emitClassName:!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #emitFooterForMethodsOf:!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #emitGUIDOfClass:!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #emitHeaderForMethodsOf:!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #emitString:!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #endChunk!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #fileIn!public!source filing-file in! !
!Kernel.ChunkSourceFiler categoriesFor: #fileOutExpression:!public!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #getSourceFromDescriptor:!public!source filing-file in! !
!Kernel.ChunkSourceFiler categoriesFor: #nextChunk!private!source filing-file in! !
!Kernel.ChunkSourceFiler categoriesFor: #nextChunkPut:!private!source filing-file out! !
!Kernel.ChunkSourceFiler categoriesFor: #normalizeLineEndings!accessing!public! !
!Kernel.ChunkSourceFiler categoriesFor: #normalizeLineEndings:!accessing!public! !
!Kernel.ChunkSourceFiler categoriesFor: #sourceDescriptorForIndex:position:!private!source filing-file in! !
!Kernel.ChunkSourceFiler categoriesFor: #sourceFileIndex:!accessing!private! !
!Kernel.ChunkSourceFiler categoriesFor: #storeSourceString:forMethod:!private!source filing-file out! !

!Kernel.ChunkSourceFiler class methodsFor!

on: aWriteStream sourceFileIndex: anInteger
	"Answer a new instance of the receiver for filing out source code onto the 
	<puttableStream> argument, and using the <integer>, anInteger, as the 
	source file index when asked to update the source descriptor of <sourceObject>s.
	If the argument is nil, then answer a null source filer that discards all filed source."

	^(self on: aWriteStream)
		sourceFileIndex: anInteger;
		yourself! !
!Kernel.ChunkSourceFiler class categoriesFor: #on:sourceFileIndex:!instance creation!public! !


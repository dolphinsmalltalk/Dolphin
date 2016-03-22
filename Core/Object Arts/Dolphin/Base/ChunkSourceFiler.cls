"Filed out from Dolphin Smalltalk 7"!

SourceFiler subclass: #ChunkSourceFiler
	instanceVariableNames: 'sourceFileIndex '
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkSourceFiler guid: (GUID fromString: '{558B318A-9FF3-4346-A445-76EE18D5458B}')!
ChunkSourceFiler comment: ''!
!ChunkSourceFiler categoriesForClass!Development!System-Support! !
!ChunkSourceFiler methodsFor!

emitCategories: aCollection for: aSymbol in: aClass 
	stream
		nextPut: $!!;
		nextPutAll: aClass name;
		space;
		nextPutAll: #categoriesFor:;
		space.
	"#2144."
	self emitString: aSymbol printString.
	stream nextPut: $!!.
	aCollection asSortedCollection do: [:each | self nextChunkPut: each name].
	self endChunk!

emitCategoriesOfClass: aClass 
	"Private - Emit a chunk to source stream to reclassify the <Class>, aClass, in all its existing 
	categories."

	| categories |
	categories := aClass categories.
	categories notEmpty 
		ifTrue: 
			[stream
				nextPut: $!!;
				nextPutAll: aClass name;
				space;
				nextPutAll: #categoriesForClass;
				nextPutAll: '!!'.
			categories asSortedCollection do: [:aCategory | self nextChunkPut: aCategory name].
			self endChunk]!

emitCategoriesOfMethod: aCompiledMethod 
	"Private - Append a chunk to the <puttableStream>, aWriteStream,
	to reclassify the <CompiledMethod>, aCompiledMethod, in all its current 
	method categories."

	self 
		emitCategories: aCompiledMethod realCategories
		for: aCompiledMethod selector
		in: aCompiledMethod methodClass!

emitChunk: aString 
	"Private - Output the specified text with a trailing end of chunk marker 
	to the argument, aWriteStream."

	self
		nextChunkPut: aString;
		cr!

emitComment: aString 
	"Private - Record aString to the change log as a comment. All comments
	logged are prefixed with a timestamp.
	N.B. Logging requests should be directed through the SessionManager."

	stream
		nextPut: $";
		nextPutAll: aString;
		nextPut: $";
		nextPut: $!!;
		cr;
		flush!

emitCommentOfClass: aClass 
	"Private - Emit a chunk which defines the comment for the <Class>, aClass, to the <puttableStream>
	aWriteStream."

	self emitChunk: aClass name , ' comment: ' , aClass comment printString!

emitDeclarationForPoolVariable: each ofClass: aClass 
	stream
		display: aClass;
		space;
		display: (each isImmutable ifTrue: [#constant:] ifFalse: [#variable:]);
		space;
		print: each key;
		nextPut: $!!;
		cr!

emitFooterForMethodsOf: aClass 
	"Private - Ends the method definition chunks for aClass onto
	the source stream."

	self endChunk!

emitGUIDOfClass: aClass 
	"Private - Emit a GUID definition chunk for the <Class>, aClass, onto the <puttableStream>, aWriteStream."

	| guid |
	guid := aClass guid.
	stream
		nextPutAll: aClass name;
		nextPutAll: ' guid: (';
		nextPutAll: guid class name;
		nextPutAll: ' fromString: ';
		print: guid asString;
		nextPut: $);
		nextPut: $!!;
		cr!

emitHeaderForMethodsOf: aClass 
	"Private - Emits a category header for the class, aClass, to the source stream."

	stream
		nextPut: $!!;
		nextPutAll: aClass name;
		space;
		nextPutAll: #methodsFor;
		nextPut: $!!!

emitInitializerForPoolVariable: aClass ofClass: each 
	^stream
		nextPut: $!!;
		display: aClass;
		space;
		display: #initializerFor:;
		space;
		print: each key;
		nextPut: $!!;
		print: each value;
		nextPut: $!!;
		cr!

emitMethod: aCompiledMethod 
	"Private - File out the source of the single <CompiledMethod>, aCompiledMethod, 
	to the source stream, updating the method's source descriptor if configured with a 
	source file index."

	self storeSource: aCompiledMethod getSource for: aCompiledMethod!

emitSetBehaviorFlag: flagName forClass: aClass 
	"Private - Emit an attribute for the <Class>, aClass, to define its special behaviour flag named by
	the <Symbol>, flagName."

	stream
		print: aClass;
		space;
		nextPutAll: flagName;
		nextPutAll: ': true!!';
		cr!

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
					["#methodsFor: expression (we hope) - don't log evaluation"

					| chunk reader |
					chunk := self nextChunk.
					reader := Compiler 
								evaluate: chunk
								for: self evaluationContext
								logged: false.
					reader isNil 
						ifTrue: 
							["The above evaluation failed to compile and the error will have
					been logged to the Transcript. Use the null ChunkReader to skip
					over the chunks in the source file."

							reader := ChunkReader null].
					reader fileInFrom: self]
				ifFalse: 
					["Normal expression evaluation - log it"

					| chunk |
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

fileOutBasicDefinitionOfClass: aClass 
	"Print a definition of the <Class>, aClass, onto the <puttableStream>, aWriteStream."

	aClass printDefinitionOn: stream.
	stream
		nextPut: $!!;
		cr!

fileOutBinaryGlobal: anAssociation 
	"File out the text representation of the non-<sourceObject> which is the value of the
	<Association>, anAssociation, onto the receiver's source stream. The key of the association
	is the global name. If the global is just an alias to a class, then we don't need to binary
	file it at all."

	| glob |
	glob := anAssociation value.
	(glob class isMeta and: [anAssociation key ~= glob name]) 
		ifTrue: 
			[stream
				nextPutAll: anAssociation key;
				nextPutAll: ' := ';
				print: anAssociation value;
				nextPut: $!!;
				cr.
			^self].
	stream
		nextPutAll: anAssociation key;
		nextPutAll: ' := ';
		print: Object;
		space;
		display: #fromBinaryStoreBytes:;
		space;
		cr.
	glob binaryStoreBytes base64StoreOn: stream.
	stream
		nextPut: $!!;
		cr!

fileOutExpression: aString
	"Append an immediate expression evaluation to the the source stream."

	self emitChunk: aString; cr!

fileOutPoolDictionary: aPoolDictionary 
	"Append a definition of the <PoolDictionary> (or <PoolConstantsDictionary>, aPoolDictionary,
	to the <puttableStream>, aWriteStream. The definition should be sufficient to recreate a
	copy of the dictionary."

	| poolName value env |
	env := aPoolDictionary environment.
	poolName := aPoolDictionary name.
	stream
		nextPutAll: (env keyAtValue: env);
		nextPutAll: ' at: ';
		print: poolName;
		nextPutAll: ' put: (';
		nextPutAll: aPoolDictionary class name;
		nextPutAll: ' named: ';
		print: aPoolDictionary name.
	self emitChunk: ')'.
	aPoolDictionary associations asSortedCollection do: 
			[:a | 
			stream
				nextPutAll: poolName;
				nextPutAll: ' at: ';
				print: a key;
				nextPutAll: ' put: '.
			value := a value.
			value isLiteral 
				ifTrue: 
					[self emitChunk: (value isInteger ifTrue: [value printStringRadix: 16] ifFalse: [value printString])]
				ifFalse: 
					[stream
						nextPut: $(;
						print: Object;
						space;
						display: #fromBinaryStoreBytes:;
						space;
						cr.
					value binaryStoreBytes base64StoreOn: stream.
					self emitChunk: ')']].
	self emitChunk: poolName , ' shrink'!

fileOutPoolInitializersOfClass: aClass 
	aClass classPool associations asSortedCollection do: 
			[:each | 
			each value isLiteral 
				ifTrue: 
					[self emitDeclarationForPoolVariable: each ofClass: aClass.
					self emitInitializerForPoolVariable: aClass ofClass: each]]!

fileOutProtocols: aCollection ofBehavior: aClassDescription 
	"File out the <MethodProtocol>s in the <collection>, aCollection, to source stream,
	associating them with the <ClassDescription>, aClassDescription."

	aCollection isEmpty ifTrue: [^self].
	(aCollection asSortedCollection: [:a :b | (a name trueCompare: b name) <= 0]) do: 
			[:p | 
			stream
				nextPutAll: aClassDescription name;
				nextPutAll: ' methodProtocol: ';
				print: p asSymbol;
				nextPutAll: ' attributes: ';
				print: p attributes asArray;
				nextPutAll: ' selectors: #('.
			"We must print the selectors individually as their may be very many and the default print truncates after
			 a certain number of characters."
			p selectors asSortedCollection do: [:s | stream print: s] separatedBy: [stream space].
			self
				nextChunkPut: ')';
				cr].
	self cr!

getSourceFromDescriptor: sourceDescriptor 
	"Answer the <readableString> source corresponding to the specified <integer> 
	descriptor, sourceDescriptor, from the receiver's source stream."

	sourceDescriptor isNil ifTrue: [^''].
	stream position: (self sourcePositionFromDescriptor: sourceDescriptor).
	^self nextChunk!

logEvaluation: aString
	"Private - Log an immediate expression evaluation to the the source stream."

	stream nextPutAll: '"Evaluate"'; cr.
	self fileOutExpression: aString!

nextChunk
	"Private - Answer a <String> containing the text up to the next chunk marker in the receiver's source stream,
	undoubling embedded chunk markers. Leading white space is skipped. 
	Implementation Note: String concatenation is more efficient here in the loop body because most 
	chunks do not include embedded chunk markers."

	| result |
	stream skipSeparators.
	result := stream upTo: $!!.
	[stream atEnd or: [(stream peekFor: $!!) not]]
		whileFalse: [result := result, '!!', (stream upTo: $!!)].
	^result!

nextChunkPut: aString 
	"Private - Print the string, aString, to the <puttableStream> aWriteStream as a chunk. 
	This means doubling any chunk marker characters in the string and terminating 
	it with another chunk marker. Answer aString."

	self emitString: aString.
	stream nextPut: $!!.
	^aString!

sourceDescriptorForIndex: indexInteger position: positionInteger 
	"Private - Answer an <integer> source descriptor which encodes the <integer> source file
	index, indexInteger, and the <integer> source file position, positionInteger. The source
	file index must be in the range 0..15, and the position >= 0."

	^(indexInteger bitAnd: 16rF) bitOr: (positionInteger bitShift: 4)!

sourceFileIndex: anInteger
	"Private - Set the <integer> source file index associated with the receiver."

	sourceFileIndex := anInteger!

storeCommentString: aString forClass: aClass
	"Save the <readableString>, aString, as the comment text for the 
	<Class>, aClass, to the receiver's source stream encoding the position and 
	index into the class' source descriptor so that the comment may be retrieved later."

	stream nextPutAll: aClass name; nextPutAll: ' comment:'; cr.
	self storeSource: aString printString for: aClass.
	stream cr!

storeCommentString: aString forPackage: aPackage 
	"Save the <readableString>, aString, as the comment text for the <Package>, aPackage, to the
	receiver's source stream encoding the position and index into the package's source
	descriptor so that the comment may be retrieved later."

	stream
		nextPut: $(;
		print: aPackage class;
		space;
		nextPutAll: #manager;
		space;
		nextPutAll: #packageNamed:;
		space;
		print: aPackage name;
		nextPutAll: ') ';
		nextPutAll: #comment:;
		cr.
	self storeSource: aString printString for: aPackage.
	stream cr!

storeSource: aString for: aSourceObject 
	"Private - Store the <readableString>, aString, as the source text for the <sourceObject>,
	aSourceObject. If the receiver has been associated with a source file (i.e. the
	sourceFileIndex is set) then update aSourceObject's source descriptor so that in future it
	retrieves the source text from the receiver's source stream."

	| position |
	position := stream position.
	self nextChunkPut: aString.
	sourceFileIndex notNil 
		ifTrue: 
			[aSourceObject sourceDescriptor: (aString isEmpty ifFalse: [self sourceDescriptorForIndex: sourceFileIndex position: position])]!

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
!ChunkSourceFiler categoriesFor: #emitCategories:for:in:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitCategoriesOfClass:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitCategoriesOfMethod:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitChunk:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitComment:!operations-logging!private! !
!ChunkSourceFiler categoriesFor: #emitCommentOfClass:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitDeclarationForPoolVariable:ofClass:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitFooterForMethodsOf:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitGUIDOfClass:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitHeaderForMethodsOf:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitInitializerForPoolVariable:ofClass:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitMethod:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitSetBehaviorFlag:forClass:!private!source filing! !
!ChunkSourceFiler categoriesFor: #emitString:!private!source filing! !
!ChunkSourceFiler categoriesFor: #endChunk!private!source filing! !
!ChunkSourceFiler categoriesFor: #fileIn!public!source filing! !
!ChunkSourceFiler categoriesFor: #fileOutBasicDefinitionOfClass:!public!source filing! !
!ChunkSourceFiler categoriesFor: #fileOutBinaryGlobal:!public!source filing! !
!ChunkSourceFiler categoriesFor: #fileOutExpression:!public!source filing! !
!ChunkSourceFiler categoriesFor: #fileOutPoolDictionary:!public!source filing! !
!ChunkSourceFiler categoriesFor: #fileOutPoolInitializersOfClass:!accessing!public! !
!ChunkSourceFiler categoriesFor: #fileOutProtocols:ofBehavior:!public!source filing! !
!ChunkSourceFiler categoriesFor: #getSourceFromDescriptor:!public!source filing! !
!ChunkSourceFiler categoriesFor: #logEvaluation:!private!source filing! !
!ChunkSourceFiler categoriesFor: #nextChunk!private!source filing! !
!ChunkSourceFiler categoriesFor: #nextChunkPut:!private!source filing! !
!ChunkSourceFiler categoriesFor: #sourceDescriptorForIndex:position:!private!source filing! !
!ChunkSourceFiler categoriesFor: #sourceFileIndex:!accessing!private! !
!ChunkSourceFiler categoriesFor: #storeCommentString:forClass:!public!source filing! !
!ChunkSourceFiler categoriesFor: #storeCommentString:forPackage:!public!source filing! !
!ChunkSourceFiler categoriesFor: #storeSource:for:!private!source filing! !
!ChunkSourceFiler categoriesFor: #storeSourceString:forMethod:!private!source filing! !

!ChunkSourceFiler class methodsFor!

on: aWriteStream sourceFileIndex: anInteger
	"Answer a new instance of the receiver for filing out source code onto the 
	<puttableStream> argument, and using the <integer>, anInteger, as the 
	source file index when asked to update the source descriptor of <sourceObject>s.
	If the argument is nil, then answer a null source filer that discards all filed source."

	^(self on: aWriteStream)
		sourceFileIndex: anInteger;
		yourself! !
!ChunkSourceFiler class categoriesFor: #on:sourceFileIndex:!instance creation!public! !


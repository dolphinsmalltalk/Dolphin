"Filed out from Dolphin Smalltalk"!

Kernel.STLInFiler
	subclass: #'Tools.STLDebugger'
	instanceVariableNames: 'indentLevel traceStream printOffsets slotName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.STLDebugger guid: (Core.GUID fromString: '{2594ee50-2952-4436-bb8b-a33cafe7790e}')!
Tools.STLDebugger comment: 'The `STLDebugger` is an `STLInFiler` that prints an indented trace of the contents of the STL file it is reading as it proceeds. 
It is useful for debugging issues with serialized objects, such as tracking down the cause of excessive size of a view resource.

For example to view the contents of a view resource, one can proceed as follows:
```
	rid := UI.ResourceIdentifier class: UI.Shell.
	in := (STLDebugger on: rid resource readStream).
	in next.
	in traceStream contents.	"Display-it"
''
'!
!Tools.STLDebugger categoriesForClass!System-Binary storage! !
!Tools.STLDebugger methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	| prefixOrLiteral class anObject newObjectIndex refIndex |
	traceStream cr.
	printOffsets
		ifTrue: 
			[stream position
				printOn: traceStream
				base: 10
				nDigits: 6.
			traceStream space].
	indentLevel timesRepeat: [traceStream nextPutAll: '    '].
	slotName
		ifNotNil: 
			[traceStream
				display: slotName;
				nextPut: $:;
				space.
			slotName := nil].

	"First, read the prefix."
	prefixOrLiteral := stream next.
	prefixOrLiteral isInteger
		ifFalse: 
			[traceStream print: prefixOrLiteral.
			^prefixOrLiteral value].

	"SmallInteger?"
	(prefixOrLiteral allMask: STxVersionPolicy.PrefixSmallIntegerMask)
		ifTrue: 
			[anObject := prefixOrLiteral bitShift: -1.
			traceStream print: anObject.
			^anObject].

	"Literal?"
	prefixOrLiteral == STLVersionPolicy.PrefixLiteralMask
		ifTrue: 
			[| literal |
			literal := policy readLiteralData.
			traceStream
				print: readMap size;
				nextPutAll: ': '.
			literal printOn: (LimitedWriteStream over: traceStream).
			^literal].
	refIndex := prefixOrLiteral bitShift: STxVersionPolicy.PrefixRefUnshift.
	(prefixOrLiteral allMask: STxVersionPolicy.PrefixDataMask)
		ifFalse: 
			[(prefixOrLiteral anyMask: STxVersionPolicy.PrefixCharacterMask)
				ifTrue: 
					[anObject := Character value: refIndex.
					traceStream
						nextPut: $[;
						print: anObject;
						nextPut: $]]
				ifFalse: 
					[anObject := self objectAt: refIndex.
					traceStream
						nextPutAll: '[<';
						print: refIndex;
						nextPutAll: ': '.
					anObject printOn: (LimitedWriteStream over: traceStream).
					traceStream nextPutAll: '>]'].
			^anObject].

	"Ascertain the class of the object."
	indentLevel := indentLevel + 1.
	traceStream nextPut: $[.
	(prefixOrLiteral allMask: STxVersionPolicy.PrefixClassMask)
		ifTrue: 
			[class := policy readClassDataWithPrefix: prefixOrLiteral.
			traceStream display: class name]
		ifFalse: 
			[class := self classAt: refIndex.
			traceStream nextPutAll: class name].
	traceStream nextPut: $].

	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: self format: (converters lookup: class).
	class isBytes
		ifTrue: 
			[traceStream
				space;
				print: newObjectIndex;
				nextPutAll: ': '.
			traceStream print: anObject].
	indentLevel := indentLevel - 1.
	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: self at: newObjectIndex!

dump
	traceStream
		nextPutAll: 'STL version ';
		print: self version;
		nextPut: $:.
	[self atEnd] whileFalse: [self next].
	traceStream
		nextPutAll: 'End of ';
		print: readMap size;
		nextPutAll: ' objects';
		cr!

initialize
	printOffsets := true.
	traceStream := String writeStream.
	indentLevel := 0.
	^super initialize!

next
	"Answer the next object from the receiver's stream."

	| answer |
	indentLevel := 0.
	answer := [self basicNext] on: Notification
				do: 
					[:ex |
					traceStream
						cr;
						cr;
						next: 80 put: $*;
						cr;
						display: ex;
						cr;
						next: 80 put: $*;
						cr.
					ex resume].
	traceStream cr.
	^answer!

objectAt: anInteger
	"Private - Answer the map value at anInteger. If anInteger is zero then answer nil.
	Signal an exception if there is no such entry."

	^anInteger == 0 ifFalse: [super objectAt: anInteger]!

printOffsets
	^printOffsets!

printOffsets: aBoolean
	printOffsets := aBoolean!

readSizeBlock
	| read |
	read := super readSizeBlock.
	^
	[:class |
	| size |
	size := read value: class.
	traceStream
		nextPut: $[;
		print: size;
		nextPut: $].
	size]!

traceStream
	^traceStream!

traceStream: aPuttableStream 
	traceStream := aPuttableStream! !
!Tools.STLDebugger categoriesForMethods!
basicNext!accessing!private! !
dump!operations!public! !
initialize!initializing!private! !
next!accessing!public! !
objectAt:!accessing!private! !
printOffsets!accessing!public! !
printOffsets:!accessing!public! !
readSizeBlock!operations!private! !
traceStream!accessing!public! !
traceStream:!accessing!public! !
!

!Tools.STLDebugger class methodsFor!

dump: aReadStream
	^((self on: aReadStream)
		dump;
		traceStream) contents!

dumpToTranscript: aReadStream
	(self on: aReadStream)
		traceStream: Transcript;
		dump! !
!Tools.STLDebugger class categoriesForMethods!
dump:!public! !
dumpToTranscript:!public! !
!


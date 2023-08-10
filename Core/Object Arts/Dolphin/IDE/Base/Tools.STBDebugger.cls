"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler
	subclass: #'Tools.STBDebugger'
	instanceVariableNames: 'indentLevel traceStream printOffsets'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.STBDebugger guid: (Core.GUID fromString: '{87b4c6e9-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.STBDebugger comment: 'The <STBDebugger> is an <STBInFiler> that prints an indented trace of the contents of the STB file it is reading as it proceeds.
It is useful for debugging issues with serialized objects..

For example to view the contents of a view resource, one can proceed as follows:

	bytes := (50@60 extent: 100@200) binaryStoreBytes.
	in := (STBDebugger on: bytes readStream).
	in next.
	in traceStream contents.	"Display-it"
'!
!Tools.STBDebugger categoriesForClass!System-Binary storage! !
!Tools.STBDebugger methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	| class anObject newObjectIndex prefixCode refIndex |
	traceStream cr.
	printOffsets
		ifTrue: 
			[stream position
				printOn: traceStream
				base: 10
				nDigits: 6.
			traceStream space].
	indentLevel timesRepeat: [traceStream nextPutAll: '    '].

	"First, read the prefix."
	prefixCode := policy readInteger.
	"Now decode"
	(prefixCode allMask: STxVersionPolicy.PrefixSmallIntegerMask)
		ifTrue: 
			[anObject := prefixCode bitShift: -1.
			traceStream
				nextPut: $[;
				print: anObject;
				nextPut: $].
			^anObject].
	refIndex := prefixCode bitShift: STxVersionPolicy.PrefixRefUnshift.
	(prefixCode allMask: STxVersionPolicy.PrefixDataMask)
		ifFalse: 
			[(prefixCode anyMask: STxVersionPolicy.PrefixCharacterMask)
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
	(prefixCode allMask: STxVersionPolicy.PrefixClassMask)
		ifTrue: 
			[class := policy readClassDataWithPrefix: prefixCode.
			traceStream
				nextPutAll: (policy locatorKeyFor: class);
				nextPut: $;.
			(converters lookup: class) ifNotNil: [:converter | traceStream print: converter version]]
		ifFalse: 
			[class := self classAt: refIndex.
			traceStream nextPutAll: (policy locatorKeyFor: class)].
	traceStream nextPut: $].

	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: self format: (converters lookup: class).
	class isBytes
		ifTrue: 
			[traceStream
				space;
				print: newObjectIndex;
				nextPutAll: ': ';
				print: anObject].
	indentLevel := indentLevel - 1.
	"If anObject was a proxy for the real one, or has some other need of fix up, do that now."
	^anObject stbFixup: self at: newObjectIndex!

dump
	traceStream
		nextPutAll: 'STB version ';
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

invalidClassReferenceErrorFormat
	^'<1s> input stream contains an invalid class reference: <2d> -> <3p>'!

next
	"Answer the next object from the receiver's stream."

	| answer |
	indentLevel := 0.
	answer := [self basicNext] on: Notification
				do: 
					[:ex | 
					traceStream cr; cr.
					80 timesRepeat: [traceStream nextPutAll: $*].
					traceStream
						cr;
						display: ex;
						cr.
					80 timesRepeat: [traceStream nextPutAll: $*].
					traceStream cr.
					ex resume].
	traceStream cr.
	^answer!

objectAt: anInteger
	"Private - Answer the map value at anInteger. If anInteger is zero then answer nil.
	Signal an exception if there is no such entry."

	^anInteger == 0 ifFalse: [super objectAt: anInteger]!

printOffsets
	^printOffsets!

printOffsets: anObject
	printOffsets := anObject!

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
!Tools.STBDebugger categoriesForMethods!
basicNext!accessing!private! !
dump!operations!public! !
initialize!initializing!private! !
invalidClassReferenceErrorFormat!constants!exceptions!private! !
next!accessing!public! !
objectAt:!accessing!private! !
printOffsets!accessing!public! !
printOffsets:!accessing!public! !
readSizeBlock!operations!private! !
traceStream!accessing!public! !
traceStream:!accessing!public! !
!

!Tools.STBDebugger class methodsFor!

dump: aReadStream
	^((self on: aReadStream)
		dump;
		traceStream) contents!

dumpToTranscript: aReadStream
	(self on: aReadStream)
		traceStream: Transcript;
		dump! !
!Tools.STBDebugger class categoriesForMethods!
dump:!public! !
dumpToTranscript:!public! !
!


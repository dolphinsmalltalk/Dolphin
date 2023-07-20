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

	| class anObject newObjectIndex prefixCode |
	traceStream cr.
	printOffsets
		ifTrue: 
			[stream position
				printOn: traceStream
				base: 10
				nDigits: 6].
	indentLevel timesRepeat: [traceStream nextPutAll: '    '].

	"First, read the prefix."
	prefixCode := policy readIntegerFrom: stream.
	"Now decode"
	(prefixCode allMask: PrefixSmallIntegerMask)
		ifTrue: 
			[anObject := prefixCode bitShift: -1.
			traceStream
				nextPut: $[;
				print: anObject;
				nextPut: $].
			^anObject].
	(prefixCode allMask: PrefixDataMask)
		ifFalse: 
			[(prefixCode anyMask: PrefixCharacterMask)
				ifTrue: 
					[anObject := Character value: (prefixCode bitShift: PrefixRefUnshift).
					traceStream
						nextPut: $[;
						print: anObject;
						nextPut: $]]
				ifFalse: 
					[anObject := self objectAt: (prefixCode bitShift: PrefixRefUnshift).
					traceStream nextPutAll: '[<'.
					anObject printOn: (LimitedWriteStream over: traceStream).
					traceStream nextPutAll: '>]'].
			^anObject].

	"Ascertain the class of the object."
	indentLevel := indentLevel + 1.
	traceStream nextPut: $[.
	(prefixCode allMask: PrefixClassMask)
		ifTrue: 
			[class := policy readClassData: self prefix: prefixCode.
			traceStream
				nextPutAll: (policy classLocatorStringFor: class);
				nextPut: $;.
			(converters lookup: class) ifNotNil: [:converter | traceStream print: converter version]]
		ifFalse: 
			[class := self classAt: (prefixCode bitShift: PrefixRefUnshift).
			traceStream nextPutAll: (policy classLocatorStringFor: class)].
	traceStream nextPut: $].

	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: self format: (converters lookup: class).
	class isBytes
		ifTrue: 
			[traceStream
				space;
				print: anObject].
	indentLevel := indentLevel - 1.
	"If anObject was a proxy for the real one, or has some other need of fix up, do that now."
	anObject := anObject stbFixup: self at: newObjectIndex.
	^anObject!

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

	^anInteger == 0
		ifFalse: [(readMap lookup: anInteger) ifNil: [self class errorInconsistentSTB: anInteger]]!

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
next!accessing!public! !
objectAt:!accessing!private! !
printOffsets!accessing!public! !
printOffsets:!accessing!public! !
readSizeBlock!operations!private! !
traceStream!accessing!public! !
traceStream:!accessing!public! !
!

!Tools.STBDebugger class methodsFor!

dumpToTranscript: aReadStream
	(self on: aReadStream)
		traceStream: Transcript;
		dump! !
!Tools.STBDebugger class categoriesForMethods!
dumpToTranscript:!public! !
!


"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler subclass: #'Tools.STBDebugger'
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

	| prefix class anObject newObjectIndex offset |
	traceStream cr.
	printOffsets
		ifTrue: 
			[offset := stream position.
			6 - offset displayString size timesRepeat: [traceStream nextPut: $0].
			traceStream display: offset].
	indentLevel timesRepeat: [traceStream nextPutAll: '    '].

	"First, read the prefix."
	prefix := STBPrefix fromInteger: self readInteger.
	prefix isSmallInteger
		ifTrue: 
			[anObject := prefix smallInteger.
			traceStream
				nextPut: $[;
				print: anObject;
				nextPut: $].
			^anObject].
	prefix isDataPrefix
		ifFalse: 
			[prefix isCharacter
				ifTrue: 
					[anObject := prefix character.
					traceStream
						nextPut: $[;
						print: anObject;
						nextPut: $]]
				ifFalse: 
					[anObject := self objectAt: prefix refIndex.
					traceStream
						nextPutAll: '[<';
						print: anObject;
						nextPutAll: '>]'].
			^anObject].

	"Ascertain the class of the object."
	indentLevel := indentLevel + 1.
	traceStream nextPut: $[.
	prefix isClassPrefix
		ifTrue: 
			[class := self readClassData: prefix uint32.
			traceStream print: class name displayString]
		ifFalse: 
			[class := self objectAt: prefix refIndex.
			traceStream nextPutAll: class name].
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
	"If anObject was a proxy for the real one, evaluate it now."
	prefix isProxy ifTrue: [anObject := anObject stbFixup: self at: newObjectIndex].
	^anObject!

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
initialize!initializing!private! !
next!accessing!public! !
objectAt:!accessing!private! !
printOffsets!accessing!public! !
printOffsets:!accessing!public! !
readSizeBlock!operations!private! !
traceStream!accessing!public! !
traceStream:!accessing!public! !
!


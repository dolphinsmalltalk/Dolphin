"Filed out from Dolphin Smalltalk"!

Kernel.STLInFiler
	subclass: #'Kernel.STLDebugger'
	instanceVariableNames: 'indentLevel traceStream printOffsets slotName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLDebugger guid: (Core.GUID fromString: '{2594ee50-2952-4436-bb8b-a33cafe7790e}')!
Kernel.STLDebugger comment: 'The `STLDebugger` is an `STLInFiler` that prints an indented trace of the contents of the STL file it is reading as it proceeds. 
It is useful for debugging issues with serialized objects, such as tracking down the cause of excessive size of a view resource.

For example to view the contents of a view resource, one can proceed as follows:
```
	rid := UI.ResourceIdentifier class: UI.Shell.
	in := (STLDebugger on: rid resource readStream).
	in next.
	in traceStream contents.	"Display-it"
''
'!
!Kernel.STLDebugger categoriesForClass!System-Binary storage! !
!Kernel.STLDebugger methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	| prefixOrLiteral class anObject newObjectIndex offset |
	traceStream cr.
	printOffsets
		ifTrue: 
			[offset := stream position.
			traceStream
				next: 6 - offset displayString size put: $0;
				display: offset;
				space].
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
			[self printValueToTrace: prefixOrLiteral.
			^prefixOrLiteral].
	prefixOrLiteral == 0
		ifTrue: 
			[self printValueToTrace: nil.
			^nil].	"optimize for nil"

	"SmallInteger?"
	(prefixOrLiteral allMask: PrefixSmallIntegerMask)
		ifTrue: 
			[anObject := prefixOrLiteral bitShift: -1.
			self printValueToTrace: anObject.
			^anObject].

	"Literal?"
	prefixOrLiteral == PrefixLiteralMask
		ifTrue: 
			[| literal |
			literal := self readLiteralData.
			self printValueToTrace: literal.
			^literal].
	(prefixOrLiteral allMask: PrefixDataMask)
		ifFalse: 
			[anObject := (prefixOrLiteral allMask: PrefixCharacterMask)
						ifTrue: [Character value: (prefixOrLiteral bitShift: PrefixRefUnshift)]
						ifFalse: [self objectAt: (prefixOrLiteral bitShift: PrefixRefUnshift)].
			self printValueToTrace: anObject.
			^anObject].

	"Ascertain the class of the object."
	indentLevel := indentLevel + 1.
	traceStream nextPut: $[.
	(prefixOrLiteral allMask: PrefixClassMask)
		ifTrue: 
			[class := policy readClassData: self prefix: prefixOrLiteral.
			traceStream display: class name]
		ifFalse: 
			[class := self classAt: (prefixOrLiteral bitShift: PrefixRefUnshift).
			traceStream nextPutAll: class name].
	traceStream nextPut: $].

	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: self format: (converters lookup: class).
	class isBytes ifTrue: [self printValueToTrace: anObject].
	indentLevel := indentLevel - 1.
	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: self at: newObjectIndex!

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

printOffsets
	^printOffsets!

printOffsets: aBoolean
	printOffsets := aBoolean!

printValueToTrace: anObject
	traceStream print: anObject!

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
!Kernel.STLDebugger categoriesForMethods!
basicNext!accessing!private! !
initialize!initializing!private! !
next!accessing!public! !
printOffsets!accessing!public! !
printOffsets:!accessing!public! !
printValueToTrace:!accessing!private! !
readSizeBlock!operations!private! !
traceStream!accessing!public! !
traceStream:!accessing!public! !
!


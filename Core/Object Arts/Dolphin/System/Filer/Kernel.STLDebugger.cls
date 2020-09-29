"Filed out from Dolphin Smalltalk 7"!

Kernel.STLInFiler subclass: #'Kernel.STLDebugger'
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
	(prefixOrLiteral allMask: STBPrefix.SmallIntegerMask)
		ifTrue: 
			[anObject := prefixOrLiteral bitShift: -1.
			self printValueToTrace: anObject.
			^anObject].

	"Literal?"
	prefixOrLiteral = STBPrefix.LiteralPrefixMask
		ifTrue: 
			[| literal |
			literal := self readLiteralData.
			self printValueToTrace: literal.
			^literal].
	(prefixOrLiteral allMask: STBPrefix.DataPrefixMask)
		ifFalse: 
			[anObject := (prefixOrLiteral allMask: STBPrefix.CharacterMask)
						ifTrue: [Character value: (prefixOrLiteral bitShift: STBPrefix.IndexShift)]
						ifFalse: [self objectAt: (prefixOrLiteral bitShift: STBPrefix.IndexShift)].
			self printValueToTrace: anObject.
			^anObject].

	"Ascertain the class of the object."
	indentLevel := indentLevel + 1.
	traceStream nextPut: $[.
	(prefixOrLiteral allMask: STBPrefix.ClassPrefixMask)
		ifTrue: 
			[class := self readClassData: prefixOrLiteral.
			traceStream display: class name]
		ifFalse: 
			[class := self classAt: (prefixOrLiteral bitShift: STBPrefix.IndexShift).
			traceStream nextPutAll: class name].
	traceStream nextPut: $].

	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := self readObjectOfClass: class.
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

objectAt: anInteger
	"Private - Answer the map value at anInteger. If anInteger is zero then answer nil.
	Signal an exception if there is no such entry."

	^anInteger == 0
		ifFalse: [(readMap lookup: anInteger) ifNil: [self class errorInconsistentSTB: anInteger]]!

printOffsets
	^printOffsets!

printOffsets: aBoolean
	printOffsets := aBoolean!

printValueToTrace: anObject
	traceStream print: anObject!

readObjectOfClass: aClass format: anObject
	"Private - Read the stream for the data to create an instance of aClass."

	"First, read the basicSize (number of indexed variables)."

	| basicSize fullSize stbClassFormat newObject |
	basicSize := (self version < 3 or: [aClass isVariable]) ifTrue: [self readInteger] ifFalse: [0].
	traceStream
		nextPut: $[;
		print: basicSize;
		nextPut: $].

	"Create a new object of sufficient size to hold the stored data."
	(stbClassFormat := converters lookup: aClass) isNil
		ifTrue: 
			["The object is of the current format.
			Create an instance of the appropriate class."
			fullSize := aClass instSize + basicSize.
			newObject := aClass isVariable ifTrue: [aClass basicNew: basicSize] ifFalse: [aClass basicNew]]
		ifFalse: 
			["The object is of an old format.
			Create an Array or ByteArray to hold the stored data. This is
			passed to the converter block which answers an instance of the
			real class initialised from it."
			fullSize := stbClassFormat instSize + basicSize.
			newObject := (stbClassFormat isBytes ifTrue: [ByteArray] ifFalse: [Array]) basicNew: fullSize].
	self register: newObject.

	"Read the object's instance data."
	newObject class isBytes
		ifTrue: [1 to: fullSize do: [:i | newObject basicAt: i put: stream next]]
		ifFalse: 
			[| instVarNames |
			instVarNames := stbClassFormat ifNil: [newObject class allInstVarNames] ifNotNil: [#()].
			1 to: fullSize
				do: 
					[:i |
					slotName := instVarNames at: i ifAbsent: [i].
					newObject instVarAt: i put: self basicNext]].
	stbClassFormat notNil
		ifTrue: 
			["Initialise a new instance from the old format object data and become it."
			newObject become: (stbClassFormat converterBlock value: newObject)].
	^newObject!

traceStream
	^traceStream!

traceStream: aPuttableStream 
	traceStream := aPuttableStream! !
!Kernel.STLDebugger categoriesFor: #basicNext!accessing!private! !
!Kernel.STLDebugger categoriesFor: #initialize!initializing!private! !
!Kernel.STLDebugger categoriesFor: #next!accessing!public! !
!Kernel.STLDebugger categoriesFor: #objectAt:!accessing!private! !
!Kernel.STLDebugger categoriesFor: #printOffsets!accessing!public! !
!Kernel.STLDebugger categoriesFor: #printOffsets:!accessing!public! !
!Kernel.STLDebugger categoriesFor: #printValueToTrace:!accessing!private! !
!Kernel.STLDebugger categoriesFor: #readObjectOfClass:format:!operations!private! !
!Kernel.STLDebugger categoriesFor: #traceStream!accessing!public! !
!Kernel.STLDebugger categoriesFor: #traceStream:!accessing!public! !


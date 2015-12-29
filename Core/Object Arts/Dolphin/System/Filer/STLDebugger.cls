"Filed out from Dolphin Smalltalk X6"!

STLInFiler subclass: #STLDebugger
	instanceVariableNames: 'indentLevel traceStream printOffsets'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STLDebugger guid: (GUID fromString: '{2594EE50-2952-4436-BB8B-A33CAFE7790E}')!
STLDebugger comment: 'The <STLDebugger> is an <STLInFiler> that prints an indented trace of the contents of the STL file it is reading as it proceeds. 
It is useful for debugging issues with serialized objects, such as tracking down the cause of excessive size of a view resource.

For example to view the contents of a view resource, one can proceed as follows:

	rid := ResourceIdentifier class: Shell.
	in := (STLDebugger on: rid resource readStream).
	in next.
	in traceStream contents.	"Display-it"'!
!STLDebugger categoriesForClass!System-Binary storage! !
!STLDebugger methodsFor!

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
	prefix := self readInteger.
	prefix == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(prefix allMask: SmallIntegerMask) 
		ifTrue: 
			[anObject := prefix bitShift: -1.
			traceStream
				nextPut: $[;
				print: anObject;
				nextPut: $].
			^anObject].

	"Literal? (Hook for STL filer)"
	prefix = LiteralPrefixMask ifTrue: [^self readLiteralData].
	(prefix allMask: DataPrefixMask) 
		ifFalse: 
			[anObject := (prefix allMask: CharacterMask) 
						ifTrue: [Character value: (prefix bitShift: IndexShift)]
						ifFalse: [self objectAt: (prefix bitShift: IndexShift)].
			traceStream
				nextPut: $[;
				print: anObject;
				nextPut: $].
			^anObject].

	"Ascertain the class of the object."
	indentLevel := indentLevel + 1.
	traceStream nextPut: $[.
	(prefix allMask: ClassPrefixMask) 
		ifTrue: 
			[class := self readClassData: prefix.
			traceStream print: class name displayString]
		ifFalse: 
			[class := self classAt: (prefix bitShift: IndexShift).
			traceStream nextPutAll: class name].
	traceStream nextPut: $].



	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := self readObjectOfClass: class.
	class isBytes 
		ifTrue: 
			[traceStream
				space;
				print: anObject].
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

printOffsets
	^printOffsets!

printOffsets: anObject
	printOffsets := anObject!

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
	(stbClassFormat := converters at: aClass ifAbsent: []) isNil 
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
		ifFalse: [1 to: fullSize do: [:i | newObject instVarAt: i put: self basicNext]].
	stbClassFormat notNil 
		ifTrue: 
			["Initialise a new instance from the old format object data and become it."
			newObject become: (stbClassFormat converterBlock value: newObject)].
	^newObject!

traceStream
	^traceStream!

traceStream: aPuttableStream 
	traceStream := aPuttableStream! !
!STLDebugger categoriesFor: #basicNext!accessing!private! !
!STLDebugger categoriesFor: #initialize!initializing!private! !
!STLDebugger categoriesFor: #next!accessing!public! !
!STLDebugger categoriesFor: #printOffsets!accessing!public! !
!STLDebugger categoriesFor: #printOffsets:!accessing!public! !
!STLDebugger categoriesFor: #readObjectOfClass:format:!operations!private! !
!STLDebugger categoriesFor: #traceStream!accessing!public! !
!STLDebugger categoriesFor: #traceStream:!accessing!public! !


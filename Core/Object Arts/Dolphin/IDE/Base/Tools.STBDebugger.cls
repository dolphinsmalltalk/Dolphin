"Filed out from Dolphin Smalltalk 7"!

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
			[class := self readClassData: prefix dword.
			traceStream print: class name displayString]
		ifFalse: 
			[class := self objectAt: prefix refIndex.
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
			newObject := stbClassFormat dataClass basicNew: fullSize].
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
!Tools.STBDebugger categoriesFor: #basicNext!accessing!private! !
!Tools.STBDebugger categoriesFor: #initialize!initializing!private! !
!Tools.STBDebugger categoriesFor: #next!accessing!public! !
!Tools.STBDebugger categoriesFor: #objectAt:!accessing!private! !
!Tools.STBDebugger categoriesFor: #printOffsets!accessing!public! !
!Tools.STBDebugger categoriesFor: #printOffsets:!accessing!public! !
!Tools.STBDebugger categoriesFor: #readObjectOfClass:format:!operations!private! !
!Tools.STBDebugger categoriesFor: #traceStream!accessing!public! !
!Tools.STBDebugger categoriesFor: #traceStream:!accessing!public! !


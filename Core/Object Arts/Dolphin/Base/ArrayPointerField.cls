"Filed out from Dolphin Smalltalk 7"!

PointerField subclass: #ArrayPointerField
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayPointerField guid: (GUID fromString: '{87b4c4e3-026e-11d3-9fd7-00a0cc3e4a32}')!
ArrayPointerField comment: 'ArrayPointerField is an <ExternalField> type to represent <ExternalStructure> fields which are pointers to external fixed arrays.'!
!ArrayPointerField categoriesForClass!External-Data-Types! !
!ArrayPointerField methodsFor!

arrayLength: sizeObject
	"Private - Set the length of the array pointed at by the field described
	by the receiver."

	arrayLength := sizeObject!

printAccessorExpressionSuffixOn: aWriteStream
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	"We need to set the length of the array"

	aWriteStream
		space;
		display: #length:;
		space.
	arrayLength printElementCountExpressionFor: self on: aWriteStream!

printMutatorBody: aSymbol on: aWriteStream
	super printMutatorBody: aSymbol on: aWriteStream.
	aWriteStream
		nextPut: $.;
		crtab.
	arrayLength printSetSizeFor: self on: aWriteStream!

readFrom: anExternal
	"Private - Answer an <ExternalArray> of the receiver's pointer class that is a reference to
	the data pointed at by the corresponding pointer field of the <ExternalStructure> argument
	at the receiver's offset, and which is of the length described by the receiver."

	^self pointerClass fromAddress: (anExternal sdwordAtOffset: offset)
		length: (arrayLength getElementCountOf: ExternalField new in: anExternal)!

writeInto: anExternalStructure value: anObject
	"Private - Write the address of the externally addressable Smalltalk object, anObject,
	into anExternal at the receiver's offset.
	N.B. Precautions must be taken (such as saving the Object as an
	instance variable of the ExternalStructure which encapsulates anExternal)
	to prevent anObject being garbage collected, which will invalidate its
	address. anObject cannot be saved by the receiver, because it is shared
	among all instances of a subclass of ExternalStructure (it is part of
	the class instance variable 'template')."

	| answer |
	answer := super writeInto: anExternalStructure value: anObject.
	arrayLength
		setElementCount: anObject size
		of: self
		in: anExternalStructure.
	^answer! !
!ArrayPointerField categoriesFor: #arrayLength:!accessing!private! !
!ArrayPointerField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!ArrayPointerField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!ArrayPointerField categoriesFor: #readFrom:!accessing!private! !
!ArrayPointerField categoriesFor: #writeInto:value:!indirect accessing!private! !

!ArrayPointerField class methodsFor!

type: aClass arrayLength: anArrayFieldLength
	"Answer a new instance of the receiver which is used for describing embedded arrays of
	external type, aClass, with the specified <ArrayFieldLength> element count descriptor. The
	field may be of a fixed or varying number of elements."

	^(self type: aClass)
		arrayLength: anArrayFieldLength;
		yourself!

type: aClass length: anInteger
	"Answer a new instance of the receiver which is used for dereferencing
	pointers to arrays objects of type aClass, of the specified fixed <integer> length."

	^self type: aClass arrayLength: (FixedArrayFieldLength elementCount: anInteger)!

type: aClass lengthField: aSymbol
	"Answer a new instance of the receiver which is used for dereferencing pointers to
	conformant arrays objects of type aClass, where the length is specified by the another field
	of the structure with the specified <Symbol> name."

	^self type: aClass arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !
!ArrayPointerField class categoriesFor: #type:arrayLength:!instance creation!public! !
!ArrayPointerField class categoriesFor: #type:length:!instance creation!public! !
!ArrayPointerField class categoriesFor: #type:lengthField:!instance creation!public! !


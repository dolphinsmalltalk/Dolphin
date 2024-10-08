﻿"Filed out from Dolphin Smalltalk"!

External.PointerField
	subclass: #'External.ArrayPointerField'
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.ArrayPointerField guid: (Core.GUID fromString: '{87b4c4e3-026e-11d3-9fd7-00a0cc3e4a32}')!

External.ArrayPointerField comment: 'ArrayPointerField is an <ExternalField> type to represent <ExternalStructure> fields which are pointers to external fixed arrays.

Instance Variables:
	arrayLength		<ArrayFieldLength> describing the length of the array.


'!

!External.ArrayPointerField categoriesForClass!External-Data-Types! !

!External.ArrayPointerField methodsFor!

arrayLength: sizeObject
	"Private - Set the length of the array pointed at by the field described
	by the receiver."

	arrayLength := sizeObject!

readFrom: anExternalStructure
	"Private - Answer an <External.Array> of the receiver's pointer class that is a reference to the data pointed at by the corresponding pointer field of the <External.Structure> argument at the receiver's offset, and which is of the length described by the receiver."

	^self pointerClass fromAddress: (anExternalStructure bytes int32AtOffset: offset)
		length: (arrayLength getElementCountOf: self in: anExternalStructure)!

writeInto: anExternalStructure value: anObject
	"Private - Write the address of the externally addressable Smalltalk object, anObject,
	into anExternalStructure at the receiver's offset.
	N.B. Precautions must be taken (such as saving the Object as an
	instance variable of the ExternalStructure which encapsulates anExternal)
	to prevent anObject being garbage collected, which will invalidate its
	address. anObject cannot be saved by the receiver, because it is shared
	among all instances of a subclass of ExternalStructure (it is part of
	the class instance variable 'template')."

	| answer |
	answer := super writeInto: anExternalStructure value: anObject.
	arrayLength
		setElementCount: anObject
		of: self
		in: anExternalStructure.
	^answer! !

!External.ArrayPointerField categoriesForMethods!
arrayLength:!accessing!private! !
readFrom:!accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.ArrayPointerField class methodsFor!

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

	^self type: aClass arrayLength: (FixedArrayFieldLength elementCount: anInteger)! !

!External.ArrayPointerField class categoriesForMethods!
type:arrayLength:!instance creation!public! !
type:length:!instance creation!public! !
!


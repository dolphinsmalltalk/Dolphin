"Filed out from Dolphin Smalltalk 7"!

External.EmbeddedField subclass: #'External.ArrayField'
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ArrayField guid: (Core.GUID fromString: '{87b4c4de-026e-11d3-9fd7-00a0cc3e4a32}')!
External.ArrayField comment: 'ArrayField is an <ExternalField> type to represent <ExternalStructure> fields which are fixed arrays whose contents are actually embedded in the structure, as opposed to being merely pointed at from the structure.

Instance Variables:
	arrayLength		<ArrayFieldLength> describing the length of the array.'!
!External.ArrayField categoriesForClass!External-Data-Types! !
!External.ArrayField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self elementSize!

allocationLength
	^arrayLength allocationLength!

arrayClass
	"Private - Answer the class of <ExternalArray> that this field type describes."

	^fieldClass!

arrayLength: anArrayFieldLength
	arrayLength := anArrayFieldLength!

byteSize
	"Private - Answer the byte size of the embedded array the receiver represents."

	^arrayLength allocationLength * self elementSize!

elementClass
	"Private - Answer the byte size of the structures/values that constitute
	the elements of the embedded array the receiver represents."

	^self arrayClass elementClass!

elementSize
	"Private - Answer the byte size of the structures/values that constitute
	the elements of the embedded array the receiver represents."

	^self arrayClass elementSize!

elementSizeSelector
	^#elementSize!

isFixedSize
	"Private - Answer whether the embedded array field described by the receiver is of fixed
	length, i.e. known statically as opposed to varying dynamically at runtime."

	^arrayLength isFixedSize!

length
	"Private - Answer the length of the embedded array represented by the receiver."

	Notification deprecated.
	^self allocationLength!

readFrom: aStructure
	"Private - Answer a byte-object array of the type described by the receiver, and of the size described by the receiver. Normally this will be an <ExternalArray> reference to the data in the <Structure> argument at the receiver's offset, but it can be an object of any class that responds to the #fromAddress:length: instance creation message, e.g. a <ByteArray> or a <String>, which both create a copy of the data."

	^self arrayClass fromAddress: aStructure yourAddress + offset
		length: (arrayLength getElementCountOf: self in: aStructure)!

writeInto: aStructure value: aByteObject
	"Private - Write the bytes of aByteObject into the <External.Structure> first argument."

	| byteSize |
	byteSize := self isFixedSize
				ifTrue: 
					[aByteObject byteSize
						min: (arrayLength getElementCountOf: self in: aStructure) * self elementSize]
				ifFalse: [aByteObject byteSize].
	aStructure bytes
		replaceFrom: offset + 1
		to: offset + byteSize
		with: aByteObject
		startingAt: 1.
	arrayLength
		setElementCount: aByteObject
		of: self
		in: aStructure! !
!External.ArrayField categoriesFor: #alignment!constants!public! !
!External.ArrayField categoriesFor: #allocationLength!accessing!private! !
!External.ArrayField categoriesFor: #arrayClass!constants!private! !
!External.ArrayField categoriesFor: #arrayLength:!accessing!private! !
!External.ArrayField categoriesFor: #byteSize!accessing!private! !
!External.ArrayField categoriesFor: #elementClass!accessing!private! !
!External.ArrayField categoriesFor: #elementSize!accessing!private! !
!External.ArrayField categoriesFor: #elementSizeSelector!automatic generation!constants!private! !
!External.ArrayField categoriesFor: #isFixedSize!private!testing! !
!External.ArrayField categoriesFor: #length!accessing!private! !
!External.ArrayField categoriesFor: #readFrom:!indirect accessing!private! !
!External.ArrayField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.ArrayField class methodsFor!

type: aClass arrayLength: anArrayFieldLength
	"Answer a new instance of the receiver which is used for describing embedded array objects
	of type, aClass, where the length is described by the <ArrayFieldLength> argument. The field
	could be fixed in length, or varying (conformant)."

	^(self basicNew)
		initialize;
		fieldClass: aClass;
		arrayLength: anArrayFieldLength;
		yourself!

type: aClass length: anInteger
	"Answer a new instance of the receiver which is used for describing
	embedded arrays of type aClass, with anInteger elements."

	^self type: aClass arrayLength: (FixedArrayFieldLength elementCount: anInteger)! !
!External.ArrayField class categoriesFor: #type:arrayLength:!instance creation!public! !
!External.ArrayField class categoriesFor: #type:length:!instance creation!public! !


"Filed out from Dolphin Smalltalk 7"!

EmbeddedField subclass: #ArrayField
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayField guid: (GUID fromString: '{87b4c4de-026e-11d3-9fd7-00a0cc3e4a32}')!
ArrayField comment: 'ArrayField is an <ExternalField> type to represent <ExternalStructure> fields which are fixed arrays whose contents are actually embedded in the structure, as opposed to being merely pointed at from the structure.

Instance Variables:
	arrayLength		<ArrayFieldLength> describing the length of the array.'!
!ArrayField categoriesForClass!External-Data-Types! !
!ArrayField methodsFor!

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

printElementSizeExpressionBodyOn: stream 
	stream
		display: self arrayClass;
		space;
		display: #elementSize!

printFieldSizeExpressionBodyOn: aWriteStream
	arrayLength printElementCountExpressionFor: self on: aWriteStream.
	aWriteStream nextPutAll: ' * '.
	self isFixedSize
		ifTrue: [self printElementSizeExpressionBodyOn: aWriteStream]
		ifFalse: [self printStaticElementSizeExpressionOn: aWriteStream]!

printFieldSizeExpressionOn: aWriteStream 
	self isFixedSize 
		ifTrue: 
			[self emitStaticExpression: [:stream | self printFieldSizeExpressionBodyOn: stream] on: aWriteStream]
		ifFalse: [self printFieldSizeExpressionBodyOn: aWriteStream]!

printStaticElementSizeExpressionOn: aWriteStream
	self emitStaticExpression: [:stream | self printElementSizeExpressionBodyOn: stream]
		on: aWriteStream!

readFrom: anExternalStructure
	"Private - Answer a byte-object array of the type described by the receiver, and of the size
	described by the receiver. Normally this will be an <ExternalArray> reference to the data in
	the <ExternalStructure> argument at the receiver's offset, but it can be an object of any
	class that responds to the #fromAddress:length: instance creation message, e.g. a
	<ByteArray> or a <String>, which both create a copy of the data."

	^self arrayClass fromAddress: anExternalStructure yourAddress + offset
		length: (arrayLength getElementCountOf: self in: anExternalStructure)!

writeInto: anExternalStructure value: aByteObject
	"Private - Write the bytes of aByteObject into anExternalStructure."

	| byteSize |
	byteSize := self isFixedSize
				ifTrue: 
					[aByteObject byteSize
						min: (arrayLength getElementCountOf: self in: anExternalStructure) * self elementSize]
				ifFalse: [aByteObject byteSize].
	anExternalStructure bytes
		replaceFrom: offset + 1
		to: offset + byteSize
		with: aByteObject
		startingAt: 1.
	arrayLength
		setElementCount: aByteObject
		of: self
		in: anExternalStructure! !
!ArrayField categoriesFor: #alignment!constants!public! !
!ArrayField categoriesFor: #allocationLength!accessing!private! !
!ArrayField categoriesFor: #arrayClass!constants!private! !
!ArrayField categoriesFor: #arrayLength:!accessing!private! !
!ArrayField categoriesFor: #byteSize!accessing!private! !
!ArrayField categoriesFor: #elementClass!accessing!private! !
!ArrayField categoriesFor: #elementSize!accessing!private! !
!ArrayField categoriesFor: #elementSizeSelector!automatic generation!constants!private! !
!ArrayField categoriesFor: #isFixedSize!private!testing! !
!ArrayField categoriesFor: #length!accessing!private! !
!ArrayField categoriesFor: #printElementSizeExpressionBodyOn:!automatic generation!private! !
!ArrayField categoriesFor: #printFieldSizeExpressionBodyOn:!automatic generation!private! !
!ArrayField categoriesFor: #printFieldSizeExpressionOn:!automatic generation!private! !
!ArrayField categoriesFor: #printStaticElementSizeExpressionOn:!automatic generation!private! !
!ArrayField categoriesFor: #readFrom:!indirect accessing!private! !
!ArrayField categoriesFor: #writeInto:value:!indirect accessing!private! !

!ArrayField class methodsFor!

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
!ArrayField class categoriesFor: #type:arrayLength:!instance creation!public! !
!ArrayField class categoriesFor: #type:length:!instance creation!public! !


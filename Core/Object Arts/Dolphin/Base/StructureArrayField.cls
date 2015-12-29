"Filed out from Dolphin Smalltalk X6.1"!

ArrayField subclass: #StructureArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArrayField guid: (GUID fromString: '{87B4C4E1-026E-11D3-9FD7-00A0CC3E4A32}')!
StructureArrayField comment: ''!
!StructureArrayField categoriesForClass!External-Data-Types! !
!StructureArrayField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self fieldClass alignment!

arrayClass
	"Private - Answer the class of <ExternalArray> that this field type describes."

	^StructureArray!

byteSize
	"Private - Answer the byte size of the embedded array the receiver represents"

	^self length * self elementSize!

elementClass
	^self fieldClass!

elementSize
	"Private - Answer the byte size of the structures/values that constitute
	the elements of the embedded array the receiver represents."

	^self fieldClass elementSize!

fieldClassName
	"Private - Answer the name of the class of object to be used to represent 
	the embedded field described by the receiver."

	^self arrayClass name!

printAccessorExpressionSuffixOn: aWriteStream 
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	"We need to set the length and element class of the structure array"

	super printAccessorExpressionSuffixOn: aWriteStream.
	aWriteStream
		space;
		display: #elementClass:;
		space;
		display: self fieldClass!

printElementSizeExpressionBodyOn: aWriteStream 
	aWriteStream
		display: self elementClass;
		space;
		display: #basicByteSize!

readFrom: anExternal
	"Private -  Answer a <StructureArray> which references the array
	of structures embedded in the <ExternalStructure>, struct, in the
	field described by the receiver.  The result may be sent #at: and #at:put:
	messages to get/set the actual elements in-place."

	^self arrayClass 
		fromAddress: anExternal yourAddress + offset 
		length: self length
		elementClass: self fieldClass! !
!StructureArrayField categoriesFor: #alignment!constants!public! !
!StructureArrayField categoriesFor: #arrayClass!constants!private! !
!StructureArrayField categoriesFor: #byteSize!accessing!private! !
!StructureArrayField categoriesFor: #elementClass!accessing!private! !
!StructureArrayField categoriesFor: #elementSize!accessing!private! !
!StructureArrayField categoriesFor: #fieldClassName!accessing!private! !
!StructureArrayField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!StructureArrayField categoriesFor: #printElementSizeExpressionBodyOn:!automatic generation!private! !
!StructureArrayField categoriesFor: #readFrom:!indirect accessing!private! !


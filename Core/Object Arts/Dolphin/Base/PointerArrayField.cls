"Filed out from Dolphin Smalltalk"!

StructureArrayField subclass: #PointerArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointerArrayField guid: (GUID fromString: '{23c14350-68ab-4481-a095-5c4f9654d211}')!
PointerArrayField comment: 'PointerArrayField is the class of <ExternalField>s used to describe fields that are fixed-size arrays of pointers to structures.'!
!PointerArrayField categoriesForClass!External-Data-Types! !
!PointerArrayField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	All pointers are 32-bits."

	^VMConstants.IntPtrSize!

arrayClass
	"Private - Answer the class of <ExternalArray> that this field type describes."

	^PointerArray!

elementSize
	"Private - Answer the byte size of the structures/values that constitute
	the elements of the embedded array the receiver represents.
	All pointers are 32-bits."

	^VMConstants.IntPtrSize! !
!PointerArrayField categoriesForMethods!
alignment!constants!public! !
arrayClass!constants!private! !
elementSize!accessing!private! !
!


"Filed out from Dolphin Smalltalk X6.1"!

StructureArrayField subclass: #PointerArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointerArrayField guid: (GUID fromString: '{23C14350-68AB-4481-A095-5C4F9654D211}')!
PointerArrayField comment: ''!
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
!PointerArrayField categoriesFor: #alignment!constants!public! !
!PointerArrayField categoriesFor: #arrayClass!constants!private! !
!PointerArrayField categoriesFor: #elementSize!accessing!private! !


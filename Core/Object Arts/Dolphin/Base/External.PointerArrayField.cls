"Filed out from Dolphin Smalltalk 7"!

External.StructureArrayField subclass: #'External.PointerArrayField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.PointerArrayField guid: (Core.GUID fromString: '{23c14350-68ab-4481-a095-5c4f9654d211}')!
External.PointerArrayField comment: 'PointerArrayField is the class of <ExternalField>s used to describe fields that are fixed-size arrays of pointers to structures.'!
!External.PointerArrayField categoriesForClass!External-Data-Types! !
!External.PointerArrayField methodsFor!

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
!External.PointerArrayField categoriesFor: #alignment!constants!public! !
!External.PointerArrayField categoriesFor: #arrayClass!constants!private! !
!External.PointerArrayField categoriesFor: #elementSize!accessing!private! !


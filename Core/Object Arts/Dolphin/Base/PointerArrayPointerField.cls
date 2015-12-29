"Filed out from Dolphin Smalltalk X6"!

StructureArrayPointerField subclass: #PointerArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointerArrayPointerField guid: (GUID fromString: '{3A78C2FD-CF0B-4F89-BE59-BF48CEA436FA}')!
PointerArrayPointerField comment: ''!
!PointerArrayPointerField categoriesForClass!External-Data-Types! !
!PointerArrayPointerField methodsFor!

pointerClass
	"Private - Answer the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type."

	^PointerArray! !
!PointerArrayPointerField categoriesFor: #pointerClass!accessing!private! !


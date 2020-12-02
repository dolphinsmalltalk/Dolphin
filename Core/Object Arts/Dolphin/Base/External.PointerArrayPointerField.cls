"Filed out from Dolphin Smalltalk 7"!

StructureArrayPointerField subclass: #PointerArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PointerArrayPointerField guid: (GUID fromString: '{3a78c2fd-cf0b-4f89-be59-bf48cea436fa}')!
PointerArrayPointerField comment: ''!
!PointerArrayPointerField categoriesForClass!External-Data-Types! !
!PointerArrayPointerField methodsFor!

pointerClass
	"Private - Answer the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type."

	^PointerArray! !
!PointerArrayPointerField categoriesFor: #pointerClass!accessing!private! !


"Filed out from Dolphin Smalltalk"!

UINT_PTRArray subclass: #PointerArray
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PointerArray guid: (GUID fromString: '{fac953e0-dfd2-4e68-8c31-879bba4c50c4}')!

PointerArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of pointers to arbitrary <ExternalStructure>s.

Instance Variables:
	elementClass	<ExternalStructure>. Class to represent elements of the array.

'!

!PointerArray categoriesForClass!External-Data-Structured! !

!PointerArray methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent the receiver's elements."

	^elementClass!

elementClass: elemClass
	"Private - Set the class to be used for accessing elements of the receiver.
	Answer the receiver."

	elementClass := elemClass!

uncheckedAt: anInteger 
	"Private - Answer an instance of the receiver's elementClass (a type of pointer) wrapping the 
	address at the specified <integer> index in the receiver. No bounds checks are performed on 
	the subscript."

	^elementClass fromAddress: (super uncheckedAt: anInteger)!

uncheckedAt: anInteger put: newValue 
	super uncheckedAt: anInteger put: newValue yourAddress.
	^newValue! !

!PointerArray categoriesForMethods!
elementClass!accessing!public! !
elementClass:!accessing!private! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!PointerArray class methodsFor!

fromAddress: anAddress length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that points at an
	array of anInteger elements of type elementClass at anAddress.
	Implementation Note: If the length is zero, then we ignore the address (even if invalid).
	If the length is non-zero then we answer nil if the address is the Null pointer."

	^anInteger == 0 
		ifTrue: [self basicNew basicLength: 0; elementClass: elementClass]
		ifFalse: [
			anAddress isNull ifFalse: [
				self basicNew
					initializeAtAddress: anAddress;
					elementClass: elementClass;
					basicLength: anInteger]]!

length: anInteger elementClass: elementClass 
	"Answer a new instance of the receiver that contains a buffer
	of sufficient size to contain anInteger elements of type, elementClass."

	^(self length: anInteger elementSize: self elementSize) elementClass: elementClass! !

!PointerArray class categoriesForMethods!
fromAddress:length:elementClass:!instance creation!public! !
length:elementClass:!instance creation!public! !
!


"Filed out from Dolphin Smalltalk"!

External.UIntPtrArray
	subclass: #'External.PointerArray'
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.PointerArray guid: (Core.GUID fromString: '{fac953e0-dfd2-4e68-8c31-879bba4c50c4}')!

External.PointerArray comment: 'Specialized `External.Array` to represent contiguous single-dimensioned arrays of pointers to arbitrary `External.Structure`s or byte objects such as strings.

## Instance Variables:
  `elementClass`	`External.Structure` or byte object class. Class to represent elements of the array.

'!

!External.PointerArray categoriesForClass!External-Data-Structured! !

!External.PointerArray methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent the receiver's elements."

	^elementClass!

elementClass: elemClass
	"Private - Set the class to be used for accessing elements of the receiver.
	Answer the receiver."

	elementClass := elemClass!

uncheckedAt: anInteger 
	"Private - Answer an instance of the receiver's elementClass wrapping the address at the specified `<integer>` index in the receiver. No bounds checks are performed on the subscript. If the receiver's element class is a type of `External.Structure` then the answer will be a pointer instance of that structure type holding the same pointer as at the specified index in the receiver. If on the other hand the element class is a byte object class, then the (depending on that class' implementation of #fromAddress:), the answer will typically be a copy of the data pointed at by the indexed element of the receiver."

	^elementClass fromAddress: (super uncheckedAt: anInteger)!

uncheckedAt: anInteger put: newValue 
	"Private - Replace the pointer at the index specified by the `<integer>` 1st argument with a the address of the 2nd argument. Note that no reference is maintained to the new value, so a reference must be maintained elsewhere so that the object is not garbage collected leaving a dangling pointer in this array. No bounds checks are performed on the subscript. "

	super uncheckedAt: anInteger put: newValue yourAddress.
	^newValue! !

!External.PointerArray categoriesForMethods!
elementClass!accessing!public! !
elementClass:!accessing!private! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.PointerArray class methodsFor!

fromAddress: anAddress length: anInteger elementClass: elementClass
	"Answer a new instance of the receiver that points at an array of anInteger pointers to elements of type elementClass at anAddress. If the length is zero, then the address is ignored (even if invalid). If the length is not zero, then answer nil if the address is a null pointer."

	^anInteger == 0 
		ifTrue: [self basicNew basicLength: 0; elementClass: elementClass]
		ifFalse: [
			anAddress isNull ifFalse: [
				self basicNew
					initializeAtAddress: anAddress;
					elementClass: elementClass;
					basicLength: anInteger]]!

length: anInteger elementClass: elementClass 
	"Answer a new instance of the receiver that contains a buffer	of sufficient size to contain anInteger pointers to elements of type, elementClass."

	^(self length: anInteger elementSize: self elementSize) elementClass: elementClass!

with: anObject
	"Answer a new instance of the receiver containing the single `Object` that is the argument. The object must be of an `External.Structure` or byte object class. Note that the array stores the address of the bytes of the object but not the object itself, and therefore there must be some other live reference to the object to prevent the new array ending up containing a dangling pointer."

	^(self length: 1 elementClass: anObject class)
		uncheckedAt: 1 put: anObject;
		yourself!

withAll: aCollection elementClass: structClass
	"Answer a new instance of the receiver containing all of the elements of the `<collection>` 1st argument, represented in the format of the `ExternalStructure` or byte object class 2nd argument.  An error will be raised if any of the elements cannot be represented as instances of the element class. Note that the array stores the addresses of the bytes of the objects in the collection but does not hold a direct or indirect reference to the objects themselves. Therefore there must be some other live reference to the objects to prevent the new array ending up containing dangling pointers."

	| answer |
	answer := self length: aCollection size elementClass: structClass.
	aCollection inject: 1
		into: 
			[:i :each |
			answer uncheckedAt: i put: each.
			i + 1].
	^answer! !

!External.PointerArray class categoriesForMethods!
fromAddress:length:elementClass:!instance creation!public! !
length:elementClass:!instance creation!public! !
with:!instance creation!public! !
withAll:elementClass:!instance creation!public! !
!


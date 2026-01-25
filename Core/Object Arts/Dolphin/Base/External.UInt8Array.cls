"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.UInt8Array'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.UInt8Array guid: (Core.GUID fromString: '{e55effe4-7aea-495a-a80a-a17850dc6ea4}')!

External.UInt8Array comment: '`UInt8Array` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of 8-bit unsigned integers, i.e. `UInt8`s.

`UInt8Array` is define for completeness, and for cases where a pointer to an external array of bytes is required. However, for most FFI buffering purposes `ByteArray` offers a more convenient and efficient alternative.'!

!External.UInt8Array methodsFor!

value
	^bytes isNull ifFalse: [
		bytes copyFrom: 1 to: self size]! !

!External.UInt8Array categoriesForMethods!
value!public! !
!

!External.UInt8Array class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^UInt8! !

!External.UInt8Array class categoriesForMethods!
elementClass!constants!public! !
!


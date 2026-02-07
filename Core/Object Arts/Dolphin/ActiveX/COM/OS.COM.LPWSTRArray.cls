"Filed out from Dolphin Smalltalk"!

OS.COM.TaskHeapPointerArray
	subclass: #'OS.COM.LPWSTRArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.LPWSTRArray guid: (Core.GUID fromString: '{13665806-953e-4961-9da4-4e39f83f5050}')!

OS.COM.LPWSTRArray comment: '`LPWSTRArray` (aka `LPOLESTRArray`) is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of pointers to UTF-16 strings. Both the body of the array and the strings it references are expected to be allocated from the COM task heap.

As neither the array body of an `LPWSTRArray`, nor the strings it references are allocated from Dolphin memory, instances can be handed off to external consumers that understand the task memory model.'!

!OS.COM.LPWSTRArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer a <Utf16String> copy of the task heap UTF-16 string referenced by receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^Utf16String fromAddress: (self basicUncheckedAt: anInteger)! !

!OS.COM.LPWSTRArray categoriesForMethods!
uncheckedAt:!accessing!private! !
!

!OS.COM.LPWSTRArray class methodsFor!

allocator
	"Private - Answer the appropriate allocator for the receiver.
	As we are representing a block of memory for the standard COM task allocator,
	answer that."

	^IMalloc task!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^LPWSTR! !

!OS.COM.LPWSTRArray class categoriesForMethods!
allocator!accessing!private! !
elementClass!public! !
!


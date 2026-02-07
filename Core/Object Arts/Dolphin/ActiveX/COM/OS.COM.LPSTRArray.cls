"Filed out from Dolphin Smalltalk"!

OS.COM.TaskHeapPointerArray
	subclass: #'OS.COM.LPSTRArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.LPSTRArray guid: (Core.GUID fromString: '{d4bb7be9-76cb-4e67-8d24-4c0bae4625da}')!

OS.COM.LPSTRArray comment: '`LPSTRArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of pointers to ANSI strings (that is byte strings assumed to be in the encoding of the current code page). Both the body of the array and the strings it references are expected to be allocated from the COM task heap.

As neither the array body of an `LPSTRArray`, nor the strings it references are allocated from Dolphin memory, instances can be handed off to external consumers that understand the task memory model.'!

!OS.COM.LPSTRArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer an <AnsiString> copy of the task heap ANSI string referenced by receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^AnsiString fromAddress: (self basicUncheckedAt: anInteger)! !

!OS.COM.LPSTRArray categoriesForMethods!
uncheckedAt:!accessing!private! !
!

!OS.COM.LPSTRArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^LPSTR! !

!OS.COM.LPSTRArray class categoriesForMethods!
elementClass!public! !
!


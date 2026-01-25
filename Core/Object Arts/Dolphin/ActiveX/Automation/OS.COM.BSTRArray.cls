"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'OS.COM.BSTRArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.BSTRArray guid: (Core.GUID fromString: '{13665806-953e-4961-9da4-4e39f83f5050}')!

OS.COM.BSTRArray comment: '`BSTRArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of `BSTR` pointer. `BSTR`s are allocated and free''d using the relevant OLE Automation APIs. The body of the array is expected to be allocated from the COM task heap.

As neither the array body of an `BSTRArray`, nor the strings it references are allocated from Dolphin memory, instances can be handed off to external consumers that understand the relevant memory models.'!

!OS.COM.BSTRArray methodsFor!

basicFree
	"Private - Free external resources owned by the receiver."

	0 to: bytes size - 1
		by: VMConstants.IntPtrSize
		do: 
			[:offset |
			| bstr |
			bstr := bytes uintPtrAtOffset: offset.
			bstr == 0 ifFalse: [OleAut32 sysFreeString: bstr]]!

initialize
	self beFinalizable!

needsFree
	^self isNull not!

uncheckedAt: anInteger
	"Private - Answer an 32-bit unsigned <integer> representing the element of the 
	receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	| bstr |
	bstr := bytes uintPtrAtOffset: (anInteger - 1) * VMConstants.IntPtrSize.
	^bstr isNull
		ifTrue: [Utf16String empty]
		ifFalse: [Utf16String fromAddress: bstr length: (OleAut32 sysStringLen: bstr)]!

uncheckedAt: indexInteger put: aString
	| offset str |
	offset := (indexInteger - 1) * VMConstants.IntPtrSize.
	"We must release any existing value"
	str := bytes uintPtrAtOffset: offset.
	str isNull ifFalse: [OleAut32 sysFreeString: str].
	str := aString asUtf16String.
	bytes uintPtrAtOffset: offset
		put: (str size == 0 ifTrue: [0] ifFalse: [OleAut32 sysAllocString: str]).
	^aString! !

!OS.COM.BSTRArray categoriesForMethods!
basicFree!private!realizing/unrealizing! !
initialize!initializing!private! !
needsFree!public! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.BSTRArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^BSTR! !

!OS.COM.BSTRArray class categoriesForMethods!
elementClass!public! !
!


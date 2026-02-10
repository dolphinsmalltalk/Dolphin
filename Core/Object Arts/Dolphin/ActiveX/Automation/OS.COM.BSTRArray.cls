"Filed out from Dolphin Smalltalk"!

OS.COM.HeapPointerArray
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

initializeVariant: anOleVariant
	"Private - Initialize the variant argument to be a vector type holding a copy of the receiver's values. This will be either a (VT_ARRAY|VT_BSTR), or a (VT_VECTOR|VT_BSTR)."
	
	anOleVariant bstrVector: self!

isSelfEvaluating
	^self notNull and: [self allSatisfy: [:element | element asUtf8String isSelfEvaluating]]!

uncheckedAt: anInteger
	"Private - Answer a <String> copy of the external string element of the receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	| bstr |
	bstr := self basicUncheckedAt: anInteger.
	^bstr isNull
		ifTrue: [Utf16String empty]
		ifFalse: [Utf16String fromAddress: bstr length: (OleAut32 sysStringLen: bstr)]! !

!OS.COM.BSTRArray categoriesForMethods!
initializeVariant:!converting!private! !
isSelfEvaluating!public! !
uncheckedAt:!accessing!private! !
!

!OS.COM.BSTRArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^BSTR!

fromSAFEARRAY: aSAFEARRAY
	^(self
		fromAddress: aSAFEARRAY base
		owner: aSAFEARRAY
		length: aSAFEARRAY elementCount) copy! !

!OS.COM.BSTRArray class categoriesForMethods!
elementClass!public! !
fromSAFEARRAY:!public! !
!


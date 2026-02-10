"Filed out from Dolphin Smalltalk"!

OS.COM.OleVariantArray
	subclass: #'OS.COM.VARIANTArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.VARIANTArray guid: (Core.GUID fromString: '{be594b0a-427c-4694-85e9-4f9021cac776}')!

OS.COM.VARIANTArray comment: '`VARIANTArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of `VARIANT` values.
'!

!OS.COM.VARIANTArray methodsFor!

basicFree
	"Private - Free external resources owned by the receiver. Both the array of variants, and contents individual variants, may be allocated from an external heap."

	Propsys clearVariantArray: bytes cVars: self length.
	bytes free! !

!OS.COM.VARIANTArray categoriesForMethods!
basicFree!private!realizing/unrealizing! !
!

!OS.COM.VARIANTArray class methodsFor!

copyBytes: srcByteObject from: startInteger to: stopInteger into: destByteObject
	| pDest pSrc |
	pSrc := srcByteObject yourAddress.
	pDest := destByteObject yourAddress - (startInteger - 1).
	startInteger - 1 to: stopInteger - 1
		by: _VARIANT_Size
		do: [:offset | OleAut32 variantCopyInd: pDest + offset pvargSrc: pSrc + offset].
	^destByteObject!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^VARIANT! !

!OS.COM.VARIANTArray class categoriesForMethods!
copyBytes:from:to:into:!copying!private! !
elementClass!public! !
!


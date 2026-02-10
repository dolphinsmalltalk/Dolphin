"Filed out from Dolphin Smalltalk"!

OS.COM.OleVariantArray
	subclass: #'OS.COM.PROPVARIANTArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.PROPVARIANTArray guid: (Core.GUID fromString: '{2e0910bb-3cbe-4377-bbd5-fc5350eabc41}')!

OS.COM.PROPVARIANTArray comment: '`PROPVARIANTArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of `PROPVARIANT` values.

'!

!OS.COM.PROPVARIANTArray methodsFor!

basicFree
	"Private - Free external resources owned by the receiver. Both the array of variants, and contents individual variants, may be allocated from an external heap."

	Propsys clearPropVariantArray: bytes cVars: self length.
	bytes free! !

!OS.COM.PROPVARIANTArray categoriesForMethods!
basicFree!private!realizing/unrealizing! !
!

!OS.COM.PROPVARIANTArray class methodsFor!

copyBytes: srcByteObject from: startInteger to: stopInteger into: destByteObject
	| pSrc pDest |
	pSrc := srcByteObject yourAddress.
	pDest := destByteObject yourAddress - (startInteger - 1).
	startInteger - 1 to: stopInteger - 1
		by: _VARIANT_Size
		do: [:offset | Ole32 propVariantCopy: pDest + offset pvarSrc: pSrc + offset].
	^destByteObject!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^PROPVARIANT! !

!OS.COM.PROPVARIANTArray class categoriesForMethods!
copyBytes:from:to:into:!copying!private! !
elementClass!public! !
!


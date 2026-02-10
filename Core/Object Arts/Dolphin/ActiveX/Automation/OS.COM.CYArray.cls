"Filed out from Dolphin Smalltalk"!

External.Int64Array
	subclass: #'OS.COM.CYArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.CYArray guid: (Core.GUID fromString: '{13765b0a-4851-44ad-8c51-a04c650310cd}')!

OS.COM.CYArray comment: '`OS.COM.CYArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of OLE Automation `CY` (aka `CURRENCY`) values.

`CY` is a fixed point number format represented as a 64-bit integer with an assumed scale of 4, i.e. the native integer value 1234 is corresponds to 0.1234s.

The values of `CYArray`s are marshalled to/from `Core.ScaledDecimal`s.'!

!OS.COM.CYArray methodsFor!

initializeVariant: anOleVariant
	"Private - Initialize the variant argument to be a vector type holding a copy of the receiver's values. This will be a (VT_ARRAY|VT_CY), or a (VT_VECTOR|VT_CY)."

	anOleVariant cyVector: self!

uncheckedAt: anInteger
	^ScaledDecimal newFromNumber: (self basicUncheckedAt: anInteger) / 10000 scale: 4!

uncheckedAt: anInteger put: aNumber
	self basicUncheckedAt: anInteger put: aNumber * 10000.
	^aNumber! !

!OS.COM.CYArray categoriesForMethods!
initializeVariant:!converting!private! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.CYArray class methodsFor!

elementClass
	^CY! !

!OS.COM.CYArray class categoriesForMethods!
elementClass!constants!public! !
!


"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'OS.COM.CYArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.CYArray guid: (Core.GUID fromString: '{13765b0a-4851-44ad-8c51-a04c650310cd}')!

OS.COM.CYArray comment: '`CYArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of OLE Automation `CY` (aka `CURRENCY`) values.

`CY` is a fixed point number format represented as a 64-bit integer with an assumed scale of 4, i.e. the native integer value 1234 is corresponds to 0.1234s.'!

!OS.COM.CYArray methodsFor!

uncheckedAt: anInteger
	^ScaledDecimal
		newFromNumber: (bytes int64AtOffset: (anInteger - 1) * CY._CY_Size) / 10000
		scale: 4!

uncheckedAt: anInteger put: aNumber
	bytes int64AtOffset: (anInteger - 1) * CY._CY_Size put: (aNumber * 10000) asInteger.
	^aNumber! !

!OS.COM.CYArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.CYArray class methodsFor!

elementClass
	^CY! !

!OS.COM.CYArray class categoriesForMethods!
elementClass!constants!public! !
!


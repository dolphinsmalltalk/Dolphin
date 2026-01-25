"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'OS.COM.DECIMALArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.DECIMAL private})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.DECIMALArray guid: (Core.GUID fromString: '{13765b0a-4851-44ad-8c51-a04c650310cd}')!

OS.COM.DECIMALArray comment: '`DECIMALArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of OLE Automation `DECIMAL` values.

`DECIMAL` is a 16-byte fixed point value with 12-bytes (96-bits) to represent the absolute value, and a byte each for decimal scale (between 0 and 28) and sign, with the top two bytes unused.

`DECIMALArray`s elements are unmarshalled to or marshalled from Dolphin''s `ScaledDecimal` objects by the #at: and #at:put: methods, respectively.'!

!OS.COM.DECIMALArray methodsFor!

uncheckedAt: anInteger
	| base scale |
	base := (anInteger - 1) * _DECIMAL_Size.
	scale := bytes uint8AtOffset: base + _OffsetOf_scale.
	^ScaledDecimal
		newFromNumber: (((bytes uint32AtOffset: base + _OffsetOf_hi32) bitShift: 64)
				+ (bytes uint64AtOffset: base + _OffsetOf_lo64))
					* ((bytes int8AtOffset: base + _OffsetOf_sign) == 0 ifTrue: [1] ifFalse: [-1])
					/ scale exp10
		scale: scale!

uncheckedAt: anInteger put: aScaledDecimalOrInteger
	| base scale intVal |
	base := (anInteger - 1) * _DECIMAL_Size.
	scale := aScaledDecimalOrInteger scale.
	(scale between: 0 and: MaxScale)
		ifFalse: 
			[InvalidArgumentError
				signal: ('Scale <1p> is outside permitted range 0..<2p>' expandMacrosWith: scale with: MaxScale)
				with: 'aScaledDecimalOrInteger'].
	bytes uint8AtOffset: base + _OffsetOf_scale put: scale.
	intVal := (aScaledDecimalOrInteger * scale exp10) asInteger.
	bytes int8AtOffset: base + _OffsetOf_sign
		put: (intVal negative
				ifTrue: 
					[intVal := intVal negated.
					-1]
				ifFalse: [0]).
	bytes
		uint32AtOffset: base + _OffsetOf_hi32 put: (intVal bitShift: -64);
		uint64AtOffset: base + _OffsetOf_lo64 put: (intVal bitAnd: 16rFFFFFFFFFFFFFFFF).
	^aScaledDecimalOrInteger! !

!OS.COM.DECIMALArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.DECIMALArray class methodsFor!

elementClass
	^DECIMAL! !

!OS.COM.DECIMALArray class categoriesForMethods!
elementClass!constants!public! !
!


"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.DECIMAL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_DECIMAL_Size' -> 16r10.
			'_OffsetOf_hi32' -> 16r4.
			'_OffsetOf_lo64' -> 16r8.
			'_OffsetOf_scale' -> 16r2.
			'_OffsetOf_sign' -> 16r3.
			'_OffsetOf_wReserved' -> 16r0.
			'MaxScale' -> 16r1C.
			'MaxValue' -> 16rFFFFFFFFFFFFFFFFFFFFFFFF.
			'SmallestValue' -> 0.0000000000000000000000000001s
		}!

OS.COM.DECIMAL guid: (Core.GUID fromString: '{e6470841-9795-44b8-ba35-cccbab3e9a0c}')!

OS.COM.DECIMAL comment: '`DECIMAL` is an `External.Structure` class to represent the COM Automation structure of the same name.

`DECIMAL` is a rather complex 16-byte fixed point value with 12-bytes (96-bits) to represent the absolute value, and a byte each for decimal scale (between 0 and 28) and sign, with the top two bytes unused so that a `DECIMAL` can be stored safely in a `VARIANT` without overwriting the vartype. `DECIMAL` corresponds to the vartype `VT_DECIMAL`.

`DECIMAL`s are mapped to/from Dolphin''s `ScaledDecimal` objects, although of course the latter has unlimited range and precision, and therefore not all `ScaledDecimal`s can be represented in a `DECIMAL`.'!

!OS.COM.DECIMAL categoriesForClass!External-Data-Structured-COM! !

!OS.COM.DECIMAL methodsFor!

asVariant
	"Answer the <VARIANT> representation of the receiver."

	^VARIANT new
		vt: (self vt bitOr: VT_BYREF);
		reference: self;
		yourself!

displayOn: aPuttableStream
	aPuttableStream locale displayDECIMAL: self on: aPuttableStream!

hi32
	"Answer the <Integer> value of the receiver's 'hi32' field."

	^bytes uint32AtOffset: _OffsetOf_hi32!

hi32: anInteger
	"Set the receiver's 'hi32' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_hi32 put: anInteger!

lo64
	"Answer the <Integer> value of the receiver's 'lo64' field."

	^bytes uint64AtOffset: _OffsetOf_lo64!

lo64: anInteger
	"Set the receiver's 'lo64' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_lo64 put: anInteger!

scale
	"Answer the <Integer> value of the receiver's 'scale' field."

	^bytes uint8AtOffset: _OffsetOf_scale!

scale: anInteger
	"Set the receiver's 'scale' field to the value of the argument, anInteger"

	(anInteger < 0 or: [anInteger > 28])
		ifTrue: 
			[InvalidArgumentError
				signal: ('Scale <1p> is outside permitted range 0..<2p>' expandMacrosWith: anInteger with: MaxScale)
				with: 'anInteger'].
	bytes uint8AtOffset: _OffsetOf_scale put: anInteger!

sign
	"Answer the <Integer> value of the receiver's 'sign' field."

	^bytes int8AtOffset: _OffsetOf_sign!

sign: anInteger
	"Set the receiver's 'sign' field to the value of the argument, anInteger"

	bytes int8AtOffset: _OffsetOf_sign put: anInteger!

value
	"Answer the receiver's value as a Smalltalk <ScaledDecimal>."

	| scale |
	scale := self scale.
	^ScaledDecimal
		newFromNumber: ((self hi32 bitShift: 64) + self lo64) * (self sign == 0 ifTrue: [1] ifFalse: [-1])
				/ scale exp10
		scale: scale!

value: aScaledDecimalOrInteger
	"Set the receiver's value to the the closest DECIMAL representation of the <ScaledDecimal>|<Integer> argument."

	| scale intVal |
	self scale: (scale := aScaledDecimalOrInteger scale).
	intVal := (aScaledDecimalOrInteger * scale exp10) asInteger.
	self sign: (intVal negative
				ifTrue: 
					[intVal := intVal negated.
					-1]
				ifFalse: [0]).
	self hi32: (intVal bitShift: -64).
	self lo64: (intVal bitAnd: 16rFFFFFFFFFFFFFFFF)! !

!OS.COM.DECIMAL categoriesForMethods!
asVariant!converting!public! !
displayOn:!displaying!public! !
hi32!**compiled accessors**!public! !
hi32:!**compiled accessors**!public! !
lo64!**compiled accessors**!public! !
lo64:!**compiled accessors**!public! !
scale!**compiled accessors**!public! !
scale:!public! !
sign!**compiled accessors**!public! !
sign:!**compiled accessors**!public! !
value!accessing!public! !
value:!accessing!public! !
!

!OS.COM.DECIMAL class methodsFor!

byteSize
	^_DECIMAL_Size!

defineFields
	"Define the fields of the DECIMAL 'structure'.

		self compileDefinition
	"

	self
		defineField: #wReserved 	type: UInt16Field filler;
		defineField: #scale		type: UInt8Field new;
		defineField: #sign		type: Int8Field new;
		defineField: #hi32		type: UInt32Field new;
		defineField: #lo64		type: UInt64Field new!

getFieldNames
	^#(#scale #sign #hi32 #lo64)!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	| maxScale |
	maxScale := 28.
	self addClassConstant: 'MaxScale' value: maxScale.
	self addClassConstant: 'MaxValue' value: 2 ** 96 - 1.
	self addClassConstant: 'SmallestValue' value: (1 / maxScale exp10 asScaledDecimal: maxScale).
	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_DECIMAL! !

!OS.COM.DECIMAL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
vt!constants!public! !
!


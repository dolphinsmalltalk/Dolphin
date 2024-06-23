"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.CURRENCY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_CURRENCY_Size' -> 16r8.
			'_OffsetOf_cy' -> 16r0.
			'MaxValue' -> 922337203685477.5807s.
			'MinValue' -> -922337203685477.5808s
		}!

OS.COM.CURRENCY guid: (Core.GUID fromString: '{bbe7e662-de98-4ae2-b820-bae3e3c6127a}')!

OS.COM.CURRENCY comment: '`CURRENCY` is an `External.Structure` class to represent the Automation structure of the same name.

`CURRENCY` is a 64-bit fractional value scaled by 10000 to give 4 decimal places. It provides limited scaled decimal capabilities for simple scripting languages such as VB. It corresponds to the variant type `VT_CY`.

`CURRENCY`s are mapped to/from Dolphin''s `ScaledDecimal` objects, although of course the latter has unlimited  range and precision, and therefore many `ScaledDecimal`s cannot be represented in a `CURRENCY`.

See also `DECIMAL`'!

!OS.COM.CURRENCY categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CURRENCY methodsFor!

asVariant
	"Answer the <VARIANT> representation of the receiver."

	^VARIANT new
		vt: (self vt bitOr: VT_BYREF);
		reference: self;
		yourself!

cy
	"Answer the <Integer> value of the receiver's 'cy' field."

	^bytes int64AtOffset: _OffsetOf_cy!

cy: anInteger
	"Set the receiver's 'cy' field to the value of the argument, anInteger"

	bytes int64AtOffset: _OffsetOf_cy put: anInteger!

displayOn: aPuttableStream
	aPuttableStream locale displayCURRENCY: self on: aPuttableStream!

scale
	"The number of fractional digits is fixed."

	^4!

value
	"Answer the receiver's value as a Smalltalk <ScaledDecimal>."

	^ScaledDecimal newFromNumber: self cy / 10000 scale: 4!

value: newValue
	"Set the receiver's value to the <Number>, newValue."

	self cy: (newValue * 10000) asInteger! !

!OS.COM.CURRENCY categoriesForMethods!
asVariant!converting!public! !
cy!**compiled accessors**!public! !
cy:!**compiled accessors**!public! !
displayOn:!displaying!public! !
scale!**compiled accessors**!public! !
value!accessing!public! !
value:!accessing!public! !
!

OS.COM.CURRENCY methodProtocol: #variantCompatible attributes: #(#readOnly) selectors: #(#asVariant)!

!OS.COM.CURRENCY class methodsFor!

byteSize
	^_CURRENCY_Size!

defineFields
	"Define the fields of the CURRENCY 'structure'.

		self compileDefinition
	"

	self defineField: #cy type: Int64Field new
!

epsilon
	"Answer a <Float> representing the minimum relative spacing
	in the receiver's representation."

	^0.0001
!

getFieldNames
	^#(#cy)!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self addClassConstant: 'MaxValue' value: (((2 raisedToInteger: 63) - 1) / 10000 asScaledDecimal: 4).
	self addClassConstant: 'MinValue' value: ((-2 raisedToInteger: 63) / 10000 asScaledDecimal: 4).
	VM registryAt: self name put: self!

maximum
	^MaxValue!

minimum
	^MinValue!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_CY! !

!OS.COM.CURRENCY class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
epsilon!constants!public! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!initializing!private! !
maximum!constants!public! !
minimum!constants!public! !
uninitialize!class hierarchy-removing!private! !
vt!constants!public! !
!


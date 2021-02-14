"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.CURRENCY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cy' -> 16r0
	}!
OS.COM.CURRENCY guid: (Core.GUID fromString: '{bbe7e662-de98-4ae2-b820-bae3e3c6127a}')!
OS.COM.CURRENCY comment: 'CURRENCY is an <ExternalStructure> class to represent the Automation structure of the same name.

CURRENCY is a 64-bit fractional value scaled by 10000 to give 4 decimal places. It provides limited scaled decimal capabilities for simple scripting languages such as VB. It corresponds to the variant type VT_CY.

CURRENCYs are mapped to/from Dolphin''s <ScaledDecimal> objects, although of course the latter has unlimited  range, and therefore many ScaledDecimals cannot be represented in a CURRENCY.'!
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

	^bytes sqwordAtOffset: _OffsetOf_cy!

cy: anInteger
	"Set the receiver's 'cy' field to the value of the argument, anInteger"

	bytes sqwordAtOffset: _OffsetOf_cy put: anInteger!

value
	"Answer the receiver's value as a Smalltalk <ScaledDecimal>."

	^(self cy/10000) asScaledDecimal: 4
!

value: newValue
	"Set the receiver's value to the <Number>, newValue."

	self cy: (newValue * 10000) asInteger! !
!OS.COM.CURRENCY categoriesFor: #asVariant!converting!public! !
!OS.COM.CURRENCY categoriesFor: #cy!**compiled accessors**!public! !
!OS.COM.CURRENCY categoriesFor: #cy:!**compiled accessors**!public! !
!OS.COM.CURRENCY categoriesFor: #value!accessing!public! !
!OS.COM.CURRENCY categoriesFor: #value:!accessing!public! !

OS.COM.CURRENCY methodProtocol: #variantCompatible attributes: #(#readOnly) selectors: #(#asVariant)!

!OS.COM.CURRENCY class methodsFor!

defineFields
	"Define the fields of the CURRENCY 'structure'.

		self compileDefinition
	"

	self defineField: #cy type: SQWORDField new
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

	VMLibrary default registryAt: self name put: self!

maximum
	^((2 raisedToInteger: 63)-1/10000) asScaledDecimal: 4!

minimum
	^((-2 raisedToInteger: 63)/10000) asScaledDecimal: 4.!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_CY! !
!OS.COM.CURRENCY class categoriesFor: #defineFields!public!template definition! !
!OS.COM.CURRENCY class categoriesFor: #epsilon!constants!public! !
!OS.COM.CURRENCY class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.COM.CURRENCY class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.CURRENCY class categoriesFor: #maximum!constants!public! !
!OS.COM.CURRENCY class categoriesFor: #minimum!constants!public! !
!OS.COM.CURRENCY class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!OS.COM.CURRENCY class categoriesFor: #vt!constants!public! !


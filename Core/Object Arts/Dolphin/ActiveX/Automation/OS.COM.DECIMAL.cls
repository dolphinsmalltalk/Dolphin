"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.DECIMAL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hi32' -> 16r4.
		'_OffsetOf_lo64' -> 16r8.
		'_OffsetOf_scale' -> 16r2.
		'_OffsetOf_sign' -> 16r3.
		'_OffsetOf_wReserved' -> 16r0
	}!
OS.COM.DECIMAL guid: (Core.GUID fromString: '{e6470841-9795-44b8-ba35-cccbab3e9a0c}')!
OS.COM.DECIMAL comment: 'DECIMAL is an ExternalStructure class to represent the Automation structure of the same name.

DECIMAL is a rather complex 16-byte fixed point value with 12-bytes to represent the absolute value, and a byte each for scale and sign, with the top two bytes unused so that a DECIMAL can be stored safely in a VARIANT without overwriting the vartype. DECIMAL corresponds to VT_DECIMAL.

DECIMALs are mapped to/from Dolphin''s <ScaledDecimal> objects, although of course the latter has unlimited  range, and therefore not all ScaledDecimals can be represented in a DECIMAL.'!
!OS.COM.DECIMAL categoriesForClass!External-Data-Structured-COM! !
!OS.COM.DECIMAL methodsFor!

hi32
	"Answer the <Integer> value of the receiver's 'hi32' field."

	^bytes dwordAtOffset: _OffsetOf_hi32!

hi32: anInteger
	"Set the receiver's 'hi32' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hi32 put: anInteger!

lo64
	"Answer the <Integer> value of the receiver's 'lo64' field."

	^bytes qwordAtOffset: _OffsetOf_lo64!

lo64: anInteger
	"Set the receiver's 'lo64' field to the value of the argument, anInteger"

	bytes qwordAtOffset: _OffsetOf_lo64 put: anInteger!

scale
	"Answer the <Integer> value of the receiver's 'scale' field."

	^bytes byteAtOffset: _OffsetOf_scale!

scale: anInteger
	"Set the receiver's 'scale' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_scale put: anInteger!

sign
	"Answer the <Integer> value of the receiver's 'sign' field."

	^bytes byteAtOffset: _OffsetOf_sign!

sign: anInteger
	"Set the receiver's 'sign' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_sign put: anInteger!

value
	"Answer the receiver's value as a Smalltalk <ScaledDecimal>."

	| sign scale hi32 lo64 |
	scale := self scale.
	sign := self sign == 0 ifTrue: [1] ifFalse: [-1].
	hi32 := self hi32.
	lo64 := self lo64.
	^((hi32 bitShift: 64) + lo64) * sign / scale exp10 asScaledDecimal: scale!

value: val
	"Set the receiver's value to the <ScaledDecimal>, val."

	| scale intVal |
	scale := val scale.
	self scale: scale.
	intVal := val positive
				ifTrue: 
					[self sign: 0.
					val * scale exp10]
				ifFalse: 
					[self sign: 128.
					val * (-10 raisedToInteger: scale)].
	intVal := intVal asInteger.
	self hi32: (intVal bitShift: -64).
	self lo64: (intVal bitAnd: 16rFFFFFFFFFFFFFFFF)! !
!OS.COM.DECIMAL categoriesFor: #hi32!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #hi32:!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #lo64!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #lo64:!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #scale!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #scale:!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #sign!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #sign:!**compiled accessors**!public! !
!OS.COM.DECIMAL categoriesFor: #value!accessing!public! !
!OS.COM.DECIMAL categoriesFor: #value:!accessing!public! !

!OS.COM.DECIMAL class methodsFor!

defineFields
	"Define the fields of the DECIMAL 'structure'.

		self compileDefinition
	"

	self
		defineField: #wReserved 	type: WORDField filler;
		defineField: #scale		type: BYTEField new;
		defineField: #sign		type: BYTEField new;
		defineField: #hi32		type: DWORDField new;
		defineField: #lo64		type: QWORDField new!

getFieldNames
	^#(#scale #sign #hi32 #lo64)!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_DECIMAL! !
!OS.COM.DECIMAL class categoriesFor: #defineFields!public!template definition! !
!OS.COM.DECIMAL class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.COM.DECIMAL class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.DECIMAL class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!OS.COM.DECIMAL class categoriesFor: #vt!constants!public! !


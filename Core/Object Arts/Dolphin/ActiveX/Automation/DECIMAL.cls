"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #DECIMAL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
DECIMAL guid: (GUID fromString: '{E6470841-9795-44B8-BA35-CCCBAB3E9A0C}')!
DECIMAL comment: 'DECIMAL is an ExternalStructure class to represent the Automation structure of the same name.

DECIMAL is a rather complex 16-byte fixed point value with 12-bytes to represent the absolute value, and a byte each for scale and sign, with the top two bytes unused so that a DECIMAL can be stored safely in a VARIANT without overwriting the vartype. DECIMAL corresponds to VT_DECIMAL.

DECIMALs are mapped to/from Dolphin''s <ScaledDecimal> objects, although of course the latter has unlimited  range, and therefore not all ScaledDecimals can be represented in a DECIMAL.'!
!DECIMAL categoriesForClass!External-Data-Structured-COM! !
!DECIMAL methodsFor!

hi32
	"Answer the receiver's hi32 field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #hi32)!

hi32: anObject 
	"Set the receiver's hi32 field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hi32) put: anObject!

lo64
	"Answer the receiver's lo64 field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #lo64)!

lo64: anObject 
	"Set the receiver's lo64 field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #lo64) put: anObject!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: (self isNull ifTrue: ['NULL'] ifFalse: [self value]);
		nextPut: $)!

scale
	"Answer the receiver's scale field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #scale)!

scale: anObject 
	"Set the receiver's scale field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #scale) put: anObject!

sign
	"Answer the receiver's sign field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #sign)!

sign: anObject 
	"Set the receiver's sign field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #sign) put: anObject!

value
	"Answer the receiver's value as a Smalltalk <ScaledDecimal>."

	| sign scale hi32 lo64 |
	scale := self scale.
	sign := self sign == 0 ifTrue: [1] ifFalse: [-1].
	hi32 := self hi32.
	lo64 := self lo64.
	^((hi32 bitShift: 64) + lo64) * sign / (10 raisedToInteger: scale) asScaledDecimal: scale!

value: val
	"Set the receiver's value to the <ScaledDecimal>, val."

	| scale intVal |
	scale := val scale.
	self scale: scale.
	intVal := val positive 
				ifTrue: 
					[self sign: 0.
					val * (10 raisedToInteger: scale)]
				ifFalse: 
					[self sign: 128.
					val * (-10 raisedToInteger: scale)].
	intVal := intVal asInteger.
	self hi32: (intVal bitShift: -64).
	self lo64: (intVal bitAnd: 16rFFFFFFFFFFFFFFFF)! !
!DECIMAL categoriesFor: #hi32!**compiled accessors**!public! !
!DECIMAL categoriesFor: #hi32:!**compiled accessors**!public! !
!DECIMAL categoriesFor: #lo64!**compiled accessors**!public! !
!DECIMAL categoriesFor: #lo64:!**compiled accessors**!public! !
!DECIMAL categoriesFor: #printOn:!printing!public! !
!DECIMAL categoriesFor: #scale!**compiled accessors**!public! !
!DECIMAL categoriesFor: #scale:!**compiled accessors**!public! !
!DECIMAL categoriesFor: #sign!**compiled accessors**!public! !
!DECIMAL categoriesFor: #sign:!**compiled accessors**!public! !
!DECIMAL categoriesFor: #value!accessing!public! !
!DECIMAL categoriesFor: #value:!accessing!public! !

!DECIMAL class methodsFor!

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
!DECIMAL class categoriesFor: #defineFields!initializing!public! !
!DECIMAL class categoriesFor: #initialize!development!initializing!private! !
!DECIMAL class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!DECIMAL class categoriesFor: #vt!constants!public! !


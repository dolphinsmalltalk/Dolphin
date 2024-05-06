"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #_FPIEEE_RECORD
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cause _OffsetOf_enable _OffsetOf_flags _OffsetOf_operand1 _OffsetOf_operand2 _OffsetOf_result _OffsetOf_status'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

_FPIEEE_RECORD guid: (GUID fromString: '{87b4c590-026e-11d3-9fd7-00a0cc3e4a32}')!

_FPIEEE_RECORD addClassConstant: '_OffsetOf_cause' value: 16r4!
_FPIEEE_RECORD addClassConstant: '_OffsetOf_enable' value: 16r8!
_FPIEEE_RECORD addClassConstant: '_OffsetOf_flags' value: 16r0!
_FPIEEE_RECORD addClassConstant: '_OffsetOf_operand1' value: 16r10!
_FPIEEE_RECORD addClassConstant: '_OffsetOf_operand2' value: 16r28!
_FPIEEE_RECORD addClassConstant: '_OffsetOf_result' value: 16r40!
_FPIEEE_RECORD addClassConstant: '_OffsetOf_status' value: 16rC!

_FPIEEE_RECORD comment: '_FPIEEE_RECORD is an <ExternalStructure> class to represent the Win32 structure of the same name. _FPIEEE_RECORD is used in the reporting of IEEE compliant floating point exceptions.'!

!_FPIEEE_RECORD categoriesForClass!External-Data-Structured! !

!_FPIEEE_RECORD methodsFor!

cause
	"Answer the <Integer> value of the receiver's 'cause' field."

	^bytes dwordAtOffset: _OffsetOf_cause!

causeDescription
	"Answer the symbolic names of the type of floating point exception the receiver represents."

	| stream |
	stream := String writeStream: 16.
	self class printFlags: self cause on: stream.
	^stream contents!

causeNames
	"Answer the symbolic names of the type of floating point exception the receiver represents."

	| stream |
	stream := Array writeStream: 4.
	self class exceptionFlags: self cause do: [:each | stream nextPut: each].
	^stream contents!

enable
	"Answer the <Integer> value of the receiver's 'enable' field."

	^bytes dwordAtOffset: _OffsetOf_enable!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

isDivide
	"Answer whether a division operation was being attemped when the exception occurred."

	^self operation == 4!

isOverflow
	"Answer whether this IEEE FP exception record represents a floating point
	underflow error."

	^self cause isBitSet: 3!

isUnderflow
	"Answer whether this IEEE FP exception record represents a floating point
	underflow error."

	^self cause isBitSet: 2!

isZeroDivide
	"Answer whether this IEEE FP exception record represents a floating point
	division by zero error."

	"Implementation Note: Division by zero is signalled as either a ZeroDivide
	or, if dividing zero by zero, InvalidOperation.
	When dividing by integer 0, it appears that the value of the second
	operand is not reliably set up, so we assume that any invalid divide
	of zero must be a division by zero."

	^(self cause isBitSet: 4) or: [self isDivide and: [self operand1 value isZero]]!

operand1
	"Answer the <_FPIEEE_VALUE> value of the receiver's 'operand1' field."

	^_FPIEEE_VALUE fromAddress: bytes yourAddress + _OffsetOf_operand1!

operand2
	"Answer the <_FPIEEE_VALUE> value of the receiver's 'operand2' field."

	^_FPIEEE_VALUE fromAddress: bytes yourAddress + _OffsetOf_operand2!

operation
	"Answer an <integer> which identifies the type of operation being attemped when the exception
	occurred. See fpieee.h in the MS Win32 SDK for further information."

	^(self flags bitShift: -5) bitAnd: 16rFFF!

operationName
	"Answer the symbolic name of the operation being attemped when the exception
	occurred. See fpieee.h in the MS Win32 SDK for further information."

	^self class operationCodes at: self operation ifAbsent: [#Unspecified]!

precision
	"Answer an <integer> which identifies the precision configured at the time of the exception."

	^(self flags bitShift: -2) bitAnd: 2r111!

precisionName
	"Answer a the symbolic name of the precision setting at the time of the exception."

	^self class precisionModes at: self precision + 1 ifAbsent: [#Unknown]!

roundingMode
	"Answer an <integer> which identifies the rounding mode configured at the time of the exception."

	^self flags bitAnd: 2r11!

roundingModeName
	"Answer the symbolic name of the rounding mode configured at the time of the exception."

	^self class roundingModes at: self roundingMode + 1 ifAbsent: [#Unknown]! !

!_FPIEEE_RECORD categoriesForMethods!
cause!**compiled accessors**!public! !
causeDescription!accessing!public! !
causeNames!accessing!public! !
enable!**compiled accessors**!public! !
flags!**compiled accessors**!public! !
isDivide!public!testing! !
isOverflow!public!testing! !
isUnderflow!public!testing! !
isZeroDivide!public!testing! !
operand1!**compiled accessors**!public! !
operand2!**compiled accessors**!public! !
operation!accessing!public! !
operationName!accessing!public! !
precision!accessing!public! !
precisionName!accessing!public! !
roundingMode!accessing!public! !
roundingModeName!accessing!public! !
!

!_FPIEEE_RECORD class methodsFor!

defineFields
	"Define the fields of the _FPIEEE_RECORD 'structure'. The _FPIEEE_RECORD is a
	rather complex structure containing details of a floating point exception.

		self compileDefinition
	"

	self
		defineField: #flags type: DWORDField readOnly;
		defineField: #cause type: DWORDField readOnly;
		defineField: #enable type: DWORDField readOnly;
		defineField: #status type: DWORDField readOnly beUncompiled;
		defineField: #operand1 type: (StructureField type: _FPIEEE_VALUE) beReadOnly;
		defineField: #operand2 type: (StructureField type: _FPIEEE_VALUE) beReadOnly;
		defineField: #result type: (StructureField type: _FPIEEE_VALUE) beFiller!

exceptionFlags
	^#(#Inexact #Underflow #Overflow #ZeroDivide #InvalidOperation)!

exceptionFlags: anInteger do: aMonadicValuable
	(anInteger bitAnd: 2r11111) == 0
		ifTrue: 
			["Assume that if no cause bits are set, it must be for a denormal operand exception.
		This is not one of the standard IEEE causes, but can occur on Windows if unmasked."
			aMonadicValuable value: #Denormal]
		ifFalse: 
			[self exceptionFlags inject: 1
				into: 
					[:mask :each |
					(anInteger anyMask: mask) ifTrue: [aMonadicValuable value: each].
					mask << 1]]!

getFieldNames
	^#(#flags #cause #enable #status #operand1 #operand2)!

operationCodes
	^#(#Add #Subtract #Multiply #Divide #SquareRoot #Remainder #Compare #Convert #Round #Truncate #Floor #Ceil #Acos #Asin #Atan #Atan2 #Cabs #Cos #Cosh #Exp #Fabs #Fmod #Frexp #Hypot #Ldexp #Log #Log10 #Modf #Pow #Sin #Sinh #Tan #Tanh #Y0 #Y1 #Yn #Logb #Nextafter #Negate #Fmin #Fmax #ConvertTrunc #Addps #Addss #Subps #Subss #Mulps #Mulss #Divps #Divss #Sqrtps #Sqrtss #Maxps #Maxss #Minps #Minss #Cmpps #Cmpss #Comiss #UComiss #Cvtpi2ps #Cvtsi2ss #Cvtps2pi #Cvtss2si #Cvttps2pi #Cvttss2si #Addsubps #Haddps #Hsubps #Roundps #Roundss #Dpps #Addpd #Addsd #Subpd #Subsd #Mulpd #Mulsd #Divpd #Divsd #Sqrtpd #Sqrtsd #Maxpd #Maxsd #Minpd #Minsd #Cmppd #Cmpsd #Comisd #UComisd #Cvtpd2pi #Cvtsd2si #Cvttpd2pi #Cvttsd2si #Cvtps2pd #Cvtss2sd #Cvtpd2ps #Cvtsd2ss #Cvtdq2ps #Cvttps2dq #Cvtps2dq #Cvttpd2dq #Cvtpd2dq #Addsubpd #Haddpd #Hsubpd #Roundpd #Roundsd #Dppd #Fma #FmaSingle #FmaDouble #Fms #FmsSingle #FmsDouble #Fnma #FnmaSingle #FnmaDouble #Famin #Famax)!

precisionModes
	^#(#Full 53 24 64 113)!

printFlags: anInteger on: aStream
	| first |
	anInteger == 0
		ifTrue: 
			[aStream nextPut: $0.
			^self].
	first := true.
	self exceptionFlags: anInteger
		do: 
			[:flag |
			first ifTrue: [first := false] ifFalse: [aStream nextPut: $|].
			aStream display: flag]!

roundingModes
	^#(#Nearest #MinusInfinity #PlusInfinity #Chopped)! !

!_FPIEEE_RECORD class categoriesForMethods!
defineFields!public!template definition! !
exceptionFlags!constants!public! !
exceptionFlags:do:!helpers!private! !
getFieldNames!**compiled accessors**!constants!private! !
operationCodes!constants!public! !
precisionModes!constants!public! !
printFlags:on:!helpers!private! !
roundingModes!constants!public! !
!


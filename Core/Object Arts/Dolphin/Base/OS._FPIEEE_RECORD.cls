"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS._FPIEEE_RECORD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'__FPIEEE_RECORD_Size' -> 16r58.
			'_FP_OPERATION_CODE'
				-> #('_FpCodeUnspecified' '_FpCodeAdd' '_FpCodeSubtract' '_FpCodeMultiply' '_FpCodeDivide' '_FpCodeSquareRoot' '_FpCodeRemainder' '_FpCodeCompare' '_FpCodeConvert' '_FpCodeRound' '_FpCodeTruncate' '_FpCodeFloor' '_FpCodeCeil' '_FpCodeAcos' '_FpCodeAsin' '_FpCodeAtan' '_FpCodeAtan2' '_FpCodeCabs' '_FpCodeCos' '_FpCodeCosh' '_FpCodeExp' '_FpCodeFabs' '_FpCodeFmod' '_FpCodeFrexp' '_FpCodeHypot' '_FpCodeLdexp' '_FpCodeLog' '_FpCodeLog10' '_FpCodeModf' '_FpCodePow' '_FpCodeSin' '_FpCodeSinh' '_FpCodeTan' '_FpCodeTanh' '_FpCodeY0' '_FpCodeY1' '_FpCodeYn' '_FpCodeLogb' '_FpCodeNextafter' '_FpCodeNegate' '_FpCodeFmin' '_FpCodeFmax' '_FpCodeConvertTrunc' '_XMMIAddps' '_XMMIAddss' '_XMMISubps' '_XMMISubss' '_XMMIMulps' '_XMMIMulss' '_XMMIDivps' '_XMMIDivss' '_XMMISqrtps' '_XMMISqrtss' '_XMMIMaxps' '_XMMIMaxss' '_XMMIMinps' '_XMMIMinss' '_XMMICmpps' '_XMMICmpss' '_XMMIComiss' '_XMMIUComiss' '_XMMICvtpi2ps' '_XMMICvtsi2ss' '_XMMICvtps2pi' '_XMMICvtss2si' '_XMMICvttps2pi' '_XMMICvttss2si' '_XMMIAddsubps' '_XMMIHaddps' '_XMMIHsubps' '_XMMIRoundps' '_XMMIRoundss' '_XMMIDpps' '_XMMI2Addpd' '_XMMI2Addsd' '_XMMI2Subpd' '_XMMI2Subsd' '_XMMI2Mulpd' '_XMMI2Mulsd' '_XMMI2Divpd' '_XMMI2Divsd' '_XMMI2Sqrtpd' '_XMMI2Sqrtsd' '_XMMI2Maxpd' '_XMMI2Maxsd' '_XMMI2Minpd' '_XMMI2Minsd' '_XMMI2Cmppd' '_XMMI2Cmpsd' '_XMMI2Comisd' '_XMMI2UComisd' '_XMMI2Cvtpd2pi' '_XMMI2Cvtsd2si' '_XMMI2Cvttpd2pi' '_XMMI2Cvttsd2si' '_XMMI2Cvtps2pd' '_XMMI2Cvtss2sd' '_XMMI2Cvtpd2ps' '_XMMI2Cvtsd2ss' '_XMMI2Cvtdq2ps' '_XMMI2Cvttps2dq' '_XMMI2Cvtps2dq' '_XMMI2Cvttpd2dq' '_XMMI2Cvtpd2dq' '_XMMI2Addsubpd' '_XMMI2Haddpd' '_XMMI2Hsubpd' '_XMMI2Roundpd' '_XMMI2Roundsd' '_XMMI2Dppd').
			'_FpCodeAcos' -> 16rD.
			'_FpCodeAdd' -> 16r1.
			'_FpCodeAsin' -> 16rE.
			'_FpCodeAtan' -> 16rF.
			'_FpCodeAtan2' -> 16r10.
			'_FpCodeCabs' -> 16r11.
			'_FpCodeCeil' -> 16rC.
			'_FpCodeCompare' -> 16r7.
			'_FpCodeConvert' -> 16r8.
			'_FpCodeConvertTrunc' -> 16r2A.
			'_FpCodeCos' -> 16r12.
			'_FpCodeCosh' -> 16r13.
			'_FpCodeDivide' -> 16r4.
			'_FpCodeExp' -> 16r14.
			'_FpCodeFabs' -> 16r15.
			'_FpCodeFloor' -> 16rB.
			'_FpCodeFmax' -> 16r29.
			'_FpCodeFmin' -> 16r28.
			'_FpCodeFmod' -> 16r16.
			'_FpCodeFrexp' -> 16r17.
			'_FpCodeHypot' -> 16r18.
			'_FpCodeLdexp' -> 16r19.
			'_FpCodeLog' -> 16r1A.
			'_FpCodeLog10' -> 16r1B.
			'_FpCodeLogb' -> 16r25.
			'_FpCodeModf' -> 16r1C.
			'_FpCodeMultiply' -> 16r3.
			'_FpCodeNegate' -> 16r27.
			'_FpCodeNextafter' -> 16r26.
			'_FpCodePow' -> 16r1D.
			'_FpCodeRemainder' -> 16r6.
			'_FpCodeRound' -> 16r9.
			'_FpCodeSin' -> 16r1E.
			'_FpCodeSinh' -> 16r1F.
			'_FpCodeSquareRoot' -> 16r5.
			'_FpCodeSubtract' -> 16r2.
			'_FpCodeTan' -> 16r20.
			'_FpCodeTanh' -> 16r21.
			'_FpCodeTruncate' -> 16rA.
			'_FpCodeUnspecified' -> 16r0.
			'_FpCodeY0' -> 16r22.
			'_FpCodeY1' -> 16r23.
			'_FpCodeYn' -> 16r24.
			'_FPIEEE_EXCEPTION_FLAGS'
				-> #('Inexact' 'Underflow' 'Overflow' 'ZeroDivide' 'InvalidOperation').
			'_FPIEEE_PRECISION' -> #('_FpPrecisionFull' '_FpPrecision53' '_FpPrecision24').
			'_FPIEEE_ROUNDING_MODE'
				-> #('_FpRoundNearest' '_FpRoundMinusInfinity' '_FpRoundPlusInfinity' '_FpRoundChopped').
			'_FpPrecision24' -> 16r2.
			'_FpPrecision53' -> 16r1.
			'_FpPrecisionFull' -> 16r0.
			'_FpRoundChopped' -> 16r3.
			'_FpRoundMinusInfinity' -> 16r1.
			'_FpRoundNearest' -> 16r0.
			'_FpRoundPlusInfinity' -> 16r2.
			'_OffsetOf_cause' -> 16r4.
			'_OffsetOf_enabled' -> 16r8.
			'_OffsetOf_flags' -> 16r0.
			'_OffsetOf_operand1' -> 16r10.
			'_OffsetOf_operand2' -> 16r28.
			'_OffsetOf_result' -> 16r40.
			'_OffsetOf_status' -> 16rC.
			'_XMMI2Addpd' -> 16r49.
			'_XMMI2Addsd' -> 16r4A.
			'_XMMI2Addsubpd' -> 16r68.
			'_XMMI2Cmppd' -> 16r57.
			'_XMMI2Cmpsd' -> 16r58.
			'_XMMI2Comisd' -> 16r59.
			'_XMMI2Cvtdq2ps' -> 16r63.
			'_XMMI2Cvtpd2dq' -> 16r67.
			'_XMMI2Cvtpd2pi' -> 16r5B.
			'_XMMI2Cvtpd2ps' -> 16r61.
			'_XMMI2Cvtps2dq' -> 16r65.
			'_XMMI2Cvtps2pd' -> 16r5F.
			'_XMMI2Cvtsd2si' -> 16r5C.
			'_XMMI2Cvtsd2ss' -> 16r62.
			'_XMMI2Cvtss2sd' -> 16r60.
			'_XMMI2Cvttpd2dq' -> 16r66.
			'_XMMI2Cvttpd2pi' -> 16r5D.
			'_XMMI2Cvttps2dq' -> 16r64.
			'_XMMI2Cvttsd2si' -> 16r5E.
			'_XMMI2Divpd' -> 16r4F.
			'_XMMI2Divsd' -> 16r50.
			'_XMMI2Dppd' -> 16r6D.
			'_XMMI2Haddpd' -> 16r69.
			'_XMMI2Hsubpd' -> 16r6A.
			'_XMMI2Maxpd' -> 16r53.
			'_XMMI2Maxsd' -> 16r54.
			'_XMMI2Minpd' -> 16r55.
			'_XMMI2Minsd' -> 16r56.
			'_XMMI2Mulpd' -> 16r4D.
			'_XMMI2Mulsd' -> 16r4E.
			'_XMMI2Roundpd' -> 16r6B.
			'_XMMI2Roundsd' -> 16r6C.
			'_XMMI2Sqrtpd' -> 16r51.
			'_XMMI2Sqrtsd' -> 16r52.
			'_XMMI2Subpd' -> 16r4B.
			'_XMMI2Subsd' -> 16r4C.
			'_XMMI2UComisd' -> 16r5A.
			'_XMMIAddps' -> 16r2B.
			'_XMMIAddss' -> 16r2C.
			'_XMMIAddsubps' -> 16r43.
			'_XMMICmpps' -> 16r39.
			'_XMMICmpss' -> 16r3A.
			'_XMMIComiss' -> 16r3B.
			'_XMMICvtpi2ps' -> 16r3D.
			'_XMMICvtps2pi' -> 16r3F.
			'_XMMICvtsi2ss' -> 16r3E.
			'_XMMICvtss2si' -> 16r40.
			'_XMMICvttps2pi' -> 16r41.
			'_XMMICvttss2si' -> 16r42.
			'_XMMIDivps' -> 16r31.
			'_XMMIDivss' -> 16r32.
			'_XMMIDpps' -> 16r48.
			'_XMMIHaddps' -> 16r44.
			'_XMMIHsubps' -> 16r45.
			'_XMMIMaxps' -> 16r35.
			'_XMMIMaxss' -> 16r36.
			'_XMMIMinps' -> 16r37.
			'_XMMIMinss' -> 16r38.
			'_XMMIMulps' -> 16r2F.
			'_XMMIMulss' -> 16r30.
			'_XMMIRoundps' -> 16r46.
			'_XMMIRoundss' -> 16r47.
			'_XMMISqrtps' -> 16r33.
			'_XMMISqrtss' -> 16r34.
			'_XMMISubps' -> 16r2D.
			'_XMMISubss' -> 16r2E.
			'_XMMIUComiss' -> 16r3C.
			'ExceptionFlagsMask' -> 16r1F.
			'Inexact' -> 16r1.
			'InvalidOperation' -> 16r10.
			'Overflow' -> 16r4.
			'Underflow' -> 16r2.
			'ZeroDivide' -> 16r8
		}!

OS._FPIEEE_RECORD guid: (Core.GUID fromString: '{87b4c590-026e-11d3-9fd7-00a0cc3e4a32}')!

OS._FPIEEE_RECORD comment: '_FPIEEE_RECORD is an <ExternalStructure> class to represent the Win32 structure of the same name. _FPIEEE_RECORD is used in the reporting of IEEE compliant floating point exceptions.'!

!OS._FPIEEE_RECORD categoriesForClass!External-Data-Structured! !

!OS._FPIEEE_RECORD methodsFor!

cause
	"Answer the <Integer> value of the receiver's 'cause' field."

	^bytes uint32AtOffset: _OffsetOf_cause!

causeDescription
	"Answer the symbolic names of the type of floating point exception the receiver represents."

	| stream |
	stream := String writeStream: 16.
	self printFlags: self cause on: stream.
	^stream contents!

causeNames
	"Answer the symbolic names of the type of floating point exception the receiver represents."

	| stream |
	stream := Array writeStream: 4.
	self exceptionFlags: self cause do: [:each | stream nextPut: each].
	^stream contents!

enabled
	"Answer the <Integer> value of the receiver's 'enabled' field."

	^bytes uint32AtOffset: _OffsetOf_enabled!

exceptionFlags: anInteger do: aMonadicValuable
	(anInteger anyMask: ExceptionFlagsMask)
		ifFalse: 
			["Assume that if no cause bits are set, it must be for a denormal operand exception.
		This is not one of the standard IEEE causes, but can occur on Windows if unmasked."
			aMonadicValuable value: 'Denormal'.
			^self].
	1 to: _FPIEEE_EXCEPTION_FLAGS size
		do: [:i | (anInteger isBitSet: i) ifTrue: [aMonadicValuable value: (_FPIEEE_EXCEPTION_FLAGS at: i)]]!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

isDivide
	"Answer whether a division operation was being attemped when the exception occurred."

	^self operation == _FpCodeDivide!

isOverflow
	"Answer whether this IEEE FP exception record represents a floating point
	underflow error."

	^self cause anyMask: Overflow!

isUnderflow
	"Answer whether this IEEE FP exception record represents a floating point
	underflow error."

	^self cause anyMask: Underflow!

isZeroDivide
	"Answer whether this IEEE FP exception record represents a floating point
	division by zero error."

	"Implementation Note: Division by zero is signalled as either a ZeroDivide
	or, if dividing zero by zero, InvalidOperation.
	When dividing by integer 0, it appears that the value of the second
	operand is not reliably set up, so we assume that any invalid divide
	of zero must be a division by zero."

	^(self cause anyMask: ZeroDivide) or: [self isDivide and: [self operand1 value isZero]]!

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

	^_FP_OPERATION_CODE
		at: self operation + 1
		ifAbsent: '_FpCodeUnspecified'!

precision
	"Answer an <integer> which identifies the precision configured at the time of the exception."

	^(self flags bitShift: -2) bitAnd: 2r111!

precisionName
	"Answer a the symbolic name of the precision setting at the time of the exception."

	^_FPIEEE_PRECISION at: self precision + 1 ifAbsent: 'Unknown'!

printFlags: anInteger on: aStream
	| separator |
	anInteger == 0
		ifTrue: 
			[aStream nextPut: $0.
			^self].
	separator := 
			[separator := '|'.
			''].
	self exceptionFlags: anInteger
		do: 
			[:flag |
			aStream
				nextPutAll: separator value;
				display: flag]!

roundingMode
	"Answer an <integer> which identifies the rounding mode configured at the time of the exception."

	^self flags bitAnd: 2r11!

roundingModeName
	"Answer the symbolic name of the rounding mode configured at the time of the exception."

	^_FPIEEE_ROUNDING_MODE at: self roundingMode + 1 ifAbsent: 'Unknown'! !

!OS._FPIEEE_RECORD categoriesForMethods!
cause!**compiled accessors**!public! !
causeDescription!accessing!public! !
causeNames!accessing!public! !
enabled!**compiled accessors**!public! !
exceptionFlags:do:!helpers!private! !
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
printFlags:on:!helpers!private! !
roundingMode!accessing!public! !
roundingModeName!accessing!public! !
!

!OS._FPIEEE_RECORD class methodsFor!

byteSize
	^__FPIEEE_RECORD_Size!

defineFields
	"Define the fields of the _FPIEEE_RECORD 'structure'. The _FPIEEE_RECORD is a
	rather complex structure containing details of a floating point exception.

		self compileDefinition
	"

	self
		defineField: #flags type: UInt32Field readOnly;
		defineField: #cause type: UInt32Field readOnly;
		defineField: #enabled type: UInt32Field readOnly;
		defineField: #status type: UInt32Field readOnly beUncompiled;
		defineField: #operand1 type: (StructureField type: _FPIEEE_VALUE) beReadOnly;
		defineField: #operand2 type: (StructureField type: _FPIEEE_VALUE) beReadOnly;
		defineField: #result type: (StructureField type: _FPIEEE_VALUE) beFiller!

getFieldNames
	^#(#flags #cause #enabled #status #operand1 #operand2)!

initialize
	self addClassConstant: 'ExceptionFlagsMask'
		value: Inexact | Underflow | Overflow | ZeroDivide | InvalidOperation! !

!OS._FPIEEE_RECORD class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!class initialization!public! !
!


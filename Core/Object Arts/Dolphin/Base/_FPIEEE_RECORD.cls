"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #_FPIEEE_RECORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
_FPIEEE_RECORD guid: (GUID fromString: '{87B4C590-026E-11D3-9FD7-00A0CC3E4A32}')!
_FPIEEE_RECORD comment: '_FPIEEE_RECORD is an <ExternalStructure> class to represent the Win32 structure of the same name. _FPIEEE_RECORD is used in the reporting of IEEE compliant floating point exceptions.'!
!_FPIEEE_RECORD categoriesForClass!External-Data-Structured! !
!_FPIEEE_RECORD methodsFor!

cause
	"Answer the receiver's cause field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cause)!

causeDescription
	"Answer the symbolic names of the type of floating point exception the receiver represents."

	| stream |
	stream := String writeStream.
	self class printFlags: self cause on: stream.
	^stream contents!

causeNames
	"Answer the symbolic names of the type of floating point exception the receiver represents."

	| stream |
	stream := Array writeStream.
	self class exceptionFlags: self cause do: [:each | stream nextPut: each].
	^stream contents!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

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
	division by zero error.
	Implementation Note: Division by zero is signalled as either a ZeroDivide
	or InvalidOperation, the latter cause identifying 0 is divided by 0.
	When dividing by integer 0, it appears that the value of the second
	operand is not reliably set up, so we assume that any invalid divide
	of zero is a division by zero."

	^(self cause isBitSet: 4) or: [self isDivide and: [self operand1 value isZero]]!

operand1
	"Answer the receiver's operand1 field as a Smalltalk object."

	^_FPIEEE_VALUE fromAddress: bytes yourAddress + ##(self offsetOf: #operand1)!

operand2
	"Answer the receiver's operand2 field as a Smalltalk object."

	^_FPIEEE_VALUE fromAddress: bytes yourAddress + ##(self offsetOf: #operand2)!

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

printFieldsOn: aStream limit: anInteger
	self isNull
		ifTrue: 
			[aStream nextPutAll: 'NULL'.
			^self].
	aStream
		display: #roundingMode;
		nextPut: $=;
		print: self roundingModeName;
		space;
		display: #precision;
		nextPut: $=;
		print: self precisionName;
		space;
		display: #operation;
		nextPut: $=;
		print: self operationName;
		space.
	#(#cause #enable #status) do: 
			[:each |
			aStream
				space;
				display: each;
				nextPut: $=.
			self class printFlags: (self getField: each) on: aStream].
	#(#operand1 #operand2) do: 
			[:each |
			| value |
			value := self getField: each.
			value isValid
				ifTrue: 
					[aStream
						space;
						display: each;
						nextPut: $=;
						print: value]]!

roundingMode
	"Answer an <integer> which identifies the rounding mode configured at the time of the exception."

	^self flags bitAnd: 2r11!

roundingModeName
	"Answer the symbolic name of the rounding mode configured at the time of the exception."

	^self class roundingModes at: self roundingMode + 1 ifAbsent: [#Unknown]! !
!_FPIEEE_RECORD categoriesFor: #cause!**compiled accessors**!public! !
!_FPIEEE_RECORD categoriesFor: #causeDescription!accessing!public! !
!_FPIEEE_RECORD categoriesFor: #causeNames!accessing!public! !
!_FPIEEE_RECORD categoriesFor: #flags!**compiled accessors**!public! !
!_FPIEEE_RECORD categoriesFor: #isDivide!public!testing! !
!_FPIEEE_RECORD categoriesFor: #isOverflow!public!testing! !
!_FPIEEE_RECORD categoriesFor: #isUnderflow!public!testing! !
!_FPIEEE_RECORD categoriesFor: #isZeroDivide!public!testing! !
!_FPIEEE_RECORD categoriesFor: #operand1!**compiled accessors**!public! !
!_FPIEEE_RECORD categoriesFor: #operand2!**compiled accessors**!public! !
!_FPIEEE_RECORD categoriesFor: #operation!accessing!public! !
!_FPIEEE_RECORD categoriesFor: #operationName!accessing!public! !
!_FPIEEE_RECORD categoriesFor: #precision!accessing!public! !
!_FPIEEE_RECORD categoriesFor: #precisionName!accessing!public! !
!_FPIEEE_RECORD categoriesFor: #printFieldsOn:limit:!printing!private! !
!_FPIEEE_RECORD categoriesFor: #roundingMode!accessing!public! !
!_FPIEEE_RECORD categoriesFor: #roundingModeName!accessing!public! !

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
	self exceptionFlags inject: 1
		into: 
			[:mask :each |
			(anInteger anyMask: mask) ifTrue: [aMonadicValuable value: each].
			mask << 1]!

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
!_FPIEEE_RECORD class categoriesFor: #defineFields!initializing!public! !
!_FPIEEE_RECORD class categoriesFor: #exceptionFlags!constants!public! !
!_FPIEEE_RECORD class categoriesFor: #exceptionFlags:do:!helpers!private! !
!_FPIEEE_RECORD class categoriesFor: #operationCodes!constants!public! !
!_FPIEEE_RECORD class categoriesFor: #precisionModes!constants!public! !
!_FPIEEE_RECORD class categoriesFor: #printFlags:on:!helpers!private! !
!_FPIEEE_RECORD class categoriesFor: #roundingModes!constants!public! !


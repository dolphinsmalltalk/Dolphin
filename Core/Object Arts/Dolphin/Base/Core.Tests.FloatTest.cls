"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.FloatTest'
	instanceVariableNames: 'fpeMask'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.FloatTest guid: (Core.GUID fromString: '{b2b95b67-e8f3-4991-a4b4-94edc5e83f28}')!
Core.Tests.FloatTest comment: ''!
!Core.Tests.FloatTest categoriesForClass!Unclassified! !
!Core.Tests.FloatTest methodsFor!

assertFloat: result equals: aFloat
	aFloat isNaN ifTrue: [self assert: result isNaN] ifFalse: [self assert: result equals: aFloat]!

assertNegativeZero: aFloat
	self assert: aFloat equals: -0.0.
	self assert: aFloat negative!

continuationValues
	^self infinities , {Float nan}!

finiteSignificand: aNormalFloat
	^(aNormalFloat timesTwoPower: Float.Precision - 1 - (aNormalFloat exponent max: Float.EMin))
		truncated abs!

infinities
	^{Float infinity. Float negativeInfinity}!

normals
	^{0.1.
		0.5.
		Float pi.
		Float pi / 100.
		Float fmax.
		Float fminNormalized.
		Float fmax negated.
		Float fminNormalized negated} , self zeroes
	"Zeroes don't have the implied leading mantissa bit, but they aren't denormals as such"!

predecessor: aFloat
	^self class predecessor: aFloat!

printString: aFloat decimalPlaces: anInteger
	| stream |
	stream := String writeStream.
	aFloat printOn: stream decimalPlaces: anInteger.
	^stream contents!

printString: aFloat significantFigures: anInteger
	| stream |
	stream := String writeStream.
	aFloat printOn: stream significantFigures: anInteger.
	^stream contents!

setUp
	"Ensure the default exception mask is set. Certain tests will temporarily change the exception mask to verify behaviour with/without certain exceptions masked."

	fpeMask := Float exceptionMask: Process.DefaultFpControl.
	Float reset.
	super setUp!

shouldRaiseInvalidOperation: aBlock
	| mask exceptions invalid result status2 result2 |
	Float reset.
	exceptions := OrderedCollection new.
	mask := Float exceptionMask.
	Float exceptionMask: (mask maskClear: OS.CRTConstants._EM_INVALID).
	result := aBlock on: ArithmeticError
				do: 
					[:e |
					exceptions addLast: e.
					e resume].
	invalid := exceptions anySatisfy: 
					[:e |
					"We map InvalidOperation with divide operation and operand2 = 0, to ZeroDivide"
					(e isKindOf: ZeroDivide) or: [e _ieeeRecord causeNames includes: #InvalidOperation]].
	self assert: invalid
		description: 'Test operation did not raise expected FP Invalid Operation exception'.
	self assert: result isNaN.

	"Repeat with all exceptions masked. This is the normal setting in Dolphin now and may cause the CRT functions to use an SSE2 implementation"
	Float exceptionMask: OS.CRTConstants._MCW_EM.
	self assert: Float statusFlags equals: 0.
	"With all FP exceptions masked we expect a NaN continuation value for invalid operations."
	result2 := aBlock value.
	status2 := Float statusFlags.
	self assert: (status2 allMask: OS.CRTConstants._SW_INVALID)
		description: 'Test operation did not notify Invalid Operation with all exceptions masked.'.
	self assert: result2 isNaN!

shouldRaiseOverflow: aBlock
	self shouldRaiseOverflow: aBlock withContinuation: Float infinity!

shouldRaiseOverflow: aBlock withContinuation: aFloat
	| raised result1 status2 result2 |
	raised := false.
	Float exceptionMask: (OS.CRTConstants._MCW_EM maskClear: OS.CRTConstants._EM_OVERFLOW).
	result1 := aBlock
				on: FloatingPointException
				do: 
					[:e |
					e isOverflow ifTrue: [raised := true].
					e resume]
				on: OS.HRESULTError
				do: 
					[:e |
					e hresult asInteger = -2147352566 "DISP_E_OVERFLOW" ifTrue: [raised := true].
					e resume].
	"Repeat the operation with overflow masked to check that overflow condition 'notification'
	is available, and the correct continuation result is returned."
	Float exceptionMask: OS.CRTConstants._MCW_EM.
	result2 := aBlock value.
	status2 := Float statusFlags.
	"Now check the results are as expected"
	self assert: raised
		description: 'Test operation did not raise expected FP overflow exception when unmasked'.
	self assert: result1 equals: aFloat.
	self assert: (status2 allMask: OS.CRTConstants._SW_OVERFLOW)
		description: 'Test operation did not notify FP overflow with overflow masked.'.
	self assert: result2 equals: aFloat!

shouldRaiseUnderflow: aBlock
	| mask raised status1 result1 status2 result2 |
	Float reset.
	raised := false.
	mask := Float exceptionMask.
	Float exceptionMask: (mask maskClear: OS.CRTConstants._EM_UNDERFLOW).
	
	[aBlock on: FloatingPointException do: [:e | e isUnderflow ifTrue: [raised := true]].
	"Repeat the operation with overflow masked to check that overflow condition 'notification'
	is available, and the correct continuation result is returned."
	Float exceptionMask: (mask maskSet: OS.CRTConstants._EM_UNDERFLOW).
	result1 := aBlock value.
	status1 := Float statusFlags.
	"Finally repeat with all exceptions masked (because the CRT functions often behave differently and use an SSE2 implementation)"
	Float exceptionMask: OS.CRTConstants._MCW_EM.
	result2 := aBlock value.
	status2 := Float statusFlags]
			ensure: [Float exceptionMask: mask].
	self assert: raised description: 'Test operation did not raise expected FP underflow exception'.
	self assert: (status1 allMask: OS.CRTConstants._SW_UNDERFLOW)
		description: 'Test operation did not notify FP underflow with underflow masked.'.
	Float denormalized ifTrue: [self assert: result1 isZero] ifFalse: [self assert: result1 isDenormal].
	self assert: (status2 allMask: OS.CRTConstants._SW_UNDERFLOW)
		description: 'Test operation did not notify FP underflow with all exceptions masked.'.
	self assert: result2 isZero!

shouldRaiseZeroDivide: aBlock
	self shouldRaiseZeroDivide: aBlock withContinuation: Float infinity!

shouldRaiseZeroDivide: aBlock status: anInteger withContinuations: anArrayOfFloat
	| result2 mask result exceptions1 exceptions2 pair |
	result := result2 := nil.
	Float reset.
	self assert: (Float statusFlags bitAnd: OS.CRTConstants._SW_INEXACT bitInvert) equals: 0.
	exceptions1 := OrderedCollection new.
	exceptions2 := OrderedCollection new.

	"We will first evaluate with zero divide and invalid operation unmasked to see if we get an FP exception"
	mask := Float exceptionMask: (OS.CRTConstants._MCW_EM
						maskClear: OS.CRTConstants._EM_ZERODIVIDE | OS.CRTConstants._EM_INVALID).
	
	[result := aBlock on: ArithmeticError
				do: 
					[:e |
					exceptions1 addLast: Float statusFlags -> e.
					e resume].
	"Evaluate with everything masked"
	Float exceptionMask: OS.CRTConstants._MCW_EM.
	result2 := [aBlock value] on: ArithmeticError
				do: 
					[:e |
					exceptions2 addLast: Float statusFlags -> e.
					e resume]]
			ensure: 
				["Restore exception mask on entry for the remainder of the test"
				Float exceptionMask: mask].
	self assert: exceptions1 size equals: 1.
	pair := exceptions1 first.
	self assert: (pair value isKindOf: ZeroDivide)
		description: 'Test operation did not raise ZeroDivide'.
	self assert: (pair key anyMask: anInteger)
		description: 'Test operation did not set expected FP status flags with exceptions ZeroDivide/InvalidOperation unmasked.'.
	"Did we get the expected continuation value?"
	self assertFloat: result equals: anArrayOfFloat first.
	"Now check the results when all exceptions were masked"
	self assert: exceptions2 isEmpty.
	"	self assert: (status2 == anInteger or: [status2 anyMask: anInteger])
		description: 'Test operation did not set expected FP status flags with all exceptions masked.'."
	self assertFloat: result2 equals: anArrayOfFloat last!

shouldRaiseZeroDivide: aBlock withContinuation: aFloat
	self shouldRaiseZeroDivide: aBlock withContinuations: {aFloat}!

shouldRaiseZeroDivide: aBlock withContinuations: anArrayOfFloat
	self
		shouldRaiseZeroDivide: aBlock
		status: OS.CRTConstants._SW_ZERODIVIDE | OS.CRTConstants._SW_INVALID
		withContinuations: anArrayOfFloat!

successor: aFloat
	^self class successor: aFloat!

tearDown
	"Be careful not to leave a test FPE mask"

	Float exceptionMask: fpeMask.
	Float reset.
	super tearDown!

testAbs
	self assert: 0.0 abs equals: 0.0.
	self assert: 1.0 abs equals: 1.0.
	self assert: -2.5 abs equals: 2.5.
	self assert: -0.0 abs equals: 0.0.
	self assert: Float fmax negated abs equals: Float fmax.
	self assert: Float fmin negated abs equals: Float fmin.
	self assert: Float.NaN abs isNaN.
	self infinities do: [:each | self assert: each abs equals: Float infinity].
	Float denormalized
		ifTrue: [self assert: (Float fminDenormalized * -1) abs equals: Float fminDenormalized]!

testAdd
	| cases |
	self assert: 1.0 + 1.0 equals: 2.0.
	self assert: 1.0 + 1.5 equals: 2.5.
	self assert: 1.0 + 1 equals: 2.0.
	self assert: 1.0 + (3 / 2) equals: 2.5.
	cases := {Float infinity.
				1.23.
				Float negativeInfinity.
				Float nan.
				Float fmax.
				Float fmin.
				Float fmax * -1}.
	Float denormalized ifTrue: [cases := cases , {Float fminDenormalized}].
	cases do: 
			[:each |
			self assert: (Float nan + each) isNaN.
			self assert: (each + Float nan) isNaN].
	self assert: 0.0 + SmallInteger maximum equals: SmallInteger maximum asFloat.
	self assert: Float fmax + SmallInteger maximum equals: Float fmax!

testArcCos
	self assert: -1 arcCos equals: Float pi.
	self assert: Float fminNormalized arcCos * 2 equals: Float pi.
	Float denormalized ifTrue: [self assert: Float fminDenormalized arcCos * 2 equals: Float pi].
	{-1.1. 1.1. Float fmax} do: [:each | self shouldRaiseInvalidOperation: [each arcCos]].
	self zeroes do: [:each | self assert: each arcCos * 2 equals: Float pi].
	self continuationValues do: [:each | self assert: each arcCos isNaN]!

testArcSin
	self assert: 1 arcSin * 2 equals: Float pi.
	self assert: 0.5 arcSin equals: 0.5235987755982989.
	self assert: -1 arcSin * 2 equals: Float pi negated.
	self assert: -0.5 arcSin equals: -0.5235987755982989.
	self assert: Float fminNormalized arcSin equals: Float fminNormalized.
	Float denormalized
		ifTrue: [self assert: Float fminDenormalized arcSin equals: Float fminDenormalized].
	{-1.1. 1.1. Float fmax} do: [:each | self shouldRaiseInvalidOperation: [each arcSin]].
	self zeroes do: [:each | self assert: each arcSin equals: each].
	self continuationValues do: [:each | self assert: each arcSin isNaN]!

testArcTan
	self assert: 1 arcTan radiansToDegrees equals: 45.
	self assert: -1 arcTan radiansToDegrees equals: -45.
	self assert: 0.41421356237309503 arcTan radiansToDegrees equals: 22.5.
	self assert: 1.6331778728383844e16 arcTan radiansToDegrees equals: 90.
	self infinities do: [:each | self assert: each arcTan radiansToDegrees equals: each sign * 90].
	self assert: Float nan arcTan isNaN.
	self assert: Float fmax arcTan * 2 equals: Float pi.
	self zeroes do: [:each | self assert: each arcTan equals: each].
	self assert: Float fminNormalized arcTan equals: Float fminNormalized.
	Float denormalized
		ifTrue: [self assert: Float fminDenormalized arcTan equals: Float fminDenormalized]!

testArcTan2
	| pi |
	pi := Float pi.
	self assert: (100 arcTan: 100s) equals: pi / 4.
	self assert: (-100 arcTan: 100) equals: pi / -4.
	self assert: (100 arcTan: -100) equals: pi * 3 / 4.
	self assert: (-100 arcTan: -100) equals: pi * -3 / 4.
	self assert: (0 arcTan: 100) equals: 0.
	self assert: (0 arcTan: -100) equals: pi.
	self assert: (100 arcTan: 0.0) equals: pi / 2.
	self assert: (-100 arcTan: 0) equals: pi / -2.
	self assert: (-0.0 arcTan: 100) equals: 0.
	self assert: (-0.0 arcTan: -100) equals: pi * -1.
	self assert: (0 arcTan: 0) equals: 0.
	self assert: (-0.0 arcTan: 0) equals: 0.
	self assert: (0 arcTan: -0.0) equals: pi.
	self assert: (-0.0 arcTan: -0.0) equals: pi negated.
	self assert: (Float nan arcTan: 0) isNaN.
	self infinities do: [:each | self assert: (each arcTan: 0) equals: pi / 2 * each sign].
	self assert: (100 arcTan: Float negativeInfinity) equals: pi.
	self assert: (100 arcTan: Float infinity) isZero.
	self assert: (100 arcTan: Float nan) isNaN!

testAsInteger
	"By the ANSI definition this should be the same as #rounded for a <Float>, not #truncated"

	self assert: 1.5 asInteger equals: 2.
	self assert: (self predecessor: 1.5) asInteger equals: 1.
	self assert: 2.5 asInteger equals: 3.
	self assert: 0.5 asInteger equals: 1.
	self assert: -0.5 asInteger equals: -1.
	self assert: (self successor: -0.5) asInteger equals: 0.
	self assert: Float fmax asInteger
		equals: (Float.MantissaHighBit | Float.MantissaMask bitShift: Float emax - Float precision + 1).
	{0.0. -0.0. Float fminNormalized} do: [:each | self assert: each asInteger equals: 0].
	self continuationValues do: [:each | self should: [each asInteger] raise: ArithmeticError]!

testAsTrueFraction
	self assert: 0.1 asTrueFraction equals: 16rCCCCCCCCCCCCD / 16r80000000000000.
	self assert: 0.5 asTrueFraction equals: 1 / 2.
	self assert: Float fmax asTrueFraction
		equals: 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.
	self assert: Float fmax negated asTrueFraction
		equals: -179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.
	self continuationValues do: [:each | self should: [each asTrueFraction] raise: ArithmeticError]!

testCeiling
	self assert: 1.0 ceiling equals: 1.
	self assert: 1.1 ceiling equals: 2.
	self assert: -2.0 ceiling equals: -2.
	self assert: -2.1 ceiling equals: -2.
	self assert: -0.0 ceiling equals: 0.
	self assert: -0.1 ceiling equals: 0.
	self assert: 0.0 ceiling equals: 0.
	self assert: 0.1 ceiling equals: 1.
	self assert: Float fminNormalized ceiling equals: 1.
	self assert: Float fminNormalized negated ceiling equals: 0.
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized ceiling equals: 1.
			self assert: Float fminDenormalized negated ceiling equals: 0].
	{SmallInteger maximum. SmallInteger minimum. SmallInteger maximum + 1. 2 ** 63 - 1024}
		do: [:each | self assert: each asFloat ceiling equals: each].
	self assert: Float fmax ceiling equals: Float fmax asInteger.
	self assert: Float fmax negated ceiling equals: Float fmax negated asInteger.
	self continuationValues do: [:each | self should: [each ceiling] raise: ArithmeticError]!

testCopy
	self assert: Float nan copy isNaN.
	{-0.0.
		0.0.
		Float infinity.
		Float negativeInfinity.
		Float fmax.
		Float fminDenormalized.
		Float fminNormalized} do: [:each | self assert: each copy equals: each]!

testCos
	| sixty |
	sixty := Float pi / 3.
	self assert: Float pi cos equals: -1.0.
	self assert: 0.0 cos equals: 1.0.
	self assert: -0.0 cos equals: 1.0.
	"Note that the result is not precise"
	self assert: (sixty cos roundTo: Float.SignificantDifference) equals: 0.5.
	self assert: (sixty cos * -1 roundTo: Float.SignificantDifference) equals: -0.5.
	self infinities do: [:each | self shouldRaiseInvalidOperation: [each cos]].
	self assert: Float nan cos isNaN!

testDenormalsAsTrueFraction
	"check if gradual underflow is correctly handled"

	| fminDenorm |
	self skipUnless: [Float denormalized].
	self assert: 1.0e-316 asTrueFraction asFloat equals: 1.0e-316.
	fminDenorm := Float fminDenormalized asTrueFraction.
	self assert: fminDenorm equals: 1 / (1 << 1074).
	self assert: fminDenorm equals: (1 << (Float precision - Float emin - 1)) reciprocal.
	self assert: fminDenorm asFloat equals: Float fminDenormalized!

testDivideByZero
	| cases |
	cases := self normals reject: [:each | each isZero].
	Float denormalized ifTrue: [cases := cases copyWith: Float fminDenormalized].
	cases do: 
			[:each |
			| continuation |
			continuation := each negative ifTrue: [Float negativeInfinity] ifFalse: [Float infinity].
			self shouldRaiseZeroDivide: [each / 0.0] withContinuation: continuation.
			self shouldRaiseZeroDivide: [each / -0.0] withContinuation: continuation negated.
			self shouldRaiseZeroDivide: [each / 0] withContinuation: continuation].
	"Note that division of zero by zero is handled differently by the CPU (by design, judging from the docs). It is reported as an InvalidOperation rather than Divide-by-Zero. We translate this oddity to a ZeroDivide exception when the fp exception is reported (which only occurs if Invalid is unmasked), but when exceptions are masked the continuation value for an invalid operation will be a NaN, not an infinity value."
	self zeroes do: 
			[:each |
			| continuation |
			continuation := each negative ifTrue: [Float negativeInfinity] ifFalse: [Float infinity].
			self shouldRaiseZeroDivide: [each / 0.0] withContinuations: {continuation. Float nan}.
			self shouldRaiseZeroDivide: [each / -0.0] withContinuations: {continuation negated. Float nan}.
			self shouldRaiseZeroDivide: [each / 0] withContinuations: {continuation. Float nan}].
	self shouldRaiseZeroDivide: [1 / 0.0].
	self shouldRaiseZeroDivide: [1 / -0.0] withContinuation: Float negativeInfinity.

	"The CPU behave differently for infinities with SSE2 instructions and doesn't raise zero divide OR set the expected flags when exceptions are masked."
	self infinities do: 
			[:each |
			self assert: each / 0.0
				equals: (each negative ifTrue: [Float negativeInfinity] ifFalse: [Float infinity]).
			self assert: each / -0.0
				equals: (each negative ifTrue: [Float infinity] ifFalse: [Float negativeInfinity])].
	self assert: (Float nan / 0.0) isNaN.
	self assert: (Float nan / -0.0) isNaN!

testEqualsColon
	self assert: (0.0 equals: 0.0000000001).
	self assert: (0.0 equals: -0.0000000001).
	self assert: (0.0000000001 equals: 0.0).
	self assert: (-0.0000000001 equals: 0.0).
	self assert: (0.0 equals: 0.0000000009).
	self assert: (0.0 equals: 0.000000009) not.
	self assert: (Float fmin equals: 0.0).
	self assert: (0.0 equals: Float fmin).
	self assert: (Float fmin * 2 equals: Float fmin).
	self assert: (Float fmin * 2 equals: 1e-10).
	self assert: (Float fmin * 2 equals: 1e-8) not.
	self assert: (1.123456789e308 equals: 1.1234567891e308).
	self assert: (1.1234567891e308 equals: 1.123456789e308).
	self assert: (1.123456788e308 equals: 1.123456789e308).
	self assert: (1.12345678e308 equals: 1.12345679e308) not.
	self assert: (1.123456789e20 equals: 1.1234567899e20).
	self assert: (1.123456799e20 equals: 1.123456789e20) not.
	self deny: (Float nan equals: 1.0).
	self deny: (Float nan equals: Float nan)!

testEqualsZero
	self assert: 0.0 equals: 0.
	self assert: -0.0 equals: 0.
	{Float pi. Float fminNormalized. Float fmax. Float infinity. Float nan} , (Float denormalized
				ifTrue: [{self predecessor: Float fminNormalized. Float fminDenormalized}]
				ifFalse: [#()])
		do: 
			[:each |
			self deny: each equals: 0.
			self deny: each negated equals: 0]!

testExp
	| e pi |
	e := 2.718281828459045.
	pi := Float pi.
	self assert: 1.0 exp equals: e.
	self assert: 1.1447298858494002 exp equals: pi.
	self assert: Float infinity exp equals: Float infinity.
	self assert: Float negativeInfinity exp equals: 0.0.
	self assert: Float fmax exp equals: Float infinity.
	self assert: Float fmax negated exp equals: 0.0.
	self assert: Float nan exp isNaN.
	self assert: 10000 exp equals: Float infinity.
	self zeroes do: [:each | self assert: each exp equals: 1.0]!

testExponent
	self assert: 0.0 exponent equals: 0.
	self assert: -0.0 exponent equals: 0.
	self assert: 1.0 exponent equals: 0.
	self assert: 2.0 exponent equals: 1.
	self assert: -2.0 exponent equals: 1.
	self assert: (self predecessor: 4.0) exponent equals: 1.
	self assert: 4.0 exponent equals: 2.
	self assert: -4.0 exponent equals: 2.
	self assert: 0.5 exponent equals: -1.
	self assert: -0.5 exponent equals: -1.
	self assert: 0.25 exponent equals: -2.
	self assert: -0.25 exponent equals: -2.
	self assert: Float fmax exponent equals: Float emax.
	self assert: Float fminNormalized exponent equals: Float emin.
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized exponent equals: Float.EMinDenormalized.
			self assert: Float fminDenormalized negated exponent equals: Float.EMinDenormalized].
	"Not useful enquiries, but reveals the underlying representation"
	{Float nan. Float infinity. Float negativeInfinity}
		do: [:each | self assert: each exponent equals: -1]!

testFloatCharacterization
	self assert: Float radix equals: 2.
	self assert: Float precision equals: 53.

	"Test the relative precision"
	self assert: Float one + Float epsilon > Float one.
	self assert: Float one + Float epsilon equals: (self successor: Float one).
	self assert: Float one + (Float epsilon / Float radix) equals: Float one.
	"Check expressions from ANSI standard - note comparison against integer/fractional result"
	self assert: Float epsilon equals: (Float radix raisedTo: 1 - Float precision).
	self assert: Float one + Float epsilon > Float one.
	self assert: Float one + (Float epsilon / Float radix) equals: Float one.
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized equals: (Float radix raisedTo: Float emin - Float precision + 1).
			self assert: Float fminDenormalized equals: Float epsilon * (Float radix raisedTo: Float emin)].
	self assert: Float fminNormalized equals: (Float radix raisedTo: Float emin) asFloat.
	self assert: Float fmax asInteger
		equals: (1 - (Float radix raisedTo: Float precision negated))
				* (Float radix raisedTo: Float emax + 1).
	self assert: (Float radix - Float epsilon) * (Float radix raisedTo: Float emax) equals: Float fmax.
	self assert: Float fmax exponent equals: Float emax.
	self assert: Float fminNormalized exponent equals: Float emin.
	Float denormalized
		ifTrue: [self assert: Float fminDenormalized exponent equals: Float emin + 1 - Float precision].

	"IEEE 754 64-bit double precision invariants"
	"Maximum normalized value has an exponent of 16r7FE>>1 (1023), and mantissa of (1<<52)-1"
	self assert: (Float fmax qwordAtOffset: 0) equals: 16r7FEFFFFFFFFFFFFF.
	"Min denormalized value has just lsb of mantissa set"
	Float denormalized ifTrue: [self assert: (Float fminDenormalized qwordAtOffset: 0) equals: 1].
	self assert: (Float fminNormalized qwordAtOffset: 0) equals: 16r0010000000000000.
	"0 is, unsurprisingly, all zeroes."
	self assert: (0.0 qwordAtOffset: 0) equals: 0.
	"-0.0, same as 0.0 with sign bit set"
	self assert: (Float negativeZero qwordAtOffset: 0) equals: 16r8000000000000000.
	self assert: (Float one qwordAtOffset: 0) equals: 16r3FF0000000000000.
	self assert: (Float infinity qwordAtOffset: 0) equals: 16r7FF0000000000000.
	"-Infinity is the same as Infinity, but with the sign bit set."
	self assert: (Float negativeInfinity qwordAtOffset: 0) equals: 16rFFF0000000000000!

testFloor
	self assert: 1.0 floor equals: 1.
	self assert: 1.1 floor equals: 1.
	self assert: -2.0 floor equals: -2.
	self assert: -2.1 floor equals: -3.
	self assert: -0.0 floor equals: 0.
	self assert: -0.1 floor equals: -1.
	self assert: 0.0 floor equals: 0.
	self assert: 0.1 floor equals: 0.
	self assert: Float fminNormalized floor equals: 0.
	self assert: Float fminNormalized negated floor equals: -1.
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized floor equals: 0.
			self assert: Float fminDenormalized negated floor equals: -1].
	{SmallInteger maximum. SmallInteger minimum. 2 ** 63 - 1024}
		do: [:each | self assert: each asFloat floor equals: each].
	self assert: Float fmax floor equals: Float fmax asInteger.
	self assert: Float fmax negated floor equals: Float fmax negated asInteger.
	self continuationValues do: [:each | self should: [each floor] raise: ArithmeticError]!

testFloorLog2
	| aBitLess aBitMore |
	aBitMore := 1 + Float epsilon.
	aBitLess := 1 - Float epsilon.
	Float emin + 1 to: Float emax - 1
		do: 
			[:exp |
			| exactPowerOfTwo |
			exactPowerOfTwo := 1.0 timesTwoPower: exp.
			self assert: (exactPowerOfTwo floorLog: 2) equals: exp.
			self assert: (exactPowerOfTwo * aBitMore floorLog: 2) equals: exp.
			self assert: (exactPowerOfTwo * aBitLess floorLog: 2) equals: exp - 1]!

testFractionAsFloat
	| random fraction err cases highbit |
	highbit := 1 << (Float precision - 1).
	self assert: (highbit + 0 + (1 / 4)) asFloat asTrueFraction equals: highbit + 0.
	self assert: (highbit + 0 + (1 / 2)) asFloat asTrueFraction equals: highbit + 0.
	self assert: (highbit + 0 + (3 / 4)) asFloat asTrueFraction equals: highbit + 1.
	self assert: (highbit + 1 + (1 / 4)) asFloat asTrueFraction equals: highbit + 1.
	self assert: (highbit + 1 + (1 / 2)) asFloat asTrueFraction equals: highbit + 2.
	self assert: (highbit + 1 + (3 / 4)) asFloat asTrueFraction equals: highbit + 2.

	"use a random test to be sure that fractions are rounded to nearest float"
	random := RandomLinearCongruential
				newModulus: (2 raisedTo: 54)
				multiplier: (2 raisedTo: 53) - (2 raisedTo: 47) - (2 raisedTo: 33) - 1
				increment: 1234567.
	random seed: 1234567.
	1000 timesRepeat: 
			[fraction := ((random
						next;
						seed) * (random
									next;
									seed) + 1)
						/ ((random
								next;
								seed) * (random
											next;
											seed) + 1).
			err := (fraction - fraction asFloat asTrueFraction) * fraction reciprocal
						* (1 bitShift: Float precision - 1).
			self assert: err < (1 / 2)].
	cases := #(16r010000000000000 16r01FFFFFFFFFFFFF 1 2 16r020000000000000 16r0020000000000001 16r3FFFFFFFFFFFFF 16r3FFFFFFFFFFFFE 16r3FFFFFFFFFFFFD).
	cases do: 
			[:numerator |
			cases do: 
					[:denominator |
					fraction := Fraction numerator: numerator denominator: denominator.
					err := (fraction - fraction asFloat asTrueFraction) * fraction reciprocal
								* (1 bitShift: Float precision - 1).
					self assert: err <= (1 / 2)]].
	self
		assert: ((4941354647941236926152115130903637082561047305201416295417964660936672448910241499199436867464432378497521953013385156994196064073355718205444063842406844645633777822001794087786934643288359176347668049138450287177670914977920820153695869859050205437477052264104760638348351154610327758358316855246056228125726457933011243259488904319976931378470626978044536189271422830698827951298790996380571297736272436985642542223705097895166027
				/ 7128865274665093053166384155714272920668358861885893040452001991154324087581111499476444151913871586911717817019575256512980264067621009251465871004305131072686268143200196609974862745937188343705015434452523739745298963145674982128236956232823794011068809262317708861979540791247754558049326475737829923352751796735248042463638051137034331214781746850878453485678021888075373249921995672056932029099390891687487672697950931603520000)
					asFloat equals: 0.69314743055982).
	Float denormalized
		ifTrue: 
			[self assert: (2 raisedTo: Float emin - (Float precision - 1)) asFloat equals: Float fminDenormalized.
			self assert: (2 raisedTo: Float emin - Float precision) asFloat equals: 0.0.
			self assertNegativeZero: (2 raisedTo: Float emin - Float precision) negated asFloat]!

testFractionComparisons
	"Fractions should not be equal to Floats, unless a Float can exactly exact representat the Fraction"

	{1 / 10. 1 / 3. 3 / 5} do: 
			[:each |
			| float |
			float := each asFloat.
			self deny: float equals: each.
			self deny: each equals: float].
	{1 / 2. 3 / 4} do: 
			[:each |
			self assert: each equals: each asFloat.
			self assert: each hash equals: each asFloat hash].
	"This will overflow on conversion to a Fraction, just a kick the tyres test really"
	self assert: ((200 factorial - 1) / 2) hash isKindOf: SmallInteger!

testFractionPart
	self assert: 1.25 fractionPart equals: 0.25.
	self assert: -2.625 fractionPart equals: -0.625.
	"All fraction; sign of resuilt must be same as receiver"
	{0.5. -0.25. 0.0. -0.0. 2.125e-16. Float fminNormalized. Float fminNormalized negated} do: 
			[:each |
			| actual |
			actual := each fractionPart.
			self assert: actual equals: each.
			self assert: actual sign equals: each sign].
	Float denormalized
		ifTrue: 
			[{self predecessor: Float fminNormalized. Float fminDenormalized. Float fminDenormalized negated}
				do: [:each | self assert: each fractionPart equals: each]].

	"No fraction and infinity cases"
	{1.0. -2.0. 2.125e16. Float fmax. Float fmax negated. Float infinity. Float negativeInfinity} do: 
			[:each |
			| actual |
			actual := each fractionPart.
			self assert: actual equals: 0.0.
			"If negative, should get -0.0, not 0.0"
			self assert: actual negative equals: each negative].
	"NaN"
	self assert: Float nan fractionPart isNaN!

testGreaterThanInteger
	| notGreaterThanZero |
	notGreaterThanZero := {Float negativeInfinity.
				Float nan.
				Float fmax negated.
				Float fminDenormalized negated.
				Float fminNormalized negated.
				0.0.
				-0.0}.
	notGreaterThanZero do: [:each | self deny: each > 0].
	self deny: 1.9 > 2.
	self assert: 2.1 > 2.
	{-1. 1. 2. 2 ** 53. 2 ** 53 + 1. 2 ** 53 + 2} do: [:each | self deny: each asFloat > each].
	self deny: Float nan > 2.
	"Imprecise"
	self deny: (2 ** 53 + 1) asFloat > (2 ** 53)!

testHash
	| subject1 subject2 hashes hash1 hash2 |
	{SmallInteger minimum. 0. 1. SmallInteger maximum. SmallInteger maximum + 1. 20 factorial. 1 / 2}
		do: 
			[:each |
			| subject hash |
			subject := each asFloat.
			self assert: subject equals: each.
			hash := subject hash.
			self assert: hash isKindOf: SmallInteger.
			self assert: hash equals: each hash].
	self assert: 0.0 hash equals: 0.
	self assert: -0.0 hash equals: 0.
	self assert: Float fminNormalized hash equals: 4096.
	Float denormalized ifTrue: [self assert: Float fminDenormalized hash equals: 0].
	self assert: Float infinity hash equals: 61440.
	self assert: Float nan hash equals: 63488.
	hashes := Set new.
	1 to: 16
		do: 
			[:each |
			| subject hash |
			subject := 2.0 raisedTo: each negated.
			hash := subject hash.
			self assert: hash isKindOf: SmallInteger.
			self deny: (hashes includes: hash).
			hashes add: hash].
	"A value with largest possible significand"
	subject1 := ((1 << Float precision) - 1) asFloat timesTwoPower: -1.
	self deny: subject1 fractionPart isZero.
	hash1 := subject1 hash.
	self assert: hash1 isKindOf: SmallInteger.
	subject2 := subject1 / 2.
	hash2 := subject2 hash.
	self assert: hash2 isKindOf: SmallInteger.
	self deny: hash2 equals: hash1!

testInfinityComparisons
	"∞ = ∞, and -∞ = -∞, but neither should be equal to any other value.
	Excepting ∞ itself and NaN, all values are < ∞.
	Including ∞ itself and NaN, all values are <= ∞.
	Excepting -∞ itself and NaN, all values are > -∞.
	Including -∞ itself and NaN, all values are >= ∞."

	self normals , (Float denormalized ifTrue: [{Float fminDenormalized}] ifFalse: [#()]) do: 
			[:each |
			self assert: each < Float.Infinity.
			self assert: each <= Float.Infinity.
			self assert: Float.Infinity > each.
			self assert: Float.Infinity >= each.
			self deny: each equals: Float.Infinity.
			self assert: each > Float.NegativeInfinity.
			self assert: each >= Float.NegativeInfinity.
			self assert: Float.NegativeInfinity < each.
			self assert: Float.NegativeInfinity <= each].
	self assert: Float.Infinity equals: Float.Infinity.
	self assert: Float.Infinity > Float.NegativeInfinity.
	self assert: Float.Infinity >= Float.NegativeInfinity.
	self assert: Float.NegativeInfinity equals: Float.NegativeInfinity.
	self assert: Float.NegativeInfinity < Float.Infinity.
	self assert: Float.NegativeInfinity <= Float.Infinity.
	"These don't work currently - bug in the primitive"
	self assert: Float.Infinity <= Float.Infinity.
	self assert: Float.Infinity >= Float.Infinity.
	self assert: Float.NegativeInfinity <= Float.NegativeInfinity.
	self assert: Float.NegativeInfinity >= Float.NegativeInfinity.
	{Float.Infinity. Float.NegativeInfinity} do: 
			[:each |
			self deny: Float.NaN <= each.
			self deny: Float.NaN < each.
			self deny: Float.NaN > each.
			self deny: Float.NaN >= each.
			self deny: each <= Float.NaN.
			self deny: each < Float.NaN.
			self deny: each > Float.NaN.
			self deny: each >= Float.NaN]!

testIntegerAsFloat
	"assert IEEE 754 round to nearest even mode is honoured"

	self deny: 16r1FFFFFFFFFFFF0801 asFloat equals: 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 65 bits"
	self deny: 16r1FFFFFFFFFFFF0802 asFloat equals: 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 64 bits"
	self assert: 16r1FFFFFFFFFFF1F800 asFloat equals: 16r1FFFFFFFFFFF20000 asFloat.	"nearest even is upper"
	self assert: 16r1FFFFFFFFFFFF0800 asFloat equals: 16r1FFFFFFFFFFFF0000 asFloat	"nearest even is lower"!

testIntegerComparisons
	{-16rFFFFFFFF.
		-16r40000001.
		-16r40000000.
		-1.
		0.
		1.
		16r3FFFFFFF.
		16r3FFFFFFF.
		16r40000000.
		16r7FFFFFFF.
		16rFFFFFFFF.
		2 ** Float precision - 1.
		2 ** Float precision.
		2 ** 63.
		2 ** 64.
		-16r4000000000000000.
		16r100000000000010.
		-1 * (2 ** 64)} do: 
				[:each |
				self assert: each asFloat equals: each.
				self assert: each hash isKindOf: SmallInteger.
				self assert: each asFloat hash equals: each hash]
	"Some larger integers will be equal, if they can be represented without loss of precision"!

testIntegerComparisonsImprecise
	"Regression test for #772"

	"self skipUnless: [self isAtLeastVmVersion: #(2016 7 1 7)]."

	{2 ** Float precision + 1.
		(2 ** Float precision) negated - 1.
		16r100000000000004.
		16r100000000000005.
		-16r4000000000000001.
		2 ** Float precision + 1.
		2 ** 63 - 1} do: 
				[:each |
				| subject trunc |
				subject := each asFloat.
				trunc := subject asInteger.
				"Not a valid test case if this fails"
				self deny: trunc equals: each.
				self deny: subject equals: each]!

testIntegerPart
	self assert: 1.25 integerPart equals: 1.0.
	"All fraction; sign of result must be same as sign of receiver"
	{0.5. -0.25. 0.0. -0.0. 2.125e-16. Float fminNormalized. Float fminNormalized negated} do: 
			[:each |
			| actual |
			actual := each integerPart.
			self assert: actual equals: 0.0.
			self assert: actual negative equals: each negative].
	Float denormalized
		ifTrue: 
			[{self predecessor: Float fminNormalized.
				self successor: Float fminNormalized negated.
				Float fminDenormalized.
				Float fminDenormalized negated} do: 
						[:each |
						| actual |
						actual := each integerPart.
						self assert: actual equals: 0.0.
						self assert: actual negative equals: each negative].
			self assert: Float fminDenormalized negated integerPart equals: -0.0].

	"No fraction and infinity cases"
	{1.0. -2.0. 2.125e16. Float fmax. Float fmax negated. Float infinity. Float negativeInfinity}
		do: [:each | self assert: each integerPart equals: each].
	"NaN"
	self assert: Float nan integerPart isNaN!

testIsFinite
	self deny: Float negativeInfinity isFinite.
	self deny: Float infinity isFinite.
	self deny: Float nan isFinite.
	self normals do: [:each | self assert: each isFinite].
	Float denormalized
		ifTrue: 
			[{self predecessor: Float fminNormalized. Float fminDenormalized} do: 
					[:each |
					self assert: each isFinite.
					self assert: each negated isFinite]]!

testIsInfinite
	self assert: Float negativeInfinity isInfinite.
	self assert: Float infinity isInfinite.
	self deny: Float nan isInfinite.
	self normals do: [:each | self deny: each isInfinite].
	Float denormalized
		ifTrue: 
			[self deny: (self predecessor: Float fminNormalized) isInfinite.
			self deny: (self successor: Float fminNormalized negated) isInfinite.
			self deny: Float fminDenormalized isInfinite.
			self deny: Float fminDenormalized negated isInfinite]!

testIsLiteral
	"All values apart from the exception values for infinity and Not-a-Number have literal representations."

	self normals do: [:each | self assert: each isLiteral].
	Float denormalized ifTrue: [self assert: Float fminDenormalized isLiteral].
	self deny: Float nan isLiteral.
	self deny: Float infinity isLiteral.
	self deny: Float negativeInfinity isLiteral!

testIsNan
	self deny: Float negativeInfinity isNaN.
	self deny: Float infinity isNaN.
	self assert: Float nan isNaN.
	self normals do: [:each | self deny: each isNaN]!

testIsSelfEvaluating
	"All values apart from the exception values for infinity and Not-a-Number have literal representations."

	self normals do: [:each | self assert: each isSelfEvaluating].
	Float denormalized ifTrue: [self assert: Float fminDenormalized isSelfEvaluating].
	self deny: Float nan isSelfEvaluating.
	self deny: Float infinity isSelfEvaluating.
	self deny: Float negativeInfinity isSelfEvaluating!

testIsZero
	self assert: 0.0 isZero.
	self assert: -0.0 isZero.
	{Float pi. Float fminNormalized. Float fmax. Float infinity. Float nan} , (Float denormalized
				ifTrue: [{self predecessor: Float fminNormalized. Float fminDenormalized}]
				ifFalse: [#()])
		do: 
			[:each |
			self deny: each isZero.
			self deny: each negated isZero]!

testLessThanFraction
	"Floats cannot represent even some simple fractions, such as 10ths, precisely, so comparison do not necessarily do what you would intuitively expect.
	This is deliberate - the comparisons are precise, and Floats cannot precisely represent values that are not rational binary fractions such as 1/2, 1/4, etc.
	To see the actual value of any <Float> expressed as a precise rational number send it #asTrueFraction."

	self deny: 0.1 < (1 / 10).
	self assert: 0.3 < (3 / 10).
	self deny: 0.5 < (1 / 2)!

testLessThanInteger
	self assert: 1.1 < 2.
	self deny: 1.1 < 1.
	{SmallInteger minimum.
		0.
		1.
		SmallInteger maximum.
		SmallInteger minimum - 1.
		SmallInteger maximum + 1.
		16r7FFFFFFF.
		16r80000000.
		16rFFFFFFFF.
		16r7FFFFFFFFFFFFFFF.
		16r8000000000000000.
		16rFFFFFFFFFFFFFFFF} do: 
				[:each |
				self deny: Float fmax < each.
				self deny: Float nan < each.
				self assert: Float negativeInfinity < each.
				self deny: Float infinity < each].
	"Some precisely representable integer values."
	{-1. 0. 1. 2. 2 ** 53. 2 ** 53 + 2} do: [:each | self deny: each asFloat < each].
	self assert: (2 ** 53) asFloat < (2 ** 53 + 1).
	"Some cases that cannot be represented precisely as Floats, and so the approximate value may be smaller or greater than the integer value it was created from"
	{2 ** 53 + 1} do: [:each | self assert: each asFloat < each]!

testLn
	self assert: Float e ln equals: 1.0.
	self assert: Float fmax ln equals: 709.782712893384.
	self assert: Float fminNormalized ln equals: -708.3964185322641.
	self assert: Float infinity ln equals: Float infinity.
	self zeroes
		do: [:each | self shouldRaiseZeroDivide: [each ln] withContinuation: Float negativeInfinity].
	{-1.0. Float negativeInfinity}
		do: [:each | self shouldRaiseZeroDivide: [each ln] withContinuation: Float nan].
	self assert: Float nan ln isNaN!

testLog
	self assert: (10.0 raisedTo: 2.0) log equals: 2.0.
	self assert: 1000.0 log truncated equals: 3.
	self assert: Float infinity log equals: Float infinity.
	self zeroes
		do: [:each | self shouldRaiseZeroDivide: [each log] withContinuation: Float negativeInfinity].
	{-10.0. Float negativeInfinity}
		do: [:each | self shouldRaiseZeroDivide: [each log] withContinuation: Float nan].
	self assert: Float nan log isNaN!

testNaNComparisons
	| comparisons subject comparand |
	comparisons := #(#< #<= #> #>= #=).
	subject := Float nan.
	comparand := self normals
				, {0. 1. 2.3. Float infinity. Float nan copy. 2 / 3. 1.25s2. 2 raisedTo: 50}.
	Float denormalized ifTrue: [comparand := comparand copyWith: Float fminDenormalized].
	comparand := comparand , (comparand collect: [:e | e negated]).
	comparand := comparand , {0 @ 0. -1 @ -1 @ -1}.
	comparand do: 
			[:comp2 |
			comparisons do: 
					[:op2 |
					self deny: (subject perform: op2 with: comp2)
						description: ['NaN should not be <1s> <2p>' expandMacrosWith: op2 with: comp2].
					self deny: (comp2 perform: op2 with: subject)
						description: ['<2p> should not be <1s> a NaN' expandMacrosWith: op2 with: comp2]].
			self assert: subject ~= comp2 description: 'NaNs should always be unequal to any value'.
			self assert: comp2 ~= subject description: 'Another value should always be unequal to a NaN']!

testNegated
	self assert: -1.5 negated equals: 1.5.
	self assert: 1.5 negated equals: -1.5.
	self assertNegativeZero: 0.0 negated.
	self assert: -0.0 negated equals: 0.0.
	self assert: Float fmax negated equals: Float fmax * -1.
	self assert: Float fmin negated equals: Float fmin * -1.
	self assert: Float nan negated isNaN.
	self assert: Float infinity negated equals: Float negativeInfinity.
	self assert: Float negativeInfinity negated equals: Float infinity.
	Float denormalized
		ifTrue: [self assert: Float fminDenormalized negated equals: Float fminDenormalized * -1]!

testNegative
	| negativeCases positiveCases |
	negativeCases := {Float fminDenormalized negated.
				Float fminNormalized negated.
				-1.0.
				-0.0.
				Float fmax negated.
				Float negativeInfinity}.
	positiveCases := {Float fminDenormalized.
				Float fminNormalized.
				Float infinity.
				1.0.
				0.0.
				Float fmax.
				Float nan}.
	Float denormalized
		ifTrue: 
			[negativeCases := negativeCases copyWith: Float fminDenormalized negated.
			positiveCases := positiveCases copyWith: Float fminDenormalized].
	negativeCases
		do: [:each | self assert: each negative description: each printString , ' is negative'].
	positiveCases
		do: [:each | self deny: each negative description: each printString , ' is not negative']!

testOverflow
	self shouldRaiseOverflow: [Float fmax * 2].
	self shouldRaiseOverflow: [Float fmax * -2] withContinuation: Float negativeInfinity.
	self shouldRaiseOverflow: [Float fmax * 2.0].
	self shouldRaiseOverflow: [Float fmax * -2.0] withContinuation: Float negativeInfinity.
	self shouldRaiseOverflow: [Float fmax * SmallInteger maximum].
	self shouldRaiseOverflow: [Float fmax * SmallInteger minimum]
		withContinuation: Float negativeInfinity.
	self shouldRaiseOverflow: [Float fmax + Float fmax].
	self shouldRaiseOverflow: [Float fmax / Float fmin].
	self shouldRaiseOverflow: [Float fmax * -1 - Float fmax] withContinuation: Float negativeInfinity!

testPredecessorSuccessor
	self assert: (self successor: (self predecessor: Float one)) equals: Float one.
	self assert: (self predecessor: (self successor: Float one)) equals: Float one.
	self assert: (self successor: (self predecessor: Float one negated)) equals: Float one negated.
	self assert: (self predecessor: (self successor: Float one negated)) equals: Float one negated.
	self assert: (self successor: Float fmax) equals: Float infinity.
	self assert: (self predecessor: Float fmax negated) equals: Float negativeInfinity.
	self assert: (self successor: Float infinity) equals: Float infinity.
	self assert: (self successor: Float negativeInfinity) equals: Float fmax negated.
	self assert: (self predecessor: Float negativeInfinity) equals: Float infinity negated.
	self assert: (self predecessor: Float infinity) equals: Float fmax.
	self assert: (self predecessor: Float nan) isNaN.
	self assert: (self successor: Float nan) isNaN.
	Float denormalized
		ifTrue: 
			[self assert: (self successor: 0.0) equals: Float fmin.
			self assert: (self predecessor: 0.0) equals: Float fmin negated.
			self assert: (self predecessor: Float fmin) equals: 0.0.
			self assert: (self successor: Float fmin negated) equals: 0.0]!

testPrintOnDecimalPlaces
	self assert: (self printString: 3.999 decimalPlaces: 4) equals: '3.9990'.
	self assert: (self printString: 3.999 decimalPlaces: 3) equals: '3.999'.
	self assert: (self printString: 3.999 decimalPlaces: 2) equals: '4.00'.
	self assert: (self printString: 3.999 decimalPlaces: 1) equals: '4.0'.
	self assert: (self printString: 3.999 decimalPlaces: 0) equals: '4'.
	self assert: (self printString: -0.001 decimalPlaces: 2) equals: '-0.00'.
	self assert: (self printString: 0.001 decimalPlaces: 2) equals: '0.00'.
	self assert: (self printString: Float pi decimalPlaces: 15) equals: '3.141592653589793'.
	self assert: (self printString: Float pi decimalPlaces: 3) equals: '3.142'.
	"Number at the extremes of precision, but which have exact representations"
	self assert: (self printString: 1.25e22 decimalPlaces: 2) equals: '12500000000000000000000.00'.
	self assert: (self printString: 5000000000000001.0 decimalPlaces: 5)
		equals: '5000000000000001.00000'.
	self assert: (self printString: 50000000000001.25 decimalPlaces: 2) equals: '50000000000001.25'.
	"A large number close to fmax"
	self assert: (self printString: 1.0e306 decimalPlaces: 3)
		equals: (String writeStream
				nextPut: $1;
				next: 306 put: $0;
				nextPutAll: '.000';
				contents)!

testPrintOnDecimalPlacesFmax
	| fmax |
	fmax := String writeStream
				nextPutAll: '17976931348623157';
				next: 308 - 16 put: $0;
				nextPutAll: '.00000';
				contents.
	self assert: (self printString: Float fmax decimalPlaces: 5) equals: fmax.
	self assert: (self printString: Float fmax negated decimalPlaces: 5) equals: '-' , fmax!

testPrintOnDecimalPlacesFmin
	| fmax fmin |
	fmin := String writeStream
				nextPutAll: '0.';
				next: 308 - 1 put: $0;
				nextPutAll: '22250738585072014';
				contents.
	self assert: (self printString: Float fminNormalized decimalPlaces: 308 + 16) equals: fmin.
	self assert: (self printString: Float fminNormalized negated decimalPlaces: 308 + 16)
		equals: '-' , fmin.
	self assert: (self printString: Float fminNormalized decimalPlaces: 2) equals: '0.00'.
	Float denormalized
		ifTrue: 
			[| fminDenorm |
			fminDenorm := String writeStream
						nextPutAll: '0.';
						next: 324 - 1 put: $0;
						nextPutAll: '5';
						contents.
			self assert: (self printString: Float fminDenormalized decimalPlaces: 324) equals: fminDenorm.
			self assert: (self printString: Float fminDenormalized negated decimalPlaces: 324)
				equals: '-' , fminDenorm]!

testPrintOnDecimalPlacesInfinities
	self assert: (self printString: Float infinity decimalPlaces: 2) equals: 'Float.Infinity'.
	self assert: (self printString: Float infinity decimalPlaces: 0) equals: 'Float.Infinity'.
	self assert: (self printString: Float negativeInfinity decimalPlaces: 2)
		equals: 'Float.NegativeInfinity'.
	self assert: (self printString: Float negativeInfinity decimalPlaces: 0)
		equals: 'Float.NegativeInfinity'!

testPrintOnDecimalPlacesNans
	self assert: (self printString: Float nan decimalPlaces: 1) equals: 'Float.NaN'.
	self assert: (self printString: Float nan decimalPlaces: 0) equals: 'Float.NaN'.
	self assert: (self printString: Float nan negated decimalPlaces: 2) equals: 'Float.NaN'!

testPrintOnDecimalPlacesZeroes
	self assert: (self printString: Float zero decimalPlaces: 0) equals: '0'.
	self assert: (self printString: Float zero decimalPlaces: 1) equals: '0.0'.
	self assert: (self printString: Float zero decimalPlaces: 2) equals: '0.00'.
	self assert: (self printString: Float negativeZero decimalPlaces: 0) equals: '-0'.
	self assert: (self printString: Float negativeZero decimalPlaces: 1) equals: '-0.0'.
	self assert: (self printString: Float negativeZero decimalPlaces: 3) equals: '-0.000'!

testPrintOnSignificantFigures
	self assert: (self printString: Float pi significantFigures: 0) equals: '0.0'.
	self assert: (self printString: Float pi significantFigures: 1) equals: '3.0'.
	self assert: (self printString: Float pi significantFigures: 2) equals: '3.1'.
	self assert: (self printString: Float pi significantFigures: 3) equals: '3.14'.
	self assert: (self printString: Float pi significantFigures: 4) equals: '3.142'.
	self assert: (self printString: Float pi significantFigures: 5) equals: '3.1416'.
	self assert: (self printString: Float fmax significantFigures: 1) equals: '2.0e308'.
	self assert: (self printString: Float fmax significantFigures: 15) equals: '1.79769313486232e308'.
	self assert: (self printString: Float fmax significantFigures: 16) equals: '1.797693134862316e308'.
	self assert: (self printString: Float fmax negated significantFigures: 16)
		equals: '-1.797693134862316e308'.
	self assert: (self printString: Float fminNormalized significantFigures: 16)
		equals: '2.225073858507201e-308'.
	self assert: (self printString: 3.125 significantFigures: 15) equals: '3.125'.
	self assert: (self printString: 0.0 significantFigures: 15) equals: '0.0'.
	self assert: (self printString: -0.0 significantFigures: 15) equals: '-0.0'.
	self assert: (self printString: Float infinity significantFigures: 15) equals: 'Float.Infinity'.
	self assert: (self printString: Float negativeInfinity significantFigures: 15)
		equals: 'Float.NegativeInfinity'.
	self assert: (self printString: Float nan significantFigures: 15) equals: 'Float.NaN'!

testPrintString
	self assert: 1.3 printString equals: '1.3'.
	self assert: (4.0 / 3.0) printString equals: '1.3333333333333333'.
	self assert: Float zero printString equals: '0.0'.
	self assert: Float negativeZero printString equals: '-0.0'.
	self assert: Float pi printString equals: '3.141592653589793'.
	"Printed result is exact, so includes any representation error in the Float"
	self assert: (0.1 + 0.2) printString equals: '0.30000000000000004'.
	self assert: (-0.1 - 0.2) printString equals: '-0.30000000000000004'.
	self assert: 240 degreesToRadians cos equals: -0.5000000000000004.
	self assert: 240 degreesToRadians cos abs equals: 0.5000000000000004.
	"Min values"
	self assert: Float fminNormalized printString equals: '2.2250738585072014e-308'.
	self assert: Float fminNormalized negated printString equals: '-2.2250738585072014e-308'.
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized printString equals: '5.0e-324'.
			self assert: Float fminDenormalized negated printString equals: '-5.0e-324'].
	"Max values"
	self assert: Float fmax printString equals: '1.7976931348623157e308'.
	self assert: Float fmax negated printString equals: '-1.7976931348623157e308'.
	"Exceptional values"
	self assert: Float infinity printString equals: 'Float.Infinity'.
	self assert: Float negativeInfinity printString equals: 'Float.NegativeInfinity'.
	self assert: Float nan printString equals: 'Float.NaN'!

testPrintStringAndReadBack
	"Debug reading/printing a Floating point number without accumulating round off errors"

	| b r |
	b := ByteArray new: 8.
	r := RandomLinearCongruential
				newModulus: 16r100000000
				multiplier: 16r0F010800F
				increment: 16r00005F2ED.
	r seed: 1234567.
	100 timesRepeat: 
			[| f str |
			b basicDwordAtOffset: 4 put: (r
						next;
						seed) - 1.
			b basicDwordAtOffset: 0 put: (r
						next;
						seed) - 1.
			((b basicDwordAtOffset: 4) bitAnd: 16r7FF00000) = 16r7FF00000
				ifFalse: 
					["avoid nan and infinity"
					f := b doubleAtOffset: 0.
					str := (String new: 64) writeStream.
					f printOn: str.
					self assert: (Float readFrom: str contents readStream) equals: f]].
	"test big num near infinity"
	10 timesRepeat: 
			[| f str |
			b basicDwordAtOffset: 4 put: 16r7FE00000 + ((r
								next;
								seed) // 16r1000 - 1).
			b basicDwordAtOffset: 0 put: (r
						next;
						seed) - 1.
			f := b doubleAtOffset: 0.
			str := (String new: 64) writeStream.
			f printOn: str.
			self assert: (Float readFrom: str contents readStream) equals: f].
	"test infinitesimal (gradual underflow)"
	10 timesRepeat: 
			[| f str |
			b basicDwordAtOffset: 4 put: 0 + ((r
								next;
								seed) // 16r1000 - 1).
			b basicDwordAtOffset: 0 put: (r
						next;
						seed) - 1.
			f := b doubleAtOffset: 0.
			str := (String new: 64) writeStream.
			f printOn: str.
			self assert: (Float readFrom: str contents readStream) equals: f]!

testRaisedTo
	#(4 4.0 4s) do: [:each | self assert: (2.0 raisedTo: each) equals: 16.0].
	self assert: (16.0 raisedTo: 1 / 2) equals: 4.0.
	self infinities do: [:each | self assert: (each raisedTo: 2) equals: Float infinity].
	self assert: (0.0 raisedTo: 1) equals: 0.0.
	self assert: (-3.0 raisedTo: 2.0) equals: 9.0.
	self assert: (-3.0 raisedTo: 3.0) equals: -27.0.
	"Fractional powers"
	self assert: (2.0 raisedTo: 0.5) equals: 1.4142135623730951.
	self assert: ((0.5 raisedTo: 0.5) squared roundTo: 1.0e-15) equals: 0.5.
	self assert: ((0.5 raisedTo: 0.25) squared squared roundTo: 1.0e-15) equals: 0.5.
	self assert: (0.0 raisedTo: 0.5) equals: 0.0.
	self assert: (0.0 raisedTo: 0.25) equals: 0.0.
	self shouldRaiseInvalidOperation: [-3.0 raisedTo: 0.5].
	"Negative powers"
	self assert: (4.0 raisedTo: -1) equals: 0.25.
	self assert: (4.0 raisedTo: -2) equals: 1 / 16.0.
	self assert: (4.0 raisedTo: -3) equals: 1 / 64.0.
	self assert: (-4.0 raisedTo: -1.0) equals: -0.25.
	self assert: (-4.0 raisedTo: -2.0) equals: 1 / 16.0.
	self assert: (-4.0 raisedTo: -3.0) equals: -1 / 64.0.
	self assert: (0.5 raisedTo: -1.0) equals: 2.0.
	self assert: (0.5 raisedTo: -2) equals: 4.0.
	self assert: (0.5 raisedTo: -3.0) equals: 8.0.
	self assert: (-0.5 raisedTo: -1.0) equals: -2.0.
	self assert: (-0.5 raisedTo: -2) equals: 4.0.
	self assert: (-0.5 raisedTo: -3.0) equals: -8.0.
	self shouldRaiseZeroDivide: [0.0 raisedTo: -1.0].
	"Negative fractional powers"
	self assert: (0.5 raisedTo: -0.5) equals: 2.0 sqrt.
	self assert: (4 raisedTo: -0.25) equals: 0.25 sqrt sqrt.
	self assert: (0.5 raisedTo: -0.25) equals: 2.0 sqrt sqrt.
	self shouldRaiseInvalidOperation: [-3 raisedTo: -0.5].
	"Overflow"
	self shouldRaiseOverflow: [Float fmax raisedTo: 2].
	self assert: (Float nan raisedTo: 2) isNaN!

testRaisedToInteger
	| extremes |
	self assert: (2.0 raisedToInteger: 0) equals: 1.0.
	self assert: (2.0 raisedToInteger: 1) equals: 2.0.
	self assert: (2.0 raisedToInteger: 4) equals: 16.0.
	self assert: (0.0 raisedToInteger: 0) equals: 1.0.
	self assert: (0.0 raisedToInteger: 2) equals: 0.0.
	self shouldRaiseZeroDivide: [0.0 raisedToInteger: -1].
	self assert: (2.0 raisedToInteger: -1) equals: 0.5.
	self assert: (2.0 raisedToInteger: -4) equals: 0.0625.
	self assert: (-0.0 raisedToInteger: 0) equals: 1.0.
	self assert: (-0.0 raisedToInteger: 3) equals: 0.0.
	self assert: (-0.0 raisedToInteger: 2) equals: 0.0.
	self shouldRaiseZeroDivide: [-0.0 raisedToInteger: -1] withContinuation: Float negativeInfinity.
	self assert: (-2.0 raisedToInteger: 0) equals: 1.0.
	self assert: (-2.0 raisedToInteger: 1) equals: -2.0.
	self assert: (-2.0 raisedToInteger: 4) equals: 16.0.
	self assert: (-2.0 raisedToInteger: -1) equals: -0.5.
	self assert: (-2.0 raisedToInteger: -4) equals: 0.0625.
	"Anything raised to 0 should be 1"
	extremes := {Float nan. Float negativeInfinity. Float infinity. Float fmax. Float fminNormalized}.
	Float denormalized ifTrue: [extremes := extremes copyWith: Float fminDenormalized].
	extremes do: [:each | self assert: (each raisedToInteger: 0) equals: 1.0].
	#(1 2 -1 -2) do: [:each | self assert: (Float nan raisedToInteger: each) isNaN]!

testReadFrom
	308 to: -316
		do: 
			[:each |
			self assert: (Float readFrom: ('1.0e-<p>' expandMacrosWith: each) readStream) equals: 10.0 ** each].
	self normals , (Float denormalized ifTrue: [{Float fminDenormalized}] ifFalse: [#()])
		do: [:each | self assert: (Float readFrom: each printString readStream) equals: each]!

testReciprocal
	self assert: Float nan reciprocal isNaN.
	self assert: Float infinity reciprocal equals: 0.0.
	self assertNegativeZero: Float negativeInfinity reciprocal.
	self assert: 1.0 reciprocal equals: 1.0.
	self assert: -1.0 reciprocal equals: -1.0.
	self assert: 0.5 reciprocal equals: 2.0.
	self assert: 4.0 reciprocal equals: 0.25.
	self shouldRaiseZeroDivide: [0.0 reciprocal] withContinuation: Float infinity.
	self shouldRaiseZeroDivide: [-0.0 reciprocal] withContinuation: Float negativeInfinity.
	self assert: Float fmax reciprocal bitRepresentation equals: 16r4000000000000.
	self assert: Float fminNormalized reciprocal bitRepresentation equals: 16r7FD0000000000000.
	Float denormalized ifTrue: [self shouldRaiseOverflow: [Float fminDenormalized reciprocal]].
	self assert: Float pi reciprocal reciprocal equals: Float pi!

testRounded
	| x y int |
	self assert: 1.5 rounded equals: 2.0.
	self assert: 0.5 rounded equals: 1.0.
	self assert: -1.5 rounded equals: -2.0.

	"5000000000000001 asFloat has an exact representation (no round off error).
	It should round to nearest integer without loosing bits."

	"This is a preamble asserting exactness of representation
	and quality of various conversions"
	int := 5000000000000001.
	x := int asFloat.
	y := (5 asFloat squared squared squared squared timesTwoPower: 15) + 1.
	self assert: x equals: y.
	self assert: x asTrueFraction equals: int.

	"this one should be true for any float
	in order to conform to ISO/IEC 10967-2"
	self assert: x rounded equals: x asTrueFraction rounded.
	self assert: x negated rounded equals: x negated asTrueFraction rounded.

	"Extremes and special cases"
	self assert: 0.0 rounded equals: 0.
	self assert: -0.0 rounded equals: 0.
	Float denormalized ifTrue: [self assert: Float fminDenormalized rounded equals: 0].
	self assert: Float fminNormalized rounded equals: 0.
	self continuationValues do: [:each | self should: [each rounded] raise: ArithmeticError].
	self assert: Float fmax rounded
		equals: 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.
	self assert: Float fmax negated rounded
		equals: -179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368!

testSign
	self assert: 0.0 sign equals: 0.
	self assert: 1.0 sign equals: 1.
	self assert: -1.0 sign equals: -1.
	self assert: Float negativeZero sign equals: -1.
	self assert: Float fmax sign equals: 1.
	self assert: Float fmax negated sign equals: -1.
	self assert: Float fminNormalized sign equals: 1.
	self assert: Float fminNormalized negated sign equals: -1.
	self assert: Float infinity sign equals: 1.
	self assert: Float negativeInfinity sign equals: -1.
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized sign equals: 1.
			self assert: Float fminDenormalized negated sign equals: -1].
	self assert: Float nan sign equals: 0!

testSignificandAsInteger
	| denormalPowersOfTwo denormals exceptionals normalPowersOfTwo normals |
	normals := {Float pi. Float pi * 100.0. Float pi / -100.0. Float fmax. Float fminNormalized}.
	denormals := {0.0. Float negativeZero} , (Float denormalized
						ifTrue: [{self predecessor: Float fminDenormalized. Float fminDenormalized negated}]
						ifFalse: [#()]).
	exceptionals := {Float nan. Float infinity. Float negativeInfinity}.
	normalPowersOfTwo := (-10 to: 10) collect: [:i | 1.0 timesTwoPower: i].
	normals do: 
			[:aNormalFloat |
			"Assume the mantissa is written in least 52 bits of hex format, with an implied 1 on position 53"
			self assert: (self finiteSignificand: aNormalFloat) equals: aNormalFloat significandAsInteger].
	denormals , exceptionals do: 
			[:aDenormalOrExceptionalFloat |
			"For every other Float, zero, denormal or exceptional, no implied leading one"
			self assert: ((aDenormalOrExceptionalFloat qwordAtOffset: 0) bitAnd: Float.MantissaMask)
				equals: aDenormalOrExceptionalFloat significandAsInteger].
	normalPowersOfTwo do: 
			[:aNormalPowerOfTwoFloat |
			"The significand of a power of two is a power of two, with high bit of expected precision"
			self assert: aNormalPowerOfTwoFloat significandAsInteger isPowerOfTwo.
			self assert: aNormalPowerOfTwoFloat significandAsInteger highBit equals: Float precision.
			self assert: (self successor: aNormalPowerOfTwoFloat) significandAsInteger
				equals: aNormalPowerOfTwoFloat significandAsInteger + 1.
			"The last one is not true for fminNormalized"
			aNormalPowerOfTwoFloat = Float fminNormalized or: 
					[self assert: (self predecessor: aNormalPowerOfTwoFloat) significandAsInteger
						equals: aNormalPowerOfTwoFloat significandAsInteger * 2 - 1]].
	Float denormalized
		ifTrue: 
			[denormalPowersOfTwo := (Float emin - (Float precision - 1) to: Float emin - 1)
						collect: [:i | 1.0 timesTwoPower: i].
			denormalPowersOfTwo do: 
					[:aDenormalPowerOfTwoFloat |
					"The significand of a denormal power of two is a power of two, just with less bits"
					self assert: aDenormalPowerOfTwoFloat significandAsInteger isPowerOfTwo.
					self assert: aDenormalPowerOfTwoFloat significandAsInteger highBit
						equals: Float precision + aDenormalPowerOfTwoFloat exponent - Float emin.
					(self successor: aDenormalPowerOfTwoFloat) = Float fminNormalized or: 
							[self assert: (self successor: aDenormalPowerOfTwoFloat) significandAsInteger
								equals: aDenormalPowerOfTwoFloat significandAsInteger + 1].
					self assert: (self predecessor: aDenormalPowerOfTwoFloat) significandAsInteger
						equals: aDenormalPowerOfTwoFloat significandAsInteger - 1]].

	"Well known value for a few extremal cases"
	self assert: Float fmax significandAsInteger equals: (1 << Float precision) - 1.
	self assert: Float fminNormalized significandAsInteger equals: 1 << (Float precision - 1).
	Float denormalized ifTrue: [self assert: Float fminDenormalized significandAsInteger equals: 1].
	self assert: 0.0 significandAsInteger equals: 0.
	self assert: Float infinity significandAsInteger equals: 0.
	self assert: Float nan significandAsInteger equals: 16r8000000000000!

testSin
	| oneEighty |
	oneEighty := Float pi / 2.
	self assert: oneEighty sin equals: 1.0.
	self assert: oneEighty negated sin equals: -1.0.
	self assert: 0.0 sin equals: 0.0.
	self assertNegativeZero: -0.0 sin.
	self assert: ((Float pi / 6) sin roundTo: Float.SignificantDifference) equals: 0.5.
	self infinities do: [:each | self shouldRaiseInvalidOperation: [each sin]].
	self assert: Float nan sin isNaN!

testSqrt
	| actual |
	self assert: 2.0 sqrt equals: 1.41421356237309504880168872420969808.
	self assert: 1.0 sqrt equals: 1.0.
	self assert: 0.0 sqrt equals: 0.0.
	self assertNegativeZero: -0.0 sqrt.
	self shouldRaiseInvalidOperation: [-1.0 sqrt].
	actual := Float fminNormalized sqrt.
	self assert: actual * actual equals: Float fminNormalized.
	Float denormalized
		ifTrue: 
			[actual := Float fminDenormalized sqrt.
			self assert: actual * actual equals: Float fminDenormalized].
	self assert: Float infinity sqrt equals: Float infinity.
	self shouldRaiseInvalidOperation: [Float negativeInfinity sqrt].
	self assert: Float nan sqrt isNaN!

testStoreOn
	| cases |
	cases := self normals , self infinities , {Float fminNormalized}.
	Float denormalized ifTrue: [cases := cases copyWith: Float fminDenormalized].
	cases do: 
			[:each |
			| stored |
			stored := each storeString.
			self assert: (Compiler evaluate: stored) equals: each].
	self assert: (Compiler evaluate: Float nan storeString) isNaN!

testTimesTwoPower
	self assert: (1.0 timesTwoPower: 16) equals: 2 ** 16.
	self assert: (1.0 timesTwoPower: -1) equals: 0.5.
	self assert: (1.0 timesTwoPower: Float emax) equals: 2 ** Float emax.
	self assert: (-1.0 timesTwoPower: Float emax) equals: -2 ** Float emax.
	self assert: (0.0 timesTwoPower: 10) equals: 0.0.
	self assertNegativeZero: (-0.0 timesTwoPower: 10).
	self assert: (Float infinity timesTwoPower: 10) equals: Float infinity.
	self assert: (Float negativeInfinity timesTwoPower: 10) equals: Float negativeInfinity.
	self assert: (Float nan timesTwoPower: 10) isNaN.
	self shouldRaiseOverflow: [1.0 timesTwoPower: Float emax + 1]!

testTruncated
	| subject y int |
	int := 10 raisedTo: 16.
	subject := int asFloat.
	y := (5 raisedTo: 16) asFloat timesTwoPower: 16.
	self assert: subject equals: y.
	self assert: subject asInteger equals: int.
	self assert: subject asInteger equals: subject asTrueFraction asInteger.

	"Extremes and special cases"
	self assert: 0.0 truncated equals: 0.
	self assert: -0.0 truncated equals: 0.
	Float denormalized ifTrue: [self assert: Float fminDenormalized truncated equals: 0].
	self assert: Float fminNormalized truncated equals: 0.
	self continuationValues do: [:each | self should: [each truncated] raise: ArithmeticError].
	self assert: Float fmax truncated
		equals: 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.
	self assert: Float fmax negated truncated
		equals: -179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368!

testUnderflow
	self shouldRaiseUnderflow: [Float fmin * 0.1]!

zeroes
	^#(-0.0 0.0)! !
!Core.Tests.FloatTest categoriesFor: #assertFloat:equals:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #assertNegativeZero:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #continuationValues!constants!private! !
!Core.Tests.FloatTest categoriesFor: #finiteSignificand:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #infinities!constants!private! !
!Core.Tests.FloatTest categoriesFor: #normals!constants!private! !
!Core.Tests.FloatTest categoriesFor: #predecessor:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #printString:decimalPlaces:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #printString:significantFigures:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #setUp!private!Running! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseInvalidOperation:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseOverflow:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseOverflow:withContinuation:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseUnderflow:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseZeroDivide:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseZeroDivide:status:withContinuations:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseZeroDivide:withContinuation:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #shouldRaiseZeroDivide:withContinuations:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #successor:!helpers!private! !
!Core.Tests.FloatTest categoriesFor: #tearDown!private!Running! !
!Core.Tests.FloatTest categoriesFor: #testAbs!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testAdd!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testArcCos!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testArcSin!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testArcTan!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testArcTan2!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testAsInteger!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testAsTrueFraction!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testCeiling!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testCopy!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testCos!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testDenormalsAsTrueFraction!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testDivideByZero!public!Testing!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testEqualsColon!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testEqualsZero!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testExp!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testExponent!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testFloatCharacterization!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testFloor!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testFloorLog2!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testFractionAsFloat!public!Testing!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testFractionComparisons!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testFractionPart!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testGreaterThanInteger!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testHash!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testInfinityComparisons!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIntegerAsFloat!public!Testing!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIntegerComparisons!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIntegerComparisonsImprecise!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIntegerPart!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIsFinite!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIsInfinite!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIsLiteral!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIsNan!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIsSelfEvaluating!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testIsZero!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testLessThanFraction!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testLessThanInteger!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testLn!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testLog!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testNaNComparisons!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testNegated!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testNegative!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testOverflow!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPredecessorSuccessor!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintOnDecimalPlaces!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintOnDecimalPlacesFmax!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintOnDecimalPlacesFmin!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintOnDecimalPlacesInfinities!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintOnDecimalPlacesNans!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintOnDecimalPlacesZeroes!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintOnSignificantFigures!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintString!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testPrintStringAndReadBack!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testRaisedTo!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testRaisedToInteger!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testReadFrom!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testReciprocal!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testRounded!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testSign!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testSignificandAsInteger!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testSin!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testSqrt!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testStoreOn!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testTimesTwoPower!public!Testing!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testTruncated!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #testUnderflow!public!unit tests! !
!Core.Tests.FloatTest categoriesFor: #zeroes!constants!private! !

!Core.Tests.FloatTest class methodsFor!

predecessor: aFloat
	| ulp |
	aFloat isFinite
		ifFalse: 
			[(aFloat isNaN or: [aFloat negative]) ifTrue: [^aFloat].
			^Float fmax].
	ulp := self ulp: aFloat.
	^aFloat - (0.5 * ulp) = aFloat ifTrue: [aFloat - ulp] ifFalse: [aFloat - (0.5 * ulp)]!

successor: aFloat
	| ulp |
	aFloat isFinite
		ifFalse: 
			[(aFloat isNaN or: [aFloat positive]) ifTrue: [^aFloat].
			^Float fmax negated].
	ulp := self ulp: aFloat.
	^aFloat + (0.5 * ulp) = aFloat
		ifTrue: [(aFloat * -1.0 - ulp) * -1.0	"This trick is for obtaining a negativeZero"]
		ifFalse: [aFloat + (0.5 * ulp)]!

ulp: aFloat
	"Answer the unit of least precision of the Float argument (the power of two corresponding to last bit of mantissa)"

	| exponent |
	aFloat isFinite ifFalse: [^aFloat abs].
	aFloat = 0.0 ifTrue: [^Float fminDenormalized].
	exponent := aFloat exponent.
	^exponent < Float emin
		ifTrue: [Float fminDenormalized]
		ifFalse: [Float epsilon timesTwoPower: exponent]! !
!Core.Tests.FloatTest class categoriesFor: #predecessor:!helpers!private! !
!Core.Tests.FloatTest class categoriesFor: #successor:!helpers!private! !
!Core.Tests.FloatTest class categoriesFor: #ulp:!helpers!private! !


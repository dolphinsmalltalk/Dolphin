"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #FloatTest
	instanceVariableNames: 'fpeMask'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FloatTest guid: (GUID fromString: '{b2b95b67-e8f3-4991-a4b4-94edc5e83f28}')!
FloatTest comment: ''!
!FloatTest categoriesForClass!Unclassified! !
!FloatTest methodsFor!

assertNegativeZero: aFloat
	self assert: aFloat equals: -0.0.
	self assert: aFloat negative!

finiteSignificand: aNormalFloat
	^(aNormalFloat timesTwoPower: Float.Precision - 1 - (aNormalFloat exponent max: Float.EMin))
		truncated abs!

normals
	^OrderedCollection new
		add: Float pi;
		add: Float pi / 100; "= fractionPart"
		add: Float fmax;
		add: Float fminNormalized;
		add: Float fmax negated;
		add: Float fminNormalized negated;
		"Zeroes don't have the implied leading mantissa bit, but they aren't denormals as such"
		add: -0.0;
		add: 0.0;
		asArray!

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
	Float reset.
	fpeMask := Float exceptionMask.
	super setUp!

shouldRaiseInvalidOperation: aBlock
	| mask raised status result status2 result2 |
	Float reset.
	raised := false.
	mask := Float exceptionMask.
	Float exceptionMask: (mask maskClear: CRTConstants._EM_INVALID).
	
	[aBlock
		on: FloatingPointException
		do: [:e | (e _ieeeRecord causeNames includes: #InvalidOperation) ifTrue: [raised := true]]
		on: ZeroDivide
		do: 
			[:e |
			"On x86 0.0/0.0 raises Invalid notification, but we translate this to ZeroDivide"
			e dividend isZero ifTrue: [raised := true]].
	"Repeat the operation with overflow masked to check that invalid operation condition can be detected."
	Float exceptionMask: (mask maskSet: CRTConstants._EM_INVALID).
	self assert: Float statusFlags equals: 0.
	result := aBlock value.
	status := Float statusFlags.
	"Finally repeat with all exceptions masked (because the CRT functions often behave differently and use an SSE2 implementation when this is the case)"
	Float exceptionMask: CRTConstants._MCW_EM.
	self assert: Float statusFlags equals: 0.
	result2 := aBlock value.
	status2 := Float statusFlags]
			ensure: [Float exceptionMask: mask].
	self assert: raised
		description: 'Test operation did not raise expected FP Invalid Operation exception'.
	self assert: (status allMask: CRTConstants._SW_INVALID)
		description: 'Test operation did not notify Invalid Operation.'.
	self assert: result isNaN.
	self assert: (status2 allMask: CRTConstants._SW_INVALID)
		description: 'Test operation did not notify Invalid Operation with all exceptions masked.'.
	self assert: result2 isNaN!

shouldRaiseOverflow: aBlock
	self shouldRaiseOverflow: aBlock withContinuation: Float.Infinity!

shouldRaiseOverflow: aBlock withContinuation: aFloat
	| mask raised status1 result1 status2 result2 |
	Float reset.
	raised := false.
	mask := Float exceptionMask.
	Float exceptionMask: (mask maskClear: CRTConstants._EM_OVERFLOW).
	
	[aBlock
		on: FloatingPointException
		do: [:e | e isOverflow ifTrue: [raised := true]]
		on: HRESULTError
		do: [:e | e hresult asInteger = AXAutomationErrors.DISP_E_OVERFLOW ifTrue: [raised := true]].
	"Repeat the operation with overflow masked to check that overflow condition 'notification'
	is available, and the correct continuation result is returned."
	Float exceptionMask: (mask maskSet: CRTConstants._EM_OVERFLOW).
	result1 := aBlock value.
	status1 := Float statusFlags.
	"Finally repeat with all exceptions masked (because the CRT functions often behave differently and use an SSE2 implementation when this is the case)"
	Float exceptionMask: CRTConstants._MCW_EM.
	result2 := aBlock value.
	status2 := Float statusFlags]
			ensure: [Float exceptionMask: mask].
	self assert: raised description: 'Test operation did not raise expected FP overflow exception'.
	self assert: (status1 allMask: CRTConstants._SW_OVERFLOW)
		description: 'Test operation did not notify FP overflow with overflow masked.'.
	self assert: result1 equals: aFloat.
	self assert: (status2 allMask: CRTConstants._SW_OVERFLOW)
		description: 'Test operation did not notify FP overflow with all exceptions masked.'.
	self assert: result2 equals: aFloat!

shouldRaiseUnderflow: aBlock
	| mask raised status1 result1 status2 result2 |
	Float reset.
	raised := false.
	mask := Float exceptionMask.
	Float exceptionMask: (mask maskClear: CRTConstants._EM_UNDERFLOW).
	
	[aBlock on: FloatingPointException do: [:e | e isUnderflow ifTrue: [raised := true]].
	"Repeat the operation with overflow masked to check that overflow condition 'notification'
	is available, and the correct continuation result is returned."
	Float exceptionMask: (mask maskSet: CRTConstants._EM_UNDERFLOW).
	result1 := aBlock value.
	status1 := Float statusFlags.
	"Finally repeat with all exceptions masked (because the CRT functions often behave differently and use an SSE2 implementation)"
	Float exceptionMask: CRTConstants._MCW_EM.
	result2 := aBlock value.
	status2 := Float statusFlags]
			ensure: [Float exceptionMask: mask].
	self assert: raised description: 'Test operation did not raise expected FP underflow exception'.
	self assert: (status1 allMask: CRTConstants._SW_UNDERFLOW)
		description: 'Test operation did not notify FP underflow with underflow masked.'.
	Float denormalized ifTrue: [self assert: result1 isZero] ifFalse: [self assert: result1 isDenormal].
	self assert: (status2 allMask: CRTConstants._SW_UNDERFLOW)
		description: 'Test operation did not notify FP underflow with all exceptions masked.'.
	self assert: result2 isZero!

shouldRaiseZeroDivide: aBlock
	self shouldRaiseZeroDivide: aBlock withContinuation: Float.Infinity!

shouldRaiseZeroDivide: aBlock withContinuation: aFloat
	| raised status fpeMask result status2 result2 |
	raised := false.
	status := 0.
	fpeMask := Float exceptionMask.
	Float exceptionMask: (fpeMask maskClear: CRTConstants._EM_ZERODIVIDE).
	
	[aBlock on: ZeroDivide do: [:e | raised := true].
	Float exceptionMask: (fpeMask maskSet: CRTConstants._EM_ZERODIVIDE | CRTConstants._EM_INVALID).
	result := aBlock value.
	status := Float statusFlags.
	"Finally mask everything, since this changes the behaviour of the CRT (it will only SSE2 routines when all exceptions are masked"
	Float exceptionMask: (fpeMask maskSet: CRTConstants._MCW_EM).
	result2 := aBlock value.
	status := Float statusFlags]
			ensure: [Float exceptionMask: fpeMask].
	self assert: raised description: 'Test operation did not raise ZeroDivide'.
	self assert: (status anyMask: CRTConstants._SW_ZERODIVIDE | CRTConstants._SW_INVALID)
		description: 'Test operation did not notify zero-divide.'.
	self assert: result equals: aFloat.
	self assert: (status allMask: CRTConstants._SW_ZERODIVIDE)
		description: 'Test operation did not notify zero-divide with all exceptions masked.'.
	self assert: result2 equals: aFloat!

successor: aFloat
	^self class successor: aFloat!

tearDown
	"Be careful not to leave behind test FPE mask"
	Float exceptionMask: fpeMask.
	Float reset.
	super tearDown!

testAbs
	self assert: 0.0 abs equals: 0.0.
	self assert: 1.0 abs equals: 1.0.
	self assert: -2.5 abs equals: 2.5.
	self assert: -0.0 abs equals: 0.0.
	self assert: (Float fmax * -1) abs equals: Float fmax.
	self assert: (Float fmin * -1) abs equals: Float fmin.
	self assert: Float.NaN abs isNaN.
	self assert: Float.Infinity abs equals: Float.Infinity.
	self assert: Float.NegativeInfinity abs equals: Float.Infinity.
	Float denormalized
		ifTrue: [self assert: (Float fminDenormalized * -1) abs equals: Float fminDenormalized]!

testAdd
	self assert: 1.0 + 1.0 equals: 2.0.
	self assert: 1.0 + 1.5 equals: 2.5.
	self assert: 1.0 + 1 equals: 2.0.
	self assert: 1.0 + (3 / 2) equals: 2.5!

testArcTan
	self assert: 1 arcTan radiansToDegrees equals: 45.
	self assert: -1 arcTan radiansToDegrees equals: -45.
	self assert: 0.41421356237309503 arcTan radiansToDegrees equals: 22.5.
	self assert: 1.6331778728383844e16 arcTan radiansToDegrees equals: 90!

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
	self assert: (-0.0 arcTan: -0.0) equals: pi negated!

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
	{0.0. -0.0. Float fminNormalized} do: [:each | self assert: each asInteger equals: 0]!

testAsTrueFraction
	"check if gradual underflow is correctly handled"

	| fminDenorm |
	self skipUnless: [Float denormalized].
	self assert: 1.0e-316 asTrueFraction asFloat equals: 1.0e-316.
	fminDenorm := Float fminDenormalized asTrueFraction.
	self assert: fminDenorm equals: 1 / (1 << 1074).
	self assert: fminDenorm equals: (1 << (Float precision - Float emin - 1)) reciprocal.
	self assert: fminDenorm asFloat equals: Float fminDenormalized!

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
		do: [:each | self assert: each asFloat floor equals: each].
	self assert: Float fmax ceiling equals: Float fmax asInteger.
	self assert: Float fmax negated ceiling equals: Float fmax negated asInteger.
	Float exceptionMask: (Float exceptionMask maskClear: CRTConstants._EM_INVALID).
	{Float.Infinity. Float.NegativeInfinity. Float.NaN}
		do: [:each | self should: [each ceiling] raise: Error]!

testCos
	| sixty |
	sixty := Float pi / 3.
	self assert: Float pi cos equals: -1.0.
	self assert: 0.0 cos equals: 1.0.
	self assert: -0.0 cos equals: 1.0.
	"Note that the result is not precise"
	self assert: (sixty cos roundTo: Float.SignificantDifference) equals: 0.5.
	self assert: (sixty cos * -1 roundTo: Float.SignificantDifference) equals: -0.5.
	self assert: Float.NaN cos isNaN!

testEqualsColon
	
	self assert: (0.0 equals: 0.0000000001).
	self assert: (0.0 equals: -0.0000000001).
	self assert: (0.0000000001 equals: 0.0).
	self assert: (-0.0000000001 equals: 0.0).
	self assert: (0.0 equals: 0.0000000009).
	self assert: (0.0 equals: 0.000000009) not.

	self assert: (Float fmin equals: 0.0).
	self assert: (0.0 equals: Float fmin).

	self assert: ((Float fmin *2) equals: Float fmin).
	self assert: ((Float fmin *2) equals: 1e-10).
	self assert: ((Float fmin *2) equals: 1e-8) not.

	self assert: (1.123456789e308 equals: 1.1234567891e308).
	self assert: (1.1234567891e308 equals: 1.123456789e308).
	self assert: (1.123456788e308 equals: 1.123456789e308).
	self assert:(1.12345678e308 equals: 1.12345679e308) not.

	self assert: (1.123456789e20 equals: 1.1234567899e20).
	self assert: (1.123456799e20 equals: 1.123456789e20) not.
!

testExp
	| e pi |
	e := 2.718281828459045.
	pi := Float pi.
	self assert: 1.0 exp equals: e.
	self assert: 1.1447298858494002 exp equals: pi!

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
	"Not a useful enquiry, but reveals the underlying representation"
	self assert: Float infinity exponent equals: -1.
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized exponent equals: Float.EMinDenormalized.
			self assert: Float fminDenormalized negated exponent equals: Float.EMinDenormalized]!

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
	self assert: (Float fminDenormalized qwordAtOffset: 0) equals: 1.
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
	Float exceptionMask: (Float exceptionMask maskClear: CRTConstants._EM_INVALID).
	{Float.Infinity. Float.NegativeInfinity. Float.NaN}
		do: [:each | self should: [each floor] raise: Error]!

testFractionAsFloat
	"use a random test to be sure that fractions are rounded to nearest float"

	| r frac err collec |
	r := RandomLinearCongruential
				newModulus: (2 raisedTo: 54)
				multiplier: (2 raisedTo: 53) - (2 raisedTo: 47) - (2 raisedTo: 33) - 1
				increment: 1234567.
	r seed: 1234567.
	1000 timesRepeat: 
			[frac := ((r
						next;
						seed) * (r
									next;
									seed) + 1)
						/ ((r
								next;
								seed) * (r
											next;
											seed) + 1).
			err := (frac - frac asFloat asTrueFraction) * frac reciprocal * (1 bitShift: Float precision - 1).
			self assert: err < (1 / 2)].
	collec := #(16r010000000000000 16r01FFFFFFFFFFFFF 1 2 16r020000000000000 16r0020000000000001 16r3FFFFFFFFFFFFF 16r3FFFFFFFFFFFFE 16r3FFFFFFFFFFFFD).
	collec do: 
			[:num |
			collec do: 
					[:den |
					frac := Fraction numerator: num denominator: den.
					err := (frac - frac asFloat asTrueFraction) * frac reciprocal * (1 bitShift: Float precision - 1).
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
	{1 / 2. 1 / 3. 1 / 10} do: 
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

testHash
	| subject1 subject2 hashes hash1 hash2 |
	#(##(SmallInteger minimum) 0 1 ##(SmallInteger maximum) ##(SmallInteger maximum + 1) ##(20
		factorial)) do: 
				[:each |
				| subject hash |
				subject := each asFloat.
				self assert: subject equals: each.
				hash := subject hash.
				self assert: hash isKindOf: SmallInteger.
				self assert: hash equals: each hash].
	self assert: 0.0 hash equals: 0.
	self assert: -0.0 hash equals: 0.
	self deny: Float fminNormalized hash equals: 0.
	Float denormalized ifTrue: [self assert: Float fminDenormalized hash equals: 0].
	self deny: Float nan hash equals: 0.
	self deny: Float infinity hash equals: 0.
	self deny: Float nan hash equals: Float infinity hash.
	self assert: (1 / 2) hash equals: 0.5 hash.
	self assert: 0.5 equals: 1 / 2.
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
	self assert: Float.NegativeInfinity >= Float.NegativeInfinity!

testIntegerAsFloat
	"assert IEEE 754 round to nearest even mode is honoured"

	self deny: 16r1FFFFFFFFFFFF0801 asFloat equals: 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 65 bits"
	self deny: 16r1FFFFFFFFFFFF0802 asFloat equals: 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 64 bits"
	self assert: 16r1FFFFFFFFFFF1F800 asFloat equals: 16r1FFFFFFFFFFF20000 asFloat.	"nearest even is upper"
	self assert: 16r1FFFFFFFFFFFF0800 asFloat equals: 16r1FFFFFFFFFFFF0000 asFloat	"nearest even is lower"!

testIntegerComparisons
	#(-16rFFFFFFFF -16r40000001 -16r40000000 -1 0 1 16r3FFFFFFF 16r3FFFFFFF 16r40000000 16rFFFFFFFF 16r100000000000004 16r100000000000005 -16r4000000000000001 -16r4000000000000000 ##(2
		** Float precision - 1) ##(2 ** Float precision + 1) ##(2 ** 63 - 1) ##(2 ** 64) ##(-1 * (2 ** 64)))
		do: 
			[:each |
			self assert: each asFloat equals: each.
			self assert: each hash isKindOf: SmallInteger.
			self assert: each asFloat hash equals: each hash.
			self assert: (each hash = 0 or: [each hash sign = each sign])]!

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

testLn
	self assert: Float e ln equals: 1.0!

testLog
	self assert: (10.0 raisedTo: 2.0 log) equals: 2.0.
	self assert: 1000.0 log truncated equals: 3!

testNaNComparisons
	| comparisons subject comparand |
	comparisons := #(#< #<= #> #>= #=).
	subject := Float nan.
	comparand := {0.
				1.
				2.3.
				-0.0.
				0.0.
				Float infinity.
				Float fminNormalized.
				2 / 3.
				1.25s2.
				2 raisedTo: 50.
				subject}.
	Float exceptionMask: (Float exceptionMask maskSet: CRTConstants._EM_INVALID).
	comparand := comparand , (comparand collect: [:e | e negated]).
	comparand := comparand , {0 @ 0. -1 @ -1 @ -1}.
	comparand do: 
			[:comp2 |
			comparisons do: 
					[:op2 |
					self deny: (subject perform: op2 with: comp2)
						description: ['NaN should not be <1s> <2p>' expandMacrosWithArguments: {op2. comp2}].
					self deny: (comp2 perform: op2 with: subject)
						description: ['<2p> should not be <1s> a NaN' expandMacrosWithArguments: {op2. comp2}]].
			self assert: subject ~= comp2 description: 'NaNs should always be unequal to any value'.
			self assert: comp2 ~= subject description: 'Another value should always be unequal to a NaN']!

testNegated
	self assert: -1.5 negated equals: 1.5.
	self assert: 1.5 negated equals: -1.5.
	self assertNegativeZero: 0.0 negated.
	self assert: -0.0 negated equals: 0.0.
	self assert: Float fmax negated equals: Float fmax * -1.
	self assert: Float fmin negated equals: Float fmin * -1.
	self assert: Float.NaN negated isNaN.
	self assert: Float.Infinity negated equals: Float.NegativeInfinity.
	self assert: Float.NegativeInfinity negated equals: Float.Infinity.
	Float denormalized
		ifTrue: [self assert: Float fminDenormalized negated equals: Float fminDenormalized * -1]!

testOverflow
	self shouldRaiseOverflow: [Float fmax * 2].
	self shouldRaiseOverflow: [Float fmax * -2] withContinuation: Float.NegativeInfinity.
	self shouldRaiseOverflow: [Float fmax * 2.0].
	self shouldRaiseOverflow: [Float fmax * -2.0] withContinuation: Float.NegativeInfinity.
	self shouldRaiseOverflow: [Float fmax * SmallInteger maximum].
	self shouldRaiseOverflow: [Float fmax * SmallInteger minimum]
		withContinuation: Float.NegativeInfinity.
	self shouldRaiseOverflow: [Float fmax + Float fmax].
	self shouldRaiseOverflow: [Float fmax / Float fmin].
	self shouldRaiseOverflow: [Float fmax * -1 - Float fmax] withContinuation: Float.NegativeInfinity!

testPredecessorSuccessor
	self assert: (self successor: (self predecessor: Float one)) equals: Float one.
	self assert: (self predecessor: (self successor: Float one)) equals: Float one.
	self assert: (self successor: (self predecessor: Float one negated)) equals: Float one negated.
	self assert: (self predecessor: (self successor: Float one negated)) equals: Float one negated.
	self assert: (self successor: Float fmax) equals: Float.Infinity.
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
	| fmax fmin |
	self assert: (self printString: 3.999 decimalPlaces: 4) equals: '3.9990'.
	self assert: (self printString: 3.999 decimalPlaces: 3) equals: '3.999'.
	self assert: (self printString: 3.999 decimalPlaces: 2) equals: '4.00'.
	self assert: (self printString: 3.999 decimalPlaces: 1) equals: '4.0'.
	self assert: (self printString: 3.999 decimalPlaces: 0) equals: '4'.
	self assert: (self printString: Float zero decimalPlaces: 0) equals: '0'.
	self assert: (self printString: Float zero decimalPlaces: 1) equals: '0.0'.
	self assert: (self printString: Float zero decimalPlaces: 2) equals: '0.00'.
	self assert: (self printString: Float negativeZero decimalPlaces: 0) equals: '-0'.
	self assert: (self printString: Float negativeZero decimalPlaces: 1) equals: '-0.0'.
	self assert: (self printString: Float negativeZero decimalPlaces: 3) equals: '-0.000'.
	self assert: (self printString: Float pi decimalPlaces: 15) equals: '3.141592653589793'.
	self assert: (self printString: Float pi decimalPlaces: 3) equals: '3.142'.
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
				equals: '-' , fminDenorm].
	fmax := String writeStream
				nextPutAll: '17976931348623157';
				next: 308 - 16 put: $0;
				nextPutAll: '.00000';
				contents.
	self assert: (self printString: Float fmax decimalPlaces: 5) equals: fmax.
	self assert: (self printString: Float fmax negated decimalPlaces: 5) equals: '-' , fmax.
	self assert: (self printString: Float infinity decimalPlaces: 2) equals: 'Float.Infinity'.
	self assert: (self printString: Float infinity decimalPlaces: 0) equals: 'Float.Infinity'.
	self assert: (self printString: Float negativeInfinity decimalPlaces: 2)
		equals: 'Float.NegativeInfinity'.
	self assert: (self printString: Float negativeInfinity decimalPlaces: 0)
		equals: 'Float.NegativeInfinity'.
	self assert: (self printString: Float nan decimalPlaces: 1) equals: 'Float.NaN'.
	self assert: (self printString: Float nan decimalPlaces: 0) equals: 'Float.NaN'.
	self assert: (self printString: Float nan negated decimalPlaces: 2) equals: 'Float.NaN'!

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
	self assert: Float nan printString equals: 'Float.NaN'.
	self assert: Float nan negated printString equals: 'Float.NaN'!

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
	self assert: (Float.Infinity raisedTo: 2) equals: Float.Infinity.
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
	self shouldRaiseOverflow: [Float fmax raisedTo: 2] withContinuation: Float.Infinity!

testRaisedToInteger
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
	self shouldRaiseZeroDivide: [-0.0 raisedToInteger: -1] withContinuation: Float.NegativeInfinity.
	self assert: (-2.0 raisedToInteger: 0) equals: 1.0.
	self assert: (-2.0 raisedToInteger: 1) equals: -2.0.
	self assert: (-2.0 raisedToInteger: 4) equals: 16.0.
	self assert: (-2.0 raisedToInteger: -1) equals: -0.5.
	self assert: (-2.0 raisedToInteger: -4) equals: 0.0625!

testReadFrom
	308 to: -316
		do: 
			[:each |
			self assert: (Float readFrom: ('1.0e-<d>' expandMacrosWith: each) readStream) equals: 10.0 ** each].
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
	self shouldRaiseZeroDivide: [0.0 reciprocal].
	self shouldRaiseZeroDivide: [-0.0 reciprocal] withContinuation: Float negativeInfinity.
	self assert: Float fmax reciprocal bitRepresentation equals: 16r4000000000000.
	self assert: Float fminNormalized reciprocal bitRepresentation equals: 16r7FD0000000000000.
	Float denormalized ifTrue: [self shouldRaiseOverflow: [Float fminDenormalized reciprocal]].
	self assert: Float pi reciprocal reciprocal equals: Float pi!

testRounded
	"5000000000000001 asFloat has an exact representation (no round off error).
	It should round to nearest integer without loosing bits."

	| x y int r |
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

	"a random test"
	r := Random new.
	10000 timesRepeat: 
			[x := r next * 1.9999e16 + 1.0e12.
			self assert: x rounded equals: x asTrueFraction rounded.
			self assert: x negated rounded equals: x negated asTrueFraction rounded]!

testSign
	self assert: 0.0 sign equals: 0.
	self assert: 1.0 sign equals: 1.
	self assert: -1.0 sign equals: -1.
	self assert: Float negativeZero sign equals: -1.
	self assert: Float fmax sign equals: 1.
	self assert: Float fmax negated sign equals: -1.
	self assert: Float fminNormalized sign equals: 1.
	self assert: Float fminDenormalized sign equals: 1.
	self assert: Float fminNormalized negated sign equals: -1.
	self assert: Float infinity sign equals: 1.
	self assert: Float negativeInfinity sign equals: -1.
	Float denormalized ifTrue: [self assert: Float fminDenormalized negated sign equals: -1]!

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
	self assert: Float nan significandAsInteger > 0!

testSin
	| oneEighty |
	oneEighty := Float pi / 2.
	self assert: oneEighty sin equals: 1.0.
	self assert: oneEighty negated sin equals: -1.0.
	self assert: 0.0 sin equals: 0.0.
	self assertNegativeZero: -0.0 sin.
	self assert: ((Float pi / 6) sin roundTo: Float.SignificantDifference) equals: 0.5!

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
			self assert: actual * actual equals: Float fminDenormalized]!

testTimesTwoPower
	self assert: (1.0 timesTwoPower: 16) equals: 2 ** 16.
	self assert: (1.0 timesTwoPower: -1) equals: 0.5.
	self assert: (1.0 timesTwoPower: Float emax) equals: 2 ** Float emax.
	self assert: (-1.0 timesTwoPower: Float emax) equals: -2 ** Float emax.
	self assert: (0.0 timesTwoPower: 10) equals: 0.0.
	self assertNegativeZero: (-0.0 timesTwoPower: 10).
	self assert: (Float.Infinity timesTwoPower: 10) equals: Float.Infinity.
	self assert: (Float.NegativeInfinity timesTwoPower: 10) equals: Float.NegativeInfinity.
	self assert: (Float.NaN timesTwoPower: 10) isNaN.
	self shouldRaiseOverflow: [1.0 timesTwoPower: Float emax + 1]!

testUnderflow
	self shouldRaiseUnderflow: [Float fmin * 0.1]
!

testZeroDivide
	| cases mask |
	cases := {Float fminNormalized. Float fmax. Float pi}.
	Float denormalized ifTrue: [cases := cases copyWith: Float fminDenormalized].
	cases do: 
			[:each |
			self shouldRaiseZeroDivide: [each / 0.0].
			self shouldRaiseZeroDivide: [each / -0.0] withContinuation: Float negativeInfinity.
			self shouldRaiseZeroDivide: [each / 0].
			self shouldRaiseZeroDivide: [each negated / 0.0] withContinuation: Float negativeInfinity.
			self shouldRaiseZeroDivide: [each negated / -0.0].
			self shouldRaiseZeroDivide: [each negated / 0] withContinuation: Float negativeInfinity].
	self shouldRaiseZeroDivide: [1 / 0.0].
	self shouldRaiseZeroDivide: [1 / -0.0] withContinuation: Float negativeInfinity.
	self assert: (Float nan / 0.0) isNaN.
	self assert: (Float nan / -0.0) isNaN.
	"Note that division of zero by zero is handled differently by the CPU (by design, judging
	from the docs). It is reported as an InvalidOperation rather than Divide-by-Zero. We
	translate this oddity to a ZeroDivide exception when the fp exception is reported (which
	only occurs if Invalid is unmasked)"
	mask := Float exceptionMask.
	Float exceptionMask: (mask maskSet: CRTConstants._EM_ZERODIVIDE).
	
	[#(0.0 -0.0) do: 
			[:each |
			self shouldRaiseInvalidOperation: [each / 0.0].
			self shouldRaiseInvalidOperation: [each / -0.0]]]
			ensure: [Float exceptionMask: mask]! !
!FloatTest categoriesFor: #assertNegativeZero:!helpers!private! !
!FloatTest categoriesFor: #finiteSignificand:!helpers!private! !
!FloatTest categoriesFor: #normals!constants!private! !
!FloatTest categoriesFor: #predecessor:!helpers!private! !
!FloatTest categoriesFor: #printString:decimalPlaces:!helpers!private! !
!FloatTest categoriesFor: #printString:significantFigures:!helpers!private! !
!FloatTest categoriesFor: #setUp!private!Running! !
!FloatTest categoriesFor: #shouldRaiseInvalidOperation:!helpers!private! !
!FloatTest categoriesFor: #shouldRaiseOverflow:!helpers!private! !
!FloatTest categoriesFor: #shouldRaiseOverflow:withContinuation:!helpers!private! !
!FloatTest categoriesFor: #shouldRaiseUnderflow:!helpers!private! !
!FloatTest categoriesFor: #shouldRaiseZeroDivide:!helpers!private! !
!FloatTest categoriesFor: #shouldRaiseZeroDivide:withContinuation:!helpers!private! !
!FloatTest categoriesFor: #successor:!helpers!private! !
!FloatTest categoriesFor: #tearDown!private!Running! !
!FloatTest categoriesFor: #testAbs!public!unit tests! !
!FloatTest categoriesFor: #testAdd!public!unit tests! !
!FloatTest categoriesFor: #testArcTan!public!unit tests! !
!FloatTest categoriesFor: #testArcTan2!public!unit tests! !
!FloatTest categoriesFor: #testAsInteger!public!unit tests! !
!FloatTest categoriesFor: #testAsTrueFraction!public!Testing! !
!FloatTest categoriesFor: #testCeiling!public!unit tests! !
!FloatTest categoriesFor: #testCos!public!unit tests! !
!FloatTest categoriesFor: #testEqualsColon!public!unit tests! !
!FloatTest categoriesFor: #testExp!public!unit tests! !
!FloatTest categoriesFor: #testExponent!public!unit tests! !
!FloatTest categoriesFor: #testFloatCharacterization!public!unit tests! !
!FloatTest categoriesFor: #testFloor!public!unit tests! !
!FloatTest categoriesFor: #testFractionAsFloat!public!Testing! !
!FloatTest categoriesFor: #testFractionComparisons!public!unit tests! !
!FloatTest categoriesFor: #testFractionPart!public!unit tests! !
!FloatTest categoriesFor: #testHash!public!unit tests! !
!FloatTest categoriesFor: #testInfinityComparisons!public!unit tests! !
!FloatTest categoriesFor: #testIntegerAsFloat!public!Testing! !
!FloatTest categoriesFor: #testIntegerComparisons!public!unit tests! !
!FloatTest categoriesFor: #testIntegerPart!public!unit tests! !
!FloatTest categoriesFor: #testIsFinite!public!unit tests! !
!FloatTest categoriesFor: #testIsInfinite!public!unit tests! !
!FloatTest categoriesFor: #testIsLiteral!public!unit tests! !
!FloatTest categoriesFor: #testIsNan!public!unit tests! !
!FloatTest categoriesFor: #testIsZero!public!unit tests! !
!FloatTest categoriesFor: #testLn!public!unit tests! !
!FloatTest categoriesFor: #testLog!public!unit tests! !
!FloatTest categoriesFor: #testNaNComparisons!public!unit tests! !
!FloatTest categoriesFor: #testNegated!public!unit tests! !
!FloatTest categoriesFor: #testOverflow!public!unit tests! !
!FloatTest categoriesFor: #testPredecessorSuccessor!public!unit tests! !
!FloatTest categoriesFor: #testPrintOnDecimalPlaces!public!unit tests! !
!FloatTest categoriesFor: #testPrintOnSignificantFigures!public!unit tests! !
!FloatTest categoriesFor: #testPrintString!public!unit tests! !
!FloatTest categoriesFor: #testPrintStringAndReadBack!public!unit tests! !
!FloatTest categoriesFor: #testRaisedTo!public!unit tests! !
!FloatTest categoriesFor: #testRaisedToInteger!public!unit tests! !
!FloatTest categoriesFor: #testReadFrom!public!unit tests! !
!FloatTest categoriesFor: #testReciprocal!public!unit tests! !
!FloatTest categoriesFor: #testRounded!public!unit tests! !
!FloatTest categoriesFor: #testSign!public!unit tests! !
!FloatTest categoriesFor: #testSignificandAsInteger!public!unit tests! !
!FloatTest categoriesFor: #testSin!public!unit tests! !
!FloatTest categoriesFor: #testSqrt!public!unit tests! !
!FloatTest categoriesFor: #testTimesTwoPower!public!Testing! !
!FloatTest categoriesFor: #testUnderflow!public!unit tests! !
!FloatTest categoriesFor: #testZeroDivide!public!unit tests! !

!FloatTest class methodsFor!

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
!FloatTest class categoriesFor: #predecessor:!helpers!private! !
!FloatTest class categoriesFor: #successor:!helpers!private! !
!FloatTest class categoriesFor: #ulp:!helpers!private! !


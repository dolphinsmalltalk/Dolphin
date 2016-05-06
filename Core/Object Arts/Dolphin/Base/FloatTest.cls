"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #FloatTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
FloatTest guid: (GUID fromString: '{B2B95B67-E8F3-4991-A4B4-94EDC5E83F28}')!
FloatTest comment: ''!
!FloatTest categoriesForClass!Unclassified! !
!FloatTest methodsFor!

getBinaryRepresentation: aFloat
	^VMLibrary default makeLargeUnsigned: aFloat!

infinity
	^#[0 0 0 0 0 0 16rF0 16r7F] copy becomeA: Float!

nan
	^#[0 0 0 0 0 0 16rF8 16rFF] copy becomeA: Float!

negativeInfinity
	^#[0 0 0 0 0 0 16rF0 16rFF] copy becomeA: Float!

normals
	^(OrderedCollection new)
		add: Float pi;
		add: Float pi / 100;
		add: Float pi * 100;
		add: Float fmax;
		add: Float fmin;
		add: Float fmax negated;
		add: Float fmin negated;
		add: Float negativeZero;
		add: 0.0;
		asArray!

predecessor: aFloat
	| ulp |
	aFloat isFinite
		ifFalse: 
			[(aFloat isNaN or: [aFloat negative]) ifTrue: [^self].
			^Float fmax].
	ulp := self ulp: aFloat.
	^aFloat - (0.5 * ulp) = aFloat ifTrue: [aFloat - ulp] ifFalse: [aFloat - (0.5 * ulp)]!

setUp
	Float reset.
	super setUp!

shouldRaiseOverflow: aBlock
	| raised |
	Float reset.
	raised := false.
	aBlock 
		on: FloatingPointException do: [:e | e isOverflow ifTrue: [raised := true]]
		on: HRESULTError do: [:e | e hresult asInteger = -2147352566 ifTrue: [raised := true]].
	self assert: raised!

shouldRaiseUnderflow: aBlockClosure
	| answer oldMask |
	Float reset.
	oldMask := Processor activeProcess 
				fpeMask: (Processor activeProcess fpeMask maskClear: _EM_UNDERFLOW).
	
	[answer := self 
				should: aBlockClosure
				raise: FloatingPointException
				matching: [:e | e isUnderflow]] 
			ensure: [Processor activeProcess fpeMask: oldMask].
	^answer!

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

tearDown
	Float reset.
	super tearDown!

testAdd
	self assert: 1.0 + 1.0 equals: 2.0.
	self assert: 1.0 + 1.5 equals: 2.5.
	self assert: 1.0 + 1 equals: 2.0.
	self assert: 1.0 + (3 / 2) equals: 2.5!

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

testExponent
	self assert: 0.0 exponent equals: -1.
	self assert: Float negativeZero exponent equals: -1.
	self assert: 1.0 exponent equals: 0.
	self assert: 2.0 exponent equals: 1.
	self assert: -2.0 exponent equals: 1.
	self assert: (self predecessor: 4.0) exponent equals: 1.
	self assert: Float fminDenormalized exponent equals: -1074.
	self assert: Float fminDenormalized negated exponent equals: -1074.
	self assert: 4.0 exponent equals: 2.
	self assert: -4.0 exponent equals: 2.
	self assert: 0.5 exponent equals: -1.
	self assert: -0.5 exponent equals: -1.
	self assert: 0.25 exponent equals: -2.
	self assert: -0.25 exponent equals: -2.
	self assert: Float fmax exponent equals: Float emax.
	self assert: Float fminNormalized exponent equals: Float emin!

testFiniteSignificand
	"There are 52 bits used for representing the mantissa (plus an eventual leading 1, see below)"

	| mantissaBits denormalPowersOfTwo denormals exceptionals normalPowersOfTwo normals |
	mantissaBits := Float precision - 1.
	normals := Array
				with: Float pi
				with: Float pi * 100.0
				with: Float pi / -100.0
				with: Float fmax
				with: Float fminNormalized.
	denormals := Array
				with: 0.0
				with: Float negativeZero
				with: (self predecessor: Float fminDenormalized)
				with: Float fminDenormalized negated.
	exceptionals := Array
				with: self nan
				with: self infinity
				with: self negativeInfinity.
	normalPowersOfTwo := (-10 to: 10) collect: [:i | 1.0 timesTwoPower: i].
	denormalPowersOfTwo := (Float emin - mantissaBits to: Float emin - 1)
				collect: [:i | 1.0 timesTwoPower: i].
	normals do: 
			[:aNormalFloat |
			"Assume the mantissa is written in least 52 bits of hex format, with an implied 1 on position 53"
			self assert: (((self getBinaryRepresentation: aNormalFloat) bitAnd: (1 << mantissaBits) - 1)
						bitOr: 1 << mantissaBits)
				equals: aNormalFloat significandAsInteger].
	denormals , exceptionals do: 
			[:aDenormalOrExceptionalFloat |
			"For every other Float, zero, denormal or exceptional, no implied leading one"
			self
				assert: ((self getBinaryRepresentation: aDenormalOrExceptionalFloat) bitAnd: (1 << mantissaBits) - 1)
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
				equals: aDenormalPowerOfTwoFloat significandAsInteger - 1].

	"Well known value for a few extremal cases"
	self assert: Float fmax significandAsInteger equals: (1 << Float precision) - 1.
	self assert: Float fminDenormalized significandAsInteger equals: 1.
	self assert: 0.0 significandAsInteger equals: 0.
	self assert: self infinity significandAsInteger equals: 0.
	self assert: self nan significandAsInteger > 0.0!

testFloatAsTrueFraction
	"check if gradual underflow is correctly handled"

	self assert: (10.0 ** -316) asTrueFraction asFloat equals: 10.0 ** -316.
	self assert: Float fminDenormalized asTrueFraction equals: 1 / (1 << 1074).
	self assert: Float fminDenormalized asTrueFraction
		equals: (1 << (Float precision - Float emin - 1)) reciprocal.
	self assert: Float fminDenormalized asTrueFraction asFloat equals: Float fminDenormalized!

testFloatCharacterization
	self assert: Float radix equals: 2.
	self assert: Float precision equals: 53.

	"Check expressions from ANSI standard - note comparison against integer/fractional result"
	self assert: Float epsilon equals: (Float radix raisedTo: 1 - Float precision).
	Float denormalized
		ifTrue: 
			[self assert: Float fminDenormalized equals: (Float radix raisedTo: Float emin - Float precision)].
	self assert: Float fminNormalized equals: (Float radix raisedTo: Float emin).
	self assert: Float fmax
		equals: (1 - (Float radix raisedTo: Float precision negated))
				* (Float radix raisedTo: Float emax + 1)!

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
					asFloat equals: 0.69314743055982)!

testFractionComparisons
	(Array
		with: 1 / 2
		with: 1 / 3
		with: 1 / 10) do: 
				[:each |
				self assert: each asFloat equals: each.
				self assert: each asFloat hash equals: each hash].
	"This will overflow on conversion to a Fraction, just a kick the tyres test really"
	self assert: (((200 factorial - 1) / 2) hash isKindOf: SmallInteger)!

testHash
	#'685'.
	#(##(SmallInteger minimum) 0 1 ##(SmallInteger maximum) ##(SmallInteger maximum + 1) ##(20
		factorial)) do: 
				[:each |
				self assert: each equals: each asFloat.
				self assert: each asFloat hash equals: each hash].
	self assert: 1 hash equals: 1.0 hash.
	self assert: (1 / 2) hash equals: 0.5 hash.
	self assert: 0.5 equals: 1 / 2!

testIntegerAsFloat
	"assert IEEE 754 round to nearest even mode is honoured"

	self deny: 16r1FFFFFFFFFFFF0801 asFloat = 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 65 bits"
	self deny: 16r1FFFFFFFFFFFF0802 asFloat = 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 64 bits"
	self assert: 16r1FFFFFFFFFFF1F800 asFloat equals: 16r1FFFFFFFFFFF20000 asFloat.	"nearest even is upper"
	self assert: 16r1FFFFFFFFFFFF0800 asFloat equals: 16r1FFFFFFFFFFFF0000 asFloat	"nearest even is lower"!

testIntegerComparisons
	#(-16rFFFFFFFF -16r40000001 -16r40000000 -1 0 1 16r3FFFFFFF 16r3FFFFFFF 16r40000000 16rFFFFFFFF 16r100000000000004 16r100000000000005 -16r4000000000000001 -16r4000000000000000 ##(2
		** Float precision - 1) ##(2 ** Float precision + 1) ##(2 ** 63 - 1) ##(2 ** 64) ##(-1 * (2 ** 64)))
		do: 
			[:each |
			self assert: each asFloat equals: each.
			self assert: (each hash isKindOf: SmallInteger).
			self assert: each asFloat hash equals: each hash.
			self assert: (each hash = 0 or: [each hash sign = each sign])]!

testIsFinite
	self deny: self negativeInfinity isFinite.
	self deny: self infinity isFinite.
	self deny: self nan isFinite.
	self normals do: [:each | self assert: each isFinite].
	self assert: Float fminDenormalized isFinite!

testIsInfinite
	self assert: self negativeInfinity isInfinite.
	self assert: self infinity isInfinite.
	self deny: self nan isInfinite.
	self normals do: [:each | self deny: each isInfinite].
	self deny: Float fminDenormalized isInfinite!

testIsLiteral
	self normals do: [:each | self assert: each isLiteral].
	self assert: Float fminDenormalized isLiteral.
	self deny: self nan isLiteral.
	self deny: self infinity isLiteral.
	self deny: self negativeInfinity isLiteral!

testIsNan
	self deny: self negativeInfinity isNaN.
	self deny: self infinity isNaN.
	self assert: self nan isNaN.
	self normals do: [:each | self deny: each isNaN]!

testIsZero
	self assert: 0.0 isZero.
	self deny: 0.1 isZero.
	self assert: Float negativeZero isZero!

testLog
	self assert: (10.0 raisedTo: 2.0 log) equals: 2.0.
	self assert: 1000.0 log truncated equals: 3!

testOverflow
	self shouldRaiseOverflow: [Float fmax * 2].
	self shouldRaiseOverflow: [Float fmax * -2].
	self shouldRaiseOverflow: [Float fmax * 2.0].
	self shouldRaiseOverflow: [Float fmax * -2.0].
	self shouldRaiseOverflow: [Float fmax * SmallInteger maximum].
	self shouldRaiseOverflow: [Float fmax * SmallInteger minimum].
	self shouldRaiseOverflow: [Float fmax + Float fmax].
!

testPrintOnDecimalPlaces
	| stream |
	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 4.
	self assert: stream contents equals: '3.9990'.
	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 3.
	self assert: stream contents equals: '3.999'.
	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 2.
	self assert: stream contents equals: '4.00'.
	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 1.
	self assert: stream contents equals: '4.0'.

	"Defect #373 - produced 3"
	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 0.
	self assert: stream contents equals: '4'!

testPrintString
	self assert: 1.3 printString equals: '1.3'.
	self assert: (4.0 / 3.0) printString equals: '1.3333333333333333'.
	self assert: Float negativeZero printString equals: '-0.0'.
	self assert: Float pi printString equals: '3.141592653589793'.
	self assert: Float fminNormalized printString equals: '2.2250738585072014e-308'.
	self assert: Float fminDenormalized printString equals: '5.0e-324'.
	self assert: Float fmax printString equals: '1.7976931348623157e308'.
	self assert: self infinity printString equals: 'Infinity'.
	self assert: self negativeInfinity printString equals: '-Infinity'.
	self assert: self nan printString equals: 'NaN'!

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
					f printOn: str significantFigures: 17.
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
			f printOn: str significantFigures: 17.
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
			f printOn: str significantFigures: 17.
			self assert: (Float readFrom: str contents readStream) equals: f]!

testReadFrom
	308 to: -316
		do: 
			[:each |
			self assert: (Float readFrom: ('1.0e-<d>' expandMacrosWith: each) readStream) equals: 10.0 ** each].
	self normals , (Array with: Float fminDenormalized)
		do: [:each | self assert: (Float readFrom: each printString readStream) equals: each]!

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
	self assert: Float fminDenormalized negated sign equals: -1.
	self assert: self infinity sign equals: 1.
	self assert: self negativeInfinity sign equals: -1!

testUnderflow
	self shouldRaiseUnderflow: [Float fmin * 0.1]
!

testZeroDivide
	self shouldRaiseZeroDivide: [Float fmin / 0.0].
	self shouldRaiseZeroDivide: [Float fmax / 0.0].
	self shouldRaiseZeroDivide: [Float fmin / 0].
	self shouldRaiseZeroDivide: [Float fmax / 0].
	self shouldRaiseZeroDivide: [1.0 / 0.0].
	self shouldRaiseZeroDivide: [1.0 / 0].
	self shouldRaiseZeroDivide: [1 / 0.0].

!

ulp: aFloat
	"Answer the unit of least precision of the Float argument (the power of two corresponding to last bit of mantissa)"

	| exponent |
	aFloat isFinite ifFalse: [^aFloat abs].
	aFloat = 0.0 ifTrue: [^Float fminDenormalized].
	exponent := aFloat exponent.
	^exponent < Float emin
		ifTrue: [Float fminDenormalized]
		ifFalse: [Float epsilon timesTwoPower: exponent]! !
!FloatTest categoriesFor: #getBinaryRepresentation:!helpers!private! !
!FloatTest categoriesFor: #infinity!constants!private! !
!FloatTest categoriesFor: #nan!constants!private! !
!FloatTest categoriesFor: #negativeInfinity!constants!private! !
!FloatTest categoriesFor: #normals!constants!private! !
!FloatTest categoriesFor: #predecessor:!helpers!private! !
!FloatTest categoriesFor: #setUp!private!Running! !
!FloatTest categoriesFor: #shouldRaiseOverflow:!helpers!private! !
!FloatTest categoriesFor: #shouldRaiseUnderflow:!helpers!private! !
!FloatTest categoriesFor: #successor:!helpers!private! !
!FloatTest categoriesFor: #tearDown!private!Running! !
!FloatTest categoriesFor: #testAdd!public!unit tests! !
!FloatTest categoriesFor: #testEqualsColon!public!unit tests! !
!FloatTest categoriesFor: #testExponent!public!unit tests! !
!FloatTest categoriesFor: #testFiniteSignificand!public!unit tests! !
!FloatTest categoriesFor: #testFloatAsTrueFraction!public!Testing! !
!FloatTest categoriesFor: #testFloatCharacterization!public!unit tests! !
!FloatTest categoriesFor: #testFractionAsFloat!public!Testing! !
!FloatTest categoriesFor: #testFractionComparisons!public!unit tests! !
!FloatTest categoriesFor: #testHash!public!unit tests! !
!FloatTest categoriesFor: #testIntegerAsFloat!public!Testing! !
!FloatTest categoriesFor: #testIntegerComparisons!public!unit tests! !
!FloatTest categoriesFor: #testIsFinite!public!unit tests! !
!FloatTest categoriesFor: #testIsInfinite!public!unit tests! !
!FloatTest categoriesFor: #testIsLiteral!public!unit tests! !
!FloatTest categoriesFor: #testIsNan!public!unit tests! !
!FloatTest categoriesFor: #testIsZero!public!unit tests! !
!FloatTest categoriesFor: #testLog!public!unit tests! !
!FloatTest categoriesFor: #testOverflow!public!unit tests! !
!FloatTest categoriesFor: #testPrintOnDecimalPlaces!public!unit tests! !
!FloatTest categoriesFor: #testPrintString!public!unit tests! !
!FloatTest categoriesFor: #testPrintStringAndReadBack!public!unit tests! !
!FloatTest categoriesFor: #testReadFrom!public! !
!FloatTest categoriesFor: #testSign!public!unit tests! !
!FloatTest categoriesFor: #testUnderflow!public!unit tests! !
!FloatTest categoriesFor: #testZeroDivide!public!unit tests! !
!FloatTest categoriesFor: #ulp:!helpers!private! !


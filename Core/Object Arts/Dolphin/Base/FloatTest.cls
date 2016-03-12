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

tearDown
	Float reset.
	super tearDown!

testAdd
	self assert: (1.0 + 1.0) = 2.0.
	self assert: (1.0 + 1.5) = 2.5.
	self assert: (1.0 + 1) = 2.0.
	self assert: (1.0 + (3/2)) = 2.5

!

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

testFloatAsTrueFraction
        "check if gradual underflow is correctly handled"

	self assert: (10.0 ** -316) asTrueFraction asFloat = (10.0 ** -316).
	self assert: Float fminDenormalized asTrueFraction = (1 / (1 << 1074)).
	self 
		assert: Float fminDenormalized asTrueFraction = (1 << (Float precision - Float emin)) reciprocal.
	self assert: Float fminDenormalized asTrueFraction asFloat = Float fminDenormalized!

testFloatCharacterization
	self assert: Float radix = 2.
	self assert: Float precision = 53.

	"Check expressions from ANSI standard - note comparison against integer/fractional result"
	self assert: Float epsilon = (Float radix raisedTo: 1 - Float precision).
	Float denormalized 
		ifTrue: 
			[self 
				assert: Float fminDenormalized = (Float radix raisedTo: Float emin - Float precision)].
	self assert: Float fminNormalized = (Float radix raisedTo: Float emin - 1).
	self 
		assert: Float fmax = ((1 - (Float radix raisedTo: Float precision negated)) 
						* (Float radix raisedTo: Float emax))!

testFloatPrintString
	"Debug reading/printing a Floating point number without accumulating
round off errors"

	| b r |
	b := ByteArray new: 8.
	r := RandomLinearCongruential
		newModulus: 16r100000000
		multiplier: 16r0F010800F
		increment: 16r00005F2ED.
	r seed: 1234567.
	100
		timesRepeat: [| f str |
			b basicDwordAtOffset: 4 put: (r next; seed) - 1.
			b basicDwordAtOffset: 0 put: (r next; seed) - 1.
			((b basicDwordAtOffset: 4) bitAnd: 16r7FF00000) = 16r7FF00000
				ifFalse: ["avoid nan and infinity"
					f := b doubleAtOffset: 0.
					str := (String new: 64) writeStream.
					f printOn: str significantFigures: 17.
					self assert: (Float readFrom: str contents readStream) = f]].
	"test big num near infinity"
	10
		timesRepeat: [| f str |
			b basicDwordAtOffset: 4 put: 16r7FE00000 + ((r next; seed) //
16r1000 - 1).
			b basicDwordAtOffset: 0 put: (r next; seed) - 1.
			f := b doubleAtOffset: 0.
			str := (String new: 64) writeStream.
			f printOn: str significantFigures: 17.
			self assert: (Float readFrom: str contents readStream) = f].
	"test infinitesimal (gradual underflow)"
	10
		timesRepeat: [| f str |
			b basicDwordAtOffset: 4 put: 0 + ((r next; seed) // 16r1000 - 1).
			b basicDwordAtOffset: 0 put: (r next; seed) - 1.
			f := b doubleAtOffset: 0.
			str := (String new: 64) writeStream.
			f printOn: str significantFigures: 17.
			self assert: (Float readFrom: str contents readStream) = f].!

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
				self assert: each asFloat = each.
				self assert: each asFloat hash = each hash].
	"This will overflow on conversion to a Fraction, just a kick the tyres test really"
	self assert: (((200 factorial - 1) / 2) hash isKindOf: SmallInteger)!

testHash
	#'685'.
	#(##(SmallInteger minimum) 0 1 ##(SmallInteger maximum) ##(SmallInteger maximum + 1) ##(20 
		factorial)) do: 
				[:each | 
				self assert: each = each asFloat.
				self assert: each asFloat hash = each hash].
	self assert: 1 hash = 1.0 hash.
	self assert: (1 / 2) hash = 0.5 hash.
	self assert: 0.5 = (1 / 2)!

testIntegerAsFloat
	"assert IEEE 754 round to nearest even mode is honoured"

	self deny: 16r1FFFFFFFFFFFF0801 asFloat = 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 65 bits"
	self deny: 16r1FFFFFFFFFFFF0802 asFloat = 16r1FFFFFFFFFFFF0800 asFloat.	"this test is on 64 bits"
	self assert: 16r1FFFFFFFFFFF1F800 asFloat = 16r1FFFFFFFFFFF20000 asFloat.	"nearest even is upper"
	self assert: 16r1FFFFFFFFFFFF0800 asFloat = 16r1FFFFFFFFFFFF0000 asFloat	"nearest even is lower"!

testIntegerComparisons
	#(-16rFFFFFFFF -16r40000001 -16r40000000 -1 0 1 16r3FFFFFFF 16r3FFFFFFF 16r40000000 16rFFFFFFFF 16r100000000000004 16r100000000000005 -16r4000000000000001 -16r4000000000000000 ##(2 
		** Float precision - 1) ##(2 ** Float precision + 1) ##(2 ** 63 - 1) ##(2 ** 64) ##(-1 
		* (2 ** 64))) do: 
				[:each | 
				self assert: each asFloat = each.
				self assert: (each hash isKindOf: SmallInteger).
				self assert: each asFloat hash = each hash.
				self assert: (each hash = 0 or: [each hash sign = each sign])]!

testIsZero
	self assert: 0.0 isZero.
	self deny: 0.1 isZero!

testLog
	self assert: (10.0 raisedTo: 2.0 log) = 2.0.
	self assert: 1000.0 log truncated = 3!

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
	self assert: stream contents = '3.9990'.

	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 3.
	self assert: stream contents = '3.999'.

	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 2.
	self assert: stream contents = '4.00'.

	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 1.
	self assert: stream contents = '4.0'.

	"Defect #373 - produced 3"
	stream := String writeStream.
	3.999 printOn: stream decimalPlaces: 0.
	self assert: stream contents = '4'.
!

testPrintString
	| b r |
	self assert: 1.3 printString = '1.3'.
	self assert: (4.0 / 3.0) printString = '1.33333333333333'!

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
					self assert: (Float readFrom: str contents readStream) = f]].
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
			self assert: (Float readFrom: str contents readStream) = f].
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
			self assert: (Float readFrom: str contents readStream) = f]!

testReadFrom
	308 to: -316
		do: [:each | self assert: (Float readFrom: ('1.0e-<d>' expandMacrosWith: each) readStream) = (10.0 ** each)]!

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

! !
!FloatTest categoriesFor: #setUp!private!Running! !
!FloatTest categoriesFor: #shouldRaiseOverflow:!helpers!private! !
!FloatTest categoriesFor: #shouldRaiseUnderflow:!helpers!private! !
!FloatTest categoriesFor: #tearDown!private!Running! !
!FloatTest categoriesFor: #testAdd!public!unit tests! !
!FloatTest categoriesFor: #testEqualsColon!public!unit tests! !
!FloatTest categoriesFor: #testFloatAsTrueFraction!public!Testing! !
!FloatTest categoriesFor: #testFloatCharacterization!public!unit tests! !
!FloatTest categoriesFor: #testFloatPrintString!public!Testing! !
!FloatTest categoriesFor: #testFractionAsFloat!public!Testing! !
!FloatTest categoriesFor: #testFractionComparisons!public!unit tests! !
!FloatTest categoriesFor: #testHash!public!unit tests! !
!FloatTest categoriesFor: #testIntegerAsFloat!public!Testing! !
!FloatTest categoriesFor: #testIntegerComparisons!public!unit tests! !
!FloatTest categoriesFor: #testIsZero!public!unit tests! !
!FloatTest categoriesFor: #testLog!public!unit tests! !
!FloatTest categoriesFor: #testOverflow!public!unit tests! !
!FloatTest categoriesFor: #testPrintOnDecimalPlaces!public!unit tests! !
!FloatTest categoriesFor: #testPrintString!public!unit tests! !
!FloatTest categoriesFor: #testPrintStringAndReadBack!public!unit tests! !
!FloatTest categoriesFor: #testReadFrom!public! !
!FloatTest categoriesFor: #testUnderflow!public!unit tests! !
!FloatTest categoriesFor: #testZeroDivide!public!unit tests! !


﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.IntegerTest
	subclass: #'Core.Tests.SmallIntegerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.SmallIntegerTest guid: (Core.GUID fromString: '{3fc98bda-cdeb-45ea-a355-2968f5fd5e3a}')!

Core.Tests.SmallIntegerTest comment: ''!

!Core.Tests.SmallIntegerTest methodsFor!

canonicalInstance
	^123!

test1234
	self assert: 3 >= (2@3).
	self deny: 2 >= (2@3)!

testAbs
	self assert: -4 abs identicalTo: 4!

testAllMask

	self assert: (29127 allMask: 20805).
	self assert: (29127 allMask: 21845) not
!

testAnyMask

	self assert: (29127 anyMask: 21845).
!

testBasicNew
	self should: [SmallInteger basicNew] raise: TestResult error!

testBitAnd
	self assert: (29127 bitAnd: 3640) identicalTo: 0!

testBitOr
	self assert: (29127 bitOr: 3640) identicalTo: 32767.
	self assert: (29127 bitOr: 21845) identicalTo: 30167!

testBitShift
	"Bit manipulation (in particular check 32-bitness)"

	self class bitShiftTestCases
		do: [:each | self assert: (each first bitShift: each second) equals: each third].
	"A very large result - be careful not to try and print these"
	self assert: (SmallInteger maximum bitShift: SmallInteger maximum) highBit
		equals: SmallInteger maximum + SmallInteger maximum highBit!

testDecimalDigitLength
	2 to: 10 do: [:i | | subject |
		subject := 10 raisedToInteger: i-1.
		self assert: subject decimalDigitLength equals: i.
		self assert: (subject - 1) decimalDigitLength equals: i-1.
		self assert: (subject + 1) decimalDigitLength equals: i].
	self assert: 0 decimalDigitLength equals: 1.
	self assert: 1 decimalDigitLength equals: 1.
	self assert: 16r3FFFFFFF decimalDigitLength equals: 10!

testDigitLength
	"Note that the digitLength is the number of bytes required to represent the positive magnitude,
	not the 2's complement value."

	#(-255 -129 -128 -1 0 1 127 128 255) do: [:each | self assert: each digitLength identicalTo: 1].
	#(-65535 -256 256 65535) do: [:each | self assert: each digitLength identicalTo: 2].
	#(16rFFFFFF -16rFFFFFF) do: [:each | self assert: each digitLength identicalTo: 3].
	#(16r1000000 -16r1000000) do: [:each | self assert: each digitLength identicalTo: 4].
	"This loop repeats some of the above tests, but those for literal values are left for clarity"
	(2 to: VMConstants.IntPtrSize) collect: 
			[:i |
			| first |
			first := 2 ** ((i - 1) * 8).
			self assert: first digitLength identicalTo: i.
			self assert: (first * -1) digitLength identicalTo: i.
			i == VMConstants.IntPtrSize
				ifFalse: 
					[| last |
					last := 2 ** (i * 8) - 1.
					self assert: last digitLength identicalTo: i.
					self assert: (last * -1) digitLength identicalTo: i]].
	self assert: SmallInteger minimum digitLength equals: VMConstants.IntPtrSize.
	self assert: SmallInteger maximum digitLength equals: VMConstants.IntPtrSize!

testDivide
	self assert: 6 / 2 identicalTo: 3.
	self assert: 7 / 2 equals: (Fraction numerator: 7 denominator: 2)!

testEven
	#(-1073741824 -2 0 4 32768 1073741822) do: 
			[:each | 
			self assert: each even.
			self deny: (each + 1) even]!

testExp10
	| expected |
	self assert: -2 exp10 equals: 1 / 100.
	self assert: -1 exp10 equals: 1 / 10.
	self assert: 0 exp10 equals: 1.
	expected := 10.
	1 to: 50
		do: 
			[:i |
			self assert: i exp10 equals: expected.
			expected := expected * 10]!

testGcd
	self assert: (55 gcd: 30) identicalTo: 5!

testGreaterOrEqualPoint
	self assert: 3 >= (2@3).
	self deny: 2 >= (2@3)!

testGreaterOrEqualToFloat
	| pos neg zero |
	pos := SmallInteger maximum.
	neg := SmallInteger minimum.
	"+ve"
	self deny: (pos greaterOrEqualToFloat: Float infinity).
	self deny: (pos greaterOrEqualToFloat: Float nan).
	self assert: (pos greaterOrEqualToFloat: Float negativeInfinity).
	self assert: (pos greaterOrEqualToFloat: Float negativeZero).
	self assert: (pos greaterOrEqualToFloat: Float zero).
	self deny: (pos greaterOrEqualToFloat: Float fmax).
	self assert: (pos greaterOrEqualToFloat: Float fmin).
	self assert: (pos greaterOrEqualToFloat: Float fminDenormalized).
	self assert: (pos greaterOrEqualToFloat: pos asFloat).
	self assert: (pos greaterOrEqualToFloat: neg asFloat).
	"-ve"
	self deny: (neg greaterOrEqualToFloat: Float infinity).
	self deny: (neg greaterOrEqualToFloat: Float nan).
	self assert: (neg greaterOrEqualToFloat: Float negativeInfinity).
	self deny: (neg greaterOrEqualToFloat: Float negativeZero).
	self deny: (neg greaterOrEqualToFloat: Float zero).
	self deny: (neg greaterOrEqualToFloat: Float pi).
	self deny: (neg greaterOrEqualToFloat: pos asFloat).
	self assert: (neg greaterOrEqualToFloat: neg asFloat).
	self deny: (neg greaterOrEqualToFloat: Float fmin negated).
	self deny: (neg greaterOrEqualToFloat: Float fminDenormalized negated).
	self assert: (neg greaterOrEqualToFloat: Float fmax negated).
	"Zero"
	zero := 0.
	self deny: (zero greaterOrEqualToFloat: Float infinity).
	self deny: (zero greaterOrEqualToFloat: Float nan).
	self assert: (zero greaterOrEqualToFloat: Float negativeInfinity).
	self assert: (zero greaterOrEqualToFloat: Float negativeZero).
	self assert: (zero greaterOrEqualToFloat: Float zero).
	self assert: (zero greaterOrEqualToFloat: Float fmin negated).
	self assert: (zero greaterOrEqualToFloat: Float fminDenormalized negated).
	self assert: (zero greaterOrEqualToFloat: Float fmax negated)!

testGreaterThanFloat
	| pos neg zero |
	pos := 3.
	neg := -3.
	"+ve"
	self deny: (pos greaterThanFloat: Float infinity).
	self deny: (pos greaterThanFloat: Float nan).
	self assert: (pos greaterThanFloat: Float negativeInfinity).
	self assert: (pos greaterThanFloat: Float negativeZero).
	self assert: (pos greaterThanFloat: Float zero).
	self deny: (pos greaterThanFloat: Float fmax).
	self assert: (pos greaterThanFloat: Float fmin).
	self assert: (pos greaterThanFloat: Float fminDenormalized).
	self deny: (pos greaterThanFloat: Float pi).
	self deny: (pos greaterThanFloat: pos asFloat).
	self assert: (pos greaterThanFloat: neg asFloat).
	"-ve"
	self deny: (neg greaterThanFloat: Float infinity).
	self deny: (neg greaterThanFloat: Float nan).
	self assert: (neg greaterThanFloat: Float negativeInfinity).
	self deny: (neg greaterThanFloat: Float negativeZero).
	self deny: (neg greaterThanFloat: Float zero).
	self deny: (neg greaterThanFloat: Float pi).
	self deny: (neg greaterThanFloat: pos asFloat).
	self deny: (neg greaterThanFloat: neg asFloat).
	self deny: (neg greaterThanFloat: Float fmin negated).
	self deny: (neg greaterThanFloat: Float fminDenormalized negated).
	self assert: (neg greaterThanFloat: Float fmax negated).
	"zero"
	zero := 0.
	self deny: (zero greaterThanFloat: Float infinity).
	self deny: (zero greaterThanFloat: Float nan).
	self assert: (zero greaterThanFloat: Float negativeInfinity).
	self deny: (zero greaterThanFloat: Float negativeZero).
	self deny: (zero greaterThanFloat: Float zero).
	self assert: (zero greaterThanFloat: Float fmin negated).
	self assert: (zero greaterThanFloat: Float fminDenormalized negated).
	self assert: (zero greaterThanFloat: Float fmax negated)!

testHighBit
	self should: [-1 highBit] raise: Error.
	self assert: 0 highBit equals: 0.
	0 to: 30 do: [:each | self assert: (2 ** each) highBit equals: each + 1].
	self assert: SmallInteger maximum highBit equals: 30!

testIntegerDivide
	"Note that divide by -1 can overflow SmallInteger to LargeInteger if dividing SmallInteger minimum"

	self class integerDivideTestCases
		do: [:each | self assert: each first // each second equals: each third].
	{1. -1. SmallInteger maximum. SmallInteger minimum} do: 
			[:each |
			self should: [each // 0] raise: ZeroDivide.
			self should: [each // 0.0] raise: ZeroDivide].
	self should: [0 // 0] raise: ZeroDivide!

testIsInt16
	self assert: 0 isInt16.
	self assert: 1 isInt16.
	self assert: -1 isInt16.
	self assert: -32768 isInt16.
	self assert: 32767 isInt16.
	self deny: 32768 isInt16.
	self deny: -32769 isInt16.
	self deny: SmallInteger maximum isInt16.
	self deny: SmallInteger minimum isInt16!

testIsInt32
	self assert: 0 isInt32.
	self assert: 1 isInt32.
	self assert: -1 isInt32.
	self assert: SmallInteger maximum isInt32.
	self assert: SmallInteger minimum isInt32!

testIsInt64
	{ 0. 1. -1. 2. SmallInteger maximum. SmallInteger minimum } do: [:each | self assert: each isInt64]!

testLargeSmallComparisons
	self assert: SmallInteger maximum < (SmallInteger maximum + 1).
	self assert: SmallInteger maximum <= (SmallInteger maximum + 1).
	self assert: SmallInteger maximum <=> (SmallInteger maximum + 1) equals: -1.
	self assert: SmallInteger maximum <==> (SmallInteger maximum + 1) equals: -1.
	self deny: SmallInteger maximum equals: SmallInteger maximum + 1.
	self assert: SmallInteger maximum equals: SmallInteger maximum.
	self assert: SmallInteger maximum <=> SmallInteger maximum equals: 0.
	self assert: SmallInteger maximum <==> SmallInteger maximum equals: 0.
	self deny: SmallInteger maximum > (SmallInteger maximum + 1).
	self deny: SmallInteger maximum >= (SmallInteger maximum + 1).
	self assert: SmallInteger maximum + 1 > SmallInteger maximum.
	self assert: SmallInteger maximum + 1 >= SmallInteger maximum.
	self assert: SmallInteger maximum + 1 <=> SmallInteger maximum equals: 1.
	self assert: SmallInteger maximum + 1 <==> SmallInteger maximum equals: 1.
	self deny: SmallInteger maximum + 1 <= SmallInteger maximum.
	self deny: SmallInteger maximum + 1 equals: SmallInteger maximum.
	self deny: SmallInteger maximum + 1 < SmallInteger maximum!

testLcm
	self assert: (6 lcm: 10) identicalTo: 30!

testLessOrEqualToFloat
	| pos neg zero |
	pos := 3.
	neg := -3.
	"+ve"
	self assert: pos <= Float infinity.
	self deny: pos <= Float nan.
	self deny: pos <= Float negativeInfinity.
	self deny: pos <= Float negativeZero.
	self deny: pos <= Float zero.
	self assert: pos <= Float pi.
	self assert: pos <= pos asFloat.
	self deny: pos <= neg asFloat.
	"-ve"
	self assert: neg <= Float infinity.
	self deny: neg <= Float nan.
	self deny: neg <= Float negativeInfinity.
	self assert: neg <= Float negativeZero.
	self assert: neg <= Float zero.
	self assert: neg <= Float pi.
	self assert: neg <= pos asFloat.
	self assert: neg <= neg asFloat.
	"zero"
	zero := 0.
	self assert: zero <= Float infinity.
	self deny: zero <= Float nan.
	self deny: zero <= Float negativeInfinity.
	self assert: zero <= Float negativeZero.
	self assert: zero <= Float zero!

testLessOrEqualToFraction
	| pos neg zero posFraction negFraction |
	pos := 1.
	neg := -1.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self assert: pos <= posFraction.
	self deny: pos <= negFraction.
	self assert: pos <= (5 / 4).
	"-ve"
	self assert: neg <= posFraction.
	self deny: neg <= negFraction.
	self assert: neg <= (-3 / 4).
	"Zero"
	zero := 0.
	self assert: zero <= posFraction.
	self deny: zero <= negFraction!

testLessThanFloat
	| pos neg zero |
	pos := 3.
	neg := -3.
	"+ve"
	self assert: pos < Float infinity.
	self deny: pos < Float nan.
	self deny: pos < Float negativeInfinity.
	self deny: pos < Float negativeZero.
	self deny: pos < Float zero.
	self assert: pos < Float pi.
	self deny: pos < pos asFloat.
	self deny: pos < neg asFloat.
	"-ve"
	self assert: neg < Float infinity.
	self deny: neg < Float nan.
	self deny: neg < Float negativeInfinity.
	self assert: neg < Float negativeZero.
	self assert: neg < Float zero.
	self assert: neg < Float pi.
	self assert: neg < pos asFloat.
	self deny: neg < neg asFloat.
	"zero"
	zero := 0.
	self assert: zero < Float infinity.
	self deny: zero < Float nan.
	self deny: zero < Float negativeInfinity.
	self deny: zero < Float negativeZero.
	self deny: zero < Float zero!

testLessThanFraction
	| pos neg zero posFraction negFraction |
	pos := 1.
	neg := -1.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self assert: pos < posFraction.
	self deny: pos < negFraction.
	self deny: pos < (3 / 4).
	"-ve"
	self assert: neg < posFraction.
	self deny: neg < negFraction.
	self deny: neg < (-5 / 4).
	"Zero"
	zero := 0.
	self assert: zero < posFraction.
	self deny: zero < negFraction!

testLowBit
	0 to: 30 do: [:each | 
		| i |
		i := 1 << each.
		self assert: i lowBit equals: each+1.
		self assert: i negated lowBit equals: each + 1].
	#(#(0 0) #(3 1) #(16r30000000 29) #(-3 1) #(-16r40000000 31))
		do: [:each | self assert: each first lowBit equals: each second]!

testMaxVal
	self should: [SmallInteger maximum = ((1 bitShift: VMConstants.IntPtrBits - 2) - 1)]!

testMinMax
	VMConstants.IsWin64
		ifTrue: 
			[self assert: SmallInteger maximum + 1 equals: 16r4000000000000000.
			self assert: SmallInteger minimum - 1 equals: -16r4000000000000001.
			self assert: (SmallInteger maximum // 2 + 1) * 2 equals: 16r4000000000000000.
			self assert: (SmallInteger minimum // 2 - 1) * 2 equals: -16r4000000000000002]
		ifFalse: 
			[self assert: SmallInteger maximum + 1 equals: 16r40000000.
			self assert: SmallInteger minimum - 1 equals: -16r40000001.
			self assert: (SmallInteger maximum // 2 + 1) * 2 equals: 16r40000000.
			self assert: (SmallInteger minimum // 2 - 1) * 2 equals: -16r40000002]!

testMinVal
	self should: [SmallInteger minimum = (1 bitShift: VMConstants.IntPtrBits - 2) negated]!

testModulo
	{1. -1. 0. SmallInteger maximum. SmallInteger minimum}
		do: [:each | self should: [each \\ 0] raise: ZeroDivide].
	self class moduloTestCases do: [:each | self assert: each first \\ each second equals: each third]!

testNew
	self should: [SmallInteger new] raise: TestResult error!

testNoMask

	self assert: (29127 noMask: 3640).!

testNumberOfDigitsInBase
	(1 to: 30) do: 
			[:each |
			self assert: ((2 raisedToInteger: each) - 1 numberOfDigitsInBase: 2) equals: each.
			self assert: ((2 raisedToInteger: each) numberOfDigitsInBase: 16) equals: each // 4 + 1].
	self assert: (-2 numberOfDigitsInBase: 2) equals: 2.
	self assert: (16r3FFFFFFF numberOfDigitsInBase: 16) equals: 8.
	self assert: (16r3FFFFFFF numberOfDigitsInBase: 3) equals: 19!

testOdd
	#(1 5 -1 -5) do: [:each | self assert: each odd].
	#(0 2 6 -2 -6) do: [:each | self deny: each odd].
	self assert: SmallInteger maximum odd.
	self deny: SmallInteger minimum odd!

testOverflow
	"Test overflow of SmallInteger arithmetic prims"

	| res |
	res := SmallInteger maximum + 1.
	self assert: res equals: 16r40000000.
	self assert: res class identicalTo: LargeInteger.
	res := SmallInteger maximum + SmallInteger maximum.
	self assert: res equals: 16r7FFFFFFE.
	self assert: res class identicalTo: LargeInteger.
	res := SmallInteger minimum - 1.
	self assert: res equals: -16r40000001.
	self assert: res class identicalTo: LargeInteger.
	res := SmallInteger minimum + SmallInteger minimum.
	self assert: res equals: -16r80000000.
	self assert: res class identicalTo: LargeInteger.
	res := SmallInteger minimum - SmallInteger maximum.
	self assert: res equals: -16r7FFFFFFF.
	self assert: res class identicalTo: LargeInteger.
	res := 16r20000000 * 2.
	self assert: res equals: 16r40000000.
	self assert: res class identicalTo: LargeInteger.
	res := SmallInteger maximum * SmallInteger maximum.
	self assert: res equals: 16rFFFFFFF80000001.
	self assert: res class identicalTo: LargeInteger.
	res := SmallInteger minimum * SmallInteger maximum.
	self assert: res equals: -16rFFFFFFFC0000000.
	self assert: res class identicalTo: LargeInteger.
	res := SmallInteger minimum * SmallInteger minimum.
	self assert: res equals: 16r1000000000000000.
	self assert: res class identicalTo: LargeInteger!

testPrimesUpTo
	"Use a brute force technique to generate the first few hundred primes, which we know works."

	| primes primes2 max |
	self should: [Integer primesUpTo: -1] raise: Error.
	self should: [Integer primesUpTo: 0] raise: Error.
	self assert: (Integer primesUpTo: 1) isEmpty.
	self assert: (Integer primesUpTo: 2) asArray equals: #(2).
	self assert: (Integer primesUpTo: 3) asArray equals: #(2 3).
	max := 2000.
	primes := OrderedCollection with: 2.
	(3 to: max by: 2) do: [:n | primes detect: [:p | n \\ p == 0] ifNone: [primes add: n]].
	primes2 := Integer primesUpTo: 2000.
	self assert: primes asArray equals: primes2!

testPrintString
	| pairs |
	pairs := #(#(0 '0') #(1 '1') #(-1 '-1') #(12 '12') #(-12 '-12') #(255 '255') #(-255 '-255') #(256 '256') #(-256 '-256') #(999 '999') #(-999 '-999') #(1000 '1000') #(-1000 '-1000') #(4095 '4095') #(-4095 '-4095') #(4096 '4096') #(-4096 '-4096') #(9999 '9999') #(-9999 '-9999') #(10000 '10000') #(-10000 '-10000') #(65535 '65535') #(-65535 '-65535') #(65536 '65536') #(-65536 '-65536') #(99999 '99999') #(-99999 '-99999') #(100000 '100000') #(-100000 '-100000') #(1048575 '1048575') #(-1048575 '-1048575') #(1048576 '1048576') #(-1048576 '-1048576') #(9999999 '9999999') #(-9999999 '-9999999') #(10000000 '10000000') #(-10000000 '-10000000') #(99999999 '99999999') #(-99999999 '-99999999') #(100000000 '100000000') #(-100000000 '-100000000') #(16777215 '16777215') #(-16777215 '-16777215') #(16777216 '16777216') #(-16777216 '-16777216') #(268435455 '268435455') #(-268435455 '-268435455') #(268435456 '268435456') #(-268435456 '-268435456') #(999999999 '999999999') #(-999999999 '-999999999') #(1000000000 '1000000000') #(-1000000000 '-1000000000') #(1073741823 '1073741823') #(-1073741823 '-1073741823') #(-1073741824 '-1073741824')).
	VMConstants.IsWin64
		ifTrue: 
			[pairs := pairs
						, #(#(4294967295 '4294967295') #(-4294967295 '-4294967295') #(4294967296 '4294967296') #(-4294967296 '-4294967296') #(4611686018427387903 '4611686018427387903') #(-4611686018427387903 '-4611686018427387903') #(-4611686018427387904 '-4611686018427387904'))].
	pairs do: [:eachPair | self assert: eachPair first printString equals: eachPair second]!

testPrintStringRadix
	self assert: (32767 printStringRadix: 2) equals: '2r111111111111111'.
	self assert: (30167 printStringRadix: 2) equals: '2r111010111010111'.
	self assert: (0 printStringRadix: 2) equals: '2r0'.
	self assert: (-1 printStringRadix: 2) equals: '-2r1'.
	self assert: (1295 printStringRadix: 36) equals: '36rZZ'.
	self assert: (SmallInteger maximum printStringRadix: 36) equals: '36rHRA0HR'.
	self assert: (SmallInteger minimum printStringRadix: 36) equals: '-36rHRA0HS'.
	self should: [1 printStringRadix: 1] raise: Error.
	self should: [36 printStringRadix: 37] raise: Error!

testQuo
	self class quoTestCases do: [:each | self assert: (each first quo: each second) equals: each third]!

testRaisedToInteger
	| expected subject |
	subject := 10.
	self assert: (subject raisedToInteger: 0) equals: 1.
	expected := subject.
	1 to: 10
		do: 
			[:i |
			self assert: (10 raisedToInteger: i) equals: expected.
			expected := expected * subject].
	self assert: (0 raisedToInteger: 0) equals: 1.
	self assert: (0 raisedToInteger: 1) equals: 0.
	self assert: (0 raisedToInteger: 2) equals: 0.
	self should: [0 raisedToInteger: -1] raise: ZeroDivide.
	self assert: (2 raisedToInteger: -1) equals: 1 / 2.
	self assert: (2 raisedToInteger: -4) equals: 1 / 16.
	self assert: (-3 raisedToInteger: 0) equals: 1.
	self assert: (-3 raisedToInteger: 1) equals: -3.
	self assert: (-3 raisedToInteger: 2) equals: 9.
	self assert: (-3 raisedToInteger: 3) equals: -27.
	self assert: (-3 raisedToInteger: -2) equals: 1 / 9.
	self assert: (-3 raisedToInteger: -3) equals: -1 / 27.
	self should: [10 raisedToInteger: 1.0] raise: Error.
	self assert: (SmallInteger maximum raisedToInteger: 1) equals: SmallInteger maximum.
	self assert: (SmallInteger maximum raisedToInteger: 2)
		equals: SmallInteger maximum * SmallInteger maximum.
	self assert: (SmallInteger minimum raisedToInteger: 2)
		equals: SmallInteger minimum * SmallInteger minimum.
	self assert: (SmallInteger minimum raisedToInteger: -2)
		equals: 1 / (SmallInteger minimum * SmallInteger minimum)!

testReciprocal
	self assert: 7 reciprocal equals: (Fraction numerator: 1 denominator: 7)!

testRem
	self assert: (7 rem: 2) identicalTo: 1.
	self assert: (-7 rem: 2) identicalTo: -1!

testSubtract
	"Coercion to float"

	self assert: (5 - 2.125 equals: 2.875)! !

!Core.Tests.SmallIntegerTest categoriesForMethods!
canonicalInstance!public!unit tests! !
test1234!public! !
testAbs!public!unit tests! !
testAllMask!public!unit tests! !
testAnyMask!public!unit tests! !
testBasicNew!public!unit tests! !
testBitAnd!public!unit tests! !
testBitOr!public!unit tests! !
testBitShift!public!unit tests! !
testDecimalDigitLength!public!unit tests! !
testDigitLength!public!unit tests! !
testDivide!public!unit tests! !
testEven!public!unit tests! !
testExp10!public!unit tests! !
testGcd!public!unit tests! !
testGreaterOrEqualPoint!public! !
testGreaterOrEqualToFloat!public! !
testGreaterThanFloat!public! !
testHighBit!public!unit tests! !
testIntegerDivide!public!unit tests! !
testIsInt16!public!unit tests! !
testIsInt32!public!unit tests! !
testIsInt64!public!unit tests! !
testLargeSmallComparisons!public!unit tests! !
testLcm!public!unit tests! !
testLessOrEqualToFloat!public!unit tests! !
testLessOrEqualToFraction!public!unit tests! !
testLessThanFloat!public!unit tests! !
testLessThanFraction!public!unit tests! !
testLowBit!public!unit tests! !
testMaxVal!public!unit tests! !
testMinMax!public!unit tests! !
testMinVal!public!unit tests! !
testModulo!public!unit tests! !
testNew!public!unit tests! !
testNoMask!public!unit tests! !
testNumberOfDigitsInBase!public!unit tests! !
testOdd!public! !
testOverflow!public!unit tests! !
testPrimesUpTo!public!unit tests! !
testPrintString!public!unit tests! !
testPrintStringRadix!public!unit tests! !
testQuo!public!unit tests! !
testRaisedToInteger!public!unit tests! !
testReciprocal!public!unit tests! !
testRem!public!unit tests! !
testSubtract!public!unit tests! !
!

!Core.Tests.SmallIntegerTest class methodsFor!

bitShiftTestCases
	| highBit |
	highBit := SmallInteger maximum highBit.
	^((0 to: highBit + 35) collect: [:i | {0. i. 0}])
		, ((0 to: highBit + 35) collect: [:i | {1. i. 2 raisedToInteger: i}])
			, ((0 to: highBit + 35) collect: [:i | {-1. i. (2 raisedToInteger: i) negated}]) , ((0 to: highBit)
					collect: [:i | {SmallInteger maximum. i negated. (2 raisedToInteger: highBit - i) - 1}])
		, {{-1. -1. -1}.
				{-16r40000000. 1. -16r80000000}.
				{-16r40000000. 31. -16r2000000000000000}.
				{-16r40000000. 32. -16r4000000000000000}.
				{-16r40000000. 33. -16r8000000000000000}.
				{SmallInteger minimum. highBit negated + 1. -2}.
				{SmallInteger minimum. highBit negated. -1}.
				{SmallInteger minimum. highBit negated - 1. -1}.
				{SmallInteger minimum. highBit negated - 2. -1}.
				{SmallInteger minimum. highBit negated - 32. -1}.
				{SmallInteger minimum. highBit negated - 33. -1}.
				{SmallInteger minimum. SmallInteger minimum. -1}.
				{1. -1. 0}.
				{SmallInteger maximum. SmallInteger minimum. 0}.
				{3640. 1. 7280}}!

integerDivideTestCases
	^#(#(0 1 0) #(1 1 1) #(1 -1 -1) #(0 -1 0) #(-1 1 -1) #(-1 -1 1) #(0 2 0) #(2 1 2) #(2 2 1) #(2 -1 -2) #(2 -2 -1) #(0 -2 0) #(-2 1 -2) #(-2 -2 1) #(-2 -1 2) #(-2 2 -1) #(7 2 3) #(-7 2 -4) #(7 -2 -4) #(-7 -2 3) #(1 2 0) #(-1 2 -1) #(1 -2 -1) #(-1 -2 0) #(-16r40000000 3 -16r15555556) #(-16r40000000 -3 16r15555555) #(7 -3.0 -3) #(9 4.0 2) #(9 -4.0 -3) #(2 -2.0 -1) #(2 2.0 1) #(1073741823 0.011 97612893000) #(1073741823 -0.011 -97612893001))
		, {{0. SmallInteger maximum. 0}.
				{0. SmallInteger maximum + 1. 0}.
				{0. SmallInteger minimum. 0}.
				{0. SmallInteger minimum - 1. 0}.
				{SmallInteger minimum. 1. SmallInteger minimum}.
				{SmallInteger minimum. -1. SmallInteger minimum negated}.
				{SmallInteger minimum. 2. SmallInteger minimum bitShift: -1}.
				{SmallInteger minimum. -2. (SmallInteger minimum bitShift: -1) negated}.
				{SmallInteger minimum. SmallInteger maximum. -2}.
				{SmallInteger minimum. SmallInteger maximum - 1. -2}.
				{SmallInteger minimum. SmallInteger maximum - 2. -2}.
				{SmallInteger minimum. SmallInteger maximum + 1. -1}.
				{SmallInteger minimum. SmallInteger maximum bitShift: 1. -1}.
				{SmallInteger minimum. SmallInteger maximum bitShift: 2. -1}.
				{SmallInteger minimum. SmallInteger maximum squared. -1}.
				{SmallInteger minimum. 16r7FFFFFFF. -1}.
				{SmallInteger minimum. 16r80000000. -1}.
				{SmallInteger minimum. 16rFFFFFFFF. -1}.
				{SmallInteger minimum. 16r3FFFFFFFFFFFFFFF. -1}.
				{SmallInteger minimum. 16r7FFFFFFFFFFFFFFF. -1}.
				{SmallInteger minimum. 16r8000000000000000. -1}.
				{SmallInteger minimum. 16rFFFFFFFFFFFFFFFF. -1}.
				{SmallInteger minimum. SmallInteger minimum + 1. 1}.
				{SmallInteger minimum. 1. SmallInteger minimum}.
				{SmallInteger minimum. SmallInteger minimum. 1}.
				{SmallInteger minimum. SmallInteger minimum - 1. 0}.
				{SmallInteger minimum. SmallInteger minimum - 2. 0}.
				{SmallInteger minimum. SmallInteger minimum bitShift: 1. 0}.
				{SmallInteger minimum. SmallInteger minimum bitShift: 2. 0}.
				{SmallInteger minimum. -16r7FFFFFFF. 0}.
				{SmallInteger minimum. -16r80000000. 0}.
				{SmallInteger minimum. -16rFFFFFFFF. 0}.
				{SmallInteger minimum. -16r3FFFFFFFFFFFFFFF. 0}.
				{SmallInteger minimum. -16r7FFFFFFFFFFFFFFF. 0}.
				{SmallInteger minimum. -16r8000000000000000. 0}.
				{SmallInteger minimum. -16rFFFFFFFFFFFFFFFF. 0}.
				{SmallInteger maximum. 1. SmallInteger maximum}.
				{SmallInteger maximum. 2. SmallInteger maximum bitShift: -1}.
				{SmallInteger maximum. -1. SmallInteger maximum negated}.
				{SmallInteger maximum. -2. (SmallInteger maximum bitShift: -1) negated - 1}.
				{SmallInteger maximum. SmallInteger minimum. -1}.
				{SmallInteger maximum. SmallInteger minimum - 1. -1}.
				{SmallInteger maximum. SmallInteger minimum - 2. -1}.
				{SmallInteger maximum. SmallInteger minimum + 1. -1}.
				{SmallInteger maximum. SmallInteger minimum + 2. -2}.
				{SmallInteger maximum. SmallInteger maximum. 1}.
				{SmallInteger maximum. SmallInteger maximum + 1. 0}.
				{SmallInteger maximum. SmallInteger maximum - 1. 1}.
				{SmallInteger maximum. SmallInteger maximum bitShift: 1. 0}.
				{SmallInteger maximum. SmallInteger maximum bitShift: 2. 0}.
				{SmallInteger maximum. SmallInteger maximum squared. 0}.
				{SmallInteger maximum. 16r7FFFFFFF. 0}.
				{SmallInteger maximum. 16r80000000. 0}.
				{SmallInteger maximum. 16rFFFFFFFF. 0}.
				{SmallInteger maximum. 16r3FFFFFFFFFFFFFFF. 0}.
				{SmallInteger maximum. 16r7FFFFFFFFFFFFFFF. 0}.
				{SmallInteger maximum. 16r8000000000000000. 0}.
				{SmallInteger maximum. 16rFFFFFFFFFFFFFFFF. 0}.
				{SmallInteger maximum. 2.0. SmallInteger maximum bitShift: -1}.
				{SmallInteger maximum. -2.0. (SmallInteger maximum bitShift: -1) negated - 1}.
				{SmallInteger maximum. -0.1. SmallInteger maximum * 10 negated}.
				{-16r40000000. Float pi. -341782638}.
				{-16r40000000. Float pi negated. 341782637}.
				{16r3FFFFFFF. Float pi. 341782637}.
				{16r3FFFFFFF. Float pi negated. -341782638}}!

moduloTestCases
	^#(#(6 2 0) #(-6 2 0) #(5 -3 -1) #(-5 -3 -2) #(7 2 1) #(7 3 1) #(7 11 7) #(7 -2 -1) #(7 -3 -2) #(7 -4 -1) #(7 -5 -3) #(7 -6 -5) #(7 -7 0) #(7 -8 -1) #(7 -11 -4) #(-7 2 1) #(-7 7 0) #(-7 11 4) #(-7 -11 -7) #(0 1 0) #(0 -1 0) #(0 2 0) #(0 -2 0) #(-12 5 3) #(-12 -5 -2) #(12 -5 -3) #(12 5 2) #(7 3.0 1.0) #(7 -3.0 -2.0) #(-7 -3.0 -1.0) #(-7 3.0 2.0) #(9 -4.0 -3.0) #(9 4.0 1.0))
		, {{0. SmallInteger maximum. 0}.
				{0. SmallInteger minimum. 0}.
				{0. SmallInteger maximum + 1. 0}.
				{0. SmallInteger minimum - 1. 0}.
				{SmallInteger maximum. 1. 0}.
				{SmallInteger maximum. -1. 0}.
				{SmallInteger maximum. 2. 1}.
				{SmallInteger maximum. -2. -1}.
				{SmallInteger maximum. 5. 3}.
				{SmallInteger maximum. -5. -2}.
				{SmallInteger maximum. SmallInteger maximum. 0}.
				{SmallInteger maximum. SmallInteger maximum + 1. SmallInteger maximum}.
				{SmallInteger maximum. SmallInteger maximum - 1. 1}.
				{SmallInteger maximum. SmallInteger minimum. -1}.
				{SmallInteger maximum. SmallInteger minimum - 1. -2}.
				{SmallInteger maximum. SmallInteger minimum + 1. 0}.
				{SmallInteger maximum. 2.0. 1.0}.
				{SmallInteger minimum. 1. 0}.
				{SmallInteger minimum. -1. 0}.
				{SmallInteger minimum. 2. 0}.
				{SmallInteger minimum. -2. 0}.
				{SmallInteger minimum. 3. 2}.
				{SmallInteger minimum. -3. -1}.
				{SmallInteger minimum + 1. SmallInteger minimum. SmallInteger minimum + 1}.
				{SmallInteger minimum. SmallInteger minimum. 0}.
				{SmallInteger minimum. SmallInteger minimum - 1. SmallInteger minimum}.
				{SmallInteger minimum. SmallInteger minimum + 1. -1}.
				{SmallInteger minimum. SmallInteger maximum. SmallInteger maximum - 1}.
				{SmallInteger minimum. SmallInteger maximum - 1. SmallInteger maximum - 3}.
				{SmallInteger minimum. SmallInteger maximum + 1. 0}.
				{SmallInteger minimum. SmallInteger maximum + 2. 1}.
				{SmallInteger minimum. 3.0. 2.0}.
				{16r3FFFFFFF. Float pi. 1.4762530326843262}.
				{16r3FFFFFFF. Float pi negated. -1.665339708328247}.
				{-16r40000000. Float pi. 0.6653397083282471}.
				{-16r40000000. Float pi negated. -2.476253032684326}}!

quoTestCases
	^#(#(6 2 3) #(7 2 3) #(7 -2 -3) #(7 3 2) #(-7 2 -3) #(-7 -2 3) #(9 4 2) #(-9 4 -2) #(16r3FFFFFFF 1.23 872960831) #(16r3FFFFFFF -1.23 -872960831) #(-16r40000000 1.23 -872960832) #(-16r40000000 -1.23 872960832))
		, {{SmallInteger maximum. SmallInteger maximum. 1}.
				{SmallInteger maximum. SmallInteger maximum + 1. 0}.
				{SmallInteger maximum. SmallInteger minimum. 0}.
				{SmallInteger minimum. SmallInteger maximum + 1. -1}.
				{SmallInteger minimum. SmallInteger maximum. -1}.
				{SmallInteger minimum. SmallInteger minimum. 1}.
				{SmallInteger minimum. -1. SmallInteger maximum + 1}.
				{SmallInteger minimum. SmallInteger maximum + 1. -1}.
				{SmallInteger minimum. SmallInteger maximum squared. 0}.
				{SmallInteger minimum. 2.0. SmallInteger minimum bitShift: -1}.
				{SmallInteger maximum. 4.0. SmallInteger maximum bitShift: -2}.
				{SmallInteger maximum. Float fmax. 0}.
				{SmallInteger maximum. Float fmax negated. 0}.
				{SmallInteger minimum. Float fmax. 0}.
				{SmallInteger minimum. Float fmax negated. 0}.
				{SmallInteger minimum. 0.01. SmallInteger minimum * 100}.
				{-16r40000000. Float pi. -341782637}.
				{-16r40000000. Float pi negated. 341782637}.
				{16r3FFFFFFF. Float pi. 341782637}.
				{16r3FFFFFFF. Float pi negated. -341782637}}! !

!Core.Tests.SmallIntegerTest class categoriesForMethods!
bitShiftTestCases!constants!public! !
integerDivideTestCases!constants!public! !
moduloTestCases!constants!public! !
quoTestCases!constants!public! !
!


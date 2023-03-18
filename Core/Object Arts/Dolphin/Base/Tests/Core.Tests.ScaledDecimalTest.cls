"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Core.Tests.ScaledDecimalTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ScaledDecimalTest guid: (Core.GUID fromString: '{dfe00781-39f5-4b43-ba15-861976d2ff7c}')!
Core.Tests.ScaledDecimalTest comment: ''!
!Core.Tests.ScaledDecimalTest methodsFor!

floatTestValues
	^(self integerTestValues, self fractionTestValues) collect: [ :each | each asFloat]!

fractionTestValues
	^(self integerTestValues collect: [ :each | each / 17]), (self integerTestValues collect: [ :each | each / 297])!

integerTestValues
	^self smallIntegerTestValues, self largeIntegerTestValues!

largeIntegerTestValues
	^self smallIntegerTestValues collect: [ :each | each positive ifTrue: [each + SmallInteger maximum] ifFalse: [each + SmallInteger minimum]]!

literalInstances
	^{1.00s2}!

nonLiteralInstances
	^{1 / 3.00s2}
	"Note that (1 / 3.00s2) is not a well behaved literal,
	because it does not re-evaluate to self...
	Every literal should be evaluated as self (see isSelfEvaluating).
	There is currently no way to print it as a literal.
	So i propose it shall not answer true."!

numericTestValues
	^self integerTestValues, self floatTestValues, self fractionTestValues!

smallIntegerTestValues
	^{0. 1. -1. 999. -999. SmallInteger maximum. SmallInteger minimum}!

testAsNumber
	"Ensure no loss of precision"

	| sd |
	sd := '1.40s2' asNumber.
	self assert: sd class identicalTo: ScaledDecimal.
	self assert: sd scale equals: 2.
	self assert: sd printString equals: '1.40s'!

testAsNumberNegatedWithoutDecimalPoint
	| sd |
	sd := '-123s0' asNumber.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd scale equals: 0.
	self assert: sd printString equals: '-123s'!

testAsNumberNegatedWithoutDecimalPoint2
	| sd |
	sd := '-123s2' asNumber.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd scale equals: 2.
	self assert: sd printString equals: '-123.00s'!

testAsNumberWithExtendedScale
	| sd |
	sd := '123s2' asNumber.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd scale equals: 2.
	self assert: sd printString equals: '123.00s'!

testAsNumberWithoutDecimalPoint
	| sd |
	sd := '123s0' asNumber.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd scale equals: 0.
	self assert: sd printString equals: '123s'!

testAsNumberWithoutDecimalPoint2
	| sd |
	sd := '123s2' asNumber.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd scale equals: 2.
	self assert: sd printString equals: '123.00s'!

testAsNumberWithRadix
	self should: ['10r-22.2s5' asNumber] raise: InvalidFormat!

testAsNumberWithSuperfluousDecimalPoint
	self should: ['123.s2' asNumber] raise: InvalidFormat!

testCoercion
	#(#* #+ #- #/) do: 
			[:op |
			self assert: (1.0s1 perform: op with: 2) class equals: ScaledDecimal.
			self assert: (1.0s1 perform: op with: 1 / 2) class equals: ScaledDecimal.
			self deny: (1.0s1 perform: op with: 1.0) class equals: ScaledDecimal.
			self assert: (1 perform: op with: 2.0s1) class equals: ScaledDecimal.
			self assert: (1 / 2 perform: op with: 2.0s1) class equals: ScaledDecimal.
			self deny: (1.0 perform: op with: 1.0s1) class equals: ScaledDecimal]!

testConvertFromFloat
	| aFloat sd f2 diff |
	aFloat := 11 / 13 asFloat.
	sd := aFloat asScaledDecimal: 2.
	self assert: sd scale equals: 2.
	self assert: sd printString equals: '0.85s'.
	self assert: sd negated printString equals: '-0.85s'.
	f2 := sd asFloat.
	diff := f2 - aFloat.
	self assert: diff abs < 1.0e-9	"actually, f = f2, but this is not a requirement"!

testConvertFromFraction
	| sd |
	sd := 13 / 11 asScaledDecimal: 6.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd printString equals: '1.181818s'.
	self assert: sd scale equals: 6.
	sd := -13 / 11 asScaledDecimal: 6.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd printString equals: '-1.181818s'.
	self assert: sd scale equals: 6!

testConvertFromIntegerWithScale
	"Converting an Integer with asScaledDecimal:. To be ANSI compliant, the scale must be ignored."

	| sd |
	sd := 13 asScaledDecimal: 6.
	self assert: sd scale equals: 0.
	self assert: sd printString equals: '13s'.
	sd := -13 asScaledDecimal: 4.
	self assert: sd scale equals: 0.
	self assert: sd printString equals: '-13s'.
	sd := 130000000013 asScaledDecimal: 3.
	self assert: sd scale equals: 0.
	self assert: sd printString equals: '130000000013s'.
	sd := -130000000013 asScaledDecimal: 1.
	self assert: sd scale equals: 0.
	self assert: sd printString equals: '-130000000013s'!

testEqualityComparisons
	"Test equality comparisons between ScaledDecimals of various scales, and various classes of numbers (including other ScaledDecimals)"

	0 to: 15
		do: 
			[:scale |
			self numericTestValues do: 
					[:each |
					| scaledDecimal scaledDecimalPlusOne scaledDecimalMinusFraction |
					scaledDecimal := each asScaledDecimal: scale.
					scaledDecimalPlusOne := scaledDecimal + 1.
					scaledDecimalMinusFraction := scaledDecimal - 0.005s.
					self
						assert: scaledDecimal equals: scaledDecimal;
						assert: scaledDecimal equals: each;
						assert: each equals: scaledDecimal.
					self
						deny: scaledDecimal equals: scaledDecimalPlusOne;
						deny: scaledDecimalPlusOne equals: scaledDecimal;
						deny: scaledDecimalPlusOne equals: each;
						deny: each equals: scaledDecimalPlusOne.
					self
						deny: scaledDecimal equals: scaledDecimalMinusFraction;
						deny: scaledDecimalMinusFraction equals: scaledDecimal;
						deny: scaledDecimalMinusFraction equals: scaledDecimalPlusOne;
						deny: scaledDecimalPlusOne equals: scaledDecimalMinusFraction;
						deny: scaledDecimalMinusFraction equals: each;
						deny: each equals: scaledDecimalMinusFraction]].

	"This doesn't seem right to me (should be equal), although Pharo and Squeak have the same 'bug', so maybe it isn't"
	self deny: (1 / 3 asScaledDecimal: 4) equals: 0.3333s!

testExactNthRoot
	| eight thousandth tenth two |
	self skip: 'Raising a number to a Fraction does not currently produce a precise result in Dolphin'.
	eight := 8.0s1.
	two := eight raisedTo: 1 / 3.
	self assert: two equals: 2.
	self assert: (two class = eight class and: [two scale = eight scale]).
	thousandth := 0.001s3.
	tenth := thousandth raisedTo: 1 / 3.
	self assert: tenth * 10 equals: 1.
	self assert: (tenth class = thousandth class and: [tenth scale = thousandth scale])!

testExactSqrt
	| four hundredth tenth two |
	self skip: 'Dolphin does not currently implement an exact square root for Fractions.'.
	four := 4.0s1.
	two := four sqrt.
	self assert: two equals: 2.
	self assert: (two class = four class and: [two scale = four scale]).
	hundredth := 0.01s2.
	tenth := hundredth sqrt.
	self assert: tenth * 10 equals: 1.
	self assert: (tenth class = hundredth class and: [tenth scale = hundredth scale])!

testGreaterOrEqualToFloat
	| pos neg zero |
	pos := 1.25s.
	neg := -1.25s.
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
	self assert: (3.15s greaterOrEqualToFloat: Float pi).
	self assert: (3.141592653589793s greaterOrEqualToFloat: Float pi).
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
	zero := 0s.
	self deny: (zero greaterOrEqualToFloat: Float infinity).
	self deny: (zero greaterOrEqualToFloat: Float nan).
	self assert: (zero greaterOrEqualToFloat: Float negativeInfinity).
	self assert: (zero greaterOrEqualToFloat: Float negativeZero).
	self assert: (zero greaterOrEqualToFloat: Float zero).
	self assert: (zero greaterOrEqualToFloat: Float fmin negated).
	self assert: (zero greaterOrEqualToFloat: Float fminDenormalized negated).
	self assert: (zero greaterOrEqualToFloat: Float fmax negated)!

testGreaterOrEqualToFraction
	| pos neg zero posFraction negFraction |
	pos := 1.25s.
	neg := -1.25s.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self deny: pos >= posFraction.
	self assert: pos >= negFraction.
	self assert: pos >= (5 / 4).
	"-ve"
	self deny: neg >= posFraction.
	self assert: neg >= negFraction.
	self assert: neg >= (-5 / 4).
	"Zero"
	zero := 0s.
	self deny: zero >= posFraction.
	self assert: zero >= negFraction!

testGreaterOrEqualToInteger
	| pos neg zero largePos largeNeg smallNeg smallPos |
	pos := 1.25s.
	neg := -1.25s.
	smallPos := SmallInteger maximum.
	smallNeg := SmallInteger minimum.
	largePos := SmallInteger maximum + 1.
	largeNeg := SmallInteger minimum - 1.
	"+ve"
	self deny: pos >= largePos.
	self assert: pos >= largeNeg.
	self assert: pos >= 0.
	self assert: pos >= smallNeg.
	self deny: pos >= smallPos.
	self assert: pos >= 1.
	self deny: pos >= 2.
	self assert: 2.0s >= 2.
	"-ve"
	self deny: neg >= largePos.
	self assert: neg >= largeNeg.
	self deny: neg >= 0.
	self assert: neg >= smallNeg.
	self assert: neg >= -2.
	self deny: neg >= -1.
	self assert: -2.0s >= -2.
	"Zero"
	zero := 0s.
	self deny: zero >= largePos.
	self deny: zero >= smallPos.
	self assert: zero >= largeNeg.
	self assert: zero >= smallNeg.
	self assert: zero >= 0!

testGreaterThanFloat
	| pos neg zero |
	pos := 1.25s.
	neg := -1.25s.
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
	self assert: (3.15s greaterThanFloat: Float pi).
	self deny: (3.141592653589793s greaterThanFloat: Float pi).
	self deny: (neg greaterThanFloat: Float pi).
	self deny: (neg greaterThanFloat: pos asFloat).
	self deny: (neg greaterThanFloat: neg asFloat).
	self deny: (neg greaterThanFloat: Float fmin negated).
	self deny: (neg greaterThanFloat: Float fminDenormalized negated).
	self assert: (neg greaterThanFloat: Float fmax negated).
	"zero"
	zero := 0s.
	self deny: (zero greaterThanFloat: Float infinity).
	self deny: (zero greaterThanFloat: Float nan).
	self assert: (zero greaterThanFloat: Float negativeInfinity).
	self deny: (zero greaterThanFloat: Float negativeZero).
	self deny: (zero greaterThanFloat: Float zero).
	self assert: (zero greaterThanFloat: Float fmin negated).
	self assert: (zero greaterThanFloat: Float fminDenormalized negated).
	self assert: (zero greaterThanFloat: Float fmax negated)!

testGreaterThanFraction
	| pos neg zero posFraction negFraction |
	pos := 1.25s.
	neg := -1.25s.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self deny: pos > posFraction.
	self assert: pos > negFraction.
	self deny: pos > (5 / 4).
	"-ve"
	self deny: neg > posFraction.
	self assert: neg > negFraction.
	self deny: neg > (-5 / 4).
	"Zero"
	zero := 0s.
	self deny: zero > posFraction.
	self assert: zero > negFraction!

testGreaterThanInteger
	| pos neg zero largePos largeNeg smallNeg smallPos |
	pos := 1.25s.
	neg := -1.25s.
	smallPos := SmallInteger maximum.
	smallNeg := SmallInteger minimum.
	largePos := SmallInteger maximum + 1.
	largeNeg := SmallInteger minimum - 1.
	"+ve"
	self deny: pos > largePos.
	self assert: pos > largeNeg.
	self assert: pos > 0.
	self assert: pos > smallNeg.
	self deny: pos > smallPos.
	self assert: pos > 1.
	self deny: pos > 2.
	self deny: 2s > 2.
	"-ve"
	self deny: neg > largePos.
	self assert: neg > largeNeg.
	self deny: neg > 0.
	self assert: neg > smallNeg.
	self assert: neg > -2.
	self deny: neg > -1.
	self deny: -2s > -2.
	"Zero"
	zero := 0s.
	self deny: zero > largePos.
	self deny: zero > smallPos.
	self assert: zero > largeNeg.
	self assert: zero > smallNeg.
	self deny: zero > 0!

testInexactNthRoot
	| tenth cubicRoot3 fifthRootTenth three |
	three := 3.0s1.
	cubicRoot3 := three raisedTo: 1 / 3.
	self assert: cubicRoot3 isFloat.
	self deny: cubicRoot3 squared equals: 3.
	tenth := 0.10s2.
	fifthRootTenth := tenth raisedTo: 1 / 5.
	self assert: fifthRootTenth isFloat.
	self deny: fifthRootTenth squared equals: tenth!

testInexactSqrt
	| tenth sqrt3 sqrtTenth three |
	three := 3.0s1.
	sqrt3 := three sqrt.
	self assert: sqrt3 isFloat.
	self deny: sqrt3 squared equals: 3.
	tenth := 0.10s2.
	sqrtTenth := tenth sqrt.
	self assert: sqrtTenth isFloat.
	self assert: sqrtTenth squared equals: tenth!

testIsLiteral
	"This test is related to http://bugs.squeak.org/view.php?id=6796"

	self literalInstances
		do: [:each | self assert: each isLiteral description: 'every literal obviously isLiteral'].
	self nonLiteralInstances
		do: [:each | self deny: each isLiteral description: 'this number cannot represent itself as a literal']!

testIsSelfEvaluating
	self literalInstances
		do: [:each | self assert: each isSelfEvaluating description: 'every literal obviously isLiteral'].
	self nonLiteralInstances
		do: [:each | self deny: each isSelfEvaluating description: 'this number cannot represent itself as a literal']!

testLessOrEqualToFloat
	| pos neg zero |
	pos := 1.25s.
	neg := -1.25s.
	"+ve"
	self assert: pos <= Float infinity.
	self deny: pos <= Float nan.
	self deny: pos <= Float negativeInfinity.
	self deny: pos <= Float negativeZero.
	self deny: pos <= Float zero.
	self deny: pos <= Float fmin.
	self deny: pos <= Float fminDenormalized.
	self assert: pos <= Float fmax.
	self assert: pos <= Float pi.
	self assert: pos <= pos asFloat.
	self deny: pos <= neg asFloat.
	self assert: pos < (FloatTest successor: pos asFloat).
	"-ve"
	self assert: neg <= Float infinity.
	self deny: neg <= Float nan.
	self deny: neg <= Float negativeInfinity.
	self assert: neg <= Float negativeZero.
	self assert: neg <= Float zero.
	self assert: neg <= Float fmin negated.
	self assert: neg <= Float fminDenormalized negated.
	self deny: neg <= Float fmax negated.
	self deny: 3.15s <= Float pi.
	self assert: 3.141592653589793s <= Float pi.
	self assert: neg <= Float pi.
	self assert: neg <= pos asFloat.
	self assert: neg <= neg asFloat.
	self deny: neg < (FloatTest predecessor: neg asFloat).
	"zero"
	zero := 0s.
	self assert: zero <= Float infinity.
	self deny: zero <= Float nan.
	self deny: zero <= Float negativeInfinity.
	self assert: zero <= Float negativeZero.
	self assert: zero <= Float zero!

testLessOrEqualToFraction
	| pos neg zero posFraction negFraction |
	pos := 1.25s.
	neg := -1.25s.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self assert: pos <= posFraction.
	self deny: pos <= negFraction.
	self assert: pos <= (5 / 4).
	"-ve"
	self assert: neg <= posFraction.
	self deny: neg <= negFraction.
	self assert: neg <= (-5 / 4).
	"Zero"
	zero := 0s.
	self assert: zero <= posFraction.
	self deny: zero <= negFraction!

testLessOrEqualToInteger
	| pos neg zero largePos largeNeg smallNeg smallPos |
	pos := 1.25s.
	neg := -1.25s.
	smallPos := SmallInteger maximum.
	smallNeg := SmallInteger minimum.
	largePos := SmallInteger maximum + 1.
	largeNeg := SmallInteger minimum - 1.
	"+ve"
	self assert: pos <= largePos.
	self deny: pos <= largeNeg.
	self deny: pos <= 0.
	self deny: pos <= smallNeg.
	self assert: pos <= smallPos.
	self deny: pos <= 1.
	self assert: pos <= 2.
	self assert: 2.0s <= 2.
	"-ve"
	self assert: neg <= largePos.
	self deny: neg <= largeNeg.
	self assert: neg <= 0.
	self deny: neg <= smallNeg.
	self deny: neg <= -2.
	self assert: neg <= -1.
	self assert: -2.0s <= -2.
	"Zero"
	zero := 0s.
	self assert: zero <= largePos.
	self assert: zero <= smallPos.
	self deny: zero <= largeNeg.
	self deny: zero <= smallNeg.
	self assert: zero <= 0!

testLessThanFloat
	| pos neg zero |
	pos := 1.25s.
	neg := -1.25s.
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
	self deny: 3.15s < Float pi.
	self deny: 3.141592653589793s < Float pi.
	self assert: neg < Float pi.
	self assert: neg < pos asFloat.
	self deny: neg < neg asFloat.
	self assert: neg < (FloatTest successor: neg asFloat).
	"zero"
	zero := 0s.
	self assert: zero < Float infinity.
	self deny: zero < Float nan.
	self deny: zero < Float negativeInfinity.
	self deny: zero < Float negativeZero.
	self deny: zero < Float zero!

testLessThanFraction
	| pos neg zero posFraction negFraction |
	pos := 1.25s.
	neg := -1.25s.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self assert: pos < posFraction.
	self deny: pos < negFraction.
	self deny: pos < (5 / 4).
	"-ve"
	self assert: neg < posFraction.
	self deny: neg < negFraction.
	self deny: neg < (-5 / 4).
	"Zero"
	zero := 0s.
	self assert: zero < posFraction.
	self deny: zero < negFraction!

testLessThanInteger
	| pos neg zero largePos largeNeg smallNeg smallPos |
	pos := 1.25s.
	neg := -1.25s.
	smallPos := SmallInteger maximum.
	smallNeg := SmallInteger minimum.
	largePos := SmallInteger maximum + 1.
	largeNeg := SmallInteger minimum - 1.
	"+ve"
	self assert: pos < largePos.
	self deny: pos < largeNeg.
	self deny: pos < 0.
	self deny: pos < smallNeg.
	self assert: pos < smallPos.
	self deny: pos < 1.
	self assert: pos < 2.
	self deny: 2.0s < 2.
	"-ve"
	self assert: neg < largePos.
	self deny: neg < largeNeg.
	self assert: neg < 0.
	self deny: neg < smallNeg.
	self deny: neg < -2.
	self assert: neg < -1.
	self deny: -2.0s < -2.
	"Zero"
	zero := 0s.
	self assert: zero < largePos.
	self assert: zero < smallPos.
	self deny: zero < largeNeg.
	self deny: zero < smallNeg.
	self deny: zero < 0!

testLiteral
	| sd |
	sd := 1.40s2.
	self assert: ScaledDecimal identicalTo: sd class.
	self assert: sd scale equals: 2.
	self assert: sd printString equals: '1.40s'!

testOneRaisedToInteger
	"One might be handled specially"

	self assert: (1.0s1 raisedToInteger: -1) scale equals: 1.
	self assert: (1.0s1 raisedToInteger: -1) equals: 1.
	self assert: (1.0s1 raisedToInteger: 0) scale equals: 1.
	self assert: (1.0s1 raisedToInteger: 0) equals: 1.
	self assert: (1.0s1 raisedToInteger: 1) scale equals: 1.
	self assert: (1.0s1 raisedToInteger: 1) equals: 1.
	self assert: (1.0s1 raisedToInteger: 2) scale equals: 1.
	self assert: (1.0s1 raisedToInteger: 2) equals: 1!

testPrinting
	| subject |
	subject := 100000000000 / 3 asScaledDecimal: 4.
	self assert: subject printString equals: '33333333333.3333s'.
	subject := 13 / 11 asScaledDecimal: 6.
	self assert: subject printString equals: '1.181818s'.
	subject := 13 / 11 asScaledDecimal: 5.
	self assert: subject printString equals: '1.18182s'!

testPrintString
	| subject stream |
	subject := 100000000000 / 3 asScaledDecimal: 4.
	"We don't want the integer part to print in hex."
	stream := String writeStream
				locale: SmalltalkLocale.Hex;
				yourself.
	subject printOn: stream.
	self assert: stream contents equals: '33333333333.3333s'.
	"The printed representation of a ScaledDecimal is rounded.
	Note that old implementation was truncated."
	subject := 13 / 11 asScaledDecimal: 6.
	self assert: subject printString equals: '1.181818s'.
	subject := 13 / 11 asScaledDecimal: 5.
	self assert: subject printString equals: '1.18182s'!

testRaisedToInteger
	"Raising to integer should preserve class and scale"

	self assert: (3.0s1 raisedToInteger: -1) scale equals: 1.
	self assert: (3.0s1 raisedToInteger: -1) equals: 1 / 3.
	self assert: (3.0s1 raisedToInteger: 0) scale equals: 1.
	self assert: (3.0s1 raisedToInteger: 0) equals: 1.
	self assert: (3.0s1 raisedToInteger: 1) scale equals: 1.
	self assert: (3.0s1 raisedToInteger: 1) equals: 3.
	self assert: (3.0s1 raisedToInteger: 2) scale equals: 1.
	self assert: (3.0s1 raisedToInteger: 2) equals: 9!

testReadFrom
	"This is related to http://bugs.squeak.org/view.php?id=6779"

	self skip: 'Needs fixing; Dolphin answers a Float, when it shouldn''t'.
	self should: [(ScaledDecimal readFrom: '5.3' readStream) isKindOf: ScaledDecimal]
		description: 'Reading a ScaledDecimal should answer a ScaledDecimal'.
	self should: 
			[((ScaledDecimal readFrom: '5.3' readStream) asScaledDecimal: 1) = (53 / 10 asScaledDecimal: 1)]
		description: 'ScaledDecimal readFrom: should not use Float intermediate because it would introduce round off errors'!

testRounded
	self assert: (1999 / 1000s2) printString equals: '2.00s'.
	self assert: (-1999 / 1000s2) printString equals: '-2.00s'!

testScaleExtension
	"The scale is extended to the larger one in case of arithmetic operation"

	#(#* #+ #- #/) do: 
			[:op |
			self assert: (2.5s1 perform: op with: 1.000s3) scale equals: 3.
			self assert: (3.5000s4 perform: op with: 1.0s1) scale equals: 4]!

testStoreOnRoundTrip
	"this is http://bugs.squeak.org/view.php?id=4378"

	"Both results should be 1.
	ScaledDecimal representations are exact
	(though only scale digits or fractional part are printed)"

	self assert: (self class compilerClass evaluate: 0.5s1 squared storeString) * 4 equals: 0.5s1 squared * 4.


	"However, exact literals should store literaly
	If not, they would break Decompiler."

	"BUG: i cannot write the test like this:
	self assert:
    		0.5s2 squared storeString = '0.25s2'
	BECAUSE compiler would consider 0.5s2 as = 0.5s1 and would reuse same slot..."
	self assert: 0.25s2 storeString equals: '0.25s'!

testSubtractionFromInteger
	"Test subtraction of ScaledDecimals of various scales from Integers"

	0 to: 15 do: 
		[ :scale |
		self integerTestValues do: 
			[ :each || scaledDecimal result |
			scaledDecimal := each asScaledDecimal: scale.

			result := each - scaledDecimal.
			self assert: result isZero.
			self assert: result class = ScaledDecimal.
			self assert: result scale equals: scaledDecimal scale.

			result := (each + each) - scaledDecimal.
			self assert: result equals: each.
			self assert: result class = ScaledDecimal.
			self assert: result scale equals: scaledDecimal scale.

			result := each negated - scaledDecimal.
			self assert: result equals: (each * -2).
			self assert: result class = ScaledDecimal.
			self assert: result scale equals: scaledDecimal scale]]!

testZeroRaisedToInteger
	"Zero might be handle specially"

	self should: [0.0s1 raisedToInteger: -1] raise: Error.
	self assert: (0.0s1 raisedToInteger: 0) equals: 1.
	self assert: (0.0s1 raisedToInteger: 0) scale equals: 1.
	self assert: (0.0s1 raisedToInteger: 1) equals: 0.
	self assert: (0.0s1 raisedToInteger: 1) scale equals: 1.
	self assert: (0.0s1 raisedToInteger: 2) equals: 0.
	self assert: (0.0s1 raisedToInteger: 2) scale equals: 1! !
!Core.Tests.ScaledDecimalTest categoriesForMethods!
floatTestValues!constants!private! !
fractionTestValues!constants!private! !
integerTestValues!constants!private! !
largeIntegerTestValues!constants!private! !
literalInstances!helpers!private! !
nonLiteralInstances!helpers!private! !
numericTestValues!constants!private! !
smallIntegerTestValues!constants!private! !
testAsNumber!public!unit tests! !
testAsNumberNegatedWithoutDecimalPoint!public!unit tests! !
testAsNumberNegatedWithoutDecimalPoint2!public!unit tests! !
testAsNumberWithExtendedScale!public!unit tests! !
testAsNumberWithoutDecimalPoint!public!unit tests! !
testAsNumberWithoutDecimalPoint2!public!unit tests! !
testAsNumberWithRadix!public!unit tests! !
testAsNumberWithSuperfluousDecimalPoint!public!unit tests! !
testCoercion!public!unit tests! !
testConvertFromFloat!public!unit tests! !
testConvertFromFraction!public!unit tests! !
testConvertFromIntegerWithScale!public!unit tests! !
testEqualityComparisons!public!unit tests! !
testExactNthRoot!public!unit tests! !
testExactSqrt!public!unit tests! !
testGreaterOrEqualToFloat!public!unit tests! !
testGreaterOrEqualToFraction!public!unit tests! !
testGreaterOrEqualToInteger!public!unit tests! !
testGreaterThanFloat!public!unit tests! !
testGreaterThanFraction!public!unit tests! !
testGreaterThanInteger!public!unit tests! !
testInexactNthRoot!public!unit tests! !
testInexactSqrt!public!unit tests! !
testIsLiteral!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testLessOrEqualToFloat!public!unit tests! !
testLessOrEqualToFraction!public!unit tests! !
testLessOrEqualToInteger!public!unit tests! !
testLessThanFloat!public!unit tests! !
testLessThanFraction!public!unit tests! !
testLessThanInteger!public!unit tests! !
testLiteral!public!unit tests! !
testOneRaisedToInteger!public!unit tests! !
testPrinting!public! !
testPrintString!public!unit tests! !
testRaisedToInteger!public!unit tests! !
testReadFrom!public!unit tests! !
testRounded!public!unit tests! !
testScaleExtension!public!unit tests! !
testStoreOnRoundTrip!public!unit tests! !
testSubtractionFromInteger!public!unit tests! !
testZeroRaisedToInteger!public!unit tests! !
!


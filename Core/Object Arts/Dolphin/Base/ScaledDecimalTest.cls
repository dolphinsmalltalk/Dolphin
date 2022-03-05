"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ScaledDecimalTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScaledDecimalTest guid: (GUID fromString: '{dfe00781-39f5-4b43-ba15-861976d2ff7c}')!
ScaledDecimalTest comment: ''!
!ScaledDecimalTest categoriesForClass!Unclassified! !
!ScaledDecimalTest methodsFor!

floatTestValues
	^(self integerTestValues, self fractionTestValues) collect: [ :each | each asFloat]!

fractionTestValues
	^(self integerTestValues collect: [ :each | each / 17]), (self integerTestValues collect: [ :each | each / 297])!

integerTestValues
	^self smallIntegerTestValues, self largeIntegerTestValues!

largeIntegerTestValues
	^self smallIntegerTestValues collect: [ :each | each positive ifTrue: [each + SmallInteger maximum] ifFalse: [each + SmallInteger minimum]]!

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

	0 to: 15 do: 
		[ :scale |
		self numericTestValues do: 
			[ :each || scaledDecimal scaledDecimalPlusOne scaledDecimalMinusFraction |
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
				deny: each equals: scaledDecimalMinusFraction]]!

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
	
	self assert: 1.00s2 isLiteral description: 'every literal obviously isLiteral'.
	
	"Note that (1 / 3.00s2) is not a well behaved literal,
	because it does not re-evaluate to self...
	Every literal should be evaluated as self (see isSelfEvaluating).
	There is currently no way to print it as a literal.
	So i propose it shall not answer true."
	self deny: (1/3.00s2) isLiteral description: 'this number cannot represent itself as a literal'.!

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

testPrintString
	"The printed representation of a ScaledDecimal is rounded.
	Note that old implementation was truncated."

	| sd |
	sd := 13 / 11 asScaledDecimal: 6.
	self assert: sd printString equals: '1.181818s'.
	sd := 13 / 11 asScaledDecimal: 5.
	self assert: sd printString equals: '1.18182s'.
	sd := 13 / 11 asScaledDecimal: 5.
	self deny: '1.18181s' equals: sd printString!

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
	self should: [((ScaledDecimal readFrom: '5.3' readStream) asScaledDecimal: 1) = (53/10 asScaledDecimal: 1)]
		description: 'ScaledDecimal readFrom: should not use Float intermediate because it would introduce round off errors'.!

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
!ScaledDecimalTest categoriesForMethods!
floatTestValues!constants!private! !
fractionTestValues!constants!private! !
integerTestValues!constants!private! !
largeIntegerTestValues!constants!private! !
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
testInexactNthRoot!public!unit tests! !
testInexactSqrt!public!unit tests! !
testIsLiteral!public!unit tests! !
testLiteral!public!unit tests! !
testOneRaisedToInteger!public!unit tests! !
testPrintString!public!unit tests! !
testRaisedToInteger!public!unit tests! !
testReadFrom!public!unit tests! !
testRounded!public!unit tests! !
testScaleExtension!public!unit tests! !
testStoreOnRoundTrip!public!unit tests! !
testSubtractionFromInteger!public!unit tests! !
testZeroRaisedToInteger!public!unit tests! !
!


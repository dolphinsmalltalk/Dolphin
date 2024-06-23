"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.FractionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.FractionTest guid: (Core.GUID fromString: '{0f827f5d-fc60-490e-90f8-bc89012f1b54}')!

Core.Tests.FractionTest comment: ''!

!Core.Tests.FractionTest methodsFor!

testComparePoint
	| subject point |
	subject := 22 / 7.
	point := 3 @ 4.

	"Strange but true"
	self deny: subject < point.
	self deny: point < subject.
	self deny: subject <= point.
	self deny: point <= subject.
	self deny: point equals: subject.
	self deny: point > subject.
	self deny: subject > point.
	self deny: point >= subject.
	self deny: subject >= point.

	"More obviously true"
	point := 4@4.
	self assert: subject < point.
	self deny: point < subject.
	self assert: subject <= point.
	self deny: point <= subject.
	self deny: point equals: subject.
	self assert: point > subject.
	self deny: subject > point.
	self assert: point >= subject.
	self deny: subject >= point.
!

testComparison
	| subject subject2 subject3 |
	subject := 22 / 7.
	subject2 := 22 / 7.
	subject3 := 23 / 7.
	self assert: subject equals: subject2.
	self assert: subject hash equals: subject2 hash.
	self deny: subject equals: subject3.
	self deny: subject hash equals: subject3 hash.
	self deny: subject < subject2.
	self assert: subject <= subject2.
	self assert: subject >= subject2.
	self deny: subject > subject2.
	self assert: subject3 > subject.
	self assert: subject3 >= subject.
	self deny: subject3 < subject.
	self deny: subject3 <= subject!

testEqualToFloat
	| pos neg |
	pos := 5 / 4.
	neg := -5 / 4.
	"+ve"
	self deny: pos equals: Float infinity.
	self deny: pos equals: Float nan.
	self deny: pos equals: Float negativeInfinity.
	self deny: pos equals: Float negativeZero.
	self deny: pos equals: Float zero.
	self deny: pos equals: Float pi.
	self deny: pos equals: Float fminDenormalized.
	self assert: pos equals: 1.25.
	self deny: pos equals: neg asFloat.
	"-ve"
	self deny: neg equals: Float infinity.
	self deny: neg equals: Float nan.
	self deny: neg equals: Float negativeInfinity.
	self deny: neg equals: Float negativeZero.
	self deny: neg equals: Float zero.
	self deny: 22 / 7 equals: Float pi.
	self assert: 884279719003555 / 281474976710656 equals: Float pi.
	self deny: neg equals: Float pi.
	self deny: neg equals: pos asFloat.
	self assert: neg equals: -1.25!

testGreaterOrEqualToFloat
	| pos neg |
	pos := 5 / 4.
	neg := -5 / 4.
	"+ve"
	self deny: (pos greaterOrEqualToFloat: Float infinity).
	self deny: (pos greaterOrEqualToFloat: Float nan).
	self assert: (pos greaterOrEqualToFloat: Float negativeInfinity).
	self assert: (pos greaterOrEqualToFloat: Float negativeZero).
	self assert: (pos greaterOrEqualToFloat: Float zero).
	self assert: (pos greaterOrEqualToFloat: Float fmin).
	self assert: (pos greaterOrEqualToFloat: Float fminDenormalized).
	self deny: (pos greaterOrEqualToFloat: Float fmax).
	self assert: (pos greaterOrEqualToFloat: pos asFloat).
	self assert: (pos greaterOrEqualToFloat: neg asFloat).
	self assert: (22 / 7 greaterOrEqualToFloat: Float pi).
	self assert: (884279719003555 / 281474976710656 greaterOrEqualToFloat: Float pi).
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
	self assert: (neg greaterOrEqualToFloat: Float fmax negated)!

testGreaterOrEqualToFraction
	| pos neg posFraction negFraction |
	pos := 5 / 4.
	neg := -5 / 4.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self deny: pos >= posFraction.
	self assert: pos >= negFraction.
	self assert: pos >= (5 / 4).
	"-ve"
	self deny: neg >= posFraction.
	self assert: neg >= negFraction.
	self assert: neg >= (-5 / 4)!

testGreaterOrEqualToInteger
	| pos neg largePos largeNeg smallNeg smallPos |
	pos := 5 / 4.
	neg := -5 / 4.
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
	"-ve"
	self deny: neg >= largePos.
	self assert: neg >= largeNeg.
	self deny: neg >= 0.
	self assert: neg >= smallNeg.
	self assert: neg >= -2.
	self deny: neg >= -1!

testGreaterThanFloat
	| pos neg |
	pos := 5 / 4.
	neg := -5 / 4.
	"+ve"
	self deny: (pos greaterThanFloat: Float infinity).
	self deny: (pos greaterThanFloat: Float nan).
	self assert: (pos greaterThanFloat: Float negativeInfinity).
	self assert: (pos greaterThanFloat: Float negativeZero).
	self assert: (pos greaterThanFloat: Float zero).
	self assert: (pos greaterThanFloat: Float fmin).
	self assert: (pos greaterThanFloat: Float fminDenormalized).
	self deny: (pos greaterThanFloat: Float fmax).
	self deny: (pos greaterThanFloat: Float pi).
	self deny: (pos greaterThanFloat: pos asFloat).
	self assert: (pos greaterThanFloat: neg asFloat).
	"-ve"
	self deny: (neg greaterThanFloat: Float infinity).
	self deny: (neg greaterThanFloat: Float nan).
	self assert: (neg greaterThanFloat: Float negativeInfinity).
	self deny: (neg greaterThanFloat: Float negativeZero).
	self deny: (neg greaterThanFloat: Float zero).
	self assert: (22 / 7 greaterThanFloat: Float pi).
	self deny: (884279719003555 / 281474976710656 greaterThanFloat: Float pi).
	self deny: (neg greaterThanFloat: Float pi).
	self deny: (neg greaterThanFloat: pos asFloat).
	self deny: (neg greaterThanFloat: neg asFloat).
	self deny: (neg greaterThanFloat: Float fmin negated).
	self deny: (neg greaterThanFloat: Float fminDenormalized negated).
	self assert: (neg greaterThanFloat: Float fmax negated)!

testGreaterThanFraction
	| pos neg posFraction negFraction |
	pos := 5 / 4.
	neg := -5 / 4.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self deny: pos > posFraction.
	self assert: pos > negFraction.
	self assert: pos > 0.
	self assert: pos > 1.
	self deny: pos > 2.
	self deny: pos > (5 / 4).
	"-ve"
	self deny: neg > posFraction.
	self assert: neg > negFraction.
	self deny: neg > 0.
	self assert: neg > -2.
	self deny: neg > -1.
	self deny: neg > (-5 / 4)!

testGreaterThanInteger
	| pos neg largePos largeNeg smallNeg smallPos |
	pos := 5 / 4.
	neg := -5 / 4.
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
	"-ve"
	self deny: neg > largePos.
	self assert: neg > largeNeg.
	self deny: neg > 0.
	self assert: neg > smallNeg.
	self assert: neg > -2.
	self deny: neg > -1!

testLessOrEqualToFloat
	| pos neg |
	pos := 5 / 4.
	neg := -5 / 4.
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
	"-ve"
	self assert: neg <= Float infinity.
	self deny: neg <= Float nan.
	self deny: neg <= Float negativeInfinity.
	self assert: neg <= Float negativeZero.
	self assert: neg <= Float zero.
	self deny: 22 / 7 <= Float pi.
	self assert: 884279719003555 / 281474976710656 <= Float pi.
	self assert: neg <= Float pi.
	self assert: neg <= pos asFloat.
	self assert: neg <= neg asFloat.
	self assert: neg <= Float fmin negated.
	self assert: neg <= Float fminDenormalized negated.
	self deny: neg <= Float fmax negated!

testLessOrEqualToFraction
	| pos neg posFraction negFraction |
	pos := 5 / 4.
	neg := -5 / 4.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self assert: pos <= posFraction.
	self deny: pos <= negFraction.
	self assert: pos <= (5 / 4).
	"-ve"
	self assert: neg <= posFraction.
	self deny: neg <= negFraction.
	self assert: neg <= (-5 / 4)!

testLessOrEqualToInteger
	| pos neg largePos largeNeg smallNeg smallPos |
	pos := 5 / 4.
	neg := -5 / 4.
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
	"-ve"
	self assert: neg <= largePos.
	self deny: neg <= largeNeg.
	self assert: neg <= 0.
	self deny: neg <= smallNeg.
	self deny: neg <= -2.
	self assert: neg <= -1!

testLessThanFloat
	| pos neg |
	pos := 5 / 4.
	neg := -5 / 4.
	"+ve"
	self assert: pos < Float infinity.
	self deny: pos < Float nan.
	self deny: pos < Float negativeInfinity.
	self deny: pos < Float negativeZero.
	self deny: pos < Float zero.
	self deny: pos < Float fmin.
	self deny: pos < Float fminDenormalized.
	self assert: pos < Float fmax.
	self assert: pos < Float pi.
	self deny: pos < pos asFloat.
	self deny: pos < neg asFloat.
	"-ve"
	self assert: neg < Float infinity.
	self deny: neg < Float nan.
	self deny: neg < Float negativeInfinity.
	self assert: neg < Float negativeZero.
	self assert: neg < Float zero.
	self deny: 22 / 7 < Float pi.
	self deny: 884279719003555 / 281474976710656 < Float pi.
	self assert: neg < Float pi.
	self assert: neg < pos asFloat.
	self deny: neg < neg asFloat.
	self assert: neg < Float fmin negated.
	self assert: neg < Float fminDenormalized negated.
	self deny: neg < Float fmax negated!

testLessThanFraction
	| pos neg posFraction negFraction |
	pos := 5 / 4.
	neg := -5 / 4.
	posFraction := 3 / 2.
	negFraction := -3 / 2.
	"+ve"
	self assert: pos < posFraction.
	self deny: pos < negFraction.
	self deny: pos < 0.
	self deny: pos < 1.
	self assert: pos < 2.
	self deny: pos < (5 / 4).
	"-ve"
	self assert: neg < posFraction.
	self deny: neg < negFraction.
	self assert: neg < 0.
	self deny: neg < -2.
	self assert: neg < -1.
	self deny: neg < (-5 / 4)!

testLessThanInteger
	| pos neg largePos largeNeg smallNeg smallPos |
	pos := 5 / 4.
	neg := -5 / 4.
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
	"-ve"
	self assert: neg < largePos.
	self deny: neg < largeNeg.
	self assert: neg < 0.
	self deny: neg < smallNeg.
	self deny: neg < -2.
	self assert: neg < -1!

testNanComparisons
	| subject nan |
	subject := 22 / 7.
	nan := Float nan.
	self deny: subject equals: nan.
	self deny: nan equals: subject.
	self deny: subject < nan.
	self deny: nan < subject.
	self deny: subject <= nan.
	self deny: nan <= subject.
	self deny: subject >= nan.
	self deny: nan >= subject.
	self deny: subject > nan.
	self deny: nan > subject! !

!Core.Tests.FractionTest categoriesForMethods!
testComparePoint!public!unit tests! !
testComparison!public!unit tests! !
testEqualToFloat!public!unit tests! !
testGreaterOrEqualToFloat!public!unit tests! !
testGreaterOrEqualToFraction!public!unit tests! !
testGreaterOrEqualToInteger!public!unit tests! !
testGreaterThanFloat!public!unit tests! !
testGreaterThanFraction!public!unit tests! !
testGreaterThanInteger!public!unit tests! !
testLessOrEqualToFloat!public!unit tests! !
testLessOrEqualToFraction!public!unit tests! !
testLessOrEqualToInteger!public!unit tests! !
testLessThanFloat!public!unit tests! !
testLessThanFraction!public!unit tests! !
testLessThanInteger!public!unit tests! !
testNanComparisons!public!unit tests! !
!


"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.AbstractPointTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.AbstractPointTest guid: (Core.GUID fromString: '{a0f6e2b2-8bd1-44bc-b0ad-3343d7aa2c0f}')!
Graphics.Tests.AbstractPointTest isNonInstantiable: true!
Graphics.Tests.AbstractPointTest comment: ''!
!Graphics.Tests.AbstractPointTest methodsFor!

subjectClass
	^self subclassResponsibility!

subjectSupportNonIntegralValues
	^false!

testAdd
	| subject1 subject2 |
	subject1 := self subjectClass x: 3 y: 4.
	self assert: 0.25 + subject1 equals: 3.25 @ 4.25.
	self assert: subject1 + 0.25 equals: 3.25 @ 4.25.
	self assert: 3 / 4 + subject1 equals: (15 / 4) @ (19 / 4).
	self assert: subject1 + (3 / 4) equals: (15 / 4) @ (19 / 4).
	self assert: 5 + subject1 equals: 8 @ 9.
	self assert: subject1 + 5 equals: 8 @ 9.
	self assert: 0.33s + subject1 equals: 3.33s @ 4.33s.
	self assert: subject1 + 0.33s equals: 3.33s @ 4.33s.
	subject2 := self subjectClass x: 5 y: 10.
	self assert: subject1 + subject2 equals: 8 @ 14.
	self assert: 1 @ 3 + subject2 equals: 6 @ 13.
	self assert: subject2 + (1 @ 3) equals: 6 @ 13.
	self assert: 10 @ 20 @ 50 + subject2 equals: 15 @ 30 @ 50.
	self assert: subject2 + (10 @ 20 @ 50) equals: 15 @ 30 @ 50!

testAsGenericPoint
	| subject |
	subject := self subjectClass x: 101 y: 202.
	self assert: subject asGenericPoint identicalTo: subject!

testAsPoint
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject asPoint.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202!

testComparePOINTL
	| subject point |
	point := POINTL fromPoint: 101 @ 102.
	subject := self subjectClass x: point x y: point y.
	self assert: subject equals: subject.
	self assert: subject species identicalTo: Point.
	self assert: subject hash equals: point hash.
	self assert: subject equals: point.
	self assert: point equals: subject!

testComparePOINTS
	| subject point |
	point := POINTS fromPoint: 101 @ 102.
	subject := self subjectClass x: point x y: point y.
	self assert: subject equals: subject.
	self assert: subject species identicalTo: Point.
	self assert: subject hash equals: point hash.
	self assert: subject equals: point.
	self assert: point equals: subject!

testComparing
	| subject point |
	point := 101 @ 102.
	subject := self subjectClass x: point x y: point y.
	self assert: subject equals: subject.
	self assert: subject species identicalTo: Point.
	self assert: subject hash equals: point hash.
	self assert: subject equals: point.
	self assert: point equals: subject.
	self deny: subject equals: 101.
	self deny: 101 equals: subject.
	self deny: subject equals: 102.
	self deny: 102 equals: subject.
	self deny: subject equals: 101.0.
	self deny: 101.0 equals: subject.
	self deny: subject equals: 102.0.
	self deny: 102.0 equals: subject.
	self deny: subject equals: 101s.
	self deny: 101s equals: subject.
	self deny: subject equals: 102s.
	self deny: 102s equals: subject.
	subject := self subjectClass x: 100 y: 100.
	self assert: subject equals: 100.
	self assert: 100 equals: 100.
	self assert: subject equals: 100.0.
	self assert: 100.0 equals: subject.
	self assert: subject equals: 100s1.
	self assert: 100s1 equals: subject.
	self subjectSupportNonIntegralValues ifFalse: [^self].
	point := 0.5 @ 0.25.
	subject := self subjectClass x: 0.5 y: 0.25.
	self assert: subject equals: subject.
	self assert: subject hash equals: point hash.
	self assert: subject equals: point.
	self assert: point equals: subject.
	self deny: subject equals: 1 / 2.
	self deny: 1 / 2 equals: subject.
	self deny: subject equals: 1 / 4.
	self deny: 1 / 4 equals: subject.
	subject := self subjectClass x: 0.75 y: 0.75.
	self assert: subject equals: 0.75.
	self assert: 0.75 equals: subject.
	self assert: subject equals: 3 / 4.
	self assert: 3 / 4 equals: subject.
	self assert: subject equals: 0.75s.
	self assert: 0.75s equals: subject.
	subject := self subjectClass x: Float nan y: 0.75.
	self deny: subject equals: 0.75.
	self deny: 0.75 equals: subject.
	self deny: subject equals: 3 / 4.
	self deny: 3 / 4 equals: subject.
	self deny: subject equals: 0.75s.
	self deny: 0.75s equals: subject.
	subject := self subjectClass x: 0.75 y: Float nan.
	self deny: subject equals: 0.75.
	self deny: 0.75 equals: subject.
	self deny: subject equals: 3 / 4.
	self deny: 3 / 4 equals: subject.
	self deny: subject equals: 0.75s.
	self deny: 0.75s equals: subject!

testDivide
	| subject2 subject1 point1 point2 large |
	point1 := 10 @ 100.
	subject1 := self subjectClass x: point1 x y: point1 y.
	point2 := 2 @ 4.
	subject2 := self subjectClass x: point2 x y: point2 y.
	self assert: subject1 / subject2 equals: 5 @ 25.
	self assert: point1 / subject2 equals: 5 @ 25.
	self assert: subject1 / subject2 equals: 5 @ 25.
	self assert: subject1 / point2 equals: 5 @ 25.
	self assert: subject1 / 4 equals: 2.5 @ 25.
	self assert: 4 / subject2 equals: 2 @ 1.
	self assert: subject1 / 0.5 equals: 20 @ 200.
	self assert: 2.5 / subject2 equals: 1.25 @ 0.625.
	self assert: subject1 / 0.5s equals: 20 @ 200.
	self assert: 2.5s / subject2 equals: 1.25s @ 0.625s.
	self assert: subject1 / (1 / 2) equals: 20 @ 200.
	self assert: 5 / 2 / subject2 equals: (5 / 4) @ (5 / 8).
	large := SmallInteger maximum + 1.
	self assert: subject2 / large equals: (2 / large) @ (4 / large).
	"Because coercing a point to a Point3D always results in zero 'z' dimension, we will always get a zero divide error here"
	self
		should: [1 @ 2 @ 3 / (self subjectClass x: 4 y: 5)]
		raise: ZeroDivide
		matching: [:ex | ex tag = 3]!

testFractionPart
	self assert: (self subjectClass x: 1 y: 2) fractionPart equals: 0@0.
	self subjectSupportNonIntegralValues ifFalse: [^self].
	self assert: (self subjectClass x: 1.25 y: 2.5) fractionPart equals: 0.25@0.5

!

testGreaterOrEqual
	| subject |
	subject := self subjectClass x: 2 y: 3.
	self assert: subject >= 1.
	self deny: 1 >= subject.
	self assert: subject >= 2.
	self deny: 2 >= subject.
	self deny: subject >= 4.
	self assert: 4 >= subject.
	self assert: subject >= 1.5.
	self deny: 1.5 >= subject.
	self assert: subject >= 2.0.
	self deny: 2.0 >= subject.
	self deny: subject >= 2.1.
	self deny: 2.1 >= subject.
	self deny: subject >= 3.1.
	self assert: 3.1 >= subject.
	self assert: subject >= (3 / 2).
	self deny: 3 / 2 >= subject.
	self deny: subject >= (11 / 5).
	self deny: 11 / 5 >= subject.
	self deny: subject >= (10 / 3).
	self assert: 10 / 3 >= subject.
	self assert: subject >= 1.5s.
	self deny: 1.5s >= subject.
	self assert: subject >= 2.0s.
	self deny: 2.0s >= subject.
	self deny: subject >= 2.01s.
	self deny: 2.01s >= subject.
	self deny: subject >= 3.0s.
	self assert: 3.0s >= subject.
	self deny: subject >= 3.1s.
	self assert: 3.1s >= subject.
	self assert: subject >= (1.9 @ 2.9).
	self deny: 1.9 @ 2.9 >= subject.
	self deny: subject >= (2.1 @ 2.9).
	self deny: 2.1 @ 2.9 >= subject.
	self assert: subject >= (1.1 @ 2.1 @ 0).
	self deny: 1.1 @ 2.1 @ 0 >= subject.
	self assert: subject >= (1 @ 3 @ 0).
	self deny: 1 @ 3 @ 0 >= subject.
	self assert: subject >= (2 @ 3 @ 0).
	self assert: 2 @ 3 @ 0 >= subject.
	self deny: subject >= (2.1 @ 3 @ 0).
	self assert: 2.1 @ 3 @ 0 >= subject.
	self deny: 2.1 @ 3 @ -1 >= subject.
	self deny: subject >= (2 @ 3.1 @ 0).
	self assert: 2 @ 3.1 @ 0 >= subject.
	self deny: subject >= (2 @ 3 @ 4).
	self assert: 2 @ 3 @ 4 >= subject!

testGreaterThan
	| subject |
	subject := self subjectClass x: 2 y: 3.
	self assert: subject > 1.
	self deny: 1 > subject.
	self deny: subject > 2.
	self deny: 2 > subject.
	self deny: subject > 3.
	self deny: 3 > subject.
	self deny: subject > 4.
	self assert: 4 > subject.
	self assert: subject > 1.5.
	self deny: 1.5 > subject.
	self deny: subject > 2.0.
	self deny: 2.0 > subject.
	self deny: subject > 3.0.
	self deny: 3.0 > subject.
	self deny: subject > 3.1.
	self assert: 3.1 > subject.
	self assert: subject > (1 / 2).
	self deny: 1 / 2 > subject.
	self deny: subject > (10 / 3).
	self assert: 10 / 3 > subject.
	self assert: subject > 0.5s.
	self deny: 0.5s > subject.
	self deny: subject > 3.0s.
	self deny: 3.0s > subject.
	self deny: subject > 3.1s.
	self assert: 3.1s > subject.
	self assert: subject > (1.9 @ 2.9).
	self deny: (1.9 @ 2.9) > subject.
	self deny: subject > (2 @ 2.9).
	self deny: (2 @ 2.9) > subject.
	self deny: subject > (2 @ 3.1).
	self deny: (2 @ 3.1) > subject.
	self deny: subject > (2.1 @ 3).
	self deny: (2.1 @ 3) > subject.
	self assert: (2.1 @ 3.1) > subject.
	self deny: subject > (2 @ 3 @ 0).
	self deny: subject > (2.1 @ 3.1 @ 0).
	self assert: subject > (1.1 @ 2.1 @ -0.1).
	self deny: subject > (2 @ 3 @ 0)!

testIntegerPart
	self assert: (self subjectClass x: 1 y: 2) integerPart equals: 1@2.
	self subjectSupportNonIntegralValues ifFalse: [^self].
	self assert: (self subjectClass x: 1.25 y: 2.5) integerPart equals: 1@2

!

testIsZero
	self assert: (self subjectClass x: 0 y: 0) isZero.
	self deny: (self subjectClass x: 0 y: 1) isZero.
	self deny: (self subjectClass x: 1 y: 0) isZero.
	self deny: (self subjectClass x: 1 y: 1) isZero!

testLessOrEqual
	| subject |
	subject := self subjectClass x: 1 y: 2.
	self assert: subject <= 3.
	self assert: 3 >= subject.
	self assert: subject <= 2.
	self assert: 2 >= subject.
	self deny: subject <= 1.
	self deny: 1 >= subject.
	self assert: subject <= 2.5.
	self assert: 2.5 >= subject.
	self assert: subject <= 2.0.
	self assert: 2.0 >= subject.
	self deny: subject <= 1.9.
	self deny: 1.9 >= subject.
	self assert: subject <= (5 / 2).
	self assert: 5 / 2 >= subject.
	self assert: subject <= 2.1s.
	self assert: 2.1s >= subject.
	self assert: subject <= 2.0s.
	self assert: 2.0s >= subject.
	self assert: subject <= (1.1 @ 2.1).
	self assert: 1.1 @ 2.1 >= subject.
	self assert: subject <= (1.1 @ 2.0).
	self assert: 1.1 @ 2.0 >= subject.
	self deny: subject <= (1.1 @ 1.9).
	self deny: 1.1 @ 1.9 >= subject.
	self assert: subject <= (1.1 @ 2.1 @ 0).
	self assert: 1.1 @ 2.1 @ 0 >= subject!

testLessThan
	| subject |
	subject := self subjectClass x: 1 y: 2.
	self assert: subject < 3.
	self assert: 3 > subject.
	self deny: subject < 2.
	self deny: 2 > subject.
	self assert: subject < 2.5.
	self assert: 2.5 > subject.
	self deny: subject < 2.0.
	self deny: 2.0 > subject.
	self assert: subject < (5 / 2).
	self assert: 5 / 2 > subject.
	self assert: subject < 2.1s.
	self assert: 2.1s > subject.
	self deny: subject < 2.0s.
	self deny: 2.0s > subject.
	self assert: subject < (1.1 @ 2.1).
	self assert: 1.1 @ 2.1 > subject.
	self deny: subject < (1.1 @ 2.0).
	self deny: 1.1 @ 2.0 > subject.
	self assert: subject < (1.1 @ 2.1 @ 0).
	self assert: 1.1 @ 2.1 @ 1 > subject!

testMakePoint
	| point point2 originalMethod testMethod |
	point := self subjectClass x: 101 y: 202.
	self assert: point x equals: 101.
	self assert: point y equals: 202.
	originalMethod := self subjectClass class lookupMethod: #x:y:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	point2 := testMethod value: self subjectClass withArguments: #(101 202).
	self assert: point2 x equals: 101.
	self assert: point2 y equals: 202!

testMultiply
	| subject1 subject2 |
	subject1 := self subjectClass x: 3 y: 4.
	subject2 := self subjectClass x: 4 y: 5.
	self assert: subject1 * subject2 equals: 12 @ 20.
	self assert: 0.25 * subject1 equals: 0.75 @ 1.0.
	self assert: subject1 * 0.25 equals: 0.75 @ 1.0.
	self assert: 1 / 4 * subject1 equals: (3 / 4) @ 1.
	self assert: subject1 * (1 / 4) equals: (3 / 4) @ 1.
	self assert: 5 * subject1 equals: 15 @ 20.
	self assert: subject1 * 5 equals: 15 @ 20.
	self assert: 4 @ 5 * subject1 equals: 12 @ 20.
	self assert: subject1 * (4 @ 5) equals: 12 @ 20.
	self assert: 0.25s * subject1 equals: 0.75 @ 1.
	self assert: subject1 * 0.25s equals: 0.75 @ 1.
	self assert: 4 @ 5 @ 6 * subject1 equals: 12 @ 20 @ 0.
	self assert: subject1 * (4 @ 5 @ 6) equals: 12 @ 20 @ 0!

testSubtract
	| subject1 subject2 |
	subject1 := self subjectClass x: 1 y: 2.
	subject2 := self subjectClass x: 5 y: 10.
	self assert: subject1 - subject2 equals: -4 @ -8.
	self assert: subject2 - subject1 equals: 4 @ 8.
	self assert: 1.25 - subject1 equals: 0.25 @ -0.75.
	self assert: subject1 - 1.25 equals: -0.25 @ 0.75.
	self assert: 1 / 2 - subject1 equals: (-1 / 2) @ (-3 / 2).
	self assert: subject1 - (1 / 2) equals: (1 / 2) @ (3 / 2).
	self assert: 3 - subject1 equals: 2 @ 1.
	self assert: subject1 - 3 equals: -2 @ -1.
	self assert: subject1 - (SmallInteger minimum - 1)
		equals: (SmallInteger minimum - 2) negated @ (SmallInteger minimum - 3) negated.
	self assert: 0.25s - subject1 equals: -0.75s @ -1.75s.
	self assert: subject1 - 0.25s equals: 0.75s @ 1.75s.
	self assert: 10 @ 20 - subject2 equals: 5 @ 10.
	self assert: subject2 - (10 @ 20) equals: -5 @ -10.
	self assert: 10 @ 20 @ 30 - subject2 equals: 5 @ 10 @ 30.
	self assert: subject2 - (10 @ 20 @ 30) equals: -5 @ -10 @ -30! !
!Graphics.Tests.AbstractPointTest categoriesForMethods!
subjectClass!constants!private! !
subjectSupportNonIntegralValues!private!testing! !
testAdd!public!unit tests! !
testAsGenericPoint!public!unit tests! !
testAsPoint!public!unit tests! !
testComparePOINTL!public!unit tests! !
testComparePOINTS!public!unit tests! !
testComparing!public!unit tests! !
testDivide!public!unit tests! !
testFractionPart!public!unit tests! !
testGreaterOrEqual!public!unit tests! !
testGreaterThan!public!unit tests! !
testIntegerPart!public! !
testIsZero!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLessThan!public!unit tests! !
testMakePoint!public!unit tests! !
testMultiply!public!unit tests! !
testSubtract!public!unit tests! !
!


"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.AbstractRectangleTest'
	instanceVariableNames: 'desktop oddDesktop unary'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.AbstractRectangleTest guid: (Core.GUID fromString: '{87bd8e07-c183-4124-a098-05b9e73fbd86}')!

Graphics.Tests.AbstractRectangleTest isNonInstantiable: true!

Graphics.Tests.AbstractRectangleTest comment: ''!

!Graphics.Tests.AbstractRectangleTest methodsFor!

setUp
	"Note that desktop is always a fixed size to make writing the tests easier"

	super setUp.
	desktop := self subjectClass origin: 0 @ 0 corner: 1280 @ 1024.
	oddDesktop := self subjectClass origin: -1 @ 2 corner: 1279 @ 1023.
	unary := self subjectClass origin: 0 @ 0 extent: 1 @ 1!

subjectClass
	^self subclassResponsibility!

testBottom
	self assert: oddDesktop bottom equals: 1023.
	self assert: oddDesktop height equals: 1021.
	oddDesktop bottom: 2048.
	self assert: oddDesktop bottom equals: 2048.
	self assert: oddDesktop height equals: 2046
!

testCenter
	self assert: desktop center equals: 640 @ 512.
	self assert: oddDesktop center equals: 639 @ 512.
	self assert: unary center equals: 0 @ 0!

testCenterRight
	self assert: desktop centerRight equals: 1280 @ 512!

testCenterX
	self assert: desktop centerX equals: 640.
	self assert: oddDesktop centerX equals: 639!

testComparing
	| rectangle |
	self assert: oddDesktop equals: oddDesktop.
	self assert: oddDesktop species identicalTo: Rectangle.
	rectangle := -1 @ 2 corner: 1279 @ 1023.
	self assert: oddDesktop hash equals: rectangle hash.
	self assert: oddDesktop equals: rectangle.
	self assert: rectangle equals: oddDesktop!

testCopy
	| subject copy |
	subject := self subjectClass origin: 51 @ 101 corner: 101 @ 202.
	self assert: subject corner equals: 101 @ 202.
	copy := subject copy.
	self deny: subject == copy.
	self assert: copy equals: subject.
	self deny: subject origin == copy origin.
	self deny: subject corner == copy corner.
	subject top: 103.
	self assert: subject origin equals: 51 @ 103.
	self deny: copy equals: subject.
	self assert: copy origin equals: 51 @ 101.
	copy right: 105.
	self assert: subject corner equals: 101 @ 202!

testHeight
	self assert: oddDesktop height equals: 1021!

testLeft
	self assert: oddDesktop left equals: -1.
	self assert: oddDesktop width equals: 1280.
	oddDesktop left: 3.
	self assert: oddDesktop left equals: 3.
	self assert: oddDesktop width equals: 1276!

testOriginCorner
	| rect rect2 originalMethod testMethod |
	rect := self subjectClass origin: 100 @ 200 corner: 300 @ 400.
	self assert: rect origin equals: 100 @ 200.
	self assert: rect corner equals: 300 @ 400.
	originalMethod := self subjectClass class lookupMethod: #origin:corner:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	rect2 := testMethod value: self subjectClass withArguments: {100 @ 200. 300 @ 400}.
	self assert: rect2 equals: rect!

testPosition
	| rect ext |
	rect := self subjectClass origin: 2 @ 1 corner: 6 @ 4.
	ext := rect extent.
	rect position: 1 @ 3.
	self assert: rect origin equals: 1 @ 3.
	self assert: rect extent equals: ext.
	self assert: rect corner equals: rect origin + ext!

testRight
	self assert: desktop right equals: 1280.
	desktop right: 3072.
	self assert: desktop right equals: 3072.
	self assert: desktop width equals: 3072
!

testScaledBy
	| subject scaled |
	subject := self subjectClass origin: 2 @ 2 corner: 6 @ 4.
	scaled := subject scaledBy: 2.
	self assert: scaled equals: (4 @ 4 corner: 12 @ 8).
	scaled := subject scaledBy: 1 / 2.
	self assert: scaled equals: (1 @ 1 corner: 3 @ 2).
	scaled := subject scaledBy: 0.
	self assert: scaled equals: (0 @ 0 corner: 0 @ 0)!

testScaleToDpiFrom
	"Test DPI scaling in-place"

	| rect |
	rect := self subjectClass origin: 2 @ 2 corner: 6 @ 4.
	rect scaleToDpi: 192 from: 96.
	self assert: rect left equals: 4.
	self assert: rect right equals: 12.
	self assert: rect top equals: 4.
	self assert: rect bottom equals: 8.
	rect := self subjectClass origin: 2 @ 2 corner: 6 @ 4.
	rect scaleToDpi: 96 from: 192.
	self assert: rect left equals: 1.
	self assert: rect right equals: 3.
	self assert: rect top equals: 1.
	self assert: rect bottom equals: 2!

testTop
	self assert: oddDesktop top equals: 2.
	self assert: oddDesktop height equals: 1021.
	oddDesktop top: 3.
	self assert: oddDesktop top equals: 3.
	self assert: oddDesktop height equals: 1020.
!

testWidth
	self assert: oddDesktop width equals: 1280! !

!Graphics.Tests.AbstractRectangleTest categoriesForMethods!
setUp!public!Running! !
subjectClass!constants!private! !
testBottom!public!unit tests! !
testCenter!public!unit tests! !
testCenterRight!public!unit tests! !
testCenterX!public!unit tests! !
testComparing!public! !
testCopy!public! !
testHeight!public!unit tests! !
testLeft!public!unit tests! !
testOriginCorner!public!unit tests! !
testPosition!public!unit tests! !
testRight!public!unit tests! !
testScaledBy!public!unit tests! !
testScaleToDpiFrom!public!unit tests! !
testTop!public!unit tests! !
testWidth!public!unit tests! !
!


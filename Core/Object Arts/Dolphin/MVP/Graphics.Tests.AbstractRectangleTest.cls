"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.AbstractRectangleTest'
	instanceVariableNames: 'desktop oddDesktop unary'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.AbstractRectangleTest guid: (Core.GUID fromString: '{87bd8e07-c183-4124-a098-05b9e73fbd86}')!
Graphics.Tests.AbstractRectangleTest isNonInstantiable: true!
Graphics.Tests.AbstractRectangleTest comment: ''!
!Graphics.Tests.AbstractRectangleTest categoriesForClass!Unclassified! !
!Graphics.Tests.AbstractRectangleTest methodsFor!

setUp
	"Note that desktop is always a fixed size to make writing the tests easier"

	desktop := self subjectClass origin: 0 @ 0 corner: 1280 @ 1024.
	oddDesktop := self subjectClass origin: -1 @ 2 corner: 1279 @ 1023.
	unary := self subjectClass origin: 0 @ 0 extent: 1 @ 1!

subjectClass
	^self subclassResponsibility!

testBottom
	self assert: desktop bottom equals: 1024!

testCenter
	self assert: desktop center equals: 640 @ 512.
	self assert: oddDesktop center equals: 639 @ 512.
	self assert: unary center equals: 0 @ 0!

testCenterX
	self assert: desktop centerX equals: 640.
	self assert: oddDesktop centerX equals: 639!

testHeight
	self assert: oddDesktop height equals: 1021!

testLeft
	self assert: oddDesktop left  equals: -1!

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

testRight
	self assert: desktop right equals: 1280!

testTop
	self assert: oddDesktop top equals: 2!

testWidth
	self assert: oddDesktop width equals: 1280! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #setUp!public!Running! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #subjectClass!constants!private! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testBottom!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testCenter!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testCenterX!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testHeight!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testLeft!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testOriginCorner!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testRight!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testTop!public!unit tests! !
!Graphics.Tests.AbstractRectangleTest categoriesFor: #testWidth!public!unit tests! !


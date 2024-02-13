"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #AbstractRectangleTest
	instanceVariableNames: 'desktop oddDesktop unary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractRectangleTest guid: (GUID fromString: '{87bd8e07-c183-4124-a098-05b9e73fbd86}')!

AbstractRectangleTest isAbstract: true!

AbstractRectangleTest comment: ''!

!AbstractRectangleTest categoriesForClass!Unclassified! !

!AbstractRectangleTest methodsFor!

setUp
	"Note that desktop is always a fixed size to make writing the tests easier"

	desktop := self subjectClass origin: 0 @ 0 corner: 1280 @ 1024.
	oddDesktop := self subjectClass origin: -1 @ 2 corner: 1279 @ 1023.
	unary := self subjectClass origin: 0 @ 0 extent: 1 @ 1!

subjectClass
	^self subclassResponsibility!

testArea
	self assert: self subjectClass new area equals: 0.
	self assert: (self subjectClass origin: 0 @ 0 corner: 5 @ 5) area equals: 25.
	self assert: (self subjectClass origin: 2 @ 3 corner: 10 @ 8) area equals: 40.
	self assert: (self subjectClass origin: 5 @ 5 corner: 6 @ 6) area equals: 1.
	self assert: (self subjectClass origin: -1 @ -2 corner: 2 @ 1) area equals: 9!

testAreasOutside
	"2"

	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (0 @ 0 corner: 180 @ 180)) asArray
		equals: (Array with: (100 @ 180 corner: 200 @ 200) with: (180 @ 100 corner: 200 @ 180)).
	"3"
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 0 corner: 180 @ 180)) asArray
		equals: (Array
				with: (100 @ 180 corner: 200 @ 200)
				with: (100 @ 100 corner: 120 @ 180)
				with: (180 @ 100 corner: 200 @ 180)).
	"4"
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 120 corner: 180 @ 180)) asArray
		equals: (Array
				with: (100 @ 100 corner: 200 @ 120)
				with: (100 @ 180 corner: 200 @ 200)
				with: (100 @ 120 corner: 120 @ 180)
				with: (180 @ 120 corner: 200 @ 180)).
	"#2132: If the rectangles do not intersect should get back the receiver whether or not they touch."
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (120 @ 200 corner: 180 @ 400))
		equals: (Array with: (100 @ 100 corner: 200 @ 200)).
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (300 @ 300 corner: 400 @ 400)) asArray
		equals: (Array with: (100 @ 100 corner: 200 @ 200)).
	self assert: ((100 @ 100 corner: 200 @ 200) areasOutside: (200 @ 200 corner: 400 @ 400))
		equals: (Array with: (100 @ 100 corner: 200 @ 200))!

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

testCenterMove
	self assert: ((self subjectClass origin: 100 @ 200 extent: 300 @ 300) center: 200 @ 100)
		equals: (50@-50 extent: 300 @ 300)!

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
	self assert: rectangle equals: oddDesktop.
	self deny: desktop equals: Object new!

testContains
	self assert: (desktop contains: (100 @ 200 extent: 300 @ 400)).
	self assert: (desktop contains: desktop).
	self assert: (desktop contains: desktop copy).
	self deny: (desktop contains: (-1 @ 0 extent: desktop extent)).
	self deny: (desktop contains: (0 @ 1 extent: desktop extent)).
	self assert: (desktop contains: (1 @ 1 extent: desktop extent - 1))!

testContainsPoint
	self assert: (desktop containsPoint: 0 @ 0).
	self deny: (desktop containsPoint: 1280 @ 1024).
	self deny: (desktop containsPoint: 1280 @ 1023).
	self deny: (desktop containsPoint: 1279 @ 1024).
	self assert: (desktop containsPoint: 1279 @ 1023).
	self deny: (desktop containsPoint: -1 @ 0).
	self assert: (oddDesktop containsPoint: -1 @ 2)!

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

testInsetBy
	| square100 |
	self assert: (desktop insetBy: 1) equals: (1 @ 1 corner: 1279 @ 1023).
	self assert: (desktop insetBy: 2) equals: (2 @ 2 corner: 1278 @ 1022).
	self assert: (desktop insetBy: 1 @ 1) equals: (1 @ 1 corner: 1279 @ 1023).
	self assert: (desktop insetBy: 2 @ 2) equals: (2 @ 2 corner: 1278 @ 1022).
	self assert: (desktop insetBy: 1 @ 2) equals: (1 @ 2 corner: 1279 @ 1022).
	self assert: ((1 @ 2 corner: 3 @ 4) insetBy: (2 @ 0 corner: 0 @ 0)) equals: (3 @ 2 corner: 3 @ 4).
	square100 := self subjectClass origin: 0 @ 0 extent: 100 @ 100.
	self assert: (square100 insetBy: 200 @ 200) equals: (200 @ 200 corner: -100 @ -100).
	self assert: square100 equals: (0 @ 0 extent: 100 @ 100).
	self assert: (square100 insetBy: 50 @ 50) equals: (self subjectClass origin: 50 @ 50 extent: 0 @ 0)!

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
	self assert: desktop width equals: 3072!

testScaledBy
	| subject |
	subject := self subjectClass origin: 2 @ 2 corner: 6 @ 4.
	self assert: (subject scaledBy: 2) left equals: 4.
	self assert: (subject scaledBy: 2) right equals: 12.
	self assert: (subject scaledBy: 2) top equals: 4.
	self assert: (subject scaledBy: 2) bottom equals: 8.
	self assert: (subject scaledBy: 1 / 2) left equals: 1.
	self assert: (subject scaledBy: 1 / 2) right equals: 3.
	self assert: (subject scaledBy: 1 / 2) top equals: 1.
	self assert: (subject scaledBy: 1 / 2) bottom equals: 2.
	self assert: (subject scaledBy: 0) left equals: 0.
	self assert: (subject scaledBy: 0) right equals: 0.
	self assert: (subject scaledBy: 0) top equals: 0.
	self assert: (subject scaledBy: 0) bottom equals: 0!

testTop
	self assert: oddDesktop top equals: 2.
	self assert: oddDesktop height equals: 1021.
	oddDesktop top: 3.
	self assert: oddDesktop top equals: 3.
	self assert: oddDesktop height equals: 1020.
!

testTranslatedBy
	| subject |
	subject := self subjectClass origin: 2 @ 2 corner: 6 @ 4.
	self assert: (subject translatedBy: 2) left equals: 4.
	self assert: (subject translatedBy: 2) right equals: 8.
	self assert: (subject translatedBy: 2) top equals: 4.
	self assert: (subject translatedBy: 2) bottom equals: 6.
	self assert: (subject translatedBy: 2 negated) left equals: 0.
	self assert: (subject translatedBy: 2 negated) right equals: 4.
	self assert: (subject translatedBy: 2 negated) top equals: 0.
	self assert: (subject translatedBy: 2 negated) bottom equals: 2!

testWidth
	self assert: oddDesktop width equals: 1280! !

!AbstractRectangleTest categoriesForMethods!
setUp!public!Running! !
subjectClass!constants!private! !
testArea!public!unit tests! !
testAreasOutside!public!unit tests! !
testBottom!public!unit tests! !
testCenter!public!unit tests! !
testCenterMove!public!unit tests! !
testCenterRight!public! !
testCenterX!public!unit tests! !
testComparing!public!unit tests! !
testContains!public! !
testContainsPoint!public! !
testCopy!public!unit tests! !
testHeight!public!unit tests! !
testInsetBy!public!unit tests! !
testLeft!public!unit tests! !
testOriginCorner!public!unit tests! !
testPosition!public!unit tests! !
testRight!public!unit tests! !
testScaledBy!public!unit tests! !
testTop!public!unit tests! !
testTranslatedBy!public!unit tests! !
testWidth!public!unit tests! !
!


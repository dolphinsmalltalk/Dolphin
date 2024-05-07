"Filed out from Dolphin Smalltalk"!

AbstractRectangleTest subclass: #ExternalRectangleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalRectangleTest guid: (GUID fromString: '{5b388dce-77ef-4247-b882-b3918e272295}')!

ExternalRectangleTest isAbstract: true!

ExternalRectangleTest comment: ''!

!ExternalRectangleTest categoriesForClass!Unclassified! !

!ExternalRectangleTest methodsFor!

testAsRectangle
	self assert: desktop asRectangle equals: (0 @ 0 corner: 1280 @ 1024).
	self assert: oddDesktop asRectangle equals: (-1 @ 2 corner: 1279 @ 1023).
	self assert: unary asRectangle equals: (0 @ 0 extent: 1 @ 1)!

testMarshal
	| subject rectangle rectangle2 |
	rectangle := -5 @ -10 corner: 100 @ 200.
	subject := self subjectClass marshal: rectangle.
	self assert: subject isKindOf: self subjectClass.
	self assert: subject equals: rectangle.
	rectangle2 := subject asRectangle.
	self assert: rectangle2 isKindOf: Rectangle.
	self assert: rectangle2 equals: rectangle!

testScaleBy
	"Test scaling in-place"

	| rect |
	rect := self subjectClass marshal: (2 @ 2 corner: 6 @ 4).
	rect scaleBy: 2.
	self assert: rect left equals: 4.
	self assert: rect right equals: 12.
	self assert: rect top equals: 4.
	self assert: rect bottom equals: 8.
	rect := self subjectClass marshal: (2 @ 2 corner: 6 @ 4).
	rect scaleBy: 1 / 2.
	self assert: rect left equals: 1.
	self assert: rect right equals: 3.
	self assert: rect top equals: 1.
	self assert: rect bottom equals: 2.
	rect scaleBy: 0.
	self assert: rect left equals: 0.
	self assert: rect right equals: 0.
	self assert: rect top equals: 0.
	self assert: rect bottom equals: 0! !

!ExternalRectangleTest categoriesForMethods!
testAsRectangle!public! !
testMarshal!public! !
testScaleBy!public! !
!


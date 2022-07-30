"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractRectangleTest subclass: #'External.Tests.RECTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.RECTTest guid: (Core.GUID fromString: '{5b388dce-77ef-4247-b882-b3918e272295}')!
External.Tests.RECTTest isNonInstantiable: true!
External.Tests.RECTTest comment: ''!
!External.Tests.RECTTest methodsFor!

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
	self assert: rectangle2 isKindOf: UI.Rectangle.
	self assert: rectangle2 equals: rectangle! !
!External.Tests.RECTTest categoriesForMethods!
testAsRectangle!public! !
testMarshal!public! !
!


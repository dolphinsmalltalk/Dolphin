"Filed out from Dolphin Smalltalk"!

AbstractRectangleTest subclass: #RectangleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RectangleTest guid: (GUID fromString: '{aceafc61-24f9-482c-a8e7-0aff0e7fcc85}')!

RectangleTest comment: ''!

!RectangleTest categoriesForClass!Unclassified! !

!RectangleTest methodsFor!

subjectClass
	^Rectangle!

testCenterXMove
	self assert: (desktop centerX: -320) equals: (-960 @ 0 extent: 1280 @ 1024)!

testVertices
	self assert: oddDesktop vertices equals: {-1 @ 2. 1279 @ 2. 1279 @ 1023. -1 @ 1023}! !

!RectangleTest categoriesForMethods!
subjectClass!constants!private! !
testCenterXMove!public!unit tests! !
testVertices!public!unit tests! !
!


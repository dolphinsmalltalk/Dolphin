"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.Point3DTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.Point3DTest guid: (Core.GUID fromString: '{e1ecedad-639e-42fc-b8a0-04911e61fcb5}')!
Graphics.Tests.Point3DTest comment: 'Test the Point3D class'!
!Graphics.Tests.Point3DTest methodsFor!

testAsPoint
	| result |
	result := (1 @ 2 @ 3) asPoint.
	self assert: result class identicalTo: Point.
	self assert: result x equals: 1.
	self assert: result y equals: 2!

testEquals
	self assert: 0 @ 0 @ 0 equals: 0.
	self assert: 0 equals: 0 @ 0 @ 0.
	self assert: 1 @ 1 @ 1 equals: 1.
	self assert: 1 equals: 1 @ 1 @ 1.
	self assert: 1.5 @ 1.5 @ 1.5 equals: 1.5.
	self assert: 1.5 equals: 1.5 @ 1.5 @ 1.5.
	self assert: 1 @ 1 @ 1 equals: 1 @ 1 @ 1.
	self deny: 1 @ 2 @ 3 equals: 2 @ 1 @ 3.
	self deny: 1 @ 2 @ 3 equals: 1.5!

testNew
	| new |
	new := Point3D new.
	self assert: new x identicalTo: 0.
	self assert: new y identicalTo: 0.
	self assert: new z identicalTo: 0.
	self assert: new equals: Point3D zero! !
!Graphics.Tests.Point3DTest categoriesForMethods!
testAsPoint!public!unit tests! !
testEquals!public!unit tests! !
testNew!public!unit tests! !
!


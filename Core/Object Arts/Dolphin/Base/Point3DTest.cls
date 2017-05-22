"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #Point3DTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Point3DTest guid: (GUID fromString: '{e1ecedad-639e-42fc-b8a0-04911e61fcb5}')!
Point3DTest comment: 'Test the Point3D class'!
!Point3DTest categoriesForClass!Unclassified! !
!Point3DTest methodsFor!

testAsPoint
	| result |
	result :=  (1@2@3) asPoint.
	self assert: result class == Point.
	self assert: result x = 1.
	self assert: result y = 2.!

testEquals
	self assert: 0 @ 0 @ 0 = 0.
	self assert: 0 = (0 @ 0 @ 0).
	self assert: 1 @ 1 @ 1 = 1.
	self assert: 1 = (1 @ 1 @ 1).
	self assert: 1.5 @ 1.5 @ 1.5 = 1.5.
	self assert: 1.5 = (1.5 @ 1.5 @ 1.5).
	self assert: 1 @ 1 @ 1 = (1 @ 1 @ 1).
	self assert: (1 @ 2) @ 3 ~= ((2 @ 1) @ 3).
	self assert: (1 @ 2) @ 3 ~= 1.5!

testNew
	| new |
	new := Point3D new.
	self assert: new x == 0.
	self assert: new y == 0.
	self assert: new z == 0.

	self assert: new = Point3D zero.
	! !
!Point3DTest categoriesFor: #testAsPoint!public!unit tests! !
!Point3DTest categoriesFor: #testEquals!public!unit tests! !
!Point3DTest categoriesFor: #testNew!public!unit tests! !


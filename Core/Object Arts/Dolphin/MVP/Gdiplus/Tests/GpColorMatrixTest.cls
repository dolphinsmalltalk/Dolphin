"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GpColorMatrixTest
	instanceVariableNames: 'matrix'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpColorMatrixTest guid: (GUID fromString: '{00610fdc-d988-4d65-a319-78a2dd28b367}')!
GpColorMatrixTest comment: ''!
!GpColorMatrixTest categoriesForClass!Unclassified! !
!GpColorMatrixTest methodsFor!

assertIsIdentity
	1 to: 5
		do: [:r | 1 to: 5 do: [:c | self assert: (matrix atPoint: r @ c) equals: (r = c ifTrue: [1] ifFalse: [0])]]!

setUp
	super setUp.
	matrix := GpColorMatrix identity!

testAccessing
	(OrderedCollection new
		add: 1 @ 1;
		add: 2 @ 1;
		add: 1 @ 2;
		add: 5 @ 5;
		yourself) do: 
				[:each |
				matrix atPoint: each put: 0.5.
				self assert: (matrix atPoint: each) equals: 0.5]!

testConstruction
	matrix := GpColorMatrix withAll: GpColorMatrix identityArray.
	self assertIsIdentity!

testIdentity
	self assert: (matrix atPoint: 1 @ 1) equals: 1.
	self assertIsIdentity! !
!GpColorMatrixTest categoriesForMethods!
assertIsIdentity!public!unit tests! !
setUp!public!setup! !
testAccessing!public!unit tests! !
testConstruction!public!unit tests! !
testIdentity!public!unit tests! !
!


"Filed out from Dolphin Smalltalk X6"!

GdiplusTests subclass: #GpColorMatrixTest
	instanceVariableNames: 'matrix'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpColorMatrixTest guid: (GUID fromString: '{00610FDC-D988-4D65-A319-78A2DD28B367}')!
GpColorMatrixTest comment: ''!
!GpColorMatrixTest categoriesForClass!Unclassified! !
!GpColorMatrixTest methodsFor!

assertIsIdentity
	1 to: 5
		do: 
			[:r | 
			1 to: 5 do: [:c | self assert: (matrix atPoint: r @ c) = (r = c ifTrue: [1] ifFalse: [0])]]!

setUp
	super setUp.
	matrix := GpColorMatrix identity!

testAccessing
	((OrderedCollection new)
		add: 1 @ 1;
		add: 2 @ 1;
		add: 1 @ 2;
		add: 5 @ 5;
		yourself) do: 
				[:each | 
				matrix atPoint: each put: 0.5.
				self assert: (matrix atPoint: each) = 0.5]!

testConstruction
	matrix := GpColorMatrix withAll: GpColorMatrix identityArray.
	self assertIsIdentity!

testIdentity
	self assert: (matrix atPoint: 1 @ 1) = 1.
	self assertIsIdentity! !
!GpColorMatrixTest categoriesFor: #assertIsIdentity!public!unit tests! !
!GpColorMatrixTest categoriesFor: #setUp!public!setup! !
!GpColorMatrixTest categoriesFor: #testAccessing!public!unit tests! !
!GpColorMatrixTest categoriesFor: #testConstruction!public!unit tests! !
!GpColorMatrixTest categoriesFor: #testIdentity!public!unit tests! !


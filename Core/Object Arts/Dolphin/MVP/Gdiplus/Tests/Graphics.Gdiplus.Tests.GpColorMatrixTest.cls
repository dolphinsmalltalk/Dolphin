"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.GpColorMatrixTest'
	instanceVariableNames: 'matrix'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GpColorMatrixTest guid: (Core.GUID fromString: '{00610fdc-d988-4d65-a319-78a2dd28b367}')!
Graphics.Gdiplus.Tests.GpColorMatrixTest comment: ''!
!Graphics.Gdiplus.Tests.GpColorMatrixTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.GpColorMatrixTest methodsFor!

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
!Graphics.Gdiplus.Tests.GpColorMatrixTest categoriesFor: #assertIsIdentity!public!unit tests! !
!Graphics.Gdiplus.Tests.GpColorMatrixTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.GpColorMatrixTest categoriesFor: #testAccessing!public!unit tests! !
!Graphics.Gdiplus.Tests.GpColorMatrixTest categoriesFor: #testConstruction!public!unit tests! !
!Graphics.Gdiplus.Tests.GpColorMatrixTest categoriesFor: #testIdentity!public!unit tests! !


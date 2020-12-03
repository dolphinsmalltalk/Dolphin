"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'Graphics.Gdiplus.Tests.GdiplusTest'
	instanceVariableNames: 'model'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus.GdiplusConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GdiplusTest guid: (Core.GUID fromString: '{ea227fda-3570-490b-b8cf-4973dc534043}')!
Graphics.Gdiplus.Tests.GdiplusTest isNonInstantiable: true!
Graphics.Gdiplus.Tests.GdiplusTest comment: ''!
!Graphics.Gdiplus.Tests.GdiplusTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.GdiplusTest methodsFor!

assertPersistedValid
	| recreated |
	recreated := Object fromBinaryStoreBytes: model binaryStoreBytes.
	"Asking recreated for it's handle should find any errors"
	self assert: recreated handle class identicalTo: External.Handle!

compare: x to: y
	"Compare that the two <Float> values are equivalent to within the specified <Float> difference."

	^self 
		compare: x
		to: y
		epsilon: 1.0e-006!

compare: x to: y epsilon: epsilon
	"Compare that the two <Float> values are equivalent to within the specified <Float> difference."

	| max |
	^(max := x abs max: y abs) <= epsilon or: [(x - y) abs < (epsilon * max)]!

fileLocator
	^self fileResource fileLocator!

fileResource
	^FileResource current!

getSampleBrush
	#todo.	"Replace this with a solid brush"
	^self getSampleLinearGradientBrush!

getSampleGDIBitmap
	^Graphics.Bitmap 
		gdipCopyOfIcon: self icon
		extent: 32 @ 32
		backcolor: Color black!

getSampleLinearGradientBrush
	^LinearGradientBrush
		point1: 0 @ 0
		point2: 255 @ 0
		color1: Color red
		color2: Color red!

getSamplePen
	^Pen red!

tearDown
	model 
		ifNotNil: 
			[model free.
			model := nil].
	super tearDown! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #assertPersistedValid!asserting!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #compare:to:!comparing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #compare:to:epsilon:!comparing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #fileLocator!accessing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #fileResource!accessing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #getSampleBrush!accessing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #getSampleGDIBitmap!accessing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #getSampleLinearGradientBrush!accessing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #getSamplePen!accessing!public! !
!Graphics.Gdiplus.Tests.GdiplusTest categoriesFor: #tearDown!public!Running! !

!Graphics.Gdiplus.Tests.GdiplusTest class methodsFor!

resources
	^{FileResource}! !
!Graphics.Gdiplus.Tests.GdiplusTest class categoriesFor: #resources!accessing!public! !


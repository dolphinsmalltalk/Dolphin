"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'Graphics.Gdiplus.Tests.ARGBArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.ARGBArrayTest guid: (Core.GUID fromString: '{524a430f-bb14-407d-92ff-0d6baa28deda}')!

Graphics.Gdiplus.Tests.ARGBArrayTest comment: ''!

!Graphics.Gdiplus.Tests.ARGBArrayTest methodsFor!

arrayClass
	^ARGBArray!

elementFromValue: anInteger
	^Color
		a: (255.0 / (anInteger max: 1.0)) asInteger
		r: anInteger
		g: anInteger * 2
		b: anInteger * 3!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])!

numericElementClass
	^ARGBBytes

! !

!Graphics.Gdiplus.Tests.ARGBArrayTest categoriesForMethods!
arrayClass!constants!private! !
elementFromValue:!public!unit tests! !
newArrayOfIntegers:!helpers!private! !
numericElementClass!constants!private! !
!


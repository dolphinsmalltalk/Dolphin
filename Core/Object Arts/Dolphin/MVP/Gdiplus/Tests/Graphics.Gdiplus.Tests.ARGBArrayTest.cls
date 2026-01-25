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

!Graphics.Gdiplus.Tests.ARGBArrayTest class methodsFor!

arrayClass
	^ARGBArray!

elementFromIndex: anInteger
	| base |
	base := anInteger - 1.
	^Color
		a: (255.0 / (base max: 1.0)) asInteger
		r: base
		g: base * 2
		b: base * 3! !

!Graphics.Gdiplus.Tests.ARGBArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!


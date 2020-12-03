"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.BaseTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BaseTest guid: (Core.GUID fromString: '{d588d133-82ff-4f74-baa7-bdc2164bda4b}')!
Graphics.Gdiplus.Tests.BaseTest comment: ''!
!Graphics.Gdiplus.Tests.BaseTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.BaseTest methodsFor!

concreteGdiplusBaseSubclass
	"An arbitrary choice of concrete GdiplusBase subclass that we can use to test some basic
	functionality of GdiplusBase, which is itself abstract and cannot be instantiated."

	^Pen!

testComparisonEquality
	"GdiplusTestInitializer tests equality by comparing arg1"

	model := self concreteGdiplusBaseSubclass fromInitializer: (TestInitializer new arg1: 123).
	self assert: model
		equals: (self concreteGdiplusBaseSubclass fromInitializer: (TestInitializer new arg1: 123)).
	self deny: model
		equals: (self concreteGdiplusBaseSubclass fromInitializer: (TestInitializer new arg1: 456)).
	model hash!

testComparisonIdentity
	"GdiplusTestInitializer tests equality by comparing arg1"

	| initializer |
	model := self concreteGdiplusBaseSubclass
				fromInitializer: (initializer := TestInitializer new arg1: 123).
	self assert: model equals: (self concreteGdiplusBaseSubclass fromInitializer: initializer).
	model hash! !
!Graphics.Gdiplus.Tests.BaseTest categoriesFor: #concreteGdiplusBaseSubclass!private! !
!Graphics.Gdiplus.Tests.BaseTest categoriesFor: #testComparisonEquality!public!unit tests! !
!Graphics.Gdiplus.Tests.BaseTest categoriesFor: #testComparisonIdentity!public!unit tests! !


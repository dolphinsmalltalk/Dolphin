"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GdiplusBaseTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBaseTest guid: (GUID fromString: '{d588d133-82ff-4f74-baa7-bdc2164bda4b}')!

GdiplusBaseTest comment: ''!

!GdiplusBaseTest categoriesForClass!Unclassified! !

!GdiplusBaseTest methodsFor!

concreteGdiplusBaseSubclass
	"An arbitrary choice of concrete GdiplusBase subclass that we can use to test some basic
	functionality of GdiplusBase, which is itself abstract and cannot be instantiated."

	^GdiplusPen!

testComparisonEquality
	"GdiplusTestInitializer tests equality by comparing arg1"

	model := self concreteGdiplusBaseSubclass fromInitializer: (GdiplusTestInitializer new arg1: 123).
	self assert: model
		equals: (self concreteGdiplusBaseSubclass fromInitializer: (GdiplusTestInitializer new arg1: 123)).
	self deny: model
		equals: (self concreteGdiplusBaseSubclass fromInitializer: (GdiplusTestInitializer new arg1: 456)).
	model hash!

testComparisonIdentity
	"GdiplusTestInitializer tests equality by comparing arg1"

	| initializer |
	model := self concreteGdiplusBaseSubclass
				fromInitializer: (initializer := GdiplusTestInitializer new arg1: 123).
	self assert: model equals: (self concreteGdiplusBaseSubclass fromInitializer: initializer).
	model hash! !

!GdiplusBaseTest categoriesForMethods!
concreteGdiplusBaseSubclass!private! !
testComparisonEquality!public!unit tests! !
testComparisonIdentity!public!unit tests! !
!


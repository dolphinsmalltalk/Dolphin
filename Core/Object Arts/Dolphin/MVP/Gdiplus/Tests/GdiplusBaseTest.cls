"Filed out from Dolphin Smalltalk X6"!

GdiplusTests subclass: #GdiplusBaseTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBaseTest guid: (GUID fromString: '{D588D133-82FF-4F74-BAA7-BDC2164BDA4B}')!
GdiplusBaseTest comment: ''!
!GdiplusBaseTest categoriesForClass!Unclassified! !
!GdiplusBaseTest methodsFor!

setUp
	super setUp.
	model := GdiplusBase new!

testComparisonEquality
	"GdiplusTestInitializer tests equality by comparing arg1"

	model := GdiplusBase fromInitializer: (GdiplusTestInitializer new arg1: 123).
	self 
		assert: model = (GdiplusBase fromInitializer: (GdiplusTestInitializer new arg1: 123)).
	self deny: model = (GdiplusBase fromInitializer: (GdiplusTestInitializer new arg1: 456)).
	self deny: model = (GdiplusBase fromInitializer: GdiplusInitializer new).
	model hash!

testComparisonIdentity
	"GdiplusTestInitializer tests equality by comparing arg1"

	| initializer |
	model := GdiplusBase 
				fromInitializer: (initializer := GdiplusTestInitializer new arg1: 123).
	self assert: model = (GdiplusBase fromInitializer: initializer).
	model hash! !
!GdiplusBaseTest categoriesFor: #setUp!public!setup! !
!GdiplusBaseTest categoriesFor: #testComparisonEquality!public!unit tests! !
!GdiplusBaseTest categoriesFor: #testComparisonIdentity!public!unit tests! !


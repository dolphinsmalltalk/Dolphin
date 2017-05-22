"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusInitializerTests
	instanceVariableNames: 'constructorArgs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusInitializerTests guid: (GUID fromString: '{6547b0a9-3786-40b7-bacc-48ed66bf651d}')!
GdiplusInitializerTests comment: ''!
!GdiplusInitializerTests categoriesForClass!Unclassified! !
!GdiplusInitializerTests methodsFor!

assertLastArgIsHandle
	self assert: constructorArgs last class == ExternalHandle!

testErrorWith
	self should: [model gdiplusErrorWith: 0] raise: GdiplusError.
	self should: [model assertStatusOk: 1] raise: GdiplusError.
	self shouldnt: [model assertStatusOk: 0] raise: Error!

testIsPersistent
	"By default initializers can be persisted"

	self assert: model isPersistent! !
!GdiplusInitializerTests categoriesFor: #assertLastArgIsHandle!asserting!public! !
!GdiplusInitializerTests categoriesFor: #testErrorWith!public!unit tests! !
!GdiplusInitializerTests categoriesFor: #testIsPersistent!public!unit tests! !


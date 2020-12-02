"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusInitializerTests
	instanceVariableNames: 'constructorArgs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusInitializerTests guid: (GUID fromString: '{6547b0a9-3786-40b7-bacc-48ed66bf651d}')!
GdiplusInitializerTests isAbstract: true!
GdiplusInitializerTests comment: ''!
!GdiplusInitializerTests categoriesForClass!Unclassified! !
!GdiplusInitializerTests methodsFor!

assertLastArgIsHandle
	self assert: constructorArgs last class identicalTo: ExternalHandle!

testErrorWith
	self should: [model gdiplusErrorWith: 123] raise: GdiplusError matching: [:ex | ex tag = 123]
!

testIsPersistent
	"By default initializers can be persisted"

	self assert: model isPersistent! !
!GdiplusInitializerTests categoriesFor: #assertLastArgIsHandle!asserting!public! !
!GdiplusInitializerTests categoriesFor: #testErrorWith!public!unit tests! !
!GdiplusInitializerTests categoriesFor: #testIsPersistent!public!unit tests! !


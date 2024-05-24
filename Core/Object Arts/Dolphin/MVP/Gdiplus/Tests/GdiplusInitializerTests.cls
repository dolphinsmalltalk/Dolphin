"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GdiplusInitializerTests
	instanceVariableNames: 'constructorArgs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusInitializerTests guid: (GUID fromString: '{6547b0a9-3786-40b7-bacc-48ed66bf651d}')!

GdiplusInitializerTests isAbstract: true!

GdiplusInitializerTests comment: ''!

!GdiplusInitializerTests categoriesForClass!Unclassified! !

!GdiplusInitializerTests methodsFor!

assertLastArgIsHandle
	self assert: constructorArgs last class identicalTo: ExternalHandle!

testIsPersistent
	"By default initializers can be persisted"

	self assert: model isPersistent! !

!GdiplusInitializerTests categoriesForMethods!
assertLastArgIsHandle!asserting!public! !
testIsPersistent!public!unit tests! !
!


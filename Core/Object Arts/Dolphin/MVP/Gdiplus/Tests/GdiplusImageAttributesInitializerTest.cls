"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusImageAttributesInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageAttributesInitializerTest guid: (GUID fromString: '{5B179394-FE1B-49BE-8B4E-A8C385D87C6A}')!
GdiplusImageAttributesInitializerTest comment: ''!
!GdiplusImageAttributesInitializerTest categoriesForClass!Unclassified! !
!GdiplusImageAttributesInitializerTest methodsFor!

gdipCreateImageAttributes: imageattr 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusImageAttributesInitializer new library: self!

testCreateHandle
	model createHandle.
	self assert: constructorArgs size = 1.
	self assertLastArgIsHandle! !
!GdiplusImageAttributesInitializerTest categoriesFor: #gdipCreateImageAttributes:!accessing!public! !
!GdiplusImageAttributesInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusImageAttributesInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


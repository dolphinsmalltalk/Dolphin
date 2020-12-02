"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusImageAttributesInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusImageAttributesInitializerTest guid: (GUID fromString: '{5b179394-fe1b-49be-8b4e-a8c385d87c6a}')!
GdiplusImageAttributesInitializerTest comment: ''!
!GdiplusImageAttributesInitializerTest categoriesForClass!Unclassified! !
!GdiplusImageAttributesInitializerTest methodsFor!

gdipCreateImageAttributes: imageattr 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusImageAttributesInitializer basicNew library: self!

testCreateHandle
	model createHandle.
	self assert: constructorArgs size equals: 1.
	self assertLastArgIsHandle! !
!GdiplusImageAttributesInitializerTest categoriesFor: #gdipCreateImageAttributes:!accessing!public! !
!GdiplusImageAttributesInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusImageAttributesInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


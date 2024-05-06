"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusGraphicsFromImageInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusGraphicsFromImageInitializerTest guid: (GUID fromString: '{de9caa66-14ef-49f9-8e8b-dbda54c36c53}')!

GdiplusGraphicsFromImageInitializerTest comment: ''!

!GdiplusGraphicsFromImageInitializerTest categoriesForClass!Unclassified! !

!GdiplusGraphicsFromImageInitializerTest methodsFor!

gdipGetImageGraphicsContext: image graphics: graphics 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusGraphicsFromImageInitializer new library: self!

testCreateHandle
	| image |
	image := GdiplusImage fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model image: image.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: image asParameter.
	self assertLastArgIsHandle! !

!GdiplusGraphicsFromImageInitializerTest categoriesForMethods!
gdipGetImageGraphicsContext:graphics:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
!


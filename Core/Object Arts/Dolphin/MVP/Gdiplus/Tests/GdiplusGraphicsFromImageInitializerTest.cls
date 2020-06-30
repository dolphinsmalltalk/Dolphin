"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusGraphicsFromImageInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!GdiplusGraphicsFromImageInitializerTest categoriesFor: #gdipGetImageGraphicsContext:graphics:!accessing!public! !
!GdiplusGraphicsFromImageInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusGraphicsFromImageInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


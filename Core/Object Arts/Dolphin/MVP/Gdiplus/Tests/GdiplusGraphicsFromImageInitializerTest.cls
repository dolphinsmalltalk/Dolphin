"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusGraphicsFromImageInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusGraphicsFromImageInitializerTest guid: (GUID fromString: '{DE9CAA66-14EF-49F9-8E8B-DBDA54C36C53}')!
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
	self assert: constructorArgs size = 2.
	self assert: constructorArgs first == image asParameter.
	self assertLastArgIsHandle! !
!GdiplusGraphicsFromImageInitializerTest categoriesFor: #gdipGetImageGraphicsContext:graphics:!accessing!public! !
!GdiplusGraphicsFromImageInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusGraphicsFromImageInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


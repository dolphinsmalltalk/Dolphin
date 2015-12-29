"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusGraphicsFromHDCInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusGraphicsFromHDCInitializerTest guid: (GUID fromString: '{8FDE00F2-25D2-4046-907F-A52FEBBA1A57}')!
GdiplusGraphicsFromHDCInitializerTest comment: ''!
!GdiplusGraphicsFromHDCInitializerTest categoriesForClass!Unclassified! !
!GdiplusGraphicsFromHDCInitializerTest methodsFor!

gdipCreateFromHDC: hdc graphics: graphics 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusGraphicsFromHDCInitializer new library: self!

testCreateHandle
	| bitmap canvas |
	bitmap := Bitmap 
				gdipCopyOfIcon: GdiplusBitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	canvas := bitmap canvas.
	model canvas: canvas.
	model createHandle.
	self assert: constructorArgs size = 2.
	self assert: constructorArgs first == canvas asParameter.
	self assertLastArgIsHandle! !
!GdiplusGraphicsFromHDCInitializerTest categoriesFor: #gdipCreateFromHDC:graphics:!accessing!public! !
!GdiplusGraphicsFromHDCInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusGraphicsFromHDCInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


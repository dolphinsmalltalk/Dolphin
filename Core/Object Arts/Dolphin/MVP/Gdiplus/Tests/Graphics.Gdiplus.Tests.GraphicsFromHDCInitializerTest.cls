"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusGraphicsFromHDCInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusGraphicsFromHDCInitializerTest guid: (GUID fromString: '{8fde00f2-25d2-4046-907f-a52febba1a57}')!
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
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: canvas asParameter.
	self assertLastArgIsHandle! !
!GdiplusGraphicsFromHDCInitializerTest categoriesFor: #gdipCreateFromHDC:graphics:!accessing!public! !
!GdiplusGraphicsFromHDCInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusGraphicsFromHDCInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


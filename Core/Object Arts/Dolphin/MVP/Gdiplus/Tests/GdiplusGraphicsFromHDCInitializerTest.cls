"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusGraphicsFromHDCInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!GdiplusGraphicsFromHDCInitializerTest categoriesForMethods!
gdipCreateFromHDC:graphics:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
!


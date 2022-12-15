"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.BitmapFromGdiBitmapInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapFromGdiBitmapInitializerTest guid: (Core.GUID fromString: '{acefb85f-8196-4e9b-b4fb-0c12068a6cad}')!
Graphics.Gdiplus.Tests.BitmapFromGdiBitmapInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapFromGdiBitmapInitializerTest methodsFor!

subjectClass
	^BitmapFromGdiBitmapInitializer!

testCreateHandle
	| bitmap constructor |
	bitmap := Graphics.Bitmap
				gdipCopyOfIcon: Bitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	model bitmap: bitmap.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreateBitmapFromHBITMAP:hpal:bitmap:.
	self assert: constructor arguments size equals: 3.
	self assert: constructor arguments first identicalTo: bitmap basicHandle.
	"depends on dc color depth"
	self assertIsNil: constructor arguments second.
	self assert: constructor arguments last isKindOf: Handle!

testCreateHandleFreesDC
	| bitmap |
	bitmap := Graphics.Bitmap
				gdipCopyOfIcon: Bitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	model bitmap: bitmap.
	"force the bitmap to be selected into a dc"
	bitmap canvas.
	self assertNotNil: bitmap basicHdc.
	"SW: note comment in GdiplusBitmap class>>fromBitmap: ... not sure if this should succeed"
	model createHandle.
	self assertIsNil: bitmap basicHdc! !
!Graphics.Gdiplus.Tests.BitmapFromGdiBitmapInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
testCreateHandleFreesDC!public!unit tests! !
!


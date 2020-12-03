"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest guid: (Core.GUID fromString: '{acefb85f-8196-4e9b-b4fb-0c12068a6cad}')!
Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest methodsFor!

gdipCreateBitmapFromHBITMAP: hbm hpal: hpal bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := BitmapFromGdiBitmapInitializer new library: self!

testCreateHandle
	| bitmap |
	bitmap := Graphics.Bitmap
				gdipCopyOfIcon: Bitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	model bitmap: bitmap.
	model createHandle.
	self assert: constructorArgs size equals: 3.
	self assert: constructorArgs first identicalTo: bitmap basicHandle.
	"depends on dc color depth"
	self assertIsNil: constructorArgs second.
	self assertLastArgIsHandle!

testCreateHandleFreesDC
	| bitmap |
	bitmap := Graphics.Bitmap
				gdipCopyOfIcon: Bitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	model bitmap: bitmap.
	"force the bitmap to be selected into a dc"
	bitmap canvas.
	self deny: bitmap hdc isNil.
	"SW: note comment in GdiplusBitmap class>>fromBitmap: ... not sure if this should succeed"
	model createHandle.
	self assertIsNil: bitmap hdc! !
!Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest categoriesFor: #gdipCreateBitmapFromHBITMAP:hpal:bitmap:!accessing!public! !
!Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapFromBitmapInitializerTest categoriesFor: #testCreateHandleFreesDC!public!unit tests! !


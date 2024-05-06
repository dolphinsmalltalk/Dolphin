"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromBitmapInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBitmapFromBitmapInitializerTest guid: (GUID fromString: '{acefb85f-8196-4e9b-b4fb-0c12068a6cad}')!

GdiplusBitmapFromBitmapInitializerTest comment: ''!

!GdiplusBitmapFromBitmapInitializerTest categoriesForClass!Unclassified! !

!GdiplusBitmapFromBitmapInitializerTest methodsFor!

gdipCreateBitmapFromHBITMAP: hbm hpal: hpal bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusBitmapFromBitmapInitializer new library: self!

testCreateHandle
	| bitmap |
	bitmap := Bitmap
				gdipCopyOfIcon: GdiplusBitmap icon
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
	bitmap := Bitmap
				gdipCopyOfIcon: GdiplusBitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	model bitmap: bitmap.
	"force the bitmap to be selected into a dc"
	bitmap canvas.
	self deny: bitmap hdc isNil.
	"SW: note comment in GdiplusBitmap class>>fromBitmap: ... not sure if this should succeed"
	model createHandle.
	self assertIsNil: bitmap hdc! !

!GdiplusBitmapFromBitmapInitializerTest categoriesForMethods!
gdipCreateBitmapFromHBITMAP:hpal:bitmap:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
testCreateHandleFreesDC!public!unit tests! !
!


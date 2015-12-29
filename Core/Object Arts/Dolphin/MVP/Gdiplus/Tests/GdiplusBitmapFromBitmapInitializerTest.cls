"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromBitmapInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromBitmapInitializerTest guid: (GUID fromString: '{ACEFB85F-8196-4E9B-B4FB-0C12068A6CAD}')!
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
	self assert: constructorArgs size = 3.
	self assert: constructorArgs first == bitmap basicHandle.
	"depends on dc color depth"
	self assert: constructorArgs second isNil.
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
	self assert: bitmap hdc isNil! !
!GdiplusBitmapFromBitmapInitializerTest categoriesFor: #gdipCreateBitmapFromHBITMAP:hpal:bitmap:!accessing!public! !
!GdiplusBitmapFromBitmapInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapFromBitmapInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusBitmapFromBitmapInitializerTest categoriesFor: #testCreateHandleFreesDC!public!unit tests! !


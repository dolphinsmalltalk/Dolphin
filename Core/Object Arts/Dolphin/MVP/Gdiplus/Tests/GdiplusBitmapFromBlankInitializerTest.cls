"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromBlankInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromBlankInitializerTest guid: (GUID fromString: '{1C9CB1C1-E014-4FCC-AA39-81767A17AF85}')!
GdiplusBitmapFromBlankInitializerTest comment: ''!
!GdiplusBitmapFromBlankInitializerTest categoriesForClass!Unclassified! !
!GdiplusBitmapFromBlankInitializerTest methodsFor!

gdipCreateBitmapFromScan0: width height: height stride: stride format: format scan0: scan0 bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusBitmapFromBlankInitializer new library: self!

testCreateHandle
	model 
		width: 100
		height: 150
		format: nil.
	model createHandle.
	self assert: constructorArgs size = 6.
	self assert: constructorArgs first = 100.
	self assert: constructorArgs second = 150.
	self assert: constructorArgs third = 0.
	"self assert: constructorArgs fourth = PixelFormat32bppARGB."
	self assertLastArgIsHandle! !
!GdiplusBitmapFromBlankInitializerTest categoriesFor: #gdipCreateBitmapFromScan0:height:stride:format:scan0:bitmap:!public!setup! !
!GdiplusBitmapFromBlankInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapFromBlankInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


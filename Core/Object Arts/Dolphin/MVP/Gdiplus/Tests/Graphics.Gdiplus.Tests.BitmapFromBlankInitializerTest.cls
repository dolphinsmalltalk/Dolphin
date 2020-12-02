"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromBlankInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusBitmapFromBlankInitializerTest guid: (GUID fromString: '{1c9cb1c1-e014-4fcc-aa39-81767a17af85}')!
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
	self assert: constructorArgs size equals: 6.
	self assert: constructorArgs first equals: 100.
	self assert: constructorArgs second equals: 150.
	self assert: constructorArgs third equals: 0.
	"self assert: constructorArgs fourth = PixelFormat32bppARGB."
	self assertLastArgIsHandle! !
!GdiplusBitmapFromBlankInitializerTest categoriesFor: #gdipCreateBitmapFromScan0:height:stride:format:scan0:bitmap:!public!setup! !
!GdiplusBitmapFromBlankInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapFromBlankInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromFileInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromFileInitializerTest guid: (GUID fromString: '{71E91F39-1E7B-435A-A44C-C3991D981995}')!
GdiplusBitmapFromFileInitializerTest comment: ''!
!GdiplusBitmapFromFileInitializerTest categoriesForClass!Unclassified! !
!GdiplusBitmapFromFileInitializerTest methodsFor!

gdipCreateBitmapFromFile: filename bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusBitmapFromFileInitializer new library: self!

testAbsoluteFilename
	model filename: 'c:\test' fileLocator: nil.
	self assert: model absoluteFilename = 'c:\test'.
	model filename: 'c:\test' fileLocator: ImageRelativeFileLocator current.
	self assert: model absoluteFilename = 'c:\test'.
	model filename: 'test' fileLocator: ImageRelativeFileLocator current.
	self assert: model absoluteFilename 
				= (ImageRelativeFileLocator current localFileSpecFor: 'test')!

testCreateHandle
	model filename: self fileResource pafRgb0000FF_100x100bmp fileLocator: nil.
	model createHandle.
	self assert: constructorArgs size = 2.
	self 
		assert: constructorArgs first = self fileResource pafRgb0000FF_100x100bmp asUnicodeString.
	self assertLastArgIsHandle! !
!GdiplusBitmapFromFileInitializerTest categoriesFor: #gdipCreateBitmapFromFile:bitmap:!accessing!public! !
!GdiplusBitmapFromFileInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapFromFileInitializerTest categoriesFor: #testAbsoluteFilename!public!unit tests! !
!GdiplusBitmapFromFileInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


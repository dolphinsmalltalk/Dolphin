"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromFileInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBitmapFromFileInitializerTest guid: (GUID fromString: '{71e91f39-1e7b-435a-a44c-c3991d981995}')!

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
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'c:\test' fileLocator: ImageRelativeFileLocator current.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'test' fileLocator: ImageRelativeFileLocator current.
	self assert: model absoluteFilename
		equals: (ImageRelativeFileLocator current localFileSpecFor: 'test')!

testCreateHandle
	model filename: self fileResource pafRgb0000FF_100x100bmp fileLocator: nil.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first equals: self fileResource pafRgb0000FF_100x100bmp.
	self assertLastArgIsHandle! !

!GdiplusBitmapFromFileInitializerTest categoriesForMethods!
gdipCreateBitmapFromFile:bitmap:!accessing!public! !
setUp!public!setup! !
testAbsoluteFilename!public!unit tests! !
testCreateHandle!public!unit tests! !
!


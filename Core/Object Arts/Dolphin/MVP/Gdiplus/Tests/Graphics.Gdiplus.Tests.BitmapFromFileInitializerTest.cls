"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest guid: (Core.GUID fromString: '{71e91f39-1e7b-435a-a44c-c3991d981995}')!
Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest methodsFor!

gdipCreateBitmapFromFile: filename bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := BitmapFromFileInitializer new library: self!

testAbsoluteFilename
	model filename: 'c:\test' fileLocator: nil.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'c:\test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename equals: (FileLocator imageRelative localFileSpecFor: 'test')!

testCreateHandle
	model filename: self fileResource pafRgb0000FF_100x100bmp fileLocator: nil.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first equals: self fileResource pafRgb0000FF_100x100bmp.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest categoriesFor: #gdipCreateBitmapFromFile:bitmap:!accessing!public! !
!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest categoriesFor: #testAbsoluteFilename!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


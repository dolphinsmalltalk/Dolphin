"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.ImageFromFileInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageFromFileInitializerTest guid: (Core.GUID fromString: '{a57cca61-cd3f-43b3-a963-3e534232e776}')!
Graphics.Gdiplus.Tests.ImageFromFileInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest methodsFor!

gdipLoadImageFromFile: filename image: image 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := ImageFromFileInitializer new library: self!

testAbsoluteFilename
	model filename: 'c:\test' fileLocator: nil.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'c:\test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename
		equals: (FileLocator imageRelative localFileSpecFor: 'test')!

testCreateHandle
	model filename: self fileResource pafRgb0000FF_100x100bmp fileLocator: nil.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first equals: self fileResource pafRgb0000FF_100x100bmp.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest categoriesFor: #gdipLoadImageFromFile:image:!accessing!public! !
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest categoriesFor: #testAbsoluteFilename!public!unit tests! !
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


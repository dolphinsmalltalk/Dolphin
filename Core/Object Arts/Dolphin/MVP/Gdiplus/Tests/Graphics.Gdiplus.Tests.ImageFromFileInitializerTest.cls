"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.ImageFromFileInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageFromFileInitializerTest guid: (Core.GUID fromString: '{a57cca61-cd3f-43b3-a963-3e534232e776}')!
Graphics.Gdiplus.Tests.ImageFromFileInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest methodsFor!

subjectClass
	^ImageFromFileInitializer!

testAbsoluteFilename
	model filename: 'c:\test' fileLocator: nil.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'c:\test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename
		equals: (FileLocator imageRelative localFileSpecFor: 'test')!

testCreateHandle
	| constructor |
	model filename: self fileResource pafRgb0000FF_100x100bmp fileLocator: nil.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipLoadImageFromFile:image:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first equals: self fileResource pafRgb0000FF_100x100bmp.
	self assert: constructor arguments last isKindOf: Handle! !
!Graphics.Gdiplus.Tests.ImageFromFileInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testAbsoluteFilename!public!unit tests! !
testCreateHandle!public!unit tests! !
!


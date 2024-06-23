"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest guid: (Core.GUID fromString: '{71e91f39-1e7b-435a-a44c-c3991d981995}')!

Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest comment: ''!

!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest methodsFor!

subjectClass
	^BitmapFromFileInitializer!

testAbsoluteFilename
	model filename: 'c:\test' fileLocator: nil.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'c:\test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename equals: 'c:\test'.
	model filename: 'test' fileLocator: FileLocator imageRelative.
	self assert: model absoluteFilename equals: (FileLocator imageRelative localFileSpecFor: 'test')!

testCreateHandle
	| constructor |
	model filename: self fileResource pafRgb0000FF_100x100bmp fileLocator: nil.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreateBitmapFromFile:bitmap:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first equals: self fileResource pafRgb0000FF_100x100bmp.
	self assert: constructor arguments last isKindOf: Handle! !

!Graphics.Gdiplus.Tests.BitmapFromFileInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testAbsoluteFilename!public!unit tests! !
testCreateHandle!public!unit tests! !
!


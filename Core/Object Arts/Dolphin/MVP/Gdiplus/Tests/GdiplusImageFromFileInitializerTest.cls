"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusImageFromFileInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromFileInitializerTest guid: (GUID fromString: '{a57cca61-cd3f-43b3-a963-3e534232e776}')!
GdiplusImageFromFileInitializerTest comment: ''!
!GdiplusImageFromFileInitializerTest categoriesForClass!Unclassified! !
!GdiplusImageFromFileInitializerTest methodsFor!

gdipLoadImageFromFile: filename image: image 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusImageFromFileInitializer new library: self!

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
!GdiplusImageFromFileInitializerTest categoriesForMethods!
gdipLoadImageFromFile:image:!accessing!public! !
setUp!public!setup! !
testAbsoluteFilename!public!unit tests! !
testCreateHandle!public!unit tests! !
!


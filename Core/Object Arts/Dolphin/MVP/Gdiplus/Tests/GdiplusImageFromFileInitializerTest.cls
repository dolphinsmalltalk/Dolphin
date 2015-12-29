"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusImageFromFileInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromFileInitializerTest guid: (GUID fromString: '{A57CCA61-CD3F-43B3-A963-3E534232E776}')!
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
!GdiplusImageFromFileInitializerTest categoriesFor: #gdipLoadImageFromFile:image:!accessing!public! !
!GdiplusImageFromFileInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusImageFromFileInitializerTest categoriesFor: #testAbsoluteFilename!public!unit tests! !
!GdiplusImageFromFileInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.BitmapFromBlankInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapFromBlankInitializerTest guid: (Core.GUID fromString: '{1c9cb1c1-e014-4fcc-aa39-81767a17af85}')!
Graphics.Gdiplus.Tests.BitmapFromBlankInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapFromBlankInitializerTest methodsFor!

subjectClass
	^BitmapFromBlankInitializer!

testCreateHandle
	| constructor |
	model
		width: 100
		height: 150
		format: nil.
	constructor := self createHandle single.
	self assert: constructor selector
		identicalTo: #gdipCreateBitmapFromScan0:height:stride:format:scan0:bitmap:.
	self assert: constructor arguments size equals: 6.
	self assert: constructor arguments first equals: 100.
	self assert: constructor arguments second equals: 150.
	self assert: constructor arguments third equals: 0.
	"self assert: constructorArgs fourth = PixelFormat32bppARGB."
	self assert: constructor arguments last isKindOf: Handle! !
!Graphics.Gdiplus.Tests.BitmapFromBlankInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
!


"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest guid: (Core.GUID fromString: '{bf0526be-e212-4666-8678-2c66a571d808}')!
Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest methodsFor!

gdipCreateBitmapFromHICON: hicon bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := BitmapFromIconInitializer new library: self!

testCreateHandle
	| icon |
	icon := Bitmap icon.
	model icon: icon.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: icon basicHandle.
	self assertLastArgIsHandle!

testCreateHandleRealizesIcon
	| icon |
	icon := Icon fromId: 43 in: ShellLibrary default.
	model icon: icon.
	self assertIsNil: icon basicHandle.
	model createHandle.
	self denyIsNil: icon basicHandle! !
!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest categoriesFor: #gdipCreateBitmapFromHICON:bitmap:!accessing!public! !
!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest categoriesFor: #testCreateHandleRealizesIcon!public!unit tests! !


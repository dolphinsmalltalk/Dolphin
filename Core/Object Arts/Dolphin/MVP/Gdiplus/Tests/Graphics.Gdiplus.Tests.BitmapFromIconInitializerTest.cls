"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest guid: (Core.GUID fromString: '{bf0526be-e212-4666-8678-2c66a571d808}')!

Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest comment: ''!

!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest methodsFor!

subjectClass
	^BitmapFromIconInitializer!

testCreateHandle
	| constructor icon |
	icon := Bitmap icon.
	model icon: icon.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreateBitmapFromHICON:bitmap:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first identicalTo: icon basicHandle.
	self assert: constructor arguments last isKindOf: Handle!

testCreateHandleRealizesIcon
	| icon |
	icon := Icon shellStock: SHSTOCKICONID.SIID_DESKTOPPC.
	model icon: icon.
	self assertIsNil: icon basicHandle.
	model createHandle.
	self denyIsNil: icon basicHandle! !

!Graphics.Gdiplus.Tests.BitmapFromIconInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
testCreateHandleRealizesIcon!public!unit tests! !
!


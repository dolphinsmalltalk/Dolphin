"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromIconInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBitmapFromIconInitializerTest guid: (GUID fromString: '{bf0526be-e212-4666-8678-2c66a571d808}')!

GdiplusBitmapFromIconInitializerTest comment: ''!

!GdiplusBitmapFromIconInitializerTest categoriesForClass!Unclassified! !

!GdiplusBitmapFromIconInitializerTest methodsFor!

gdipCreateBitmapFromHICON: hicon bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusBitmapFromIconInitializer new library: self!

testCreateHandle
	| icon |
	icon := GdiplusBitmap icon.
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

!GdiplusBitmapFromIconInitializerTest categoriesForMethods!
gdipCreateBitmapFromHICON:bitmap:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
testCreateHandleRealizesIcon!public!unit tests! !
!


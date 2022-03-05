"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusSolidBrushFromColorInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusSolidBrushFromColorInitializerTest guid: (GUID fromString: '{039f3379-265a-4958-ba78-22f16a9e1300}')!
GdiplusSolidBrushFromColorInitializerTest comment: ''!
!GdiplusSolidBrushFromColorInitializerTest categoriesForClass!Unclassified! !
!GdiplusSolidBrushFromColorInitializerTest methodsFor!

gdipCreateSolidFill: color brush: brush 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusSolidBrushFromColorInitializer new library: self!

testCreateHandle
	model color: (Color fromArgbCode: 1).
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: 1.
	self assertLastArgIsHandle! !
!GdiplusSolidBrushFromColorInitializerTest categoriesForMethods!
gdipCreateSolidFill:brush:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
!


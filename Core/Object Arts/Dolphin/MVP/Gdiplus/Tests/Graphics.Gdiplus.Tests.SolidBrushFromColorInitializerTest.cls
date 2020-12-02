"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusSolidBrushFromColorInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!GdiplusSolidBrushFromColorInitializerTest categoriesFor: #gdipCreateSolidFill:brush:!accessing!public! !
!GdiplusSolidBrushFromColorInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusSolidBrushFromColorInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


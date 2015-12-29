"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusPenFromColorInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenFromColorInitializerTest guid: (GUID fromString: '{AF606711-5D59-44E2-B217-D6DB5D89FFC4}')!
GdiplusPenFromColorInitializerTest comment: ''!
!GdiplusPenFromColorInitializerTest categoriesForClass!Unclassified! !
!GdiplusPenFromColorInitializerTest methodsFor!

gdipCreatePen1: color width: width unit: unit pen: pen 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusPenFromColorInitializer new library: self!

testCreateHandle
	model color: (ARGB fromInteger: 1) width: 0.5.
	model createHandle.
	self assert: constructorArgs size = 4.
	self assert: constructorArgs first == 1.
	self assert: constructorArgs second = 0.5.
	self assert: constructorArgs third = UnitWorld.
	self assertLastArgIsHandle!

testCreateHandleDefaultWidth
	model color: (ARGB fromInteger: 1) width: nil.
	model createHandle.
	self assert: constructorArgs size = 4.
	self assert: constructorArgs first == 1.
	self assert: constructorArgs second = 1.0.
	self assert: constructorArgs third = UnitWorld.
	self assertLastArgIsHandle! !
!GdiplusPenFromColorInitializerTest categoriesFor: #gdipCreatePen1:width:unit:pen:!accessing!public! !
!GdiplusPenFromColorInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusPenFromColorInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusPenFromColorInitializerTest categoriesFor: #testCreateHandleDefaultWidth!public!unit tests! !


"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusPenFromColorInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusPenFromColorInitializerTest guid: (GUID fromString: '{af606711-5d59-44e2-b217-d6db5d89ffc4}')!
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
	model color: (Color fromArgbCode: 1) width: 0.5.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: 1.
	self assert: constructorArgs second equals: 0.5.
	self assert: constructorArgs third equals: UnitWorld.
	self assertLastArgIsHandle!

testCreateHandleDefaultWidth
	model color: (Color fromArgbCode: 1) width: nil.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: 1.
	self assert: constructorArgs second equals: 1.0.
	self assert: constructorArgs third equals: UnitWorld.
	self assertLastArgIsHandle! !
!GdiplusPenFromColorInitializerTest categoriesFor: #gdipCreatePen1:width:unit:pen:!accessing!public! !
!GdiplusPenFromColorInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusPenFromColorInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusPenFromColorInitializerTest categoriesFor: #testCreateHandleDefaultWidth!public!unit tests! !


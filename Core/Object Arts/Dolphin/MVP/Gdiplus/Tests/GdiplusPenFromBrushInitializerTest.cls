"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusPenFromBrushInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenFromBrushInitializerTest guid: (GUID fromString: '{911c5add-1255-427e-b2e6-26d9d8f38caf}')!
GdiplusPenFromBrushInitializerTest comment: ''!
!GdiplusPenFromBrushInitializerTest categoriesForClass!Unclassified! !
!GdiplusPenFromBrushInitializerTest methodsFor!

gdipCreatePen2: brush width: width unit: unit pen: pen 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusPenFromBrushInitializer new library: self!

testCreateHandle
	| brush |
	brush := self getSampleBrush.
	model brush: brush width: 0.5.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: brush basicHandle.
	self assert: constructorArgs second equals: 0.5.
	self assertLastArgIsHandle!

testCreateHandleDefaultWidth
	| brush |
	brush := self getSampleBrush.
	model brush: brush width: nil.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: brush basicHandle.
	self assert: constructorArgs second equals: 1.0.
	self assertLastArgIsHandle! !
!GdiplusPenFromBrushInitializerTest categoriesForMethods!
gdipCreatePen2:width:unit:pen:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
testCreateHandleDefaultWidth!public!unit tests! !
!


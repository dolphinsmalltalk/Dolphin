"Filed out from Dolphin Smalltalk 7"!

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
	self assert: constructorArgs size = 4.
	self assert: constructorArgs first == brush basicHandle.
	self assert: constructorArgs second = 0.5.
	self assertLastArgIsHandle!

testCreateHandleDefaultWidth
	| brush |
	brush := self getSampleBrush.
	model brush: brush width: nil.
	model createHandle.
	self assert: constructorArgs size = 4.
	self assert: constructorArgs first == brush basicHandle.
	self assert: constructorArgs second = 1.0.
	self assertLastArgIsHandle! !
!GdiplusPenFromBrushInitializerTest categoriesFor: #gdipCreatePen2:width:unit:pen:!accessing!public! !
!GdiplusPenFromBrushInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusPenFromBrushInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusPenFromBrushInitializerTest categoriesFor: #testCreateHandleDefaultWidth!public!unit tests! !


"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusPenFromBrushInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenFromBrushInitializerTest guid: (GUID fromString: '{911C5ADD-1255-427E-B2E6-26D9D8F38CAF}')!
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


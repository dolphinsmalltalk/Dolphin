"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromIStreamInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromIStreamInitializerTest guid: (GUID fromString: '{264CB8BF-7428-488C-8342-807ED863EF1C}')!
GdiplusBitmapFromIStreamInitializerTest comment: ''!
!GdiplusBitmapFromIStreamInitializerTest categoriesForClass!Unclassified! !
!GdiplusBitmapFromIStreamInitializerTest methodsFor!

gdipCreateBitmapFromStream: stream bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusBitmapFromIStreamInitializer new library: self!

testCreateHandle
	| pStream |
	pStream := IStream onHGLOBAL.
	model iStream: pStream.
	model createHandle.
	self assert: constructorArgs size = 2.
	self assert: constructorArgs first == pStream.
	self assertLastArgIsHandle!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #gdipCreateBitmapFromStream:bitmap:!accessing!public! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #testIsPersistent!public!unit tests! !


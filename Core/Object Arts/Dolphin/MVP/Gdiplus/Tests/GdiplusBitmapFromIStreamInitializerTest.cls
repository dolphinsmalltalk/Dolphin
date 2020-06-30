"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusBitmapFromIStreamInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusBitmapFromIStreamInitializerTest guid: (GUID fromString: '{264cb8bf-7428-488c-8342-807ed863ef1c}')!
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
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: pStream.
	self assertLastArgIsHandle!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #gdipCreateBitmapFromStream:bitmap:!accessing!public! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusBitmapFromIStreamInitializerTest categoriesFor: #testIsPersistent!public!unit tests! !


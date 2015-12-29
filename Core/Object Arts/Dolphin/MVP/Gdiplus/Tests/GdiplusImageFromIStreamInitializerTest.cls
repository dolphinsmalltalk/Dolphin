"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusImageFromIStreamInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromIStreamInitializerTest guid: (GUID fromString: '{FD12183C-22DC-4CA1-8EBC-E1D9E66485C2}')!
GdiplusImageFromIStreamInitializerTest comment: ''!
!GdiplusImageFromIStreamInitializerTest categoriesForClass!Unclassified! !
!GdiplusImageFromIStreamInitializerTest methodsFor!

gdipLoadImageFromStream: stream image: image 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusImageFromIStreamInitializer new library: self!

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
!GdiplusImageFromIStreamInitializerTest categoriesFor: #gdipLoadImageFromStream:image:!accessing!public! !
!GdiplusImageFromIStreamInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusImageFromIStreamInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!GdiplusImageFromIStreamInitializerTest categoriesFor: #testIsPersistent!public!unit tests! !


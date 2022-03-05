"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusImageFromIStreamInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromIStreamInitializerTest guid: (GUID fromString: '{fd12183c-22dc-4ca1-8ebc-e1d9e66485c2}')!
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
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: pStream.
	self assertLastArgIsHandle!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !
!GdiplusImageFromIStreamInitializerTest categoriesForMethods!
gdipLoadImageFromStream:image:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
testIsPersistent!public!unit tests! !
!


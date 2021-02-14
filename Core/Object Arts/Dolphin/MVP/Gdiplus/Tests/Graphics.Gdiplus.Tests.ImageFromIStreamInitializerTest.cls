"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest guid: (Core.GUID fromString: '{fd12183c-22dc-4ca1-8ebc-e1d9e66485c2}')!
Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest methodsFor!

gdipLoadImageFromStream: stream image: image 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := ImageFromIStreamInitializer new library: self!

testCreateHandle
	| pStream |
	pStream := COM.IStream onHGLOBAL.
	model iStream: pStream.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: pStream.
	self assertLastArgIsHandle!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !
!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest categoriesFor: #gdipLoadImageFromStream:image:!accessing!public! !
!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest categoriesFor: #testIsPersistent!public!unit tests! !


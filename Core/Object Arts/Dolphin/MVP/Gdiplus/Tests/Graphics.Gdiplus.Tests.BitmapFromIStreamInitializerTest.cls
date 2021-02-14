"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest guid: (Core.GUID fromString: '{264cb8bf-7428-488c-8342-807ed863ef1c}')!
Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest methodsFor!

gdipCreateBitmapFromStream: stream bitmap: bitmap 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := BitmapFromIStreamInitializer new library: self!

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
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest categoriesFor: #gdipCreateBitmapFromStream:bitmap:!accessing!public! !
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest categoriesFor: #testIsPersistent!public!unit tests! !


"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest guid: (Core.GUID fromString: '{264cb8bf-7428-488c-8342-807ed863ef1c}')!
Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest methodsFor!

subjectClass
	^BitmapFromIStreamInitializer!

testCreateHandle
	| pStream constructor |
	pStream := COM.IStream onHGLOBAL.
	model iStream: pStream.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreateBitmapFromStream:bitmap:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first identicalTo: pStream.
	self assert: constructor arguments last isKindOf: Handle.
	pStream free!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !
!Graphics.Gdiplus.Tests.BitmapFromIStreamInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
testIsPersistent!public!unit tests! !
!


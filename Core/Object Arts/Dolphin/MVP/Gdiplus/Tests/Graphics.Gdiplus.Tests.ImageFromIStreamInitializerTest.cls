"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest guid: (Core.GUID fromString: '{fd12183c-22dc-4ca1-8ebc-e1d9e66485c2}')!

Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest comment: ''!

!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest methodsFor!

subjectClass
	^ImageFromIStreamInitializer!

testCreateHandle
	| constructor pStream |
	pStream := COM.IStream onHGLOBAL.
	model iStream: pStream.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipLoadImageFromStream:image:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first identicalTo: pStream.
	self assert: constructor arguments last isKindOf: Handle.
	pStream free!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !

!Graphics.Gdiplus.Tests.ImageFromIStreamInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
testIsPersistent!public!unit tests! !
!


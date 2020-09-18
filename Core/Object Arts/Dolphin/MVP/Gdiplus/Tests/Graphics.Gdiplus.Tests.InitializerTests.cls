"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.InitializerTests'
	instanceVariableNames: 'constructorArgs'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.InitializerTests guid: (Core.GUID fromString: '{6547b0a9-3786-40b7-bacc-48ed66bf651d}')!
Graphics.Gdiplus.Tests.InitializerTests isNonInstantiable: true!
Graphics.Gdiplus.Tests.InitializerTests comment: ''!
!Graphics.Gdiplus.Tests.InitializerTests categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.InitializerTests methodsFor!

assertLastArgIsHandle
	self assert: constructorArgs last class identicalTo: Handle!

testIsPersistent
	"By default initializers can be persisted"

	self assert: model isPersistent! !
!Graphics.Gdiplus.Tests.InitializerTests categoriesFor: #assertLastArgIsHandle!asserting!public! !
!Graphics.Gdiplus.Tests.InitializerTests categoriesFor: #testIsPersistent!public!unit tests! !


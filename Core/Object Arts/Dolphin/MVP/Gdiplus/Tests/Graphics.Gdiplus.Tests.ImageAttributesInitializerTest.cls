"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.ImageAttributesInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageAttributesInitializerTest guid: (Core.GUID fromString: '{5b179394-fe1b-49be-8b4e-a8c385d87c6a}')!
Graphics.Gdiplus.Tests.ImageAttributesInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.ImageAttributesInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.ImageAttributesInitializerTest methodsFor!

gdipCreateImageAttributes: imageattr 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := ImageAttributesInitializer basicNew library: self!

testCreateHandle
	model createHandle.
	self assert: constructorArgs size equals: 1.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.ImageAttributesInitializerTest categoriesFor: #gdipCreateImageAttributes:!accessing!public! !
!Graphics.Gdiplus.Tests.ImageAttributesInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.ImageAttributesInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !


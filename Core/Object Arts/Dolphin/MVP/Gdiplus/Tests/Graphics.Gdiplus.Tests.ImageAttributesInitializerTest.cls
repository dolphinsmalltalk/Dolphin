"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.ImageAttributesInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageAttributesInitializerTest guid: (Core.GUID fromString: '{5b179394-fe1b-49be-8b4e-a8c385d87c6a}')!
Graphics.Gdiplus.Tests.ImageAttributesInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.ImageAttributesInitializerTest methodsFor!

createCanonicalSubject
	^self subjectClass default!

subjectClass
	^ImageAttributesInitializer!

testCreateHandle
	| constructor |
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreateImageAttributes:.
	self assert: constructor arguments size equals: 1.
	self assert: constructor arguments last isKindOf: Handle!

testIsPersistent
	self deny: model isPersistent! !
!Graphics.Gdiplus.Tests.ImageAttributesInitializerTest categoriesForMethods!
createCanonicalSubject!helpers!private! !
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
testIsPersistent!public!unit tests! !
!


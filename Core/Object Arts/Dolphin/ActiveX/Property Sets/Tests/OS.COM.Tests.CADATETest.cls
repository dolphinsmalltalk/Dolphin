"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.CountedArrayTest
	subclass: #'OS.COM.Tests.CADATETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CADATETest guid: (Core.GUID fromString: '{50e217c3-d6d9-4d09-8f7f-2c692a1cba85}')!

OS.COM.Tests.CADATETest comment: ''!

!OS.COM.Tests.CADATETest methodsFor!

assertElement: anObject equals: anObject2
	self assert: anObject closeTo: anObject precision: 100 microseconds!

elementToValue: element 
	^element asLocal!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating! !

!OS.COM.Tests.CADATETest categoriesForMethods!
assertElement:equals:!asserting!private! !
elementToValue:!helpers!private! !
testSelfEvaluating!public!unit tests! !
!

!OS.COM.Tests.CADATETest class methodsFor!

arrayClass
	^CADATE!

externalArrayTestClass
	^DATEArrayTest! !

!OS.COM.Tests.CADATETest class categoriesForMethods!
arrayClass!constants!private! !
externalArrayTestClass!constants!private! !
!


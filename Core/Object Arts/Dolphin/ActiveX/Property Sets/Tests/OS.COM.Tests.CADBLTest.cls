"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.CountedArrayTest
	subclass: #'OS.COM.Tests.CADBLTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CADBLTest guid: (Core.GUID fromString: '{73870c4e-1bae-47b1-a36e-546aaccfb644}')!

OS.COM.Tests.CADBLTest comment: ''!

!OS.COM.Tests.CADBLTest methodsFor!

testSelfEvaluating
	| subject expr |
	subject := self newTestSubjectOfSize: 4.
	self assert: subject isSelfEvaluating.
	expr := subject printString.
	self assert: expr equals: '(COM.CADBL withAll: #(0.0 1.25 1.7976931348623157e308 5.0e-324))'.
	self assert: (Compiler evaluate: expr) equals: subject.
	"Float infinity is self evaluating, but not literal"
	subject := self newTestSubjectOfSize: 6.
	self assert: subject isSelfEvaluating.
	expr := subject printString.
	self assert: expr equals: '(COM.CADBL withAll: {0.0. 1.25. 1.7976931348623157e308. 5.0e-324. Float.Infinity. Float.NegativeInfinity})'.
	self assert: (Compiler evaluate: expr) equals: subject.
! !

!OS.COM.Tests.CADBLTest categoriesForMethods!
testSelfEvaluating!public! !
!

!OS.COM.Tests.CADBLTest class methodsFor!

arrayClass
	^CADBL!

externalArrayTestClass
	^External.Tests.DOUBLEArrayTest! !

!OS.COM.Tests.CADBLTest class categoriesForMethods!
arrayClass!constants!private! !
externalArrayTestClass!constants!private! !
!


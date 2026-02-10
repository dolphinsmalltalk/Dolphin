"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.CountedArrayTest
	subclass: #'OS.COM.Tests.CAPROPVARIANTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CAPROPVARIANTTest guid: (Core.GUID fromString: '{287d2a05-3276-472d-8f49-8de9281b2376}')!

OS.COM.Tests.CAPROPVARIANTTest comment: ''!

!OS.COM.Tests.CAPROPVARIANTTest methodsFor!

elementToValue: anObject
	^anObject value!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString
		equals: 'a COM.CAPROPVARIANT(nil ''a🐬b'' (COM.CALPOLESTR withAll: #(''£1.5'' ''a🐬b'')) a POINTL(100@200) (COM.CABOOL withAll: #(true false)) ''a£b'')'! !

!OS.COM.Tests.CAPROPVARIANTTest categoriesForMethods!
elementToValue:!helpers!private! !
testSelfEvaluating!public!unit tests! !
!

!OS.COM.Tests.CAPROPVARIANTTest class methodsFor!

arrayClass
	^CAPROPVARIANT!

elementFromIndex: anInteger
	^PROPVARIANTArrayTest elementFromIndex: anInteger!

externalArrayTestClass
	^PROPVARIANTArrayTest! !

!OS.COM.Tests.CAPROPVARIANTTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
externalArrayTestClass!constants!private! !
!


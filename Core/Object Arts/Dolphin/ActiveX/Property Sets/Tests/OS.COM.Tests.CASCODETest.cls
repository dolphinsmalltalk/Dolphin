"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.CountedArrayTest
	subclass: #'OS.COM.Tests.CASCODETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CASCODETest guid: (Core.GUID fromString: '{c2a5b52b-a948-4a60-ac3e-c78008f11acc}')!

OS.COM.Tests.CASCODETest comment: ''!

!OS.COM.Tests.CASCODETest methodsFor!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString
		equals: 'a COM.CASCODE(a HRESULT(0x0 - The operation completed successfully.) a HRESULT(0x1 - Incorrect function.) a HRESULT(0x80004005 - Unspecified error) a HRESULT(0x80004003 - Invalid pointer) a HRESULT(0x8000FFFF - Catastrophic failure) a HRESULT(0xFFFFFFFF - Unrecognised NTSTATUS - 0xFFFFFFFF))'! !

!OS.COM.Tests.CASCODETest categoriesForMethods!
testSelfEvaluating!public! !
!

!OS.COM.Tests.CASCODETest class methodsFor!

arrayClass
	^CASCODE!

externalArrayTestClass
	^OS.Tests.HRESULTArrayTest! !

!OS.COM.Tests.CASCODETest class categoriesForMethods!
arrayClass!constants!private! !
externalArrayTestClass!private!unit tests! !
!


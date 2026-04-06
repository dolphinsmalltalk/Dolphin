"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.Tests.HRESULTArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.HRESULT})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.HRESULTArrayTest guid: (Core.GUID fromString: '{fb29c87a-e075-4106-9c5e-a51c43515d54}')!

OS.Tests.HRESULTArrayTest comment: ''!

!OS.Tests.HRESULTArrayTest methodsFor!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString
		equals: 'a HRESULTArray(a HRESULT(0x0 - The operation completed successfully.) a HRESULT(0x1 - Incorrect function.) a HRESULT(0x80004005 - Unspecified error) a HRESULT(0x80004003 - Invalid pointer) a HRESULT(0x8000FFFF - Catastrophic failure) a HRESULT(0xFFFFFFFF - Unrecognised NTSTATUS - 0xFFFFFFFF))'! !

!OS.Tests.HRESULTArrayTest categoriesForMethods!
testSelfEvaluating!public!unit tests! !
!

!OS.Tests.HRESULTArrayTest class methodsFor!

arrayClass
	^HRESULTArray!

elementFromIndex: anInteger
	^##({
		HRESULT ok.
		HRESULT fromInteger: S_FALSE.
		HRESULT fail.
		HRESULT fromInteger: E_POINTER.
		HRESULT fromInteger: E_UNEXPECTED.
		HRESULT fromInteger: -1
	}) at: anInteger! !

!OS.Tests.HRESULTArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!


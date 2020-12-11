"Filed out from Dolphin Smalltalk 7"!

External.Tests.POINTTest subclass: #'OS.Tests.POINTLTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.POINTLTest guid: (Core.GUID fromString: '{10c5c3a8-def8-4e74-a3d7-1bb3783e1c3e}')!
OS.Tests.POINTLTest comment: ''!
!OS.Tests.POINTLTest categoriesForClass!Unclassified! !
!OS.Tests.POINTLTest methodsFor!

subjectClass
	^POINTL!

testAsDwordOverflow
	| subject |
	subject := self subjectClass x: 16r100000 y: 16rBEEF.
	self
		should: [subject asDword]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]! !
!OS.Tests.POINTLTest categoriesFor: #subjectClass!constants!private! !
!OS.Tests.POINTLTest categoriesFor: #testAsDwordOverflow!public!unit tests! !


"Filed out from Dolphin Smalltalk"!

ExternalPointTest subclass: #POINTLTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTLTest guid: (GUID fromString: '{10c5c3a8-def8-4e74-a3d7-1bb3783e1c3e}')!

POINTLTest comment: ''!

!POINTLTest categoriesForClass!Unclassified! !

!POINTLTest methodsFor!

subjectClass
	^POINTL!

testAsDwordOverflow
	| subject |
	subject := self subjectClass x: 16r100000 y: 16rBEEF.
	self
		should: [subject asDword]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]! !

!POINTLTest categoriesForMethods!
subjectClass!constants!private! !
testAsDwordOverflow!public!unit tests! !
!


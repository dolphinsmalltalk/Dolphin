"Filed out from Dolphin Smalltalk"!

External.Tests.POINTTest subclass: #'OS.Tests.POINTLTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.POINTLTest guid: (Core.GUID fromString: '{10c5c3a8-def8-4e74-a3d7-1bb3783e1c3e}')!
OS.Tests.POINTLTest comment: ''!
!OS.Tests.POINTLTest methodsFor!

subjectClass
	^POINTL!

testAsDwordOverflow
	| subject |
	subject := self subjectClass x: 16r100000 y: 16rBEEF.
	self
		should: [subject asDword]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]!

testDivideLarge
	| largeNeg largePos subject |
	largeNeg := SmallInteger minimum - 1.
	largePos := SmallInteger maximum + 1.
	subject := self subjectClass x: largeNeg y: largePos.
	self assert: subject / largeNeg equals: 1 @ (largePos / largeNeg)! !
!OS.Tests.POINTLTest categoriesForMethods!
subjectClass!constants!private! !
testAsDwordOverflow!public!unit tests! !
testDivideLarge!public! !
!


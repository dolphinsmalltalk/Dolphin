"Filed out from Dolphin Smalltalk"!

External.Tests.POINTTest
	subclass: #'External.Tests.POINTFTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.POINTFTest guid: (Core.GUID fromString: '{f101ec1a-93fa-4bb8-8718-e576364d0532}')!
External.Tests.POINTFTest comment: ''!
!External.Tests.POINTFTest methodsFor!

subjectClass
	^POINTF!

subjectSupportNonIntegralValues
	^true!

testAsUInt32
	| subject |
	subject := self subjectClass x: 16rEFFE y: 16rF00F.
	self
		should: [subject asUInt32]
		raise: Error
		matching: [:ex | ex description = ('<1p> should not implement #asUInt32' << self subjectClass)]!

testPrintString
	self assert: self subjectClass new printString equals: 'a POINTF(0.0@0.0)'.
	self assert: (self subjectClass fromPoint: (1.25@4.5)) printString equals: ('a ', self subjectClass name, '(1.25@4.5)')! !
!External.Tests.POINTFTest categoriesForMethods!
subjectClass!public! !
subjectSupportNonIntegralValues!public! !
testAsUInt32!public!unit tests! !
testPrintString!public! !
!


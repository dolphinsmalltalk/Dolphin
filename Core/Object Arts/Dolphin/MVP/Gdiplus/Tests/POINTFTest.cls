"Filed out from Dolphin Smalltalk"!

ExternalPointTest subclass: #POINTFTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTFTest guid: (GUID fromString: '{f101ec1a-93fa-4bb8-8718-e576364d0532}')!

POINTFTest comment: ''!

!POINTFTest categoriesForClass!Unclassified! !

!POINTFTest methodsFor!

subjectClass
	^POINTF!

subjectSupportNonIntegralValues
	^true!

testAsDword
	self
		should: [super testAsDword]
		raise: Error
		matching: [:ex | ex description equals: 'POINTF should not implement #asDword']!

testAsDwordOverflow
	self
		should: [super testAsDwordOverflow]
		raise: Error
		matching: [:ex | ex description = ('<1p> should not implement #asDword' << self subjectClass)]!

testPrintString
	self assert: self subjectClass new printString equals: 'a POINTF(0.0@0.0)'.
	self assert: (self subjectClass fromPoint: (1.25@4.5)) printString equals: ('a ', self subjectClass name, '(1.25@4.5)')! !

!POINTFTest categoriesForMethods!
subjectClass!constants!private! !
subjectSupportNonIntegralValues!private!testing! !
testAsDword!public!unit tests! !
testAsDwordOverflow!public!unit tests! !
testPrintString!public!unit tests! !
!


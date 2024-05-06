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

testAsDword
	self
		should: [super testAsDword]
		raise: Error
		matching: [:ex | ex description equals: 'POINTF should not implement #asDword']! !

!POINTFTest categoriesForMethods!
subjectClass!constants!private! !
testAsDword!public!unit tests! !
!


"Filed out from Dolphin Smalltalk 2002 release 5.00"!

TestCase subclass: #ResumableTestFailureTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResumableTestFailureTestCase guid: (GUID fromString: '{E9E5D84B-1AC0-46B4-AE21-C00825895F1F}')!
ResumableTestFailureTestCase comment: ''!
!ResumableTestFailureTestCase categoriesForClass!SUnit! !
!ResumableTestFailureTestCase methodsFor!

errorTest
	^1 zork!

isLogging
	^false!

okTest
	self assert: true!

regularTestFailureTest
	self assert: false description: 'You should see me' !

resumableTestFailureTest
	self
		assert: false description: 'You should see me' resumable: true; 
		assert: false description: 'You should see me too' resumable: true; 
		assert: false description: 'You should see me last' resumable: false; 
		assert: false description: 'You should not see me' resumable: true!

testResumable
	| result suite |
	suite := (TestSuite new)
		addTest: (self class selector: #errorTest);
		addTest: (self class selector: #regularTestFailureTest);
		addTest: (self class selector: #resumableTestFailureTest);
		addTest: (self class selector: #okTest);
	yourself.
	result := suite run.
	self assert: result failures size = 2! !
!ResumableTestFailureTestCase categoriesFor: #errorTest!public!Running! !
!ResumableTestFailureTestCase categoriesFor: #isLogging!public!Running! !
!ResumableTestFailureTestCase categoriesFor: #okTest!public!Running! !
!ResumableTestFailureTestCase categoriesFor: #regularTestFailureTest!public!Running! !
!ResumableTestFailureTestCase categoriesFor: #resumableTestFailureTest!public!Running! !
!ResumableTestFailureTestCase categoriesFor: #testResumable!public!Running! !


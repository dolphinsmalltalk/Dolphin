"Filed out from Dolphin Smalltalk"!

TestCase subclass: #ResumableTestFailureTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResumableTestFailureTestCase guid: (GUID fromString: '{e9e5d84b-1ac0-46b4-ae21-c00825895f1f}')!
ResumableTestFailureTestCase comment: ''!
!ResumableTestFailureTestCase categoriesForClass!SUnit! !
!ResumableTestFailureTestCase methodsFor!

errorTest
	^1 zork!

failureLog
	"dialect-specific"
	"VA - System errorLog"
	"VW, Dolphin - Transcript"
	
	^Transcript!

isLogging
	^true!

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
	suite := TestSuite new
				addTest: (self class selector: #errorTest);
				addTest: (self class selector: #regularTestFailureTest);
				addTest: (self class selector: #resumableTestFailureTest);
				addTest: (self class selector: #okTest);
				yourself.
	result := suite run.
	self assert: result failures size equals: 2! !
!ResumableTestFailureTestCase categoriesForMethods!
errorTest!public!Running! !
failureLog!public!Running! !
isLogging!public!Running! !
okTest!public!Running! !
regularTestFailureTest!public!Running! !
resumableTestFailureTest!public!Running! !
testResumable!public!Running! !
!


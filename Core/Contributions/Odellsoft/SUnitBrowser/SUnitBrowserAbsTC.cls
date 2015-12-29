"Filed out from Dolphin Smalltalk X6.1"!

TestCase subclass: #SUnitBrowserAbsTC
	instanceVariableNames: 'suite'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserAbsTC guid: (GUID fromString: '{0CC128A4-C271-400A-B030-071F569C01B1}')!
SUnitBrowserAbsTC comment: ''!
!SUnitBrowserAbsTC categoriesForClass!Unclassified! !
!SUnitBrowserAbsTC methodsFor!

assertSunitTestRunResults

	self
		assert: self result passedCount = 13;
		assert: self result failureCount = 1;
		assert: self result errorCount = 1.

	self sunitPassingTests do: [:each |
		self
			assert: (self result numberCorrectFor: each) = 1;
			assert: (self result numberNotYetRunFor: each) = 0;
			assert: (self result isPassed: each)].

	self sunitErrorTests do: [:each |
		self
			assert: (self result numberErrorsFor: each) = 1;
			assert: (self result numberNotYetRunFor: each) = 0;
			assert: (self result isError: each)].

	self sunitFailureTests do: [:each |
		self
			assert: (self result numberFailuresFor: each) = 1;
			assert: (self result numberNotYetRunFor: each) = 0;
			assert: (self result isFailure: each)]


			!

setUp

	self suite: self sunitTestCaseClass suite
			!

suite

	^suite
			!

suite: aSuite

	suite := aSuite
			!

sunitErrorTests

	^self suite allTests select: [:each | each selector = #testDebugUI]
			!

sunitFailureTests

	^self suite allTests select: [:each | each selector = #testFailureDebugUI]
			!

sunitPassingTests

	^self suite allTests reject: [:each | #(testDebugUI testFailureDebugUI) includes: each selector]
			!

sunitTestCaseClass

	^SUnitTest! !
!SUnitBrowserAbsTC categoriesFor: #assertSunitTestRunResults!asserting!private! !
!SUnitBrowserAbsTC categoriesFor: #setUp!public!running! !
!SUnitBrowserAbsTC categoriesFor: #suite!accessing!private! !
!SUnitBrowserAbsTC categoriesFor: #suite:!accessing!private! !
!SUnitBrowserAbsTC categoriesFor: #sunitErrorTests!private!running! !
!SUnitBrowserAbsTC categoriesFor: #sunitFailureTests!private!running! !
!SUnitBrowserAbsTC categoriesFor: #sunitPassingTests!private!running! !
!SUnitBrowserAbsTC categoriesFor: #sunitTestCaseClass!constants!private! !

!SUnitBrowserAbsTC class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have TestCase instances 
	 built from it"

	^true
			! !
!SUnitBrowserAbsTC class categoriesFor: #isAbstract!public!Testing! !


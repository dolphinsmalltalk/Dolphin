"Filed out from Dolphin Smalltalk XP"!

SUnitBrowserAbsTC subclass: #SUnitBrowserResultTC
	instanceVariableNames: 'result'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserResultTC guid: (GUID fromString: '{FEBFA586-399F-4F76-B4AD-236CB7D4A6A0}')!
SUnitBrowserResultTC comment: ''!
!SUnitBrowserResultTC categoriesForClass!Unclassified! !
!SUnitBrowserResultTC methodsFor!

assertEmptyRunResults

	self
		assert: self result passedCount = 0;
		assert: self result failureCount = 0;
		assert: self result errorCount = 0.

	self sunitPassingTests do: [:each |
		self
			assert: (self result numberCorrectFor: each) = 0;
			assert: (self result numberNotYetRunFor: each) = 1].

	self sunitErrorTests do: [:each |
		self
			assert: (self result numberErrorsFor: each) = 0;
			assert: (self result numberNotYetRunFor: each) = 1].

	self sunitFailureTests do: [:each |
		self
			assert: (self result numberFailuresFor: each) = 0;
			assert: (self result numberNotYetRunFor: each) = 1]
			!

clearResults

	self result clear
			!

result

	^result
			!

result: anSUnitBrowserResult

	result := anSUnitBrowserResult
			!

runAllTests

	self runTests: self suite allTests
			!

runErrorTests

	self runTests: self sunitErrorTests
			!

runFailureTests

	self runTests: self sunitFailureTests
			!

runPassingTests

	self runTests: self sunitPassingTests
			!

runSunitTestSuite

	self runTests: self suite allTests
			!

runTests: tests

	tests do: [:each |
		self result
			merge: (each class run: each selector)
			for: each]
			!

setUp

	super setUp.
	self result: (
		SUnitBrowserResult newOn: (
			SUnitBrowserModel
				newForUI: SUnitBrowserDummyUI new
				builder: self sunitTestCaseClass))
			!

testClear

	self
		runSunitTestSuite;
		clearResults;
		assertEmptyRunResults
			!

testInitialState

	self
		assert: self result hasPassed;
		deny: self result hasFailures;
		deny: self result hasErrors
			!

testRunPassedTests

	self runPassingTests.

	self
		assert: self result passedCount = 13;
		assert: self result failureCount = 0;
		assert: self result errorCount = 0
			! !
!SUnitBrowserResultTC categoriesFor: #assertEmptyRunResults!asserting!private! !
!SUnitBrowserResultTC categoriesFor: #clearResults!private!running! !
!SUnitBrowserResultTC categoriesFor: #result!accessing!private! !
!SUnitBrowserResultTC categoriesFor: #result:!accessing!private! !
!SUnitBrowserResultTC categoriesFor: #runAllTests!private!running! !
!SUnitBrowserResultTC categoriesFor: #runErrorTests!private!running! !
!SUnitBrowserResultTC categoriesFor: #runFailureTests!private!running! !
!SUnitBrowserResultTC categoriesFor: #runPassingTests!private!running! !
!SUnitBrowserResultTC categoriesFor: #runSunitTestSuite!private!running! !
!SUnitBrowserResultTC categoriesFor: #runTests:!private!running! !
!SUnitBrowserResultTC categoriesFor: #setUp!public!running! !
!SUnitBrowserResultTC categoriesFor: #testClear!public!running! !
!SUnitBrowserResultTC categoriesFor: #testInitialState!*-unreferenced selectors!public!running! !
!SUnitBrowserResultTC categoriesFor: #testRunPassedTests!*-unreferenced selectors!public!running! !

!SUnitBrowserResultTC class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have TestCase instances 
	 built from it"

	^false
			! !
!SUnitBrowserResultTC class categoriesFor: #isAbstract!public!Testing! !


"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #SUnitTest
	instanceVariableNames: 'hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitTest guid: (GUID fromString: '{5e96793e-0810-11d4-a876-0050da643bf9}')!
SUnitTest comment: ''!
!SUnitTest categoriesForClass!SUnitTests! !
!SUnitTest methodsFor!

assertForTestResult: aResult runCount: aRunCount passed: aPassedCount failed: aFailureCount errors: anErrorCount

	self
		assert: aResult runCount = aRunCount;
		assert: aResult passedCount = aPassedCount;
		assert: aResult failureCount = aFailureCount;
		assert: aResult errorCount = anErrorCount!

error
	3 zork!

fail
	self assert: false!

hasRun
	^hasRun!

hasSetup
	^hasSetup!

noop!

setRun
	hasRun := true!

setUp
	hasSetup := true!

testAssert
	self assert: true.
	self deny: false!

testDefects
	| result suite error failure |
	suite := TestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	result := suite run.
	self assert: result defects asArray = (Array with: error with: failure).
	self
		assertForTestResult: result
		runCount: 2
		passed: 0
		failed: 1
		errors: 1!

testDialectLocalizedException
	self should: [TestResult signalFailureWith: 'Foo'] raise: TestResult failure.
	self should: [TestResult signalErrorWith: 'Foo'] raise: TestResult error.
	self shouldnt: [TestResult signalErrorWith: 'Foo'] raise: TestResult failure.!

testError
	| case result |
	case := self class selector: #error.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1!

testException
	self should: [self error: 'foo'] raise: TestResult error!

testFail
	| case result |
	case := self class selector: #fail.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 1
		errors: 0!

testIsNotRerunOnDebug
	| case |
	case := self class selector: #testRanOnlyOnce.
	case run.
	case debug!

testRan
	| case |
	case := self class selector: #setRun.
	case run.
	self assert: case hasSetup.
	self assert: case hasRun!

testRanOnlyOnce
	self assert: hasRanOnce ~= true.
	hasRanOnce := true.!

testResult
	| case result |
	case := self class selector: #noop.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0!

testRunning
	(SUnitDelay forMicroseconds: 20) wait!

testShould
	self should: [true].
	self shouldnt: [false]!

testSuite
	| suite result |
	suite := TestSuite new.
	suite addTest: (self class selector: #noop).
	suite addTest: (self class selector: #fail).
	suite addTest: (self class selector: #error).
	result := suite run.
	self
		assertForTestResult: result
		runCount: 3
		passed: 1
		failed: 1
		errors: 1! !
!SUnitTest categoriesFor: #assertForTestResult:runCount:passed:failed:errors:!helpers!public! !
!SUnitTest categoriesFor: #error!helpers!private! !
!SUnitTest categoriesFor: #fail!helpers!private! !
!SUnitTest categoriesFor: #hasRun!Accessing!public! !
!SUnitTest categoriesFor: #hasSetup!Accessing!public! !
!SUnitTest categoriesFor: #noop!helpers!private! !
!SUnitTest categoriesFor: #setRun!helpers!private! !
!SUnitTest categoriesFor: #setUp!public!Running! !
!SUnitTest categoriesFor: #testAssert!public!Testing! !
!SUnitTest categoriesFor: #testDefects!public!Testing! !
!SUnitTest categoriesFor: #testDialectLocalizedException!public!Testing! !
!SUnitTest categoriesFor: #testError!public!Testing! !
!SUnitTest categoriesFor: #testException!public!Testing! !
!SUnitTest categoriesFor: #testFail!public!Testing! !
!SUnitTest categoriesFor: #testIsNotRerunOnDebug!public!Testing! !
!SUnitTest categoriesFor: #testRan!public!Testing! !
!SUnitTest categoriesFor: #testRanOnlyOnce!public!Testing! !
!SUnitTest categoriesFor: #testResult!public!Testing! !
!SUnitTest categoriesFor: #testRunning!public!Testing! !
!SUnitTest categoriesFor: #testShould!public!Testing! !
!SUnitTest categoriesFor: #testSuite!public!Testing! !

!SUnitTest class methodsFor!

shouldInheritSelectors
	"answer true to inherit selectors from superclasses"

	^false! !
!SUnitTest class categoriesFor: #shouldInheritSelectors!public!Testing! !


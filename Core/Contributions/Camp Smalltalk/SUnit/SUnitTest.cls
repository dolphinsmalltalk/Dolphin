"Filed out from Dolphin Smalltalk"!

TestCase subclass: #SUnitTest
	instanceVariableNames: 'hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SUnitTest guid: (GUID fromString: '{5e96793e-0810-11d4-a876-0050da643bf9}')!

SUnitTest comment: ''!

!SUnitTest categoriesForClass!SUnitTests! !

!SUnitTest methodsFor!

assertForTestResult: aResult runCount: aRunCount passed: aPassedCount failed: aFailureCount errors: anErrorCount skipped: anInteger
	self
		assert: aResult runCount equals: aRunCount;
		assert: aResult passedCount equals: aPassedCount;
		assert: aResult failureCount equals: aFailureCount;
		assert: aResult errorCount equals: anErrorCount!

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

skipped
	self skip: 'Don''t care'!

testAssert
	self assert: true.
	self deny: false!

testDefects
	| result suite error failure |
	suite := TestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	result := suite run.
	self assert: result defects asArray equals: {error. failure}.
	self
		assertForTestResult: result
		runCount: 2
		passed: 0
		failed: 1
		errors: 1
		skipped: 0!

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
		errors: 1
		skipped: 0!

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
		errors: 0
		skipped: 0!

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
	self deny: hasRanOnce equals: true.
	hasRanOnce := true!

testResult
	| case result |
	case := self class selector: #noop.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0
		skipped: 0!

testRunning
	(SUnitDelay forMicroseconds: 20) wait!

testShould
	self should: [true].
	self shouldnt: [false]!

testSkip
	| case result |
	case := self class selector: #skipped.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 0
		skipped: 1!

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
		errors: 1
		skipped: 0! !

!SUnitTest categoriesForMethods!
assertForTestResult:runCount:passed:failed:errors:skipped:!helpers!public! !
error!helpers!private! !
fail!helpers!private! !
hasRun!Accessing!public! !
hasSetup!Accessing!public! !
noop!helpers!private! !
setRun!helpers!private! !
setUp!public!Running! !
skipped!helpers!private! !
testAssert!public!Testing! !
testDefects!public!Testing! !
testDialectLocalizedException!public!Testing! !
testError!public!Testing! !
testException!public!Testing! !
testFail!public!Testing! !
testIsNotRerunOnDebug!public!Testing! !
testRan!public!Testing! !
testRanOnlyOnce!public!Testing! !
testResult!public!Testing! !
testRunning!public!Testing! !
testShould!public!Testing! !
testSkip!public!Testing! !
testSuite!public!Testing! !
!

!SUnitTest class methodsFor!

shouldInheritSelectors
	"answer true to inherit selectors from superclasses"

	^false! !

!SUnitTest class categoriesForMethods!
shouldInheritSelectors!public!Testing! !
!


"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'XProgramming.SUnit.SUnitTest'
	instanceVariableNames: 'hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.SUnitTest guid: (Core.GUID fromString: '{5e96793e-0810-11d4-a876-0050da643bf9}')!
XProgramming.SUnit.SUnitTest comment: ''!
!XProgramming.SUnit.SUnitTest categoriesForClass!SUnitTests! !
!XProgramming.SUnit.SUnitTest methodsFor!

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
	self should: [TestResult signalFailureWith: 'Foo']
		raise: TestResult failure.
	self should: [TestResult signalErrorWith: 'Foo']
		raise: TestResult error.
	self shouldnt: [TestResult signalErrorWith: 'Foo']
		raise: TestResult failure!

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
	(Delay forMicroseconds: 20) wait!

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
!XProgramming.SUnit.SUnitTest categoriesFor: #assertForTestResult:runCount:passed:failed:errors:skipped:!helpers!public! !
!XProgramming.SUnit.SUnitTest categoriesFor: #error!helpers!private! !
!XProgramming.SUnit.SUnitTest categoriesFor: #fail!helpers!private! !
!XProgramming.SUnit.SUnitTest categoriesFor: #hasRun!Accessing!public! !
!XProgramming.SUnit.SUnitTest categoriesFor: #hasSetup!Accessing!public! !
!XProgramming.SUnit.SUnitTest categoriesFor: #noop!helpers!private! !
!XProgramming.SUnit.SUnitTest categoriesFor: #setRun!helpers!private! !
!XProgramming.SUnit.SUnitTest categoriesFor: #setUp!public!Running! !
!XProgramming.SUnit.SUnitTest categoriesFor: #skipped!helpers!private! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testAssert!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testDefects!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testDialectLocalizedException!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testError!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testException!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testFail!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testIsNotRerunOnDebug!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testRan!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testRanOnlyOnce!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testResult!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testRunning!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testShould!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testSkip!public!Testing! !
!XProgramming.SUnit.SUnitTest categoriesFor: #testSuite!public!Testing! !

!XProgramming.SUnit.SUnitTest class methodsFor!

shouldInheritSelectors
	"answer true to inherit selectors from superclasses"

	^false! !
!XProgramming.SUnit.SUnitTest class categoriesFor: #shouldInheritSelectors!public!Testing! !


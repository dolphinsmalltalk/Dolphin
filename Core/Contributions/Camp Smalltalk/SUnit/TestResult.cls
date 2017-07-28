"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestResult
	instanceVariableNames: 'results failures errors passed duration'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestResult guid: (GUID fromString: '{5e96793b-0810-11d4-a876-0050da643bf9}')!
TestResult comment: ''!
!TestResult categoriesForClass!SUnit! !
!TestResult methodsFor!

addError: aTestCase signal: anException
	results at: aTestCase put: (TestCaseResult case: aTestCase error: anException).
	errors add: aTestCase!

addFailure: aTestCase signal: anException
	results at: aTestCase put: (TestCaseResult case: aTestCase failure: anException).
	failures add: aTestCase!

addPass: aTestCase duration: anInteger
	results at: aTestCase put: (TestCaseResult case: aTestCase duration: anInteger).
	passed add: aTestCase!

correctCount
	#deprecated.	"use #passedCount"
	^self passedCount!

defects
	^(self errors copy)
		addAll: self failures;
		yourself!

duration
	^duration!

duration: anInteger
	duration := anInteger!

errorCount
	^errors size!

errors
	^errors!

failureCount
	^failures size!

failures
	^failures!

hasErrors
	^errors size > 0!

hasFailures
	^failures size > 0!

hasPassed
	^self runCount = self passedCount!

initialize
	results := LookupTable new.
	failures := Set new.
	errors := OrderedCollection new.
	passed := OrderedCollection new!

isError: aTestCase
	^(results at: aTestCase ifAbsent: []) ifNil: [false] ifNotNil: [:result | result outcome == #error]!

isFailure: aTestCase
	^(results at: aTestCase ifAbsent: [])
		ifNil: [false]
		ifNotNil: [:result | result outcome == #failure]!

isPassed: aTestCase
	^(results at: aTestCase ifAbsent: []) ifNil: [false] ifNotNil: [:result | result outcome == #passed]!

passed
	^passed!

passedCount
	^passed size!

printOn: aStream
	aStream
		nextPutAll: self runCount printString;
		nextPutAll: ' run, ';
		nextPutAll: self passedCount printString;
		nextPutAll: ' passed, ';
		nextPutAll: self failureCount printString;
		nextPutAll: ' failed, ';
		nextPutAll: self errorCount printString;
		nextPutAll:' error'.
	self errorCount ~= 1
		ifTrue: [aStream nextPut: $s].!

resultFor: aTestCase
	^results at: aTestCase!

results
	^results!

runCase: aTestCase
	
	[| start stop |
	start := Time microsecondClockValue.
	aTestCase runCase.
	stop := Time microsecondClockValue.
	self addPass: aTestCase duration: stop - start]
			on: self class failure
			do: 
				[:signal |
				self addFailure: aTestCase signal: signal.
				signal sunitExitWith: false]
			on: self class error
			do: 
				[:signal |
				self addError: aTestCase signal: signal.
				signal sunitExitWith: false]!

runCount
	^results size!

skippedCount
	^0!

tests
	^(OrderedCollection new: self runCount)
		addAll: self passed;
		addAll: self errors;
		addAll: self defects;
		yourself! !
!TestResult categoriesFor: #addError:signal:!adding!private! !
!TestResult categoriesFor: #addFailure:signal:!adding!private! !
!TestResult categoriesFor: #addPass:duration:!adding!private! !
!TestResult categoriesFor: #correctCount!accessing!public! !
!TestResult categoriesFor: #defects!accessing!public! !
!TestResult categoriesFor: #duration!accessing!public! !
!TestResult categoriesFor: #duration:!accessing!public! !
!TestResult categoriesFor: #errorCount!accessing!public! !
!TestResult categoriesFor: #errors!accessing!public! !
!TestResult categoriesFor: #failureCount!accessing!public! !
!TestResult categoriesFor: #failures!accessing!public! !
!TestResult categoriesFor: #hasErrors!public!testing! !
!TestResult categoriesFor: #hasFailures!public!testing! !
!TestResult categoriesFor: #hasPassed!public!testing! !
!TestResult categoriesFor: #initialize!initializing!public! !
!TestResult categoriesFor: #isError:!public!testing! !
!TestResult categoriesFor: #isFailure:!public!testing! !
!TestResult categoriesFor: #isPassed:!public!testing! !
!TestResult categoriesFor: #passed!accessing!public! !
!TestResult categoriesFor: #passedCount!accessing!public! !
!TestResult categoriesFor: #printOn:!printing!public! !
!TestResult categoriesFor: #resultFor:!accessing!public! !
!TestResult categoriesFor: #results!accessing!public! !
!TestResult categoriesFor: #runCase:!public!running! !
!TestResult categoriesFor: #runCount!accessing!public! !
!TestResult categoriesFor: #skippedCount!accessing!public! !
!TestResult categoriesFor: #tests!accessing!public! !

!TestResult class methodsFor!

error
	^self exError!

exError
	"Change for Dialect"
	^Error

	!

failure
	^TestFailure!

new
	^super new initialize!

resumableFailure
	^ResumableTestFailure!

signalErrorWith: aString
	self error signal: aString!

signalFailureWith: aString
	self failure signal: aString! !
!TestResult class categoriesFor: #error!Exceptions!public! !
!TestResult class categoriesFor: #exError!Exceptions!public! !
!TestResult class categoriesFor: #failure!Exceptions!public! !
!TestResult class categoriesFor: #new!Init / Release!public! !
!TestResult class categoriesFor: #resumableFailure!Exceptions!public! !
!TestResult class categoriesFor: #signalErrorWith:!Exceptions!public! !
!TestResult class categoriesFor: #signalFailureWith:!Exceptions!public! !


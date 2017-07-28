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
	"depreciated - use #passedCount"
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
	^self runCount = self correctCount!

initialize
	results := LookupTable new.
	failures := Set new.
	errors := OrderedCollection new.
	passed := OrderedCollection new!

isError: aTestCase
	^(results at: aTestCase ifAbsent: []) ifNil: [false] ifNotNil: [:result | result status == #error]!

isFailure: aTestCase
	^(results at: aTestCase ifAbsent: []) 
		ifNil: [false]
		ifNotNil: [:result | result status == #failure]!

isPassed: aTestCase
	^(results at: aTestCase ifAbsent: []) 
		ifNil: [false]
		ifNotNil: [:result | result status == #passed]
!

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
!TestResult categoriesFor: #addError:signal:!private!Running! !
!TestResult categoriesFor: #addFailure:signal:!private!Running! !
!TestResult categoriesFor: #addPass:duration:!private!Running! !
!TestResult categoriesFor: #correctCount!Accessing!public! !
!TestResult categoriesFor: #defects!Accessing!public! !
!TestResult categoriesFor: #duration!accessing!public! !
!TestResult categoriesFor: #duration:!accessing!public! !
!TestResult categoriesFor: #errorCount!Accessing!public! !
!TestResult categoriesFor: #errors!Accessing!public! !
!TestResult categoriesFor: #failureCount!Accessing!public! !
!TestResult categoriesFor: #failures!Accessing!public! !
!TestResult categoriesFor: #hasErrors!public!Testing! !
!TestResult categoriesFor: #hasFailures!public!Testing! !
!TestResult categoriesFor: #hasPassed!public!Testing! !
!TestResult categoriesFor: #initialize!Init / Release!public! !
!TestResult categoriesFor: #isError:!public!Testing! !
!TestResult categoriesFor: #isFailure:!public!Testing! !
!TestResult categoriesFor: #isPassed:!public!Testing! !
!TestResult categoriesFor: #passed!Accessing!public! !
!TestResult categoriesFor: #passedCount!Accessing!public! !
!TestResult categoriesFor: #printOn:!Printing!public! !
!TestResult categoriesFor: #results!accessing!public! !
!TestResult categoriesFor: #runCase:!public!Running! !
!TestResult categoriesFor: #runCount!Accessing!public! !
!TestResult categoriesFor: #skippedCount!Accessing!public! !
!TestResult categoriesFor: #tests!Accessing!public! !

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


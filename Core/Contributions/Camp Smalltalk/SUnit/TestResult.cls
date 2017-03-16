"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestResult
	instanceVariableNames: 'failures errors passed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestResult guid: (GUID fromString: '{5e96793b-0810-11d4-a876-0050da643bf9}')!
TestResult comment: ''!
!TestResult categoriesForClass!SUnit! !
!TestResult methodsFor!

correctCount
	"depreciated - use #passedCount"
	^self passedCount!

defects
	^(self errors copy)
		addAll: self failures;
		yourself!

errorCount
	^self errors size!

errors
	errors isNil ifTrue: [errors := OrderedCollection new].
	^errors!

failureCount
	^self failures size!

failures
        failures isNil ifTrue: [failures := Set new].
        ^failures!

hasErrors

	^self errors size > 0!

hasFailures

	^self failures size > 0!

hasPassed
	^self runCount = self correctCount!

initialize
!

isError: aTestCase

	^self errors includes: aTestCase!

isFailure: aTestCase
	^self failures includes: aTestCase!

isPassed: aTestCase

	^self passed includes: aTestCase!

passed
	passed isNil ifTrue: [passed := OrderedCollection new].
	^passed!

passedCount
	^self passed size!

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

runCase: aTestCase
	| testCasePassed |

	testCasePassed :=
		[
			[
				aTestCase runCase.
				true]
					sunitOn: self class failure
					do: [:signal |
						self failures add: aTestCase.
						signal sunitExitWith: false]]
							sunitOn: self class error
							do: [:signal |
								self errors add: aTestCase.
								signal sunitExitWith: false].

	testCasePassed
		ifTrue: [self passed add: aTestCase]!

runCount
	^self passedCount + self failureCount + self errorCount!

tests
	^(OrderedCollection new: self runCount)
		addAll: self passed;
		addAll: self errors;
		addAll: self defects;
		yourself! !
!TestResult categoriesFor: #correctCount!Accessing!public! !
!TestResult categoriesFor: #defects!Accessing!public! !
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
!TestResult categoriesFor: #runCase:!public!Running! !
!TestResult categoriesFor: #runCount!Accessing!public! !
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
	self error sunitSignalWith: aString!

signalFailureWith: aString 
	self failure sunitSignalWith: aString! !
!TestResult class categoriesFor: #error!Exceptions!public! !
!TestResult class categoriesFor: #exError!Exceptions!public! !
!TestResult class categoriesFor: #failure!Exceptions!public! !
!TestResult class categoriesFor: #new!Init / Release!public! !
!TestResult class categoriesFor: #resumableFailure!Exceptions!public! !
!TestResult class categoriesFor: #signalErrorWith:!Exceptions!public! !
!TestResult class categoriesFor: #signalFailureWith:!Exceptions!public! !


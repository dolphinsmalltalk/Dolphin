"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'XProgramming.SUnit.TestResult'
	instanceVariableNames: 'results failures errors passed skipped duration'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.TestResult guid: (Core.GUID fromString: '{5e96793b-0810-11d4-a876-0050da643bf9}')!
XProgramming.SUnit.TestResult comment: ''!
!XProgramming.SUnit.TestResult categoriesForClass!SUnit! !
!XProgramming.SUnit.TestResult methodsFor!

addError: aTestCase signal: anException
	results at: aTestCase put: (TestCaseResult case: aTestCase error: anException).
	errors add: aTestCase!

addFailure: aTestCase signal: anException
	results at: aTestCase put: (TestCaseResult case: aTestCase failure: anException).
	failures add: aTestCase!

addPass: aTestCase duration: anInteger
	results at: aTestCase put: (TestCaseResult case: aTestCase duration: anInteger).
	passed add: aTestCase!

addSkip: aTestCase signal: anException 
	results at: aTestCase put: (TestCaseResult case: aTestCase skipped: anException).
	skipped add: aTestCase
!

correctCount
	#deprecated.	"use #passedCount"
	^self passedCount!

defects
	^(self errors copy)
		addAll: self failures;
		yourself!

displayAttributes: aCollection on: aStream
	aCollection do: 
			[:each |
			| cases |
			cases := self perform: each first.
			cases isEmpty
				ifFalse: 
					[aStream
						nextPutAll: ', ';
						print: cases size;
						space;
						display: each last]]!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| runCount passedCount |
	runCount := self runCount.
	aPuttableStream
		print: runCount;
		nextPutAll: ' run in '.
	duration displayOn: aPuttableStream.
	passedCount := self passedCount.
	passedCount = runCount
		ifFalse: 
			[aPuttableStream
				nextPutAll: '; ';
				print: passedCount;
				nextPutAll: ' passed'.
			self displayAttributes: #(#(#skipped) #(#failures 'failed') #(#errors 'error(s)'))
				on: aPuttableStream]!

duration
	^duration!

duration: aDuration
	duration := aDuration!

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
	^self hasErrors not and: [self hasFailures not]!

initialize
	results := LookupTable new.
	failures := Set new.
	errors := OrderedCollection new.
	passed := OrderedCollection new.
	skipped := OrderedCollection new!

isError: aTestCase
	^(results at: aTestCase ifAbsent: []) ifNil: [false] ifNotNil: [:result | result outcome == #error]!

isFailure: aTestCase
	^(results at: aTestCase ifAbsent: [])
		ifNil: [false]
		ifNotNil: [:result | result outcome == #failure]!

isPassed: aTestCase
	^(results at: aTestCase ifAbsent: []) ifNil: [false] ifNotNil: [:result | result outcome == #passed]!

isSkipped: aTestCase
	^(results at: aTestCase ifAbsent: []) ifNil: [false] ifNotNil: [:result | result outcome == #skipped]!

passed
	^passed!

passedCount
	^passed size!

printOn: aStream
	aStream
		print: self runCount;
		nextPutAll: ' run'.
	self displayAttributes: #(#(#passed) #(#skipped) #(#failures 'failed') #(#errors 'error(s)'))
		on: aStream!

resultFor: aTestCase
	^results at: aTestCase!

results
	^results!

runCase: aTestCase
	
	[| start stop |
	start := Delay microsecondClockValue.
	aTestCase runCase.
	stop := Delay microsecondClockValue.
	self addPass: aTestCase duration: (stop - start) microseconds]
			on: self class failure
			do: 
				[:signal |
				self addFailure: aTestCase signal: signal.
				signal sunitExitWith: false]
			on: self class error
			do: 
				[:signal |
				self addError: aTestCase signal: signal.
				signal sunitExitWith: false]
			on: self class skip
			do: 
				[:signal |
				self addSkip: aTestCase signal: signal.
				signal sunitExitWith: false]!

runCount
	^results size!

skipped
	^skipped!

skippedCount
	^skipped size!

tests
	^(OrderedCollection new: self runCount)
		addAll: self passed;
		addAll: self errors;
		addAll: self defects;
		yourself! !
!XProgramming.SUnit.TestResult categoriesFor: #addError:signal:!adding!private! !
!XProgramming.SUnit.TestResult categoriesFor: #addFailure:signal:!adding!private! !
!XProgramming.SUnit.TestResult categoriesFor: #addPass:duration:!adding!private! !
!XProgramming.SUnit.TestResult categoriesFor: #addSkip:signal:!adding!private! !
!XProgramming.SUnit.TestResult categoriesFor: #correctCount!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #defects!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #displayAttributes:on:!printing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #displayOn:!printing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #duration!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #duration:!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #errorCount!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #errors!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #failureCount!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #failures!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #hasErrors!public!testing! !
!XProgramming.SUnit.TestResult categoriesFor: #hasFailures!public!testing! !
!XProgramming.SUnit.TestResult categoriesFor: #hasPassed!public!testing! !
!XProgramming.SUnit.TestResult categoriesFor: #initialize!initializing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #isError:!public!testing! !
!XProgramming.SUnit.TestResult categoriesFor: #isFailure:!public!testing! !
!XProgramming.SUnit.TestResult categoriesFor: #isPassed:!public!testing! !
!XProgramming.SUnit.TestResult categoriesFor: #isSkipped:!public!testing! !
!XProgramming.SUnit.TestResult categoriesFor: #passed!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #passedCount!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #printOn:!public! !
!XProgramming.SUnit.TestResult categoriesFor: #resultFor:!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #results!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #runCase:!public!running! !
!XProgramming.SUnit.TestResult categoriesFor: #runCount!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #skipped!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #skippedCount!accessing!public! !
!XProgramming.SUnit.TestResult categoriesFor: #tests!accessing!public! !

!XProgramming.SUnit.TestResult class methodsFor!

error
	^self exError!

exError
	"Change for Dialect"

	^Error!

failure
	^TestFailure!

new
	^super new initialize!

resumableFailure
	^ResumableTestFailure!

signalErrorWith: aString
	self error signal: aString!

signalFailureWith: aString
	self failure signal: aString!

skip
	^TestSkip! !
!XProgramming.SUnit.TestResult class categoriesFor: #error!Exceptions!public! !
!XProgramming.SUnit.TestResult class categoriesFor: #exError!Exceptions!public! !
!XProgramming.SUnit.TestResult class categoriesFor: #failure!Exceptions!public! !
!XProgramming.SUnit.TestResult class categoriesFor: #new!Init / Release!public! !
!XProgramming.SUnit.TestResult class categoriesFor: #resumableFailure!Exceptions!public! !
!XProgramming.SUnit.TestResult class categoriesFor: #signalErrorWith:!Exceptions!public! !
!XProgramming.SUnit.TestResult class categoriesFor: #signalFailureWith:!Exceptions!public! !
!XProgramming.SUnit.TestResult class categoriesFor: #skip!Exceptions!public! !


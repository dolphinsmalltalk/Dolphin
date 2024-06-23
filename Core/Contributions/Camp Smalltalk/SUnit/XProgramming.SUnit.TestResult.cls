"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.TestResult'
	instanceVariableNames: 'results failures errors passed skipped duration'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.TestResult guid: (Core.GUID fromString: '{5e96793b-0810-11d4-a876-0050da643bf9}')!

XProgramming.SUnit.TestResult comment: ''!

!XProgramming.SUnit.TestResult categoriesForClass!SUnit! !

!XProgramming.SUnit.TestResult methodsFor!

addError: aTestCase signal: anException after: aDuration
	results at: aTestCase
		put: (TestCaseResult
				case: aTestCase
				error: anException
				after: aDuration).
	errors add: aTestCase!

addFailure: aTestCase signal: anException after: aDuration
	results at: aTestCase
		put: (TestCaseResult
				case: aTestCase
				failure: anException
				after: aDuration).
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
	^(results at: aTestCase ifAbsent: nil) ifNil: [false] ifNotNil: [:result | result outcome == #error]!

isFailure: aTestCase
	^(results at: aTestCase ifAbsent: nil)
		ifNil: [false]
		ifNotNil: [:result | result outcome == #failure]!

isPassed: aTestCase
	^(results at: aTestCase ifAbsent: nil)
		ifNil: [false]
		ifNotNil: [:result | result outcome == #passed]!

isSkipped: aTestCase
	^(results at: aTestCase ifAbsent: nil)
		ifNil: [false]
		ifNotNil: [:result | result outcome == #skipped]!

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
	| start |
	start := Delay microsecondClockValue.
	
	[aTestCase runCase.
	self addPass: aTestCase duration: (Delay microsecondClockValue - start) microseconds]
			on: self class failure
			do: 
				[:signal |
				self
					addFailure: aTestCase
					signal: signal
					after: (Delay microsecondClockValue - start) microseconds.
				signal sunitExitWith: false]
			on: self class error
			do: 
				[:signal |
				self
					addError: aTestCase
					signal: signal
					after: (Delay microsecondClockValue - start) microseconds.
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

!XProgramming.SUnit.TestResult categoriesForMethods!
addError:signal:after:!adding!private! !
addFailure:signal:after:!adding!private! !
addPass:duration:!adding!private! !
addSkip:signal:!adding!private! !
correctCount!accessing!public! !
defects!accessing!public! !
displayAttributes:on:!printing!public! !
displayOn:!printing!public! !
duration!accessing!public! !
duration:!accessing!public! !
errorCount!accessing!public! !
errors!accessing!public! !
failureCount!accessing!public! !
failures!accessing!public! !
hasErrors!public!testing! !
hasFailures!public!testing! !
hasPassed!public!testing! !
initialize!initializing!public! !
isError:!public!testing! !
isFailure:!public!testing! !
isPassed:!public!testing! !
isSkipped:!public!testing! !
passed!accessing!public! !
passedCount!accessing!public! !
printOn:!public! !
resultFor:!accessing!public! !
results!accessing!public! !
runCase:!public!running! !
runCount!accessing!public! !
skipped!accessing!public! !
skippedCount!accessing!public! !
tests!accessing!public! !
!

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

!XProgramming.SUnit.TestResult class categoriesForMethods!
error!Exceptions!public! !
exError!Exceptions!public! !
failure!Exceptions!public! !
new!Init / Release!public! !
resumableFailure!Exceptions!public! !
signalErrorWith:!Exceptions!public! !
signalFailureWith:!Exceptions!public! !
skip!Exceptions!public! !
!


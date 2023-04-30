"Filed out from Dolphin Smalltalk"!

TestRunLogger subclass: #TestRunConsoleLogger
	instanceVariableNames: 'stream timings notifications'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TestRunConsoleLogger guid: (GUID fromString: '{c279d11f-90f1-4fe3-bfa6-09a2d85a208e}')!

TestRunConsoleLogger comment: ''!

!TestRunConsoleLogger categoriesForClass!Kernel-Objects! !

!TestRunConsoleLogger methodsFor!

emitTimestamp
	Locale userDefault
		printTime: DateAndTime now
		on: stream
		format: 'H:mm:ssFFF'.
	stream space!

finishedCase: aTestCaseResult
	stream
		nextPutAll: aTestCaseResult outcome asUppercase;
		nextPutAll: ' in '.
	aTestCaseResult duration printHumanReadableOn: stream.
	self logNotifications!

finishedRun: aTestResult knownSlowTests: aCollection
	| passed |
	passed := aTestResult hasPassed.
	stream
		nextPutAll: 'Test run ';
		nextPutAll: (passed ifTrue: ['PASSED'] ifFalse: ['FAILED']);
		nextPutAll: ' at';
		print: DateAndTime now;
		cr;
		display: aTestResult;
		cr.
	passed
		ifTrue: 
			[self
				summarizeTimings: aTestResult
				baseline: aCollection
				threshold: self slowTestThreshold]
		ifFalse: [self summarizeFailures: aTestResult].
	stream flush!

initializedResource: aTestResource in: aDuration
	stream
		nextPutAll: 'Completed in ';
		nextPutAll: aDuration humanReadablePrintString.
	self logNotifications!

initializingResource: aTestResource
	self emitTimestamp.
	stream
		nextPutAll: 'Initializing ';
		print: aTestResource;
		nextPutAll: ' ... ';
		flush!

logNotifications
	notifications isEmpty
		ifFalse: 
			[stream nextPutAll: ', with notifications:'.
			notifications do: 
					[:each |
					stream
						crtab: 2;
						print: each].
			notifications := OrderedCollection new].
	stream cr!

notify: aNotification
	notifications add: aNotification!

startingCase: aTestCase
	self emitTimestamp.
	stream
		print: aTestCase;
		nextPutAll: ' ... ';
		flush!

startingRun: aTestSuite
	stream
		nextPutAll: 'Starting test run at';
		print: DateAndTime now;
		nextPutAll: ' in locale ';
		print: Locale default code;
		cr;
		flush!

stream: aWriteStream
	stream := aWriteStream.
	notifications := OrderedCollection new!

summarizeFailures: aTestResult
	| failures errors |
	failures := aTestResult failures.
	failures notEmpty
		ifTrue: 
			[stream
				cr;
				nextPutAll: 'FAILURES:';
				cr.
			failures do: 
					[:each |
					stream
						print: each;
						cr]].
	errors := aTestResult errors.
	errors notEmpty
		ifTrue: 
			[stream
				cr;
				nextPutAll: 'ERRORS:';
				cr.
			errors do: 
					[:each |
					stream
						print: each;
						cr]]!

summarizeTimings: aTestResult baseline: aCollection threshold: aDuration
	| laggards newLaggards |
	laggards := (aTestResult results select: [:each | each duration >= aDuration])
				asSortedCollectionUsing: (MergesortAlgorithm sortBlock: [:a :b | a duration > b duration]).
	newLaggards := laggards reject: [:each | aCollection includes: each case].
	newLaggards size > 0 ifFalse: [^self].
	stream
		print: newLaggards size;
		nextPutAll: ' test(s) took '.
	aDuration printHumanReadableOn: stream.
	stream
		nextPutAll: ' or more to run, not including ';
		print: aCollection size;
		nextPutAll: ' known laggards:';
		cr.
	newLaggards do: 
			[:each |
			stream tab.
			each duration printHumanReadableOn: stream.
			stream
				tab;
				print: each case;
				cr]! !

!TestRunConsoleLogger categoriesForMethods!
emitTimestamp!logging!private! !
finishedCase:!logging!public! !
finishedRun:knownSlowTests:!logging!public! !
initializedResource:in:!logging!public! !
initializingResource:!logging!public! !
logNotifications!logging!public! !
notify:!logging!public! !
startingCase:!logging!public! !
startingRun:!logging!public! !
stream:!accessing!private! !
summarizeFailures:!helpers!private! !
summarizeTimings:baseline:threshold:!helpers!private! !
!

!TestRunConsoleLogger class methodsFor!

on: aPuttableStream
	^(self new)
		stream: aPuttableStream;
		yourself! !

!TestRunConsoleLogger class categoriesForMethods!
on:!public! !
!


"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestRunLogger subclass: #'XProgramming.SUnit.TestRunConsoleLogger'
	instanceVariableNames: 'stream timings'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.TestRunConsoleLogger guid: (Core.GUID fromString: '{c279d11f-90f1-4fe3-bfa6-09a2d85a208e}')!
XProgramming.SUnit.TestRunConsoleLogger comment: ''!
!XProgramming.SUnit.TestRunConsoleLogger categoriesForClass!Kernel-Objects! !
!XProgramming.SUnit.TestRunConsoleLogger methodsFor!

finishedCase: aTestCaseResult
	stream
		nextPutAll: aTestCaseResult outcome asUppercase;
		nextPutAll: ' in ';
		display: aTestCaseResult duration;
		cr!

finishedRun: aTestResult
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
		ifTrue: [self summarizeTimings: aTestResult threshold: self slowTestThreshold]
		ifFalse: [self summarizeFailures: aTestResult].
	stream flush!

startingCase: aTestCase
	stream locale printTime: DateAndTime now on: stream format: 'H:mm:ssFFF'.
	stream
		space;
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

stream: anObject
	stream := anObject!

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

summarizeTimings: aTestResult threshold: aDuration
	| laggards newLaggards |
	laggards := (aTestResult results select: [:each | each duration >= aDuration])
				asSortedCollectionUsing: (SortAlgorithm mergeSort: [:a :b | a duration > b duration]).
	newLaggards := laggards reject: [:each | each isKnownSlowTest].
	newLaggards isEmpty ifTrue: [^self].
	stream
		print: newLaggards size;
		nextPutAll: ' test(s) took '.
	aDuration displayOn: stream.
	stream
		nextPutAll: ' or more to run, not including ';
		print: laggards size - newLaggards size;
		nextPutAll: ' known laggards:';
		cr.
	newLaggards do: 
			[:each |
			stream tab.
			each duration displayOn: stream.
			stream
				tab;
				print: each case;
				cr]! !
!XProgramming.SUnit.TestRunConsoleLogger categoriesForMethods!
finishedCase:!logging!public! !
finishedRun:!logging!public! !
startingCase:!logging!public! !
startingRun:!logging!public! !
stream:!accessing!private! !
summarizeFailures:!helpers!private! !
summarizeTimings:threshold:!helpers!private! !
!

!XProgramming.SUnit.TestRunConsoleLogger class methodsFor!

on: aPuttableStream
	^(self new)
		stream: aPuttableStream;
		yourself! !
!XProgramming.SUnit.TestRunConsoleLogger class categoriesForMethods!
on:!public! !
!


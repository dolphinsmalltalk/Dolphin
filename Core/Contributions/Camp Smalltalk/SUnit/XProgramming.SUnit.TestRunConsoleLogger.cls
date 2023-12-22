"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestRunLogger
	subclass: #'XProgramming.SUnit.TestRunConsoleLogger'
	instanceVariableNames: 'stream timings notifications'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.TestRunConsoleLogger guid: (Core.GUID fromString: '{c279d11f-90f1-4fe3-bfa6-09a2d85a208e}')!
XProgramming.SUnit.TestRunConsoleLogger comment: ''!
!XProgramming.SUnit.TestRunConsoleLogger categoriesForClass!Kernel-Objects! !
!XProgramming.SUnit.TestRunConsoleLogger methodsFor!

emitTimestamp
	stream locale
		printTime: DateAndTime now
		on: stream
		format: 'H:mm:ssFFF'.
	stream space!

finishedCase: aTestCaseResult
	stream
		nextPutAll: aTestCaseResult outcome asUppercase;
		nextPutAll: ' in ';
		display: aTestCaseResult duration.
	self logNotifications!

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

initializedResource: aTestResource in: aDuration
	stream
		nextPutAll: 'Completed in ';
		display: aDuration.
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

processorDescription
	^OS.AdvApi32
		regGetString: OS.WinRegConstants.HKEY_LOCAL_MACHINE
		key: 'HARDWARE\Description\System\CentralProcessor\0'
		value: 'ProcessorNameString'!

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
		nextPutAll: ' on ';
		nextPutAll: self processorDescription;
		cr;
		flush!

stream: aWriteStream
	stream := aWriteStream.
	notifications := OrderedCollection new!

summarizeFailures: aTestResult
	| failures errors |
	failures := aTestResult failures asSortedArray.
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
	errors := aTestResult errors asSortedArray.
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
emitTimestamp!logging!private! !
finishedCase:!logging!public! !
finishedRun:!logging!public! !
initializedResource:in:!logging!public! !
initializingResource:!logging!public! !
logNotifications!logging!public! !
notify:!logging!public! !
processorDescription!helpers!private! !
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


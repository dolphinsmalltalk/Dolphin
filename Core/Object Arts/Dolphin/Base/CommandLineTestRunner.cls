"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLineTestRunner
	instanceVariableNames: 'results lastCase caseStart stream verbose runStart runStop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLineTestRunner guid: (GUID fromString: '{69CAE7CC-DE76-4748-BC30-E39048DDBB3C}')!
CommandLineTestRunner comment: ''!
!CommandLineTestRunner categoriesForClass!Kernel-Objects! !
!CommandLineTestRunner methodsFor!

initialize
	verbose := false!

printRuntime: anInteger
	| mS |
	mS := anInteger / 1000.0.
	mS < 1000.0
		ifTrue: 
			[mS printOn: stream decimalPlaces: (mS < 1.0 ifTrue: [3] ifFalse: [0]).
			stream nextPutAll: ' mS']
		ifFalse: 
			[| secs |
			secs := mS / 1000.0.
			secs printOn: stream decimalPlaces: (secs < 10.0 ifTrue: [1] ifFalse: [0]).
			stream nextPutAll: ' s']!

result
	^results!

resultFor: aTestCase
	(results isPassed: aTestCase) ifTrue: [^#passed].
	(results isFailure: aTestCase) ifTrue: [^#failed].
	(results isError: aTestCase) ifTrue: [^#error].
	^#indeterminate!

runSuite: aTestSuite
	verbose ifTrue: [aTestSuite addDependentToHierachy: self].
	results := TestResult new.
	aTestSuite resources do: [:res | res isAvailable ifFalse: [^res signalInitializationError]].
	stream isNil ifTrue: [stream := SessionManager current stdout].
	runStart := Time microsecondClockValue.
	
	[lastCase := nil.
	aTestSuite run: results.
	self
		update: nil
		with: nil
		from: aTestSuite]
			ensure: 
				[verbose ifTrue: [aTestSuite removeDependentFromHierachy: self].
				aTestSuite resources do: [:each | each reset]].
	self summarizeResults.
	^results!

stream: aPuttableStream
	stream := aPuttableStream!

summarizeResults
	stream
		nextPutAll: (results hasPassed ifTrue: ['PASSED'] ifFalse: ['FAILED']);
		cr;
		nextPutAll: results printString;
		nextPutAll: ' in '.
	self printRuntime: caseStart - runStart.
	stream cr.
	results failures notEmpty
		ifTrue: 
			[stream
				cr;
				nextPutAll: 'FAILURES:';
				cr.
			results failures do: 
					[:each |
					stream
						nextPutAll: each printString;
						cr]].
	results errors notEmpty
		ifTrue: 
			[stream
				cr;
				nextPutAll: 'ERRORS:';
				cr.
			results errors do: 
					[:each |
					stream
						nextPutAll: each printString;
						cr]].
	stream flush!

update: anObject with: argument from: originator
	| stop |
	stop := Time microsecondClockValue.
	originator class == TestSuite
		ifFalse: 
			[^super
				update: anObject
				with: argument
				from: originator].
	lastCase isNil
		ifFalse: 
			[stream
				nextPutAll: (self resultFor: lastCase) asUppercase;
				nextPutAll: ' in '.
			self printRuntime: stop - caseStart.
			stream cr].
	anObject isNil
		ifFalse: 
			[stream
				print: anObject;
				nextPutAll: ' ... '].
	stream flush.
	lastCase := anObject.
	caseStart := Time microsecondClockValue!

verbose: anObject
	verbose := anObject! !
!CommandLineTestRunner categoriesFor: #initialize!initializing!private! !
!CommandLineTestRunner categoriesFor: #printRuntime:!helpers!private! !
!CommandLineTestRunner categoriesFor: #result!Accessing!public! !
!CommandLineTestRunner categoriesFor: #resultFor:!helpers!private! !
!CommandLineTestRunner categoriesFor: #runSuite:!operations!public! !
!CommandLineTestRunner categoriesFor: #stream:!accessing!public! !
!CommandLineTestRunner categoriesFor: #summarizeResults!helpers!private! !
!CommandLineTestRunner categoriesFor: #update:with:from:!private!updating! !
!CommandLineTestRunner categoriesFor: #verbose:!accessing!public! !

!CommandLineTestRunner class methodsFor!

new
	^super new initialize! !
!CommandLineTestRunner class categoriesFor: #new!instance creation!public! !


"Filed out from Dolphin Smalltalk 7"!

Object subclass: #CommandLineTestRunner
	instanceVariableNames: 'results lastCase loggers verbose'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CommandLineTestRunner guid: (GUID fromString: '{69cae7cc-de76-4748-bc30-e39048ddbb3c}')!
CommandLineTestRunner comment: ''!
!CommandLineTestRunner categoriesForClass!Kernel-Objects! !
!CommandLineTestRunner methodsFor!

addLogger: aTestRunLogger
	loggers addLast: aTestRunLogger!

finishRun: aTestSuite knownSlowTests: aCollection
	aTestSuite removeDependentFromHierachy: self.
	aTestSuite resources do: [:each | each reset].
	loggers do: [:each | each finishedRun: results knownSlowTests: aCollection]!

initialize
	verbose := false.
	loggers := OrderedCollection new!

logFinishedCase: aTestCase
	| result |
	result := results resultFor: aTestCase.
	loggers do: [:each | each finishedCase: result]!

logStartingCase: aTestCase
	loggers do: [:each | each startingCase: aTestCase]!

logStartingRun: aTestSuite
	loggers do: [:each | each startingRun: aTestSuite]!

newStdOutLogger
	^TestRunConsoleLogger on: SessionManager current stdout!

result
	^results!

resultFor: aTestCase
	^results resultFor: aTestCase!

runSuite: aTestSuite
	self runSuite: aTestSuite knownSlowTests: #()!

runSuite: aTestSuite knownSlowTests: aCollection
	self startRun: aTestSuite.
	
	[lastCase := nil.
	aTestSuite run: results.
	self
		update: nil
		with: nil
		from: aTestSuite]
			ensure: [self finishRun: aTestSuite knownSlowTests: aCollection].
	^results!

startRun: aTestSuite
	(verbose and: [loggers isEmpty]) ifTrue: [self addLogger: self newStdOutLogger].
	aTestSuite addDependentToHierachy: self.
	results := TestResult new.
	self logStartingRun: aTestSuite.
	aTestSuite resources do: [:res | res isAvailable ifFalse: [res signalInitializationError]]!

update: anObject with: argument from: originator
	originator class == TestSuite
		ifFalse: 
			[^super
				update: anObject
				with: argument
				from: originator].
	lastCase isNil ifFalse: [self logFinishedCase: lastCase].
	anObject isNil ifFalse: [self logStartingCase: anObject].
	lastCase := anObject!

verbose: aBoolean
	verbose := aBoolean! !
!CommandLineTestRunner categoriesFor: #addLogger:!initializing!private! !
!CommandLineTestRunner categoriesFor: #finishRun:knownSlowTests:!operations!private! !
!CommandLineTestRunner categoriesFor: #initialize!initializing!private! !
!CommandLineTestRunner categoriesFor: #logFinishedCase:!private!updating! !
!CommandLineTestRunner categoriesFor: #logStartingCase:!logging!private! !
!CommandLineTestRunner categoriesFor: #logStartingRun:!logging!private! !
!CommandLineTestRunner categoriesFor: #newStdOutLogger!logging!private! !
!CommandLineTestRunner categoriesFor: #result!accessing!public! !
!CommandLineTestRunner categoriesFor: #resultFor:!helpers!private! !
!CommandLineTestRunner categoriesFor: #runSuite:!operations!public! !
!CommandLineTestRunner categoriesFor: #runSuite:knownSlowTests:!operations!public! !
!CommandLineTestRunner categoriesFor: #startRun:!operations!private! !
!CommandLineTestRunner categoriesFor: #update:with:from:!private!updating! !
!CommandLineTestRunner categoriesFor: #verbose:!accessing!public! !

!CommandLineTestRunner class methodsFor!

new
	^super new initialize! !
!CommandLineTestRunner class categoriesFor: #new!instance creation!public! !


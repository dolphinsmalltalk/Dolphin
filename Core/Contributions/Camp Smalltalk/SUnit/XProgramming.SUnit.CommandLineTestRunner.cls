"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.CommandLineTestRunner'
	instanceVariableNames: 'results lastCase loggers verbose'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.CommandLineTestRunner guid: (Core.GUID fromString: '{69cae7cc-de76-4748-bc30-e39048ddbb3c}')!
XProgramming.SUnit.CommandLineTestRunner comment: ''!
!XProgramming.SUnit.CommandLineTestRunner categoriesForClass!Kernel-Objects! !
!XProgramming.SUnit.CommandLineTestRunner methodsFor!

addLogger: aTestRunLogger
	loggers addLast: aTestRunLogger!

finishRun: aTestSuite
	aTestSuite removeDependentFromHierachy: self.
	aTestSuite resources do: [:each | each reset].
	loggers do: [:each | each finishedRun: results]!

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
	self startRun: aTestSuite.
	
	[lastCase := nil.
	aTestSuite run: results.
	self
		update: nil
		with: nil
		from: aTestSuite]
			ensure: [self finishRun: aTestSuite].
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
!XProgramming.SUnit.CommandLineTestRunner categoriesForMethods!
addLogger:!initializing!private! !
finishRun:!operations!private! !
initialize!initializing!private! !
logFinishedCase:!private!updating! !
logStartingCase:!logging!private! !
logStartingRun:!logging!private! !
newStdOutLogger!logging!private! !
result!accessing!public! !
resultFor:!helpers!private! !
runSuite:!operations!public! !
startRun:!operations!private! !
update:with:from:!private!updating! !
verbose:!accessing!public! !
!

!XProgramming.SUnit.CommandLineTestRunner class methodsFor!

new
	^super new initialize! !
!XProgramming.SUnit.CommandLineTestRunner class categoriesForMethods!
new!instance creation!public! !
!


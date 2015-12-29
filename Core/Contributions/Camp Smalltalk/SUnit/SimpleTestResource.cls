"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

TestResource subclass: #SimpleTestResource
	instanceVariableNames: 'runningState hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleTestResource guid: (GUID fromString: '{8276A29A-E3AA-40AB-83F8-C49D4189CB1E}')!
SimpleTestResource comment: ''!
!SimpleTestResource categoriesForClass!Unclassified! !
!SimpleTestResource methodsFor!

hasRun
	^hasRun!

hasSetup
	^hasSetup!

isAvailable
	
	^self runningState == self startedStateSymbol!

isStarted
	
	^self runningState == self startedStateSymbol!

isStopped
	
	^self runningState == self stoppedStateSymbol!

runningState

	^runningState!

runningState: aSymbol

	runningState := aSymbol!

setRun
	hasRun := true!

setUp
	
	self runningState: self startedStateSymbol.
	hasSetup := true!

startedStateSymbol

	^#started!

stoppedStateSymbol

	^#stopped!

tearDown

	self runningState: self stoppedStateSymbol! !
!SimpleTestResource categoriesFor: #hasRun!Accessing!public! !
!SimpleTestResource categoriesFor: #hasSetup!Accessing!public! !
!SimpleTestResource categoriesFor: #isAvailable!public!Testing! !
!SimpleTestResource categoriesFor: #isStarted!public!Testing! !
!SimpleTestResource categoriesFor: #isStopped!public!Testing! !
!SimpleTestResource categoriesFor: #runningState!Accessing!public! !
!SimpleTestResource categoriesFor: #runningState:!Accessing!public! !
!SimpleTestResource categoriesFor: #setRun!Accessing!public! !
!SimpleTestResource categoriesFor: #setUp!public!Running! !
!SimpleTestResource categoriesFor: #startedStateSymbol!Constants!public! !
!SimpleTestResource categoriesFor: #stoppedStateSymbol!Constants!public! !
!SimpleTestResource categoriesFor: #tearDown!public!Running! !

!SimpleTestResource class methodsFor!

isAvailable

	^super isAvailable and: [self current isStarted]! !
!SimpleTestResource class categoriesFor: #isAvailable!public! !


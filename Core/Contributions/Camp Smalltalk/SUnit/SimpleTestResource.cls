"Filed out from Dolphin Smalltalk"!

TestResource subclass: #SimpleTestResource
	instanceVariableNames: 'runningState hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SimpleTestResource guid: (GUID fromString: '{8276a29a-e3aa-40ab-83f8-c49d4189cb1e}')!

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

!SimpleTestResource categoriesForMethods!
hasRun!Accessing!public! !
hasSetup!Accessing!public! !
isAvailable!public!Testing! !
isStarted!public!Testing! !
isStopped!public!Testing! !
runningState!Accessing!public! !
runningState:!Accessing!public! !
setRun!Accessing!public! !
setUp!public!Running! !
startedStateSymbol!Constants!public! !
stoppedStateSymbol!Constants!public! !
tearDown!public!Running! !
!

!SimpleTestResource class methodsFor!

isAvailable

	^super isAvailable and: [self current isStarted]! !

!SimpleTestResource class categoriesForMethods!
isAvailable!public! !
!


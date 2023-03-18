"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestResource
	subclass: #'XProgramming.SUnit.SimpleTestResource'
	instanceVariableNames: 'runningState hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.SimpleTestResource guid: (Core.GUID fromString: '{8276a29a-e3aa-40ab-83f8-c49d4189cb1e}')!
XProgramming.SUnit.SimpleTestResource comment: ''!
!XProgramming.SUnit.SimpleTestResource methodsFor!

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
!XProgramming.SUnit.SimpleTestResource categoriesForMethods!
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

!XProgramming.SUnit.SimpleTestResource class methodsFor!

isAvailable

	^super isAvailable and: [self current isStarted]! !
!XProgramming.SUnit.SimpleTestResource class categoriesForMethods!
isAvailable!public! !
!


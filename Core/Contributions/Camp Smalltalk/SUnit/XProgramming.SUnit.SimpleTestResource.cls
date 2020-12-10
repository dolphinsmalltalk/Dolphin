"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestResource subclass: #'XProgramming.SUnit.SimpleTestResource'
	instanceVariableNames: 'runningState hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.SimpleTestResource guid: (Core.GUID fromString: '{8276a29a-e3aa-40ab-83f8-c49d4189cb1e}')!
XProgramming.SUnit.SimpleTestResource comment: ''!
!XProgramming.SUnit.SimpleTestResource categoriesForClass!Unclassified! !
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
!XProgramming.SUnit.SimpleTestResource categoriesFor: #hasRun!Accessing!public! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #hasSetup!Accessing!public! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #isAvailable!public!Testing! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #isStarted!public!Testing! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #isStopped!public!Testing! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #runningState!Accessing!public! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #runningState:!Accessing!public! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #setRun!Accessing!public! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #setUp!public!Running! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #startedStateSymbol!Constants!public! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #stoppedStateSymbol!Constants!public! !
!XProgramming.SUnit.SimpleTestResource categoriesFor: #tearDown!public!Running! !

!XProgramming.SUnit.SimpleTestResource class methodsFor!

isAvailable

	^super isAvailable and: [self current isStarted]! !
!XProgramming.SUnit.SimpleTestResource class categoriesFor: #isAvailable!public! !


"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #SemaphoreTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SemaphoreTest guid: (GUID fromString: '{b3d4af7f-c066-4ac2-8421-722762fe6ec9}')!

SemaphoreTest comment: ''!

!SemaphoreTest categoriesForClass!Unclassified! !

!SemaphoreTest methodsFor!

testCriticalEarlyTermination
	| s p |
	s := Semaphore forMutualExclusion.
	p := [s critical: [self assert: false	"should never be reached"]]
				forkAt: Processor userBackgroundPriority.
	"Take hold of the Semaphore, and then sleep so that the background proc can run and
	immediately block on that Semaphore"
	s critical: [(Delay forMilliseconds: 1) wait].
	"The Semaphore has been released, but terminate the background proc before it can start executing it's critical section"
	p terminate.
	"Allow the process to unwind itself and signal the Semaphore"
	Processor sleep: 10 milliseconds.
	"The Semaphore should have been released."
	self assert: s excessSignals identicalTo: 1! !

!SemaphoreTest categoriesForMethods!
testCriticalEarlyTermination!public!unit tests! !
!


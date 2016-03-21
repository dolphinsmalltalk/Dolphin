"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SemaphoreTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SemaphoreTest guid: (GUID fromString: '{B3D4AF7F-C066-4AC2-8421-722762FE6EC9}')!
SemaphoreTest comment: ''!
!SemaphoreTest categoriesForClass!Unclassified! !
!SemaphoreTest methodsFor!

testCriticalEarlyTermination
	| s p |
	s := Semaphore forMutualExclusion.
	p := [s critical: [self assert: false	"should never be reached"]] forkAt: Processor userBackgroundPriority.
	"Take hold of the Semaphore, and then sleep so that the background proc can run and
	immediately block on that Semaphore"
	s critical: [(Delay forMilliseconds: 1) wait].
	"The Semaphore has been released, but terminate the background proc before it can start executing it's critical section"
	p terminate.
	"Allow the process to unwind itself and signal the Semaphore"
	Processor sleep: 10.
	"The Semaphore should have been released."
	self assert: s excessSignals == 1! !
!SemaphoreTest categoriesFor: #testCriticalEarlyTermination!public!unit tests! !


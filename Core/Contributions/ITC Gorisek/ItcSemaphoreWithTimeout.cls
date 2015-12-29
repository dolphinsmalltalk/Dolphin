"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ItcSemaphoreWithTimeout
	instanceVariableNames: 'realSemaphore maxWaitTimeout lastCriticalSectionEntryTS lastCriticalSectionWaitTS onMutexResetBlock semaphoreName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcSemaphoreWithTimeout guid: (GUID fromString: '{6770FFD6-2540-4021-8C2A-CFE4A6505500}')!
ItcSemaphoreWithTimeout comment: ''!
!ItcSemaphoreWithTimeout categoriesForClass!Unclassified! !
!ItcSemaphoreWithTimeout methodsFor!

critical: aBlock 
	| timeNow |
	timeNow := ItcSystemManager absoluteSecondsClockValue.
	(lastCriticalSectionWaitTS > lastCriticalSectionEntryTS 
		and: [timeNow - lastCriticalSectionEntryTS > maxWaitTimeout]) 
			ifTrue: 
				["if no one has entered the critical section for maxWaitTimeout seconds since the last wait on the semaphore, then something is wrong with the semaphore, reset everything"
				lastCriticalSectionEntryTS := timeNow.
				ItcSystemManager 
					logLineWithTsAndPID: 'Resetting semaphore ' , self semaphoreName , ' with time-out of ' 
							, maxWaitTimeout printString , ' seconds on process ' 
							, Processor activeProcess itcProcessName asWebString.
				realSemaphore := Semaphore forMutualExclusion.
				onMutexResetBlock isNil ifFalse: [onMutexResetBlock value]].
	lastCriticalSectionWaitTS := timeNow.
	realSemaphore critical: 
			[lastCriticalSectionEntryTS := ItcSystemManager absoluteSecondsClockValue.
			aBlock value]!

initialize
	"Initialize with default values."

	maxWaitTimeout := 300.
	lastCriticalSectionEntryTS := lastCriticalSectionWaitTS := ItcSystemManager 
						absoluteSecondsClockValue.
	realSemaphore := Semaphore forMutualExclusion!

maxWaitTimeout
	^maxWaitTimeout!

maxWaitTimeout: seconds 
	maxWaitTimeout := seconds!

onMutexResetDo: aBlock 
	onMutexResetBlock := aBlock!

semaphoreName
	^semaphoreName ifNil: ['-unnamed semaphore-']!

semaphoreName: anObject 
	semaphoreName := anObject! !
!ItcSemaphoreWithTimeout categoriesFor: #critical:!public! !
!ItcSemaphoreWithTimeout categoriesFor: #initialize!public! !
!ItcSemaphoreWithTimeout categoriesFor: #maxWaitTimeout!public! !
!ItcSemaphoreWithTimeout categoriesFor: #maxWaitTimeout:!public! !
!ItcSemaphoreWithTimeout categoriesFor: #onMutexResetDo:!public! !
!ItcSemaphoreWithTimeout categoriesFor: #semaphoreName!accessing!public! !
!ItcSemaphoreWithTimeout categoriesFor: #semaphoreName:!accessing!public! !

!ItcSemaphoreWithTimeout class methodsFor!

forMutualExclusion
	^self new initialize! !
!ItcSemaphoreWithTimeout class categoriesFor: #forMutualExclusion!public! !


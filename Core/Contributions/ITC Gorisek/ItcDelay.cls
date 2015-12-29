"Filed out from Dolphin Smalltalk X6.2"!

Delay subclass: #ItcDelay
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcDelay guid: (GUID fromString: '{3DD4A98F-5618-4988-9728-22DB9C1703FA}')!
ItcDelay comment: ''!
!ItcDelay categoriesForClass!Kernel-Processes! !
!ItcDelay methodsFor!

calcResumptionTime
	"Private - Calculate and answer the value of the millisecond clock after which any 
	Process waiting on the receiver will be rescheduled. We could lazily evaluate this
	from the normal accessor, but we want to ensure that scheduling Delays is as fast 
	as possible, and we also want to be able to control when the calculation is made, 
	as for relative durations (the most common case) we really want to calculate off 
	the clock just before the receiver is scheduled, certainly not before that."

	resumptionTime isNil 
		ifTrue: [resumptionTime := ItcSystemManager absoluteMillisecondsClockValue + duration].
	^resumptionTime!

getDuration
	"Private - Determine the duration of the receiver based off the current millisecond
	clock value if not explicitly specified. We also calculate the absolute resumptionTime
	at this point (if not provided). We avoid requesting a delay which is larger than
	that which the system can provide, which means we may wake up before time and
	have to reschedule."

	^(resumptionTime - ItcSystemManager absoluteMillisecondsClockValue min: TimerMax) max: 0!

hasExpired
	"Private - Answer whether the receiver represents a Delay which should have
	fired by now."

	^resumptionTime - ItcSystemManager absoluteMillisecondsClockValue < Resolution! !
!ItcDelay categoriesFor: #calcResumptionTime!accessing!private! !
!ItcDelay categoriesFor: #getDuration!accessing!private! !
!ItcDelay categoriesFor: #hasExpired!private!testing! !

!ItcDelay class methodsFor!

isItcDelay
	^true!

onPreSaveImage
	"Private - The image is about to be saved. Store down the millisecond clock
	value so that we can reschedule Delays on restart."

	ImageClock := ItcSystemManager absoluteMillisecondsClockValue!

onStartup
	"Private - The system has just started. Initialize the timing system."

	"We don't bother detecting errors reported by the call, because it's too early to report them anyway"
	| devCaps |
	devCaps := ByteArray new: 8.
	WinMMLibrary default timeGetDevCaps: devCaps cbtc: devCaps size.
	Resolution := devCaps dwordAtOffset: 0.

	"Don't use the full range as its a bit unreliable on Windows 95.
	On NT4.0 this is fairly long duration anyway."
	TimerMax := (devCaps dwordAtOffset: 4) // 2.
	self keepAlive.
	ItcSystemManager onStartup.
	self reschedule!

reschedule
	"Private - Ensure that the next pending Delay, or the Current one, is correctly scheduled with 
	the VM. Called during startup to reschedule Delays based on the difference between the current
	millisecond clock, and that in place when the Delay was originally scheduled."

	AccessProtect critical: 
			[| delta |
			delta := ItcSystemManager absoluteMillisecondsClockValue - ImageClock.
			Current isNil ifFalse: [Current snooze].	"put current back into Pending"
			Pending do: [:each | each delta: delta].
			self scheduleNext]! !
!ItcDelay class categoriesFor: #isItcDelay!public! !
!ItcDelay class categoriesFor: #onPreSaveImage!event handling!private! !
!ItcDelay class categoriesFor: #onStartup!event handling!private! !
!ItcDelay class categoriesFor: #reschedule!initializing!private! !


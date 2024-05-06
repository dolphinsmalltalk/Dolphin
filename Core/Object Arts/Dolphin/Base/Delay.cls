"Filed out from Dolphin Smalltalk"!

Object subclass: #Delay
	instanceVariableNames: 'duration resumptionTime waitSemaphore'
	classVariableNames: 'AccessProtect Current DefaultResolution HighestResolution ImageClock LowestResolution Pending Resolution TicksToNanos TimingProcess TimingSemaphore'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Delay guid: (GUID fromString: '{87b4c47b-026e-11d3-9fd7-00a0cc3e4a32}')!

Delay addClassConstant: 'DefaultResolution' value: 16r3D09!

Delay comment: '`Delay`s are used to introduce timed pauses in the execution of a `Process`.  `Delay`s can be constructed that specify a duration using the instance creation messages `#forMicroseconds:`, `#forMilliseconds:`, and `#forSeconds:`, or an absolute time based on the millisecond clock value, `#untilMilliseconds:`. Once constructed a `Delay` responds to the `#wait` message by suspending the active process for the desired duration, or until the desired absolute time is reached. 

`Delay`s constructed to wait for an absolute time are "one-shot", in that once they have expired further attempts to `#wait` on them will return immediately. Conversely, `Delay`s scheduled to wait for a time interval can be waited on again to delay for the same interval.

`Delay`s are not hard (or even soft) real time, in that the requested delay is the minimum time period that will elapse before the process is restarted. The VM will make a best effort to reschedule the process after the desired delay by using the high-resolution multimedia clock (which is accurate to at best 1 millisecond) and high priority threads, but there may still be an arbitrary additional delay before the Process actually restarts depending on the load on the host machine and the relative priority of the Dolphin thread in relation to other OS threads, and the waiting pocess in relation to other processes. There is also some context switching and other processing overhead that will increase the average minimum delay to a period greater than 1mS, though (depending on machine speed) it should be reasonably close. 

Example usage:
```
	d := Delay forMilliseconds: 500. 5 timesRepeat: [d wait. Sound bell]
```

## Instance Variables:
  `duration`			`<integer>` number of microseconds to delay when #wait is sent (or nil for an absolute delay)
  `resumptionTime`		`<integer>` value of VM microsecond clock at which to resume
  `waitSemaphore`		`Semaphore` on which to wait

## Class Variables:
  `AccessProtect`	`Semaphore`; protects the class variables in critical regions.
  `Current`			`Delay` the next scheduled Delay (or nil if none).
  `DefaultResolution`	The default resolution of Delays; `<integer>` number of microseconds.
  `ImageClock`		The `<integer>` microsecond clock value on last image save - used to rebase pending Delays on image restart.
  `Pending`			`<SortedCollection>` of waiting `<Delay>`s in ascending order of resumption time.
  `TimingProcess`	`Process` responsible for waking up delayed processes on expiry of Delays.
  `TimingSemaphore`	`Semaphore` signalled by the VM at requested times, governing the operation of the TimingProcess.
  `HighestResolution`	`<integer>`; highest available clock resolution (most precise), in microseconds
  `LowestResolution`	`<integer>`; lowest available clock resolution (least precise), in microseconds
  `Resolution`		`<integer>`; current clock resolution, in microseconds.

'!

!Delay categoriesForClass!Kernel-Processes! !

!Delay methodsFor!

<= anotherDelay
	"Answer whether the receiver is less than or equal to the <Delay>, anotherDelay."

	^self resumptionTime <= anotherDelay resumptionTime!

basicCancel
	self == Current
		ifTrue: 
			[self class
				cancelTimer;
				scheduleNext]
		ifFalse: [Pending remove: self ifAbsent: []]!

calcResumptionTime
	"Private - Calculate and answer the value of the millisecond clock after which any Process
	waiting on the receiver will be rescheduled. We could lazily evaluate this from the normal
	accessor, but we want to ensure that scheduling Delays is as fast as possible, and we also
	want to be able to control when the calculation is made, as for relative durations (the most
	common case) we really want to calculate off the clock just before the receiver is
	scheduled, certainly not before that."

	resumptionTime isNil ifTrue: [resumptionTime := self class microsecondClockValue + duration].
	^resumptionTime!

cancel
	"Cancel the receiver. Any Process waiting on the receiver, remains waiting (but see #signal),
	the receiver is simply removed from the collection of Delays managed by the TimingProcess."

	AccessProtect critical: [self basicCancel]!

delta: anInteger
	"Private - Adjust the delay provided by the receiver by the specified delta (e.g. on
	image reload to base off a new millisecond clock relative to the old)."

	resumptionTime := resumptionTime + anInteger!

duration: anInteger
	"Private - Initialize the receiver to be a Delay for the number of microseconds specified by
	the <integer> argument. The resumptionTime is calculated when a #wait is sent.
	Answer the receiver."

	duration := anInteger truncated!

getDuration
	"Private - Answer the remaining duration of the receiver based off the current clock value
	and requested resumption time. Note that we may request a delay which is larger than that
	which the operating system can provide (on NT this is 1000000 milliseconds, or ~17 minutes),
	in which case we may wake up before time and have to reschedule. Delays should not be
	scheduled when they have expired, so the minimum duration is the timer resolution."

	^resumptionTime - self class microsecondClockValue max: HighestResolution!

hasExpired
	"Private - Answer whether the receiver represents a Delay which should have
	fired by now."

	^resumptionTime - self class microsecondClockValue < (HighestResolution bitShift: -1)!

initialize
	"Private - Initialize the receiver to be a valid Delay, but one which will fire after the minimum possible delay.
	Answer the receiver."

	duration := 0.
	waitSemaphore := Semaphore new!

microsecondClockValue
	"Answer the current value of the microsecond clock."

	<primitive: 189>
	^self primitiveFailed: _failureCode!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: resumptionTime;
		space;
		print: waitSemaphore;
		nextPut: $)!

resumptionTime
	"Answer the value of the millisecond clock after which any Process waiting on the receiver 
	will be rescheduled."

	^resumptionTime!

resumptionTime: anInteger
	"Private - Initialize the receiver to be a Delay until the microsecond clock value is >=
	anInteger. The duration remains nil as this is a delay until an absolute time, and cannot be
	rescheduled. Answer the receiver."

	resumptionTime := anInteger truncated!

riseAndShine
	"Private - The receiver's alarm has gone off. Decide whether to get up yet, or
	press the snooze button. This is necessary because we cannot always set a Delay
	for the maximum duration required.
	Implementation Note: This expects to be called inside the critical section."
	
	self hasExpired 
		ifTrue: [self wakeup]
		ifFalse: [self snooze]!

schedule
	"Private - Schedule the receiver as the next wake up signal.
	Implementation Note: This expects to be called inside the critical section."

	TimingSemaphore reset.

	"This may fire immediately, causing a Process switch to the timing process (if it's not the
	scheduler of the Delay), however it will almost immediately be forced to wait for the
	AccessProtect mutual exclusion Semaphore (which we own) to be signalled, which will mean
	that the assignment to Current must happen before the timing process accesses it. The timing
	Process will not restart until we exit our critical section."
	self class signalTimerAfter: self getDuration // 1000.

	Current := self!

signal
	"Immediately resume the Process waiting on the receiver."

	AccessProtect critical: 
			[self basicCancel.
			self wakeup]!

snooze
	"Private - The receiver wants a few more moments in bed, press the snooze button on 
	the alarm clock. This is necessary because we sometimes cannot set an alarm duration as
	long as we require, and because we can only set one alarm at a time. 
	Implementation Note: This expects to be called inside the critical section."

	Pending add: self

	

	!

terminateProcess
	"Terminate any process waiting on the receiver"

	waitSemaphore terminateProcess.
	self cancel!

wait
	"Delay the active Process until the receiver's resumption time. The processes priority is temporarily raised to prevent it holding up the timing process when its critical  section - if we did not do this and the current active process has a low priority, then it might be preempted in its critical section, which will prevent the TimingProcess from operating correctly.

	The resumption time is calculated outside the critical section so that it is based, as near as possible, on the microsecondClockValue at the time the #wait message is sent. If it were calculated inside, then it would incorrectly include the time taken to acquire the AccessProtect Semaphore. However, we must check again upon entering the critical section that it has not been cleared by a #signal in the interim--in this case we have nothing to do, similar to if we were scheduled for an amount of time less than the current resolution."

	| resumingAt |
	resumingAt := self calcResumptionTime.
	AccessProtect critical: 
			[resumptionTime isNil ifFalse: 
					["If the new Delay will be the first to wakeup, schedule it"
					Current isNil
						ifTrue: [self schedule]
						ifFalse: 
							[resumingAt < Current resumptionTime
								ifTrue: 
									[Current snooze.
									self schedule]
								ifFalse: [self snooze]]]]
		atPriority: TimingProcess priority - 1.
	"Now make the active Process wait"
	waitSemaphore wait!

wakeup
	"Private - The receiver has fired, resume the Process suspended on the receiver (if any)."

	duration ifNotNil: [resumptionTime := nil].
	waitSemaphore signal! !

!Delay categoriesForMethods!
<=!comparing!public! !
basicCancel!private!process synchronisation! !
calcResumptionTime!accessing!private! !
cancel!process synchronisation!public! !
delta:!operations!private! !
duration:!accessing!private! !
getDuration!accessing!private! !
hasExpired!private!testing! !
initialize!initializing!private! !
microsecondClockValue!enquiries!public! !
printOn:!development!printing!public! !
resumptionTime!accessing!public! !
resumptionTime:!accessing!private! !
riseAndShine!private!process synchronisation! !
schedule!initializing!private! !
signal!process synchronisation!public! !
snooze!private!process synchronisation! !
terminateProcess!process synchronisation!public! !
wait!process synchronisation!public! !
wakeup!private!process synchronisation! !
!

!Delay class methodsFor!

aboutToIdle
	"Private - The system is about to go idle.
	Answer the current millisecond clock value."

	self keepAlive!

cancelTimer
	"Private - Cancel any previously registered timer."

	self signalTimerAfter: -1!

clampResolution: anInteger
	"Private - As we are using multimedia timers at present, the shortest delay we
	can request is 1mS, so we clamp the requested resolution to 1000 as there is no point
	setting a resolution higher than we can achieve."

	^anInteger max: 1000!

forDuration: aDuration 
	^self forMicroseconds: aDuration asMicroseconds truncated!

forkTimingProcess
	"Private - Start the timing process which manages instances of the receiver. The timing 
	Process runs at the highest, Timing, priority, to ensure that the signal gets through, regardless 
	of the priority of its waiting Process relative to the active Process when it fires.
	A separate timing Process is used with a single semaphore because the VM can maintain 
	only a single timer, and because this allows for better management of Delays."

	AccessProtect critical: 
			[self cancelTimer.
			self initializeTimingSemaphore.
			TimingProcess isNil ifFalse: [TimingProcess terminate].
			Current isNil ifFalse: [Current snooze].	"put current back into Pending"
			self scheduleNext].
	TimingProcess := (
			[
			[TimingSemaphore wait.
			AccessProtect critical: 
					[Current isNil ifFalse: [Current riseAndShine].
					self scheduleNext]]
					repeat]
					forkAt: Processor timingPriority
					maxStack: 16384)
				name: 'Timing';
				yourself!

forMicroseconds: anInteger
	"Answer a new instance of the receiver with a duration of approximately anInteger
	microseconds The new instance has no effect on the progress of a Process until sent the
	message #wait. The actual delay achieved will depend on the current resolution of the OS
	timer, which has a maximum resolution on current Windows systems of at best 500uS."

	"Implementation Note: The Dolphin VM's timer is implemented on top of Windows multimedia
	timers, and these have a maximum resolution of 1mS. Any delay requested shorter than 1mS
	will result in a wait of at least 1mS."

	^self new duration: anInteger!

forMilliseconds: anInteger
	"Answer a new instance of the receiver with a duration of anInteger milliseconds.
	The new instance has no effect on the progress of a Process until sent the 
	message #wait. 
	ou can now set a delay down to 1mS - e.g. try 
		[Processor sleep: 1] speed.
	However, if you sleep for such a short period in a tight loop, then you'll not leave
	much CPU time for other processes to run.
	"

	^self new duration: anInteger * 1000!

forSeconds: anInteger
	"Answer a new instance of the receiver with a duration of anInteger seconds. The new
	instance has no effect on the progress of a Process until sent the message #wait. A Delay
	instantiated for a particular duration (as opposed to one instantiated for an absolute
	millisecond time) can be used repeatedly (i.e. the #wait message can be sent to it more than
	once, though at any one time only one Process can be waiting for a Delay)."

	^self forMilliseconds: anInteger * 1000!

getTicksToNanos
	| freq |
	freq := LargeInteger new64.
	(KernelLibrary default queryPerformanceFrequency: freq basicYourAddress)
		ifFalse: [self error: 'performance counter not available'].
	^1e9 / freq normalize!

highestResolution
	"Answer a <Duration> which is the maximum resolution of Delays, i.e. the shortest period for which one could theoretically request a Delay on the current host."

	^HighestResolution microseconds!

initialize
	"Initialize the Class Variables of the receiver:
		Delay initialize
	"

	ImageClock := 0.
	LowestResolution := HighestResolution := Resolution := DefaultResolution.
	AccessProtect isNil ifTrue: [AccessProtect := Semaphore forMutualExclusion].
	AccessProtect critical: 
			[Pending := SortedCollection new.
			Current := nil].
	TicksToNanos := 100.
	self initializeTimingSemaphore!

initializeTimingSemaphore
	"Private - Create the timing semaphore used for communication with the VM's timer services."

	TimingSemaphore isNil ifTrue: [TimingSemaphore := Semaphore new].
	VMLibrary default registryAt: #TimingSemaphore put: TimingSemaphore!

keepAlive
	"Private - Ensure that there is a timing process, and that it is in a runnable state."

	(TimingProcess isNil or: [TimingProcess suspendingList isNil])
		ifTrue: [
			Notification signal: 'Starting new timing process'.
			self forkTimingProcess]!

lowestResolution
	"Answer the maximum resolution of Delays in microseconds, i.e. the shortest period for which
	one could theoretically request a Delay on the current host."

	^LowestResolution!

microsecondClockValue
	"Answer the current value of the microsecond clock."

	<primitive: 189>
	^self primitiveFailed: _failureCode!

millisecondClockValue
	"Answer the current value of the system millisecond clock."

	"Implementation Note: Primitive 174 is actually just a call to the QueryPerformanceCounter
	API which should be accurate sub-1mS (unlike GetTickCount() which is only accurate to 10mS),
	and which also does not suffer the problem of wrapping after ~49 days of uptime."

	<primitive: 174>
	^self primitiveFailed: _failureCode!

new
	"Answer a new, valid, Delay, but one which will fire immediately it receives #wait.
	See #forMilliseconds:, #forSeconds:, and #untilMilliseconds:"

	^super new initialize!

onExit
	"The system is closing down, release timer related resources."

	self cancelTimer!

onPreSaveImage
	"Private - The image is about to be saved. Store down the millisecond clock
	value so that we can reschedule Delays on restart."

	ImageClock := self microsecondClockValue!

onStartup
	"The system has just started. Initialize the timing system."

	self queryOsTimerResolution.
	TicksToNanos := self getTicksToNanos.
	self keepAlive.
	self reschedule!

prod
	"Private - Give the timing process a poke to wake in case its time to rise and shine.
	You can send this message if Delays stop firing to see if they'll restart."

	TimingSemaphore signal!

queryOsTimerResolution
	| min max actual |
	min := ByteArray newFixed: 4.
	max := ByteArray newFixed: 4.
	actual := ByteArray newFixed: 4.
	(NTLibrary default
		ntQueryTimerResolution: min
		maximum: max
		actual: actual) == 0
		ifTrue: 
			[LowestResolution := self clampResolution: (min dwordAtOffset: 0) // 10.
			HighestResolution := self clampResolution: (max dwordAtOffset: 0) // 10.
			Resolution := self clampResolution: (actual dwordAtOffset: 0) // 10]
		ifFalse: [LowestResolution := HighestResolution := Resolution := DefaultResolution]!

reschedule
	"Private - Ensure that the next pending Delay, or the Current one, is correctly scheduled with 
	the VM. Called during startup to reschedule Delays based on the difference between the current
	millisecond clock, and that in place when the Delay was originally scheduled."

	AccessProtect critical: 
			[| delta |
			delta := self microsecondClockValue - ImageClock.
			Current isNil ifFalse: [Current snooze].	"put current back into Pending"
			Pending do: [:each | each delta: delta].
			self scheduleNext]!

resolution
	"Answer a <Duration> which is current resolution of Delays. This is the underlying resolution of the OS timer. Dolphin will try to service delays of this period, but it may not be possible. The resolution can be increased temporarily by using the #resolution:do: message, or permanently (not recommended) with #resolution:set:"

	^Resolution microseconds!

resolution: aDuration do: aNiladicValuable
	"Evaluate the <monadicValuable> argument with the system timer resolution set to the number
	of 100nS intervals specified by the <integer> argument. The actual timer resolution is
	passed as the argument to the <monadicValuable>."

	self resolution: aDuration set: true.
	[aNiladicValuable value] ensure: [self resolution: aDuration set: false]!

resolution: aDuration set: aBoolean
	"Attempt to set or relinquish a timer resolution specified by the <integer> argument, which
	represents the desired number of microseconds between each timer tick. If the <boolean>
	argument is true, then the timer resolution is requested. If the <boolean> argument is
	false, then a previous request for the specified resolution is given up. Answer the actual
	timer resolution established in microseconds. On current windows systems the maximum
	resolution is 500uS, and the minimum (and default) ~15mS. Note that increasing the timer
	resolution can reduce battery life, so this should be used with care."

	| actualResolution |
	actualResolution := DWORDBytes new.
	NTLibrary default
		setTimerResolution: aDuration asNanoseconds // 100
		set: aBoolean
		actualResolution: actualResolution.
	Resolution := actualResolution value // 10.
	^Resolution!

scheduleNext
	"Private - Schedule the next Pending Delay (if any). MUST be called from within
	a critical section managed by AccessProtect."

	Pending isEmpty 
		ifTrue: [Current := nil]
		ifFalse: [Pending removeFirst schedule]!

signalTimerAfter: anInteger
	"Private - Request that the VM signal the TimingSemaphore as soon as possible after the
	the specified millisecond delay. Cancel any existing request if aSemaphore is 
	not actuall a Semaphore (typically nil). If anInteger = 0, then the Semaphore
	is signalled immediately. If anInteger < 0, then the current timer (if any) is cancelled.

	Primitive failure results:
		InvalidParameter1	- anInteger is not a SmallInteger
		?				- OS refused to set timer. Code will be a packed HRESULT for the relevant Win32 error"

	<primitive: 100>
	^self primitiveFailed: _failureCode!

timingProcess
	"Private - Answer the <Process> which is used to manage the list of pending Delays."

	^TimingProcess!

untilMilliseconds: millisecondTime
	"Answer a new instance of the receiver that will make the active Process
	wait until the millisecond clock reaches the value millisecondTime."

	^self new resumptionTime: millisecondTime * 1000! !

!Delay class categoriesForMethods!
aboutToIdle!event handling!private! !
cancelTimer!operations!private! !
clampResolution:!helpers!private! !
forDuration:!instance creation!public! !
forkTimingProcess!initializing!private! !
forMicroseconds:!instance creation!public! !
forMilliseconds:!instance creation!public! !
forSeconds:!instance creation!public! !
getTicksToNanos!helpers!private! !
highestResolution!constants!public! !
initialize!development!initializing!public! !
initializeTimingSemaphore!initializing!private! !
keepAlive!helpers!private! !
lowestResolution!constants!public! !
microsecondClockValue!initializing!public! !
millisecondClockValue!accessing!public! !
new!instance creation!public! !
onExit!event handling!public! !
onPreSaveImage!event handling!private! !
onStartup!event handling!public! !
prod!operations!private! !
queryOsTimerResolution!helpers!private! !
reschedule!initializing!private! !
resolution!constants!public! !
resolution:do:!operations!public! !
resolution:set:!helpers!public! !
scheduleNext!initializing!private! !
signalTimerAfter:!private!processes-synchronising! !
timingProcess!initializing!private! !
untilMilliseconds:!instance creation!public! !
!


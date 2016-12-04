"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Delay
	instanceVariableNames: 'duration resumptionTime waitSemaphore'
	classVariableNames: 'AccessProtect Current DefaultResolution HighestResolution ImageClock LowestResolution Pending Resolution TimingProcess TimingSemaphore'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Delay guid: (GUID fromString: '{87B4C47B-026E-11D3-9FD7-00A0CC3E4A32}')!
Delay addClassConstant: 'DefaultResolution' value: 15625!
Delay comment: '<Delay>s are used to introduce timed pauses in the execution of a <Process>.  Delays can be constructed that specify a duration using the instance creation messages #forMicroseconds:, #forMilliseconds:, and #forSeconds:, or an absolute time based on the millisecond clock value (#untilMilliseconds:). Once constructed a Delay responds to the #wait message by suspending the active process for the desired duration, or until the desired absolute time is reached. 

Delays are "one-shot" in that once they have expired further attempts to #wait on them will return immediately. This applies even if the Delay was originally constructed to wait for a time interval rather than an absolute time. Therefore if one wishes to delay a process in a loop, new Delay instances should be created as required inside the loop. It is often more convenient to use the ProcessorScheduler>>sleep: message, which wraps up the creation and wait operations inside a convenience message.

Delays are not hard real time, in that the requested delay is the minimum time period that will elapse before the process is restarted. The VM will make a best effort to reschedule the process after the desired delay by using the high-resolution multimedia clock (which is accurate to at best 1 millisecond) and high priority threads, but there may still be an arbitrary additional delay before the Process actually restarts depending on the load on the host machine and the relative priority of the Dolphin thread in relation to other OS threads, and the waiting Process in relation to other Processes. There is also some context switching and other processing overhead that will increase the average minimum Delay to a period greater than 1mS, though (depending on machine speed) it should be quite close. 

Example usage:
	5 timesRepeat: [(Delay forMilliseconds: 500) wait. Sound bell]

Instance Variables:
	duration			<integer> number of microseconds to delay when #wait is sent
	resumptionTime	<integer> value of VM microsecond clock at which to resume
	waitSemaphore		<Semaphore> on which to wait

Class Variables:
	AccessProtect		<Semaphore>; protects the class variables in critical regions.
	Current			<Delay>; the next scheduled Delay (or nil if none).
	DefaultResolution	The default resolution of Delays; <integer> number of microseconds.
	HighestResolution	The highest requestable resolution for Delays; <integer> number of microseconds.
	ImageClock		The <integer> microsecond clock value on last image save - used to rebase pending Delays on image restart.
	LowestResolution	The lowest requestable resolution for Delays; <integer> number of microseconds.
	Pending			<SortedCollection> of waiting <Delay>s in ascending order of resumptionTime.
	Resolution			The current <integer> resolution of Delays specified in microseconds.
	TimingProcess		<Process> responsible for waking up delayed processes on expiry of Delays.
	TimingSemaphore	<Semaphore> signalled by the VM at requested times, governing the operation of the TimingProcess.'!
!Delay categoriesForClass!Kernel-Processes! !
!Delay methodsFor!

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
	"Cancel the receiver. Any Process waiting on the receiver, remains waiting (but see #resume),
	the receiver is simply removed from the collection of Delays managed by the TimingProcess."

	AccessProtect critical: [
		self == Current
			ifTrue: [
				self class
					cancelTimer;
					scheduleNext]
			ifFalse: [
				Pending remove: self ifAbsent: []]]
!

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
	^self primitiveFailed!

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

	"This may fire immediately, causing a Process switch to the timing process
	(if it's not the scheduler of the Delay), however it will almost immediately
	be forced to wait for the AccessProtect mutual exclusion Semaphore (which
	we own) to be signalled, which will mean that the assignment to Current
	must happen before the timing process accesses it. The timing Process
	will not restart until we exit our critical section."
	self class signal: TimingSemaphore afterMilliseconds: self getDuration // 1000.

	Current := self!

signal
	"Immediately resume the Process waiting on the receiver."

	self cancel.
	self wakeup
!

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
	"Delay the active Process until the receiver's resumption time. The processes priority 
	is temporarily raised to prevent it holding up the timing process when its critical 
	section - if we did not do this and the current active process has a low priority, then 
	it might be preempted in its critical section, which will prevent the TimingProcess
	from operating correctly. The resumption time is calculated outside the critical section 
	so that it is based, as near as possible, on the millisecondClockValue at the time the 
	#wait message is sent. If it were calculated inside, then it would incorrectly include 
	the time taken to acquire the AccessProtect Semaphore."

	| resumingAt |
	resumingAt := self calcResumptionTime.
	AccessProtect critical: [
		"If the new Delay will be the first to wakeup, schedule it"
		Current isNil 
			ifTrue: [self schedule]
			ifFalse: [
				resumingAt < Current resumptionTime
					ifTrue: [ 
						Current snooze.
						self schedule]
					ifFalse: [self snooze]]] atPriority: TimingProcess priority-1.
	"Now make the active Process wait"
	waitSemaphore wait!

wakeup
	"Private - The receiver has fired, resume the Process suspended on the receiver (if any)."

	waitSemaphore signal! !
!Delay categoriesFor: #calcResumptionTime!accessing!private! !
!Delay categoriesFor: #cancel!process synchronisation!public! !
!Delay categoriesFor: #delta:!operations!private! !
!Delay categoriesFor: #duration:!accessing!private! !
!Delay categoriesFor: #getDuration!accessing!private! !
!Delay categoriesFor: #hasExpired!private!testing! !
!Delay categoriesFor: #initialize!initializing!private! !
!Delay categoriesFor: #microsecondClockValue!enquiries!public! !
!Delay categoriesFor: #printOn:!development!printing!public! !
!Delay categoriesFor: #resumptionTime!accessing!public! !
!Delay categoriesFor: #resumptionTime:!accessing!private! !
!Delay categoriesFor: #riseAndShine!private!process synchronisation! !
!Delay categoriesFor: #schedule!initializing!private! !
!Delay categoriesFor: #signal!process synchronisation!public! !
!Delay categoriesFor: #snooze!private!process synchronisation! !
!Delay categoriesFor: #terminateProcess!process synchronisation!public! !
!Delay categoriesFor: #wait!process synchronisation!public! !
!Delay categoriesFor: #wakeup!private!process synchronisation! !

!Delay class methodsFor!

aboutToIdle
	"Private - The system is about to go idle.
	Answer the current millisecond clock value."

	self keepAlive!

cancelTimer
	"Private - Cancel any previously registered timer."

	self signal: nil afterMilliseconds: 0.
!

clampResolution: anInteger
	"Private - As we are using multimedia timers at present, the shortest delay we
	can request is 1mS, so we clamp the requested resolution to 1000 as there is no point
	setting a resolution higher than we can achieve."

	^anInteger max: 1000!

forkTimingProcess
	"Private - Start the timing process which manages instances of the receiver. The timing 
	Process runs at the highest, Timing, priority, to ensure that the signal gets through, regardless 
	of the priority of its waiting Process relative to the active Process when it fires.
	A separate timing Process is used with a single semaphore because the VM can maintain 
	only a single timer, and because this allows for better management of Delays."

	AccessProtect critical: [	
		self cancelTimer.
		TimingSemaphore isNil ifTrue: [self initializeTimingSemaphore].
		TimingProcess isNil ifFalse: [TimingProcess terminate].
		Current isNil ifFalse: [Current snooze].		"put current back into Pending"
		self scheduleNext.
	].
	TimingProcess := ([
		[
			TimingSemaphore wait.		"Wait for a timeout to be signalled by VM" 
			AccessProtect critical: [
				Current isNil ifFalse: [Current riseAndShine].
				self scheduleNext]] repeat.
	] forkAt: Processor timingPriority) name: 'Timing'; yourself!

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

highestResolution
	"Answer the maximum resolution of Delays in microseconds, i.e. the shortest period for which
	one could theoretically request a Delay on the current host."

	^HighestResolution!

icon
	"Answers an Icon that can be used to represent this class. Here we use a constant expression 
	evaluated at compile time in order to statically bind 'self' at this position in the class hierarchy 
	(i.e. to Object). This ensures that subclasses which do not override this method still answer 
	'Object defaultIcon' rather than 'aSubclass defaultIcon'. Classes which provide their own default icon 
	can override this method with a similar implementation perhaps with #defaultIconFrom: if the icon comes
	from an ExternalResourceLibrary other than the system default."

	^##(self) defaultIcon!

initialize
	"Initialize the Class Variables of the receiver:
		Delay initialize
	"

	ImageClock := 0.
	LowestResolution := HighestResolution := Resolution := DefaultResolution.
	AccessProtect isNil ifTrue: [AccessProtect := Semaphore forMutualExclusion].
	AccessProtect critical: 
			[Pending := SortedCollection
						sortBlock: [:delay1 :delay2 | delay1 resumptionTime <= delay2 resumptionTime].
			Current := nil].
	TimingSemaphore isNil ifTrue: [self initializeTimingSemaphore]!

initializeTimingSemaphore
	"Private - Create the timing semaphore used for communication with the VM's
	timer services."

	TimingSemaphore := Semaphore new.
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
	"Private - Answer the current value of the microsecond clock."

	<primitive: 189>
	^self primitiveFailed!

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
	self keepAlive.
	self reschedule!

prod
	"Private - Give the timing process a poke to wake in case its time to rise and shine.
	You can send this message if Delays stop firing to see if they'll restart."

	TimingSemaphore signal!

queryOsTimerResolution
	| min max actual |
	min := DWORDBytes new.
	max := DWORDBytes new.
	actual := DWORDBytes new.
	(NTLibrary default
		ntQueryTimerResolution: min
		maximum: max
		actual: actual) == 0
		ifTrue: 
			[LowestResolution := self clampResolution: min value // 10.
			HighestResolution := self clampResolution: max value // 10.
			Resolution := self clampResolution: actual value // 10]
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
	"Answer the resolution of Delays in microseconds. This is the underlying resolution of the
	OS timer. Dolphin will try to service delays of this period, but it may not be possible."

	^Resolution!

resolution: anInteger do: aNiladicValuable
	"Evaluate the <monadicValuable> argument with the system timer resolution set to the number
	of 100nS intervals specified by the <integer> argument. The actual timer resolution is
	passed as the argument to the <monadicValuable>."

	self resolution: anInteger set: true.
	[aNiladicValuable value] ensure: [self resolution: anInteger set: false]!

resolution: anInteger set: aBoolean
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
		setTimerResolution: (anInteger max: 1000) * 10
		set: aBoolean
		actualResolution: actualResolution.
	^Resolution := self clampResolution: actualResolution value!

scheduleNext
	"Private - Schedule the next Pending Delay (if any). MUST be called from within
	a critical section managed by AccessProtect."

	Pending isEmpty 
		ifTrue: [Current := nil]
		ifFalse: [Pending removeFirst schedule]!

signal: aSemaphore afterMilliseconds: anInteger 
	"Private - Request that the VM signal aSemaphore as soon as possible after the
	the specified millisecond delay. Cancel any existing request if aSemaphore is 
	not actuall a Semaphore (typically nil). If anInteger <= 0, then the Semaphore
	is signalled immediately.

	Primitive failure results:
		0 - anInteger is not a SmallInteger
		2 - anInteger was greater than the maximum Delay which can be requested.
		3 - OS refused to set timer (try KernelLibrary>>getLastError)"

	<primitive: 100>
	^self primitiveFailed!

timingProcess
	"Private - Answer the <Process> which is used to manage the list of pending Delays."

	^TimingProcess!

untilMilliseconds: millisecondTime
	"Answer a new instance of the receiver that will make the active Process
	wait until the millisecond clock reaches the value millisecondTime."

	^self new resumptionTime: millisecondTime * 1000! !
!Delay class categoriesFor: #aboutToIdle!event handling!private! !
!Delay class categoriesFor: #cancelTimer!operations!private! !
!Delay class categoriesFor: #clampResolution:!helpers!private! !
!Delay class categoriesFor: #forkTimingProcess!initializing!private! !
!Delay class categoriesFor: #forMicroseconds:!instance creation!public! !
!Delay class categoriesFor: #forMilliseconds:!instance creation!public! !
!Delay class categoriesFor: #forSeconds:!instance creation!public! !
!Delay class categoriesFor: #highestResolution!constants!public! !
!Delay class categoriesFor: #icon!constants!development!public! !
!Delay class categoriesFor: #initialize!development!initializing!public! !
!Delay class categoriesFor: #initializeTimingSemaphore!initializing!private! !
!Delay class categoriesFor: #keepAlive!helpers!private! !
!Delay class categoriesFor: #lowestResolution!constants!public! !
!Delay class categoriesFor: #microsecondClockValue!initializing!private! !
!Delay class categoriesFor: #new!instance creation!public! !
!Delay class categoriesFor: #onExit!event handling!public! !
!Delay class categoriesFor: #onPreSaveImage!event handling!private! !
!Delay class categoriesFor: #onStartup!event handling!public! !
!Delay class categoriesFor: #prod!operations!private! !
!Delay class categoriesFor: #queryOsTimerResolution!helpers!private! !
!Delay class categoriesFor: #reschedule!initializing!private! !
!Delay class categoriesFor: #resolution!constants!public! !
!Delay class categoriesFor: #resolution:do:!operations!public! !
!Delay class categoriesFor: #resolution:set:!helpers!public! !
!Delay class categoriesFor: #scheduleNext!initializing!private! !
!Delay class categoriesFor: #signal:afterMilliseconds:!private!processes-synchronising! !
!Delay class categoriesFor: #timingProcess!initializing!private! !
!Delay class categoriesFor: #untilMilliseconds:!instance creation!public! !


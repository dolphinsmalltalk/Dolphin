"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #Delay
	instanceVariableNames: 'duration resumptionTime waitSemaphore '
	classVariableNames: 'AccessProtect Current ImageClock Pending Resolution TimerMax TimingProcess TimingSemaphore'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Delay guid: (GUID fromString: '{87B4C47B-026E-11D3-9FD7-00A0CC3E4A32}')!
Delay comment: '<Delay>s are used to introduce timed pauses in the execution of a <Process>.  Delays can be constructed that specify a duration using the instance creation messages #forMilliseconds: and #forSeconds:, or an absolute time based on the millisecond clock value (#untilMilliseconds:). Once constructed a Delay responds to the #wait message by suspending the active process for the desired duration, or until the desired absolute time is reached. 

Delays are "one-shot" in that once they have expired further attempts to #wait on them will return immediately. This applies even if the Delay was originally constructed to wait for a time interval rather than an absolute time. Therefore if one wishes to delay a process in a loop, new Delay instances should be created as required inside the loop. It is often more convenient to use the ProcessorScheduler>>sleep: message, which wraps up the creation and wait operations inside a convenience message.

Delays are not hard real time, in that the requested delay is the minimum time period that will elapse before the process is restarted. The VM will make a best effort to reschedule the process after the desired delay by using the high-resolution multimedia clock (accurate to 1 millisecond) and high priority threads, but there may still be an arbitrary additional delay before the Process actually restarts depending on the load on the host machine and the relative priority of the Dolphin thread in relation to other OS threads, and the waiting Process in relation to other Processes. There is also some context switching and other processing overhead that will increase the average minimum Delay to a period greater than 1mS, though (depending on machine speed) it should be quite close. 

Example usage:
	5 timesRepeat: [(Delay forMilliseconds: 500) wait. Sound bell]

Instance Variables:
	duration		<integer> number of milliseconds to delay Process
	resumptionTime	<integer> value of millisecond clock at which to resume
	waitSemaphore	<Semaphore> on which to delay Process

Class Variables:
	AccessProtect	<Semaphore> protects the class variables in critical regions
	Current		<Delay> the next scheduled Delay (or nil if none)
	ImageClock	<integer> millisecond clock value on last image save - used to reschedule delays on image restart
	Pending		<SortedCollection> of waiting <Delay>s in ascending order of resumptionTime.
	Resolution	<integer> resolution of millisecond clock, minimum 1
	TimerMax		<integer> maximum delay recordable with the timing device.  Longer delays are achieved by repeatedly rescheduling until the desired period has elapsed.
	TimingProcess	<Process> responsible for waking up delayed processes on expiry of Delay
	TimingSemaphore	<Semaphore> Signalled by the VM at requested times, governing the operation of the TimingProcess.
'!
!Delay categoriesForClass!Kernel-Processes! !
!Delay methodsFor!

calcResumptionTime
	"Private - Calculate and answer the value of the millisecond clock after which any 
	Process waiting on the receiver will be rescheduled. We could lazily evaluate this
	from the normal accessor, but we want to ensure that scheduling Delays is as fast 
	as possible, and we also want to be able to control when the calculation is made, 
	as for relative durations (the most common case) we really want to calculate off 
	the clock just before the receiver is scheduled, certainly not before that."

	resumptionTime isNil ifTrue: [resumptionTime := self class millisecondClockValue + duration].
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

duration: millisecs
	"Private - Initialize the receiver to be a Delay for the Number of milliseconds specified by
	the argument, millisecs. The resumptionTime is calculated when a #wait is sent.
	Answer the receiver."

	duration := millisecs truncated
!

getDuration
	"Private - Answer the remaining duration of the receiver based off the current millisecond
	clock value and requested resumption time. We avoid requesting a delay which is larger than
	that which the system can provide, which means we may wake up before time and have to
	reschedule. If the resumptionTime has already passed, then answer 0 (i.e. duration is always
	positive)."

	^(resumptionTime - self class millisecondClockValue min: TimerMax) max: 0!

hasExpired
	"Private - Answer whether the receiver represents a Delay which should have
	fired by now."

	^(resumptionTime - self class millisecondClockValue) < Resolution.

	#todo "This, and other Delay methods, do not correctly account for the millisecond clock
		wrapping round. Fix this, and perhaps allow scheduling of Delays for absolute DateTimes"!

initialize
	"Private - Initialize the receiver to be a valid Delay, but one which will fire immediately.
	Answer the receiver."

	duration := 0.
	waitSemaphore := Semaphore new!

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

resumptionTime: millisecondTime
	"Private - Initialize the receiver to be a Delay until millisecondTime. The duration remains
	nil as this is a delay until an absolute time, and cannot be rescheduled.
	Answer the receiver."

	resumptionTime := millisecondTime truncated!

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
	Processor signal: TimingSemaphore afterMilliseconds: self getDuration.

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

	Processor signal: nil afterMilliseconds: 0.
!

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

forMilliseconds: millisecondCount
	"Answer a new instance of the receiver with a duration of millisecondCount seconds.
	The new instance has no effect on the progress of a Process until sent the 
	message #wait. 
	ou can now set a delay down to 1mS - e.g. try 
		[Processor sleep: 1] speed.
	However, if you sleep for such a short period in a tight loop, then you'll not leave
	much CPU time for other processes to run.
	"

	^self new duration: millisecondCount!

forSeconds: secondCount
	"Answer a new instance of the receiver with a duration of secondCount seconds.
	The new instance has no effect on the progress of a Process until sent the 
	message #wait. A Delay instantiated for a particular duration (as opposed to one
	instantiated for an absolute millisecond time) can be used repeatedly (i.e. the 
	#wait message can be sent to it more than once, though at any one time only one 
	Process can be waiting for a Delay)."

	^self forMilliseconds: secondCount*1000!

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
	Resolution := 1.
	TimerMax := 65535.
	AccessProtect isNil ifTrue: [AccessProtect := Semaphore forMutualExclusion].
	AccessProtect critical: 
			[Pending := SortedCollection 
						sortBlock: [:delay1 :delay2 | delay1 resumptionTime <= delay2 resumptionTime].
			Current := nil].
	TimingSemaphore isNil ifTrue: [self initializeTimingSemaphore]!

initializeTimingSemaphore
	"Private - Create the timing semaphore used for communication with the VM's
	timer services."

	TimingSemaphore := Semaphore new!

keepAlive
	"Private - Ensure that there is a timing process, and that it is in a runnable state."

	(TimingProcess isNil or: [TimingProcess suspendingList isNil])
		ifTrue: [
			Notification signal: 'Starting new timing process'.
			self forkTimingProcess]!

millisecondClockValue
	"Private - Answer the current millisecond clock value."

	<primitive: 174>
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

	ImageClock := self millisecondClockValue!

onStartup
	"The system has just started. Initialize the timing system."

	| devCaps |
	"We don't bother detecting errors reported by the call, because it's too early to report them anyway"
	devCaps := ByteArray new: 8.
	WinMMLibrary default timeGetDevCaps: devCaps cbtc: devCaps size.
	Resolution := devCaps dwordAtOffset: 0.

	"Don't use the full range as its a bit unreliable on Windows 95.
	On NT4.0 this is fairly long duration anyway."
	TimerMax := (devCaps dwordAtOffset: 4) // 2.
	self keepAlive.
	self reschedule!

prod
	"Private - Give the timing process a poke to wake in case its time to rise and shine.
	You can send this message if Delays stop firing to see if they'll restart."

	TimingSemaphore signal!

reschedule
	"Private - Ensure that the next pending Delay, or the Current one, is correctly scheduled with 
	the VM. Called during startup to reschedule Delays based on the difference between the current
	millisecond clock, and that in place when the Delay was originally scheduled."

	AccessProtect critical: 
			[| delta |
			delta := self millisecondClockValue - ImageClock.
			Current isNil ifFalse: [Current snooze].	"put current back into Pending"
			Pending do: [:each | each delta: delta].
			self scheduleNext]!

resolution
	"Answer the resolution of Delays. This is the underlying resolution of the timing
	device. Dolphin will try to service delays of this period, but it may not be possible."

	^Resolution!

scheduleNext
	"Private - Schedule the next Pending Delay (if any). MUST be called from within
	a critical section managed by AccessProtect."

	Pending isEmpty 
		ifTrue: [Current := nil]
		ifFalse: [Pending removeFirst schedule]!

timingProcess
	"Private - Answer the <Process> which is used to manage the list of pending Delays."

	^TimingProcess!

untilMilliseconds: millisecondTime
	"Answer a new instance of the receiver that will make the active Process
	wait until the millisecond clock reaches the value millisecondTime."

	^self new resumptionTime: millisecondTime! !
!Delay class categoriesFor: #aboutToIdle!event handling!private! !
!Delay class categoriesFor: #cancelTimer!operations!private! !
!Delay class categoriesFor: #forkTimingProcess!initializing!private! !
!Delay class categoriesFor: #forMilliseconds:!instance creation!public! !
!Delay class categoriesFor: #forSeconds:!instance creation!public! !
!Delay class categoriesFor: #icon!constants!development!public! !
!Delay class categoriesFor: #initialize!development!initializing!public! !
!Delay class categoriesFor: #initializeTimingSemaphore!initializing!private! !
!Delay class categoriesFor: #keepAlive!helpers!private! !
!Delay class categoriesFor: #millisecondClockValue!initializing!private! !
!Delay class categoriesFor: #new!instance creation!public! !
!Delay class categoriesFor: #onExit!event handling!public! !
!Delay class categoriesFor: #onPreSaveImage!event handling!private! !
!Delay class categoriesFor: #onStartup!event handling!public! !
!Delay class categoriesFor: #prod!operations!private! !
!Delay class categoriesFor: #reschedule!initializing!private! !
!Delay class categoriesFor: #resolution!constants!public! !
!Delay class categoriesFor: #scheduleNext!initializing!private! !
!Delay class categoriesFor: #timingProcess!initializing!private! !
!Delay class categoriesFor: #untilMilliseconds:!instance creation!public! !


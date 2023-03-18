"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.DelayTest'
	instanceVariableNames: 'delay startTime timerResolution'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DelayTest guid: (Core.GUID fromString: '{0b7c6875-1051-4b80-b137-cd1c02754bcd}')!
Core.Tests.DelayTest comment: ''!
!Core.Tests.DelayTest methodsFor!

expectDelay: expectedDuration for: nowMicroseconds
	| elapsed delta |
	elapsed := (nowMicroseconds - startTime) microseconds.
	delta := elapsed - expectedDuration.
	"Although a Delay could end up waiting much longer than the expected duration,
	e.g. if the CPU is very busy, this should happen only rarely, and we do not want
	to tolerate it if it happens all the time as that would indicate an actual bug."
	self assert: (delta between: timerResolution negated and: timerResolution * 5)
		description: 
			[String smalltalkWriteStream
				nextPutAll: 'Expected delay of ';
				display: expectedDuration;
				nextPutAll: ' got ';
				display: elapsed;
				contents]!

setUp
	super setUp.
	timerResolution := Delay timerResolution: 1 milliseconds set: true.
!

tearDown
	Delay timerResolution: 1 milliseconds set: false.
	super tearDown!

testBasicWait
	| duration endTime retries |
	duration := 5 milliseconds max: timerResolution.
	retries := 0.
	
	[delay := Delay forDuration: duration.
	startTime := Time microsecondClockValue.
	delay wait.
	endTime := Time microsecondClockValue.
	((endTime - startTime) microseconds - duration between: timerResolution negated
		and: timerResolution * 5) or: [retries > 3]]
			whileFalse: [retries := retries + 1].
	self expectDelay: duration for: endTime!

testCancel
	| proc endTime |
	delay := Delay forMilliseconds: 20.
	proc := 
			[delay wait.
			endTime := Time microsecondClockValue] forkAt: Processor userInterruptPriority.
	
	[delay cancel.
	self deny: Delay.Current identicalTo: delay.
	self deny: (Delay.Pending includes: delay).
	(Delay forMilliseconds: 30) wait.
	self assertIsNil: endTime.
	self assert: proc isWaiting]
			ensure: [proc terminate]!

testCancelWithOtherShorterDelay
	[(Delay forMilliseconds: 10) wait] forkAt: Processor userInterruptPriority.
	self testCancel!

testSchedulingMultipleDelays
	| endTime delay2 |
	delay := Delay forMilliseconds: 15.
	delay2 := Delay forMilliseconds: 25.
	
	[startTime := Time microsecondClockValue.
	delay wait.
	endTime := Time microsecondClockValue]
			forkAt: Processor userInterruptPriority.
	delay2 wait.
	self expectDelay: delay duration for: endTime.
	self expectDelay: delay2 duration for: Time microsecondClockValue!

testSchedulingMultipleDelaysLongerFirst
	| endTime delay2 delay3 endTime2 |
	delay := Delay forMilliseconds: 25.
	delay2 := Delay forMilliseconds: 15.
	delay3 := Delay forMilliseconds: 15.
	
	[startTime := Time microsecondClockValue.
	delay wait.
	endTime := Time microsecondClockValue]
			forkAt: Processor userInterruptPriority.
	"Wait for a shorter period than the other process"
	delay2 wait.
	"We should have waited for the correct time, other proc is still waiting"
	self expectDelay: delay2 duration for: Time microsecondClockValue.
	self assertIsNil: endTime.
	"Now wait long enough for it to be done"
	delay3 wait.
	endTime2 := Time microsecondClockValue.
	self expectDelay: delay duration for: endTime.
	self expectDelay: delay2 duration + delay3 duration for: endTime2!

testSignal
	| endTime delay2 |
	delay := Delay forMilliseconds: 20.
	delay2 := Delay forMilliseconds: 10.
	
	[startTime := Time microsecondClockValue.
	delay wait.
	endTime := Time microsecondClockValue]
			forkAt: Processor userInterruptPriority.
	delay2 wait.
	delay signal.
	self expectDelay: delay2 duration for: endTime!

testSimultaneousWaitAndSignal
	| waitError signalError signalFinished endTime |
	delay := Delay forMilliseconds: 20.
	signalFinished := false.
	Delay.AccessProtect wait.	"Ensure that the Delay wait will be blocked"
	startTime := Time microsecondClockValue.
	
	[[delay wait] on: Error do: [:ex | waitError := ex].
	endTime := Time microsecondClockValue] fork.	"Delay>>wait will calc a resumption time, then block"
	
	[[delay signal] on: Error do: [:ex | signalError := ex].
	signalFinished := true]
			forkAt: Processor userInterruptPriority.	"Will block on AccessProtect in #cancel too, but higher priority"
	Delay.AccessProtect signal.	"Allow the bug to unfold"
	OS.Kernel32 sleep: 10.	"Wait for both processes above to finish, without using the Delay mechanism"
	self expectDelay: 0 milliseconds for: endTime.	"Process should not have actually waited on the delay"
	self assertIsNil: waitError.
	self assert: signalFinished.
	self assertIsNil: signalError!

testSimultaneousWaitAndSignalWithOtherLongerDelay
	[(Delay forMilliseconds: 25) wait] forkAt: Processor userInterruptPriority.
	self testSimultaneousWaitAndSignal!

testSimultaneousWaitAndSignalWithOtherShorterDelay
	[(Delay forMilliseconds: 15) wait] forkAt: Processor userInterruptPriority.
	self testSimultaneousWaitAndSignal! !
!Core.Tests.DelayTest categoriesForMethods!
expectDelay:for:!helpers!private! !
setUp!private!running! !
tearDown!private!running! !
testBasicWait!public!unit tests! !
testCancel!public!unit tests! !
testCancelWithOtherShorterDelay!public!unit tests! !
testSchedulingMultipleDelays!public!unit tests! !
testSchedulingMultipleDelaysLongerFirst!public!unit tests! !
testSignal!public!unit tests! !
testSimultaneousWaitAndSignal!public!unit tests! !
testSimultaneousWaitAndSignalWithOtherLongerDelay!public!unit tests! !
testSimultaneousWaitAndSignalWithOtherShorterDelay!public!unit tests! !
!

